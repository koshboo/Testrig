
#include <sys/ipc.h>
#include <sys/shm.h>
#include <stdio.h>
#include <string.h>
#include <signal.h>
#include <stdlib.h>
#include <errno.h>
typedef struct {
	char instruction [5][10];
	int writer ;
	char read;
	char update;
	char ret;
} stru;

stru *boo;

int main(int argc, char **argv)
{

	// ftok to generate unique key
	char name [] = "fifo";
	strcpy(name,argv[1]);									// copy The file name to temporary variable
	strcat(name,".err");								// Add .err to the filename for the error log
	freopen( name, "a", stdout );
	long lw;
	lw = strtol (argv[1],NULL,10); 
	key_t key = ftok("shm.txt",lw);
	printf("key %d  error %d \n",key,errno);
	fflush (stdout);
	// shmget returns an identifier in shmid
	int shmid = shmget(key,1024,0666|IPC_CREAT);
	boo = shmat(shmid,NULL,0);

	while (1) {
		if ((*boo).update == 0x01) {
			printf(" %s - %s - %d ",(*boo).instruction[1],(*boo).instruction[2],(*boo).ret);
			fflush(stdout);
			(*boo).update = 0x00;
			kill ((*boo).writer,SIGUSR1);
		}
	
	}
	shmctl(shmid,IPC_RMID,NULL);

	return 0;
}
