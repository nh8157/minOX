#include "../drivers/screen.h"
#include "../drivers/low_level.h"
#include "../drivers/util.h"

// Print right after the current cursor
void print(char* str) {
	print_at(str, -1, -1);
}

// Generic print function
// Prints a string at a designated location
void print_at(char* str, int column, int row) {
	if (column >= 0 && row >= 0) {
		set_cursor(get_screen_offset(column, row));
	}
	int ptr = 0;
	while (str[ptr] != 0) {
		print_char(str[ptr], column, row, 0);
		ptr ++;
	}
}

void print_char(char content, int column, int row, char attr) {
	// Assign the pointer to the address in memory
	unsigned char* vram_ptr = (unsigned char*) VRAM_ADDR;
	int offset;
	// Set screen display attribute to default
	if (attr == 0)
		attr = WHITE_ON_BLACK;

	// Validate the cursor position
	if (row >= 0 && column >= 0) {
		// Position user provided is valid
		offset = get_screen_offset(column, row);
	} else {
		// Use cursor position if the coordinate is invalid
		offset = get_cursor();
	}
	
	// Write this character to corresponding VRAM addr
	if (content == '\n') {
		// Go to the next line and print nothing
		int new_row = offset / (2 * MAX_COLS);
		// Use 79 here because the next position would be 0 and new_row + 1
		offset = get_screen_offset(79, new_row);
	} else {
		// Write the character to the screen
		// Alternatively, use *(vram_ptr + offset)
		vram_ptr[offset] = content;
		vram_ptr[offset + 1] = attr;
	}
	// Move the cursor further to the right (2 bytes)
	offset += 2;
	// Reset the offset once we've reached the bottom of the screen
	offset = handle_scrolling(offset);
	set_cursor(offset);
}

int get_screen_offset(int column, int row) {
	return (row * MAX_COLS + column) * 2;
}

int get_cursor() {
	// Read from control registers of the cursor IO
	int offset;
	// 14 is the high byte of the offset register
	port_byte_out(REG_SCREEN_CTRL, 14);
	offset = port_byte_in(REG_SCREEN_DATA) << 8;
	// 15 is the low byte of the offset register
	port_byte_out(REG_SCREEN_CTRL, 15);
	offset += port_byte_in(REG_SCREEN_DATA);
	// remember each cell on screen takes up two bytes
	return offset * 2;
}

void set_cursor(int offset) {
	// Because each cell takes up two bytes
	offset /= 2;
	unsigned char high = (unsigned char) (offset >> 8);
	unsigned char low = (unsigned char) offset;
	port_byte_out(REG_SCREEN_CTRL, 14);
	port_byte_out(REG_SCREEN_DATA, high);
	port_byte_out(REG_SCREEN_CTRL, 15);
	port_byte_out(REG_SCREEN_DATA, low);
}

int handle_scrolling(int offset) {
	if (offset < MAX_COLS * MAX_ROWS * 2) {
		return offset;
	}
	// The cursor has reached the end of the screen
	// Need to scroll down a line
	int i;
	for (i = 1; i < MAX_ROWS; i ++) {
		mem_copy(get_screen_offset(0, i) + VRAM_ADDR,
				 get_screen_offset(0, i - 1) + VRAM_ADDR, 
				 MAX_COLS * 2
		);
	}
	char* last_line = (unsigned char*) get_screen_offset(0, MAX_ROWS - 1) + VRAM_ADDR;
	for (int i = 0; i < MAX_COLS * 2; i ++) {
		last_line[i] = 0;
	}
	return get_screen_offset(0, MAX_ROWS - 1);
}

void clear_screen() {
	unsigned char* vram_ptr = (unsigned char*) VRAM_ADDR;
	for (int i = 0; i < MAX_COLS * MAX_ROWS * 2; i += 2) {
		vram_ptr[i] = ' ';
		vram_ptr[i + 1] = WHITE_ON_BLACK;
	}
	set_cursor(0);
}
