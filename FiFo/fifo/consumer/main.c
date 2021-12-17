#include <stdio.h>
#include <string.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdint.h>
#include <errno.h>
#include "../../../LIBS/Helpers.h"
#include <sqlite3.h>
#include "ABE_IoPi.h"
#include "../../../LIBS/Core.h"
#include "../../../LIBS/redis_helper.h"
#include <signal.h>
#include <time.h>


int Callback(void *a_param, int argc, char **argv, char **column);
int Csqlop (char* sql);
char *ch;
int 	targets [100];
int 	targets2 [100] = {-1};
char 	ch_arr[20][3];
uint8_t 	in_arr [10];
int 	tag_count;
char 	*err_msg = 0;
char	OP[1];
char* 	RESPONSE;
char 	temp[100];
double seconds;
time_t Crefresh_time,Current_time;
int cl;
char temp1[20];

int main(int argc, char **argv)
{
	int i;																	// temporary variable
	RESPONSE = Rget ("DEC");												// Get redis key "DEC" value
	if (RESPONSE != NULL) {													// Has redis returned a value
		i = atoi(RESPONSE);													// if reply is not null then convert to integer
		if (i != 0 ) {														// Check if convertion worked
			if (kill (i,0) == 0) {
				exit (0);   												// If dec is active then end this program
			}
		}
	}
	i = getpid ();															// Get PID of this program
	Rseti("DEC",i);															// set DEC pid in redis
	IOPi_init(0x26,1);			// init ports
	IOPi_init(0x20,1);
	set_port_direction (0x26,1,0);											// set port directions
	set_port_direction (0x26,0,0);
	set_port_direction (0x20,1,0);
	set_port_direction (0x20,0,0);
	write_pin (0x20,3,1);													// set master arm for rams
	char name [] = "fifo";
	strcpy(name,"DEC");									// copy The file name to temporary variable
	strcat(name,".LOG");								// Add .err to the filename for the error log
	freopen( name, "a", stdout );						// Redirect stdout to file
	char Temp_Arry[50];									// temprary array for multiple things
	char pipein  [30][30];								// reader pipe text name
	int F_HANDR [30] = {-1};							// reader file handles
	tag_count = 0;
	int tt;
	
	openDB();
	char *sql = "SELECT ID FROM Programs where status = 'Active'"; // get all 'active' programs
	if (Csqlop (sql) != 0) {
		exit (1);
	};

	for (i = 0; i < tag_count ; i++) {
		errno = 0;
		sprintf(pipein[i] ,"pipes/to_DEC.%d",targets[i]);				// set file names for the pipes
		if (access (pipein[i],F_OK)== 0) {								// does a file exist for this process
			F_HANDR[i] = open (pipein[i],O_RDONLY|O_NONBLOCK);			// open first fifo
			Temp_Arry[0] = 0;											// empty the temp arry
			tt = read (F_HANDR[i],Temp_Arry,50);						// empty the pipe (read all that is in there)
			ch = strtok(Temp_Arry, ",");								// remove the first data point and store in ch
			close (F_HANDR[i]);											// close handle
			if (ch != NULL) {											// was the process id found?
				kill (atoi (ch),SIGUSR1);								// send NOK signal to make the program repeat last statement
			}
			

		}

	}

	sleep (1);
	time (&Crefresh_time);
	while (1) {
		for (i = 0; i < tag_count  ; i++) {								// Loop through all numbers
			sprintf(pipein[i] ,"pipes/to_DEC.%d",targets[i]);				// set file names for the pipes
			strcpy (Temp_Arry,"");
			tt = 0;
		
			if (access (pipein[i],F_OK)== 0) {
				F_HANDR[i] = open (pipein[i],O_RDONLY);		// open first fifo
				tt = read (F_HANDR[i],Temp_Arry,50);					// empty the pipe (read all that is in there)
				int cmd_num;
				cmd_num =0;
				if (tt > 1) {											// did we rea more than 1 byte

				ch = strtok(Temp_Arry," ");						// Split line into part
				char* token = strtok(NULL," ");					// next token
				while (token != NULL) 	{						// Repeated split
				in_arr[cmd_num] = strtol(token, NULL, 16);
				token = strtok(NULL," ");					// next token
				++ cmd_num;									// increment cmd
				}
				remove (pipein[i]);
						//printf("SIGNAL GEN======%d %d %d ========== %s   \n",in_arr [0],in_arr [1],in_arr [2],ch); // REMOVE before deploy
						//**************************************************************************************
						//**Insert  harware control here
						write_pin (in_arr [0],in_arr [1],in_arr [2]);
						//
						//**************************************************************************************
						kill (atoi (ch),SIGINT);					// send signal that the work was done
					
				}
				time (&Current_time);
				if (tt == -1 ) {										// if error occured
					printf("error %d = %s  read = %d bytes @ %d \n",errno,strerror(errno),tt,targets[i]);	// output error
					printf("file target specs :- \n  name == %d \n Handle == %d \n ",targets[i],F_HANDR[i]);					// file details
					printf("Time -- %s \n",asctime(localtime(&Current_time)));
					fflush (stdout);													// flush output
					cl = targets[i];
					sprintf(temp1,"%d",cl);
					RESPONSE = Rget (temp1);
					if (RESPONSE != NULL) {												// Has redis returned a value
					int t = atoi(RESPONSE);												// if reply is not null then convert to integer
					if (t != 0 ) {														// Check if convertion worked
					if (kill (t,0) == 0) {
						kill(t,SIGUSR1);												// send NOK signal to program
					}
		}
	}
					
				}

				if (tt == 0 ) {															// zero bytes returned
					cl = targets[i];													// 
					sprintf(temp1,"%d",cl);
					RESPONSE = Rget (temp1);
					if (RESPONSE != NULL) {												// Has redis returned a value
						cl = atoi(RESPONSE);											// if reply is not null then convert to integer
						if (cl != 0 ) {													// Check if convertion worked
							kill(cl,SIGUSR1);
						}
					}
				}
				close (F_HANDR[i]);														// close file
			}
		}
		usleep (10); 																	// sleep for 0.01 secoonds
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		time (&Current_time);
/// re scan for changes in the programs
		seconds = (Current_time - Crefresh_time);
		if (seconds > 60 ) {
		time (&Crefresh_time);
		
		tag_count = 0;
		char *sql = "SELECT ID FROM Programs where status = 'Active'"; 						// get all 'active' programs
		if (Csqlop (sql) != 0) {
		exit (1);}
		
		}


	} //End of main loop


	return 0;
}

int Callback(void *a_param, int argc, char **argv, char **column)
{
	//targets [tag_count] =999999999;
	targets [tag_count] = atoi (argv[0]) ;
	tag_count ++;
	return 0;
}

int Csqlop (char* sql)
{
	int retry = 5;
	int count = 0;
	int out = 0;

	do {
		sleep(1);
		rc = sqlite3_exec(db, sql,Callback, 0,&err_msg );
		count++;
		if (rc == SQLITE_BUSY) {
			fprintf(stderr, "Data base Busy : %s \n",err_msg);
		}
	} while ((rc != 0)|(retry <= count));
	if (retry == count) {
		out = -1;
		fprintf(stderr, "Data base Fail: %s \n","");
	}
	return out;
}
