#ifndef CORE_H
#define CORE_H

#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <sqlite3.h>

#define MAXLINE 150
#define true 1
#define false 0

char Program_Lines[50][MAXLINE];
int ReadLine(char *buff, int size, FILE *fp);
int targets [100];
int count;
int rc; 
int DB_stat;
#endif
