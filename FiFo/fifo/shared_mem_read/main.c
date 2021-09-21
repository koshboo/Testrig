
#include <sys/ipc.h>
#include <sys/shm.h>
#include <stdio.h>
#include <string.h>
typedef struct {
	char instruction [5][10];
	char read;
	char update;
	char ret;
} stru;

stru *boo;
int main(int argc, char **argv)
{
	// ftok to generate unique key
	key_t key = ftok("shmfile",65);

	// shmget returns an identifier in shmid
	int shmid = shmget(key,1024,0666|IPC_CREAT);
	boo = shmat(shmid,NULL,0);

	while (1) {
		if ((*boo).update == 0x01) {
			printf(" %s - %s - %d ",(*boo).instruction[1],(*boo).instruction[2],(*boo).ret);
			fflush(stdout);
			(*boo).ret = 0x00;
			(*boo).update = 0x00;
		}
	
	}
	shmctl(shmid,IPC_RMID,NULL);

	return 0;
}
