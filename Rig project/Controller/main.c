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

//functions
int Callback(void *a_param, int argc, char **argv, char **column);
void writeDB(char *sql);
//variables

char *err_msg = 0;
//structures
char temp[100];
char stata ;
int target;

time_t oldtime,newtime,regtime,tartime;
struct sqlret {
	char sqlret[200];
	int sqlline;
} sqlret;
void SIG_OK (int signum)
{
	printf ("Sig captured abc %d ",signum);			// Log start time
	fflush (stdout);
}
int main(int argc, char **argv)
{

signal(SIGINT,SIG_OK);
	char arr[25];
	char arr2[25];
	int Cfile1;
	int Cfile2;
	char Program_Lines[MAXLINE][20];
	int  PL_Number;
	int  L_Number;
	int cmd_num;
	char line [MAXLINE];
	char *token ;
	char cmd [10][10];
	FILE *fp;
	double seconds;
	// locate and load file
	char file_location [70];

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
	//freopen(file_location,"a", stdout );							// Redirect all logging output to file

	count = 0;
	target = 0;
	char  myfifo[30] ;
	char  myfifo2[30] ;

	//SQLITE
	/*  Open SQLITE3 database
	 * 	Read count and target
	 * Close connection to DBase
	 */
	DB_stat = 0;
	stata = 10;
	sprintf (temp,"SELECT Status,target,count FROM Programs where ID = %s",argv[1]); // form the sql query
	char *sql = (temp); 											// copy query into the correct format
	writeDB (sql);													// open DB Process query and close.
	if (stata == 0) {
		time (&newtime);
		printf ("Started - %s ",asctime(localtime(&newtime)));			// Log start time
		printf ("Start count - %i \n",count);							// Log start count

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



	sprintf(myfifo,"pipes/to_DEC.%s",argv[1]);				// Name of the the out bound pipe
	sprintf(myfifo2,"pipes/from_DEC.%s",argv[1]);			// Name of the inbound pipe
	Cfile1 = open (myfifo, O_RDWR|O_NONBLOCK);
	Cfile2 = open (myfifo2,O_RDONLY);						// open second fifo
	read (Cfile2,arr,strlen(arr)+1);						// read and discard any ack /redo signals still in the pipe
	/* MAIN PROGRAM LOOP*/
	while ( stata == 0 ) {						   				// loop until the count = target count
		fflush(stdout);
		sprintf (temp,"SELECT Status FROM Programs where ID = %s",argv[1]); // form the sql query
		sql = (temp); 												// copy query into the correct format
		writeDB(sql);												// open DB Process query and close.
		if (stata != 0) {
			break;
		}

		/* break the program line into chunks for processing*/
		time(&oldtime);												// start time for cycle timing

		while (L_Number <= PL_Number) {						// while line number is lower than program lines
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

				sprintf(arr,"%s %s %s",cmd[0],cmd[1],cmd[3]);			// create the command for the fifo buffer
/// Write data to the pipe
				arr[strlen(arr)] = 0;
				tt = write (Cfile1,arr,strlen(arr)+1);					// write command to pipe
				while (tt < 0 ) {										// was there an error
					sleep (1);											// wait 1 second
					tt = write (Cfile1,arr,strlen(arr)+1);				// retry after 1 second
				}


// read data from the pipe
				do {													// repeat
					arr[0] = 0;
					tt = read (Cfile2,arr2,20);							// read the ack or estop
				} while (tt == 0);										// while no data sent
// validate data and act accordingly

				switch (arr2[0]) {							// convert arr to int
				case 0x01: // ACK - ok proceed
					L_Number ++;
					sleep (strtol (cmd[4],NULL,10));									// add to line number
					break;
				case 0x02: // Redo - something happened please resend
					break;												// no comands needed as Lnumber does not need changing

				} // end of inner switch statement

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
				L_Number = L_Number ;
			}
		}// end of first switch statement
		time(&newtime);
		seconds = difftime(newtime,regtime); // how long since the last update to the sql database

		if (seconds > 60) {
			// get current time
			seconds = difftime(newtime,oldtime);						// how long did it take to do the cycle
			tartime = newtime+((target - count)* seconds);				// Calculate time to finish
			sprintf (temp,"UPDATE Programs SET count = %i, EST_Finish_date = '%s' WHERE ID = %s \n",count, asctime(gmtime(&tartime)),argv[1]); // Create string for update
			char *sql = (temp); 									//
			writeDB(sql);											// open DB Process query and close.
			time(&regtime);											// up date regtime
		}
		L_Number = 0;												// zero line number
		count ++;													// increase count
		if (count > target) {
			stata= 2;
		};									// Set break out condition if count = target

	}
	/* final write out before the program finishes  */
	if (stata == 2) {
		count = count - 1;
	}									// remove the extra count from count
	sprintf (temp,"UPDATE Programs SET count = %i  WHERE ID = %s \n",count,argv[1]); // Create string for update
	sql = (temp);
	writeDB(sql);											// open DB Process query and close.
	time (&tartime);
	printf ("Stopped - %s ",asctime(localtime(&tartime)));	// Log Stop time
	printf ("Stop count - %i \n",count);					// Log Stop count
	fflush (stdout);
	return 0;												// Terminate program
}
void writeDB(char *sql)
{

	while (DB_stat == 0) {										// loop while db is not open
		DB_stat = openDB();										// open DB will always return true
		sqlite3_busy_timeout (db,2000);
		rc = sqlite3_exec(db,sql,Callback, 0, &err_msg);   	    // if db open do the write
		if (rc != SQLITE_OK) {									// if the operation complete with out error
			fprintf(stderr," dbase error %s  \n",err_msg);
			fprintf(stderr," Out put %s  \n",sql);
			fflush (stderr);
			closeDB();												// Close DB
			sqlite3_free(err_msg);
			int num =(rand()% (5 - 1 +1 ))+ 1;
			sleep (num);												// wait 1 second and try again
		}
	}
	DB_stat = closeDB();										// close DB only done when db write is completed
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
		stata = (strcmp(argv[0],"Active"));									// Argument 0 is the status value
	}
	return 0;
}
