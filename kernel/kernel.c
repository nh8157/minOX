void main() {
	// pointer to a char, which represents the first text cell of the video memory
	char* video_memory = (char*) 0xb8000;

	*video_memory = 'X';
}
