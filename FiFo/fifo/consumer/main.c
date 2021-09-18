#include <stdio.h>
#include <string.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>
#include <stdlib.h>
#include <errno.h>
#include "../../../LIBS/Helpers.h"
#include <sqlite3.h>
#include "ABE_IoPi.h"
#include "../../../LIBS/Core.h"
#include "../../../LIBS/redis_helper.h"
#include <signal.h>
#include <time.h>

#define REDO 0x02
#define ACK  0x01

int Callback(void *a_param, int argc, char **argv, char **column);
int Csqlop (char* sql);

int 	targets [100];
int 	targets2 [100] = {-1};
char 	ch_arr[20][3];
int 	in_arr [10];
int 	tag_count;
char 	*err_msg = 0;
char	OP[1];
char* 	RESPONSE;
char 	temp[100];
double seconds;
time_t Crefresh_time,Current_time;

int main(int argc, char **argv)
{
	int i;																	// temporary variable

	RESPONSE = Rget ("DEC");												// Get redis key "DEC" value
	if (RESPONSE != NULL) {													// Has redis returned a value
		i = atoi(RESPONSE);													// if reply is not null then convert to integer
		if (i != 0 ) {														// Check if convertion worked
			if (kill (i,0) == 0) {
				exit (0);   												// If god is active then end this program
			}
		}
	}

	i = getpid ();															// Get PID of this program
	Rseti("DEC",i);															// set DEC pid in redis

	IOPI_init(0x26,1);
	IOPI_init(0x20,1);
	char name [] = "fifo";
	strcpy(name,"Con");									// copy The file name to temporary variable
	strcat(name,".err");								// Add .err to the filename for the error log
	//freopen( name, "a", stdout );
	char Temp_Arry[50];									// temprary array for multiple things
	char pipein  [30][30];								// reader pipe text name
	char pipeout [30][30];								// Writer pipe
	int F_HANDR [30] = {-1};							// reader file handles
	int F_HANDW [30] = {-1};							// writer file handles
	tag_count = 0;
	int tt;
	openDB();
	char *sql = "SELECT ID FROM Programs where status = 'Active'"; // get all 'active' programs
	if (Csqlop (sql) != 0) {
		exit (1);
	};
	closeDB();
	for (i = 0; i < tag_count ; i++) {
		errno = 0;
		sprintf(pipein[i] ,"pipes/to_DEC.%d",targets[i]);							// set file names for the pipes
		printf("Creating  in pipe  %s \n",pipein[i]);
				fflush (stdout);
		sprintf(pipeout[i],"pipes/from_DEC.%d",targets[i]);
		printf("Creating out pipe  %s \n",pipeout[i]);
				fflush (stdout);
		if (access (pipein[i],F_OK)!= 0) {
			mkfifo (pipein [i],0666);
		}
		if (access (pipeout[i],F_OK)!= 0) {
			mkfifo (pipeout[i],0666);
		}
		F_HANDR[i] = open (pipein[i],O_RDONLY|O_NONBLOCK);				// open first fifo
		F_HANDW[i] = open (pipeout[i],O_RDWR|O_NONBLOCK );				// open second fifo
		fflush (stdout);
		Temp_Arry[0] = 0;
		tt = 0;
		tt = read (F_HANDR[i],Temp_Arry,50);									// empty the pipe (read all that is in there)
		OP[0] = REDO;
		write (F_HANDW[i],&OP,1);										// Write REDO to pipe
	}
	sleep (1);
	time (&Crefresh_time);
	while (1) {

		for (i = 0; i < tag_count  ; i++) {								// Loop through all numbers
			strcpy (Temp_Arry,"");
			tt = 0;
			if (access (pipein[i],F_OK)== 0) {
				tt = read (F_HANDR[i],Temp_Arry,50);				// empty the pipe (read all that is in there)
			}
			

			if (tt > 1) {
				printf("Array %d = %s  read = %d bytes \n",targets[i],Temp_Arry,tt);
				fflush (stdout);
				OP[0] = ACK;
				OP[1] = 0;
				int tem = access (pipeout[i],F_OK);
				if (tem == 0) {
					tt = write (F_HANDW[i],OP,10);
					if (tt < 1 ) {
						printf("err %d ",errno);
					}
					printf("Array %d = write = %d bytes \n",targets[i],tt);
					fflush (stdout);
				} else {
					printf("Array %d error = %d \n",targets[i],errno);
					fflush (stdout);
				}
			}
		}
		sleep (2);

/// re scan for changes in the programs
		seconds = (Current_time - Crefresh_time);
		if (seconds > 60 ) {
		}


	} //End of main loop


	return 0;
}

int Callback(void *a_param, int argc, char **argv, char **column)
{
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
