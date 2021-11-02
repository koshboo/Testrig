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

	char tem [33];
	sprintf(tem, "%s%d",S, I);
	S = tem;
	return S;
}
void New_process (char* Name,char* Argval)		// generate new process
{
	int status;
	char* parmList[] = {"", Argval, NULL}; //  param list mus be NULL terminated first value is irrelervent
	pid_t pid;
	pid = fork();
	if (pid == 0) {				// child process
		pid = fork ();			// fork again.
		if (pid == 0) {			// Grand child process
			int t;
			t = 0;
			printf (" Attempting to start %s %s \n",Name,Argval);
			fflush (stdout);
			t = execv (Name,parmList);
			if (t < 0) {
				fprintf (stdout,"failed to start %s %s \n",Name,parmList[1]);
			}
			exit (0);					// grandchild end if it failed to fork 
		} else {
			exit (0);					// child ends
		}
	} else {
		waitpid(pid, &status, 0);		// wait for child to finish 
	}
}
int openDB(void)
{
	FILE *fp;
	char line [100];
	fp = fopen("config", "r");
	if (fp != NULL) {
		ReadLine (line, sizeof (line), fp);
		strcat(line,"Main.db");
		DBloc = line;
		if (access(DBloc,F_OK) == 0) {
			rc = sqlite3_open (DBloc, &db);		// open db
			while (rc != SQLITE_OK) {
				fprintf(stderr, "Cannot open database: %s\n", sqlite3_errmsg(db));
				sqlite3_close(db);
				fflush(stderr);
				sleep (1);
				rc = sqlite3_open (DBloc, &db);
			}
		}
		else
		{
			fprintf(stderr, "Cannot locate DB file %s %d \n", line,1);
			exit(1);
			}
		
	} else {
		fprintf(stderr, "Cannot locate config file %d \n", 1);
		fflush(stderr);
		exit(1);
	}
	fclose (fp);
	return 1;

}
int closeDB(void)
{
	if (DB_stat != 0) {
		sqlite3_close(db);
		DB_stat = 0;
	}

	return 0;
}
