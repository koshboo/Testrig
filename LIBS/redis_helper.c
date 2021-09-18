#include </usr/include/hiredis/hiredis.h>
#include "redis_helper.h"
#include <string.h>
#include <signal.h>
#include "Helpers.h"
#include <unistd.h>

const char *hostname =  "127.0.0.1";		//Host address of redis server
struct timeval timeout = { 1, 500000 }; 	// 1.5 seconds 

int Rsets(char* Name, char* Value)
{
	while (Rcon() == 0)						// atempt to connect to redis
	{
	sleep (5);								// if attempt fails wait 5 second and try again
	}
	int ok;
	ok = 0;
	char temp[100] = "";
	sprintf(temp,"set %s %s",Name,Value);
	if (c != NULL)
	{
		reply = redisCommand(c,temp);
	}
redisFree(c);	
	return ok;
}
int Rseti(char* Name, int Value)
{
	while (Rcon() == 0)						// atempt to connect to redis
	{
	sleep (1);								// if attempt fails wait 1 second and try again
	}
	
	int ok;
	ok = 0;
	char temp[100] = "";
	
	sprintf(temp,"set %s %d",Name,Value);
	if (c != NULL)
	{
		reply = redisCommand(c,temp);
	}
		redisFree(c);
	return ok;
}
int Rcon(void)
{
	
	c = redisConnectWithTimeout(hostname, 6379, timeout); // generate connection with redis
	if (c == NULL || c->err) 
	{
	fprintf(stderr,get_time());
        if (c) {
            fprintf(stderr,"Connection error: %s\n", c->errstr);
			fflush(stderr);							// flush stderr ensure that all prints are processed
            redisFree(c);
        } else {
            fprintf(stderr,"Connection error: can't allocate redis context\n");
			fflush(stderr);							// flush stderr ensure that all prints are processed
        }
		return 0;
    }
	
	return 1;
} 
char* Rget (char* Name)
{
	while (Rcon() == 0)						// atempt to connect to redis
	{
	sleep (5);								// if attempt fails wait 5 second and try again
	}
	
	char temp[100] = "";
	reply = NULL;
	sprintf(temp,"get %s",Name);
	reply = redisCommand(c,temp);
	if (reply == NULL|| c->err)
	{
		fprintf(stderr,"redis Connection error: %s \n", c->errstr);
		fflush(stderr);
	}
	redisFree(c);
	char* st;
	if (reply == NULL)
	{
	st ="";
	}
	else
	{
		st = reply -> str;
	}
	return st;	
}


