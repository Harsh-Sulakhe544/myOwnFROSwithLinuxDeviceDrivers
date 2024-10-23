// kernel.c
// This file contains the main function that writes a character to the video memory
// It is intended to be executed in a low-level environment, such as a bootloader.

void main() {
    char* video_memory = (char*) 0xb8000; // Pointer to the start of video memory - intel 
    *video_memory = 'X';                   // Write the character 'X' to the video memory
    while (1); // Infinite loop to prevent exit
}

