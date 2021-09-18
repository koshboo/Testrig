#include "Core.h"
#include <ctype.h>
#include <time.h>


int ReadLine(char *buff, int size, FILE *fp)
{
   buff[0] = '\0';
   buff[size - 1] = '\0';             /* mark end of buffer */
   char *tmp;

   if (fgets(buff, size, fp) == NULL) {
      *buff = '\0';                   /* EOF */
      return false;
   }
   else 
	{
      /* remove newline */
      if ((tmp = strrchr(buff, '\n')) != NULL) {
         *tmp = '\0';
      }
   }
   return true; 
}



