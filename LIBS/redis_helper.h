# include </usr/include/hiredis/hiredis.h>
 redisContext *c;							// Connection pointer
 redisReply *reply;							// Reply pointer
 
 int Rsets(char* Name, char* Value);		// Set method for redis connection with string 
 int Rseti(char* Name, int Value);			// Set method for redis connection with int
 int Rcon(void);  							// Connection to redis
 char* Rget (char* Name);
