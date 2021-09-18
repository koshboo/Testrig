#include <sqlite3.h>
sqlite3 *db;
sqlite3_stmt *res;

int targets [100];
int targ_count;
int rc;
char* get_time (void);
char* Add_intostr (char* S,int I);
void New_process (char* Name,char* Argval);
int openDB(void);
int closeDB(void);

