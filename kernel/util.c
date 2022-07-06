#include "../drivers/util.h"

void mem_copy(char* from, char* to, int num_of_bytes) {
	int i;
	for (i = 0; i < num_of_bytes; i ++) {
		*(to + i) = *(from + i);
	}
}
