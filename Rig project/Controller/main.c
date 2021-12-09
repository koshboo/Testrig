#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include "../../LIBS/Core.h"
#include "../../LIBS/Helpers.h"
#include <strings.h>
#include <sqlite3.h>
#include <../libss/ABE_IoPi.h>
#include <../../LIBS/redis_helper.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <time.h>
#include <errno.h>
#include <signal.h>
int linesd;
#define debug printf("tag %d \n",linesd);	fflush (stdout);linesd = linesd + 1;
//functions
int Callback(void *a_param, int argc, char **argv, char **column);
void writeDB(char *sql, int c); 
//variables

char *err_msg = 0;
//structures
char temp[100];
char stata ;
int target;
int sig;
int  L_Number;

time_t oldtime,newtime,regtime,tartime,aron_time,breaktime,breaktime1;
struct timespec tim,tim2;
struct sqlret {
	char sqlret[200];
	int sqlline;
} sqlret;
void SIG_OK (int signum)
{
	sig = 1;
	L_Number ++;											// increment line number
}
void SIG_NOK (int signum)
{
	sig = 2;
}
int main(int argc, char **argv)
{
linesd = 0;
	signal(SIGINT,SIG_OK);		// redirect sig int to my
	signal(SIGUSR1,SIG_NOK);		// redirect sig int to my
	
	char arr[25];

	int Cfile1;

	char Program_Lines[MAXLINE][20];
	int  PL_Number;

	int cmd_num;
	char line [MAXLINE];
	char *token ;
	char cmd [10][10];
	FILE *fp;
	double seconds;
	char file_location [70];
	// locate and load file
	
	strcpy(file_location,"Programs/");
	strcat(file_location,argv[1]);
	if (access (file_location,F_OK)!= 0) {  						// Check if the file in the starting arguments exist
		exit (0);													// Exit if it does not
	}
	
	fp = fopen(file_location, "r");									// open file readonly
	strcpy(file_location,"Programs/Logs/Error/");
	strcat(file_location,argv[1]);
	strcat(file_location,".err");									// Add .err to the filename for the error log
	freopen(file_location,"a", stderr ); 							// redirect errors to log file

	strcpy(file_location,"Programs/Logs/");
	strcat(file_location,argv[1]);									// copy The file name totemporary variable
	strcat(file_location,".log");									// Add .log to the filename for the logging
	sleep(1);
	freopen(file_location,"a", stdout );							// Redirect all logging output to file

	count = 0;
	target = 0;
	char  myfifo[30] ;
    

	//SQLITE
	/*  Open SQLITE3 database
	 * 	Read count and target
	 * Close connection to DBase
	 */
	
	
	DB_stat = 0;
	stata = 10;
	sprintf (temp,"SELECT Status,target,count FROM Programs where ID = %s",argv[1]); // form the sql query
	char *sql = (temp); 											// copy query into the correct format
	writeDB (sql,0);													// open DB Process query and close.
	if (count >= target) {stata = 10;}

	if (stata == 0) {
		time (&newtime);
		printf ("Started - %s \n ",asctime(localtime(&newtime)));			// Log start time
		fflush(stdout);
		/*  Open redis database
		 * 	Log pid on data base
		 * Close connection to DBase
		 */
		int i = getpid ();												//get pid of this process
		Rseti(argv[1],i);												// Register pid on the redis server
		
		/*
		 * Read the file line by line and copy to variable Program lines
		 */
		PL_Number = 0;													// Set program lines to 0
		fflush(stdout);													// Flush the logging data to the file
		while( ReadLine (line, MAXLINE, fp) ) {							// Read through the program file
			if (line[0] != '#' ) {										// discard lines with # at the start
				strcpy(Program_Lines[PL_Number],line);   					// copy program line into memory
				++ PL_Number;
				fflush (stdout);
			}
		}
		PL_Number = PL_Number-1;										// Remove the extra count on the program lines
		L_Number = 0;													// zero line count
		time(&regtime);													// get time for use in the sql update sequence
	}
	
	sprintf(myfifo,"pipes/to_DEC.%s",argv[1]);							// Name of the the out bound pipe
	if (access (myfifo,F_OK)== 0) {										// does myfifo exist - process killed not shut down properly
		remove (myfifo);												// remove the old file
		sleep (3);														// sleep to allow the remaoval

	}

	/* MAIN PROGRAM LOOP*/
	while ( stata == 0 ) {						   				// loop until the count = target count
		linesd = 0;
		sprintf (temp,"SELECT Status,target FROM Programs where ID = %s",argv[1]);
		sql = temp; 												// copy query into the correct format
		writeDB(sql,count);												// open DB Process query and close.
		
		fflush (stdout);
		if (stata != 0) {
			break;
		}
	
		/* break the program line into chunks for processing*/
		time(&oldtime);										// start time for cycle timing
		while (L_Number <= PL_Number) {						// while line number is lower than program lines
	
			mkfifo (myfifo,0666);							// create the fifo file
			errno = 0;										// clear the error code
			Cfile1 = open (myfifo, O_RDWR);					// open the fifo
		
			while (errno != 0 ) {							// did it open correctly if not loop
				tim.tv_nsec = 1000000;						// set tim to 10 millisecond
				nanosleep (&tim,&tim2);						// sleep for tim
				fprintf(stderr,"Error - %d === %s \n",errno,strerror (errno)); // print error to error log
				Cfile1 = open (myfifo, O_RDWR);				// try to reopen the fifo file.
			}
			
			if (L_Number <0) {								// has the line number been set to < 0
				L_Number = 0;								// set linenumber to 0
			}
			cmd_num = 0;									// zero commands
			strcpy(line,Program_Lines[L_Number]);			// copy the program line in to a temporay variable
			token = strtok(line,",");						// Split line into parts
			while (token != NULL) 	{						// Repeated split
				strcpy(cmd[cmd_num],token);					// Copy token to cmd (n)
				token = strtok(NULL,",");					// next token
				++ cmd_num;									// increment cmd
			}
			/*
			 * Process the chunks
			 */
			char tt;

			switch (strtol(cmd[2],NULL,10)) {			// test the first command info
			case 0: {
				/*
				* This is if the program is set for Timed mode
				*/

				sprintf(arr,"%i %s %s %s",getpid(),cmd[0],cmd[1],cmd[3]);			// create the command for the fifo buffer
				/// Write data to the pipe
				arr[strlen(arr)] = 0;									// add zero term to array
				tt = write (Cfile1,arr,strlen(arr)+1);					// write command to pipe
				while (tt < 0 ) {										// was there an error
					usleep (1000);										// wait 1 second
					tt = write (Cfile1,arr,strlen(arr)+1);				// retry after 1 second
				}

// wait for signal
				sig = 0;												// reset the signal flag
				time (&breaktime);
				while (sig == 0 ) {										// while the signal flag is 0 loop
					time (&breaktime1);
					usleep (100);  										// sleep for 0.1 second
				seconds = difftime(breaktime1,breaktime);
				if (seconds > 10 ) {sig = 2;}
			}
				
				close (Cfile1);											// close the fifo file
				float f = atof (cmd[4]);								// convert cmd[4] to float
				f = f * 1000000000;										// times second by 1,000,000,000 to get nanoseconds
				unsigned long long int s = f;							// convert float to long long iunsigned int
				while (s > 0) {											// loop while s > 0
					if (s > 100000000) {								// is s > 1 second
						tim.tv_nsec = 100000000;						// set tim to 1 second
						s = s - 100000000;								// take 1 second off s.
					} else {
						tim.tv_nsec = s;								// set tim to s
						s = 0;
					}
					nanosleep (&tim,&tim2);								// sleep for tim
				}



			}
			break;													// end of timed section

			case 1:
				/************************************************
				* This is if the program is set for target mode
				*************************************************/
				printf("target mode %i \n",L_Number+1);
				break;


				/*
				 * fall through
				 */

			default:
				fprintf(stderr,"%s Line fault on line %i \n",get_time(),L_Number+1);				// This should only happen if a line has an error
			}
		}// end of first switch statement

		time(&newtime);
		seconds = difftime(newtime,regtime); // how long since the last update to the sql database

		if (seconds > 60) {
		
			// get current time;
			seconds = difftime(newtime,oldtime);						// how long did it take to do the cycle
			int targettime = (target - count)			 ;				// Calculate time to finish
			targettime = targettime * seconds;
			tartime = time(NULL) + targettime;
			char * s ;
			s = asctime(gmtime(&tartime));
			s[strcspn(s,"\n")]= '\0';
			sprintf (temp,"UPDATE Programs SET count = %i, EST_Finish_date = '%s' WHERE ID = %s ",count, s,argv[1]); // Create string for update
			char *sql = (temp); 									//
			writeDB(sql,count);											// open DB Process query and close.
			
			time(&regtime);											// up date regtime
			
			
		}
		L_Number = 0;												// zero line number
		count ++;													// increase count
		if (target == 0) {count = 0;} // special case for infinite 
		if (count > target) {
			stata= 2;
		};									// Set break out condition if count = target
		
	}
	
	/* final write out before the program finishes  */
	if (stata == 2) {
		count = count - 1;
	}									// remove the extra count from count
	//printf ("target %d    count %d    Stata %d \n",target,count,stata);
	if (stata != 10) 
	{
	sprintf (temp,"UPDATE Programs SET count = %d  WHERE ID = %s \n",count,argv[1]); // Create string for update
	sql = (temp);
	writeDB(sql,count);											// open DB Process query and close.
	time (&tartime);
	
	printf ("Stopped - %s \n %s",asctime(localtime(&tartime)), temp);	// Log Stop time
	fflush (stdout);}
	sprintf (temp,"UPDATE Programs SET Status = 'Completed' WHERE ID = %s \n",argv[1]); // Create string for update
	sql = (temp);
	writeDB(sql,count);
	return 0;												// Terminate program
}// TODO help

