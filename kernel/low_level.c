#include "../drivers/low_level.h"
// short is 2 bytes
// This function is for reading a byte from a specific IO port
unsigned char port_byte_in(unsigned short port) {
	unsigned char result;
	// "=a" (result) puts AL register in variable result
	// "d" (port) loads port number into EDX
	__asm__("in %%dx, %%al" : "=a"(result) : "d"(port));
	return result;
}

void port_byte_out(unsigned short port, unsigned char byte) {
	// Why separate lines with two columns here?
	__asm__("out %%al, %%dx" : : "a"(byte), "d"(port));
}

unsigned short port_word_in(unsigned short port) {
	unsigned short result;
	__asm__("in %%dx, %%ax" : "=a"(result) : "d"(port));
	return result;
}

void port_word_out(unsigned short port, unsigned short word) {
	__asm__("out %%ax, %%dx" : : "a"(word), "d"(port));
}
