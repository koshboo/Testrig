
#include <sys/ipc.h>
#include <sys/shm.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
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
	int shmid = shmget(key,1024,0666);
	if (shmid == -1){
	printf("Failed: %s \n","");	
	shmid = shmget(key,1024,0666|IPC_CREAT);}
	else
	{
		shmctl(shmid, IPC_RMID, NULL);
		shmid = shmget(key,1024,0666|IPC_CREAT);
		}
	char str2[20] = "1";
	// shmat to attach to shared memory
	boo = shmat(shmid,NULL,0);
	(*boo).ret = 0x00;
	int i = 0;
	while (1) {
		
		if ((*boo).ret == 0x00) {
			sprintf(str2,"%d",i);
			strcpy ( (*boo).instruction[1],str2); // copy instructions
			sprintf(str2,"%d",i+1);
			strcpy ( (*boo).instruction[2],str2);
			printf("Data written in memory: %s  %s  %d \n",(*boo).instruction[1],(*boo).instruction[2],(*boo).ret);
			(*boo).update = 0x01;
			(*boo).ret = 0x01;
			i++;
		}
		
	}
	//detach from shared memory
	shmdt(boo);
	return 0;
}
