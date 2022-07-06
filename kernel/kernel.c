#include "../drivers/screen.h"
#include "../drivers/util.h"

void main() {
	clear_screen();

	char* string = "Welcome to minOX\n";
	// pointer to a char, which represents the first text cell of the video memory
	print("hi\n");
	print("hello\n");
	print("What's up\n");
	set_cursor(get_screen_offset(0, MAX_ROWS - 1));
	print("rld\n");
	print("asdfasdf");
}
