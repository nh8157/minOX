#define VRAM_ADDR 0xb8000
// Resolution under the VGA mode
#define MAX_ROWS 25
#define MAX_COLS 80

// Define color mode on the screen
#define WHITE_ON_BLACK 0x0f

// Screen device I/O
// What is this for?
#define REG_SCREEN_CTRL 0x3d4
#define REG_SCREEN_DATA 0x3d5

// Print a string at the cursor's position
void print(char* str);
// Function to printer a string at a given location
void print_at(char* str, int col, int row);
// Function to print a character
void print_char(char content, int column, int row, char attr);
// Calculate memory offset based on row and column input
int get_screen_offset(int column, int row);
// Acquire the current cursor position
int handle_scrolling(int offset);
void clear_screen();
void set_cursor(int offset);
int get_cursor();
