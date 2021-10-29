#include <stdio.h>
#include "redis_helper.h"
#include <sys/types.h>
#include <unistd.h>
#include <string.h>
#include <signal.h>
#include <stdlib.h>
#include <errno.h>
#include "Helpers.h"
#include "Core.h"

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
			if (PIDS[count] == 0) {								// is this the first time through
				PIDS[count] = reboot_p (ARG);					// Reboot
			}

			if (kill (PIDS[count],0) != 0) {					// process  not running
				PIDS[count] = reboot_p (ARG);					// double check number with redis
				if (kill (PIDS[count],0) != 0) {				// verify process  not running
					strcpy(target, "./");						// Add run command to target
					strcat (target,ARG);						// Add target name to target
					New_process (target,NULL);					// Start new process
					sleep (1);									// sleep 1 second to make sure new process has started and register with redis
					PIDS[count] = reboot_p (ARG);				// get new PID number from redis
				}
			}
			count ++;
			sleep (1);
		}

		/********************************************************************************
			interface checks are done now move on to the programs that should be running
		*********************************************************************************/
		targ_count = 0;
		DB_stat = openDB();
		char *sql = "SELECT * FROM Programs where status = 'Active'"; // get all 'active' programs
		rc = sqlite3_exec(db, sql,Callback, 0, &err_msg);
		closeDB();
		count = 0;
		while (count <= (targ_count -1)) {
			ARG[0] = 0;											// empty arg
			sprintf (ARG,"%i",targets [count]);					// convert number to string
			if (PIDSP[count] == 0) {							// is this the first time through
				PIDSP[count] = reboot_p (ARG);					// Reboot
			}
			if (kill (PIDSP[count],0) != 0) {					// process not running
				PIDSP[count] = reboot_p (ARG);					// double check number with redis
				if (kill (PIDSP[count],0) != 0) {				// verify process  not running
					strcpy(target, "./");						// Add run command to target
					strcat (target,"Controller");				// Add target name to target
					New_process (target,ARG);					// Start new process
					sleep (1);									// sleep 1 second to make sure new process has started and register with redis
					PIDSP[count] = reboot_p (ARG);				// get new PID number from redis
				}
			}
			count ++;
			sleep (1);

		}

		fflush(stdout);											// flush stdout ensure that all prints are processed
		fflush(stderr);											// Flush stdERR
		sleep (5);												// Wait 5 seconds beforer redoing scan
	;}
	return 1;													// fall through and exit
}
/***************
 * END OF MAIN *
 ***************/
int Callback(void *a_param, int argc, char **argv, char **column)
{
	int i;
	if ((  i = atoi (argv[0])) != 0 ) {
		targets [targ_count] = i;
		targ_count ++;
	}
	return 0;
}

int  reboot_p (char* Name)
{

	int i;
	i = 0;
	RESPONSE = Rget (Name);												// check redis for name
	if (RESPONSE != NULL) {												// if reply is NOT null then the PID does exist in redis
		if ((RESPONSE != 0 ) && (strstr(RESPONSE, "ERR") == NULL)) { // if response is not 0 and not Err
			i = atoi(RESPONSE);
		}
	}

	return i;
}