void writeDB(char *sql, int c) 
{
	
	while (DB_stat == 0) {										// loop while db is not open

		DB_stat = openDB();										// open DB will always return true
	}
		sqlite3_busy_timeout (db,2000);
		rc = sqlite3_exec(db,sql,Callback, 0, &err_msg);   	    // if db open do the write
		if (rc != SQLITE_OK) {									// if the operation complete with out error
			fprintf(stderr," dbase error %s  \n",err_msg);
			fprintf(stderr," Output %s  \n",sql);
			fflush (stderr);
			closeDB();												// Close DB
			sqlite3_free(err_msg);
			int num =(rand()% (5 - 1 +1 ))+ 1;
			sleep (num);												// wait 1 second and try again
		}
		if (c != 0) {count = c;}
}
int Callback(void *a_param, int argc, char **argv, char **column)
{
	
	if (argv [2] != NULL) {
		count = strtol(argv[2],NULL,10);									// Argumant 2 is the count value
	}
	if (argv [1] != NULL) {
		target = strtol(argv[1],NULL,10);								    // Argumant 1 is the target value
	}
	
	if (argv [0] != NULL) {
		//stata = (strcmp(argv[0],"Active"));									// Argument 0 is the status value
	stata = 5;
	if ((strcmp(argv[0],"Active")) == 0) {stata = 0;}
	if ((strcmp(argv[0],"Paused")) == 0) {stata = 3;}
	if ((strcmp(argv[0],"Completed")) == 0) {stata = 4;}
	
	}
	return 0;
}
