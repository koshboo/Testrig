
#include <sys/ipc.h>
#include <sys/shm.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <signal.h>
#include <unistd.h>
#include <errno.h>
typedef struct {
	char instruction [5][10];
	int writer ;
	char read;
	char update;
	char ret;
} stru;
stru *boo;
void sig_hand (int signum)
{
	(*boo).ret = 0x00;
}
int main(int argc, char **argv)
{
	char name [] = "fifo";
	strcpy(name,argv[1]);									// copy The file name to temporary variable
	strcat(name,".drr");								// Add .err to the filename for the error log
	freopen( name, "a", stdout );
// ftok to generate unique key
	long lw;
	lw = strtol (argv[1],NULL,10);
	key_t key = ftok("shm.txt",lw);
	printf("key %d  error %d \n",key,errno);
	fflush(stdout);
	signal (SIGUSR1,sig_hand);
	// shmget returns an identifier in shmid
	int shmid = shmget(key,1024,0666);
	if (shmid == -1) {
		shmid = shmget(key,1024,0666|IPC_CREAT);
	} else {
		shmctl(shmid, IPC_RMID, NULL);
		shmid = shmget(key,1024,0666|IPC_CREAT);
	}
	char str2[20] = "1";
	// shmat to attach to shared memory
	boo = shmat(shmid,NULL,0);
	(*boo).ret = 0x00;
	(*boo).writer = getpid();
	int i = 0;
	while (1) {

		if ((*boo).ret == 0x00) {
			sprintf(str2,"%d",i);
			strcpy ( (*boo).instruction[1],str2); // copy instructions
			sprintf(str2,"%d",i+1);
			strcpy ( (*boo).instruction[2],str2);
			printf("Data written in memory: %s  %s  %d \n",(*boo).instruction[1],(*boo).instruction[2],(*boo).ret);
			fflush(stdout);
			sleep(1);
			(*boo).ret = 0x01;
			(*boo).update = 0x01;
			i++;
		}

	}
	//detach from shared memory
	shmdt(boo);
	return 0;
}
