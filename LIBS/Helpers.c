#include <time.h>
#include <stdio.h>
#include "Helpers.h"
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>
#include "Core.h"
char* DBloc; // SQL DB location

char* get_time (void)				// return time and date as string
{
	time_t current_time;
	char* c_time_string;
	current_time = time(NULL);			// get current time and error checking
	if (current_time == ((time_t)-1)) {
		(void) fprintf(stderr, "Failure to obtain the current time.\n");
	}

	c_time_string = ctime(&current_time);// convert to local time string

	if (c_time_string == NULL) {
		(void) fprintf(stderr, "Failure to convert the current time.\n");

	}
	return c_time_string;
}
char* Add_intostr (char* S,int I)	// Add int to end of string
{

	char tem [33];					// setup temprary var
	sprintf(tem, "%s%d",S, I);		// copy string and the integer 
	S = tem;						// copy tem to s because we cant return local var
	return S;						// return s 
}

void New_process (char* Name,char* Argval)		// generate new process````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````
{
	int status;								// temp var
	char* parmList[] = {"", Argval, NULL}; 	//  param list mus be NULL terminated first value is irrelervent
	pid_t pid;								//	Temp var/local
	pid = fork();							// fork into new process
	if (pid == 0) {				// child process
		pid = fork ();			// fork again.
		if (pid == 0) {			// Grand child process
			int t;				// Temp Var
			t = 0;				// init t
			printf (" Attempting to start %s %s \n",Argval); 	// print a message to the log 			t = execv (Name,parmList);							// clone the new process onto this one
			if (t < 0) {										// If a neg number is returned then send message
				fprintf (stdout,"failed to start %s %s \n",Name,parmList[1]);// add message to log
			}
			exit (0);					// grandchild end if it failed to fork 
		} else {
			exit (0);					// child ends
		}
	} else {
		waitpid(pid, &status, 0);		// wait for child to finish 
	}
	fflush (stdout);					// flush buffer to make sure everything has been writtn to file
}
int openDB(void)
{
	FILE *fp;									// file name
	char line [100];							// line  variable
	fp = fopen("config", "r");					// open config
	if (fp != NULL) {							// If Fp is null e.g `thje rounter
		ReadLine (line, sizeof (line),fp);		// Readline from config																																													p);			
		strcat(line,"Main.db");					// add the database name to the base folder
		DBloc = line;							// convert to dbloc 
		if (access(DBloc,F_OK) == 0) {			// if you can accees the database
			rc = sqlite3_open (DBloc, &db);		// open db
			while (rc != SQLITE_OK) {			// check if the open was not sucsessfull2
				fprintf(stderr, "Cannot open database: %s\n", sqlite3_errmsg(db)); // Logg error 
				sqlite3_close(db);				// close the db
				fflush(stderr);					// flush stderr
				sleep (1);						
				rc = sqlite3_open (DBloc, &db);	}//try to reopen DB 
		}
	}
	return 1;

}
int closeDB(void)
{
	if (DB_stat != 0) {		// close the db connection
		sqlite3_close(db);	
		DB_stat = 0;
	}

	return 0;
}
