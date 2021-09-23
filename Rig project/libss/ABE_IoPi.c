#include </home/aron/Desktop/Test_area/Rig project/libss/ABE_IoPi.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void write_pin(char address, char pin, char value)
{
printf("Port -  %i   Pin - %i ---- val - %i \n",address,pin,value);	
fflush(stdout);
}

void set_pin_pullup(char address, char pinval, char value)
{
	
}

int read_pin(char address, char pinval)
{
 return 1;
}

void set_pin_direction(char address, char pin, char direction)
{
	
}

