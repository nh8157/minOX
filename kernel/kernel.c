void print(char* str);

void main() {
	char* string = "Hello world, this is the minOX";
	// pointer to a char, which represents the first text cell of the video memory
	print(string);
}

void print(char* str) {
	char* video_memory = (char*) 0xb8000;
	// String ends with a 0
	while (*str != 0) {
		*video_memory = *str; 	// assign the value str is pointed to to the memory cell pointed by video_memory
		video_memory += 2;		// each cell takes up 2 bytes
		str += 1;
	}
}
