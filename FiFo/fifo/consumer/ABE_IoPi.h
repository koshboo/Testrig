#include <stdint.h>
void write_pin(char address, char pin, char value);
void set_pin_pullup(char address, char pinval, char value);
int  read_pin(char address, char pinval);
void set_pin_direction(char address, char pin, char direction);
void IOPI_init (uint8_t address, uint8_t reset);
