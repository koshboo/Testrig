#include <stdio.h>
#include "../../LIBS/redis_helper.h"
#include <sys/types.h>
#include <unistd.h>
#include <string.h>
#include <signal.h>
#include <stdlib.h>
#include <errno.h>
#include "../../LIBS/Helpers.h"
#include "../../LIBS/Core.h"

int Callback(void *a_param, int argc, char **argv, char **column);
int  reboot_p (char* Name);

struct sqlret {
	char sqlret[200];
	int sqlline;

} sqlret;
char* RESPONSE;
char *NAMES[] = {"INTERFACE","DEC", NULL};   	// list of file to start
int PIDS [4] = {0};						// array of pids that have been ided
int PIDSP [40] = {0};					// array of pids that have been ided
const char *a[2];
int Loop;
int done;
char target[100];					// Array containing name of file to start
char ARG[100];						// Array containing argiuments to send to file
char *err_msg = 0;
char Start_FLAG = 0;
	int loop_count = 0;

int main(int argc, char **argv)
{
	/***********************************************
		SETUP GOD- see if god is running alreaday
	************************************************/
	int i;																	// temporary variable
	RESPONSE = Rget ("GOD");												// Get redis key "GOD" value
	if (RESPONSE != NULL) {													// Has redis returned a value
		i = atoi(RESPONSE);													// if reply is not null then convert to integer
		if (i != 0 ) {														// Check if convertion worked
			if (kill (i,0) == 0) {											// Check if god process is still running
				exit (0);   												// If god is active then end this program
			}
		}
	}
	i = getpid ();															// Get PID of this program
	Rseti("GOD",i);															// set GOD pid in redis
	freopen( "God.err", "a", stderr ); 										// redirect errors to log file
	freopen( "God.log", "a", stdout );										// redirect stdout to file
	if (argv[1]!= NULL)  {
		i = atoi(argv[1]);
		if (i == 1) {
			printf ("God started by Interface @ %s",get_time());
		}			// print to log file time of start
		else {
			printf ("God started by Command line @ %s",get_time());
		}
	} else {
		printf ("God started by Command line @ %s",get_time());
	}

	fflush (stdout);

	/********************************************************************************************************
	*Setup complete. now enter main loop that checks to make sure that the DEC & interface is running.
	*Also makes sure programs are running
	*********************************************************************************************************/

	while (1) {													// main loop
	
		int count = 0;											// zero out names count
		while (NAMES[count] != NULL) {						    // Cycle the test for interface and dec
			ARG[0] = 0;											// empty arg
			sprintf (ARG,"%s",NAMES [count]);					// convert number to string
			loop_count = 0;
			Start_FLAG = 0;
			if (PIDS[count] == 0) {								// First time around;
				loop_count = 0;
				
				while ((PIDS[count] == 0)||(loop_count < 5)) {	// Loop while redis reports error
				PIDS[count] = reboot_p (ARG);					// Get updated pid from redis
				if (PIDS[count] == 0) {							// if redis return a non zero no need to wait
				sleep(1);}
				loop_count ++;
				
			}
				
				if (PIDS[count] > 0){							// did redis return a non zero non error
				if (kill (PIDS[count],0) != 0) {Start_FLAG = 1;}// If new pid is still not valid
				if (PIDS[count] < 0){Start_FLAG = 1;}
			}
			} // end of first time
			if (Start_FLAG == 0){								// is it already flagged to start?
			if (kill (PIDS[count],0) != 0) 						// is currunt PID valid
			{													// NO
				loop_count = 0;
				while ((PIDS[count] == 0)||(loop_count < 5)) {	// Loop while redis reports error
				PIDS[count] = reboot_p (ARG);					// Get updated pid from redis
				
				if (PIDS[count] == 0) {							// if redis return a non zero no need to wait
				sleep(1);}
				loop_count ++;
				
				}
				if (PIDS[count] < 0){Start_FLAG = 1;}			// has redis returned null
				if (PIDS[count] > 0){							// if pid returns a non negative and non zero number 
				if (kill (PIDS[count],0) != 0) {Start_FLAG = 1;}// If new pid is still not valid
				}
			}
			}


			if (Start_FLAG != 0) {					// Has the restart flag been set?
				strcpy(target, "./");				// Add run command to target
				strcat (target,ARG);				// Add target name to target
				New_process (target,ARG);			// Start new process
				sleep (5);							// sleep 1 second to make sure new process has started and register with redis
				PIDS[count] = reboot_p (ARG);		// get new PID number from redis
				}
			count ++;
		}
		

		/********************************************************************************
			interface checks are done now move on to the programs that should be running
		*********************************************************************************/
		targ_count = 0;
		DB_stat = openDB();
		char *sql = "SELECT * FROM Programs where status = 'Active'"; 	// get all 'active' programs
		rc = sqlite3_exec(db, sql,Callback, 0, &err_msg);				// execute the sql 
		closeDB();														// close db 
		count = 0;														// zero the count 
		while (count <= (targ_count -1)) {								// loop while we have another program to check
			loop_count = 0;											// maximum of 5 loops - reset counter
			Start_FLAG = 0;											// set the flag to not to restart the program
			ARG[0] = 0;											// empty arg
			sprintf (ARG,"%i",targets [count]);					// convert number to string
			
			if (PIDSP[count] >  0){								// Is current number > 0
			printf ("abc2 %i  %i\n",Start_FLAG,PIDSP[count]);
				fflush (stdout);
				if (kill (PIDSP[count],0) != 0) 				// is currunt PID valid
			{													// NO
				loop_count = 0;									// reset loop
				while ((PIDSP[count] == 0)||(loop_count < 5)) {	// loop max of 5 times while ther is an error
				PIDSP[count] = reboot_p (ARG);					// Get updated pid from redis
				if (PIDSP[count] == 0){							// did redis return a zero if not no need to wait 
				sleep(1);}										// sleep 1 second
				loop_count ++;									// increment loop counter
					
				}	
			}
				if (PIDSP[count] > 0){								//  if pid returns a non negative and non zero number 
				if (kill (PIDSP[count],0) != 0) {Start_FLAG = 1;}	// If new pid is still not valid if not set restart flag
				}
			}
			
			
			else
				
			{
				
				while ((PIDSP[count] == 0)||(loop_count < 5)) {	// Loop while redis reports error
				PIDSP[count] = reboot_p (ARG);					// Get updated pid from redis
				sleep(1);										// Wait 1 second 
				loop_count ++;
				};
				}
			
			if (PIDSP[count] < 0) {Start_FLAG = 1;}				// redis returned null
			printf ("abc %i  %i\n",Start_FLAG,PIDSP[count]);
			fflush (stdout);
			if (Start_FLAG != 0) {								// is the restrt flag set ?
				strcpy(target, "./");							// Add run command to target
				strcat (target,"Controller");					// Add target name to target
				New_process (target,ARG);						// Start new process
				sleep (5);										// sleep 1 second to make sure new process has started and register with redis
				PIDSP[count] = reboot_p (ARG);					// get new PID number from redis
				}
			count ++;											// get next program to be tested
		fflush(stdout);											// flush stdout ensure that all prints are processed
		fflush(stderr);											// Flush stdERR
		sleep (5);												// Wait 5 seconds beforer redoing scan
		}
	}
	return 1;													// fall through and exit
}
/***************
 * END OF MAIN *
 ***************/
 
 /***********************************************************************************************
  * This function iterates through the sql returns and fills in the target value for the program 
  * 
  *********************************************************************/
int Callback(void *a_param, int argc, char **argv, char **column)	
{
	int i;														// tempory Var 
	if ((  i = atoi (argv[0])) != 0 ) {							// does argv[0] return a number
		targets [targ_count] = i;								// Put number into the target count 
		targ_count ++;											// move to the next program number
	}
	return 0;													//  always returns 0
}

int  reboot_p (char* Name)
{

	int i;																// temporary variable
	i = 0;																// set i to 0  	
	RESPONSE = Rget (Name);												// check redis for name
	if (RESPONSE != NULL) {												// if reply is NOT null then the PID does exist in redis
		if ((RESPONSE != 0 ) && (strstr(RESPONSE, "ERR") == NULL)) {	// if response is not 0 and not Err
			i = atoi(RESPONSE);											// convert response to integer
		}
	}
	if (RESPONSE == NULL) {i = -1;										// if the response returned null then signal that with neg number
	}
	return i;															// return the pid or error code
}
