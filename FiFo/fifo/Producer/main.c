#include <stdio.h>
#include <string.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>
#include <stdlib.h>

int main(int argc, char **argv)

{
	char arr[10];
	char * myfifo = "../../myfifo";
	mkfifo (myfifo,0666);
	int fd;
	sprintf(arr,"%d",getpid());
	
	fd = open (myfifo,O_WRONLY);
	write (fd,arr,strlen(arr)+1);
	close (fd);
	
	
	return 0;
}
