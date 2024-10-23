#include "display.h"
#include "ports.h"
#include <stdint.h>

// KERNEL SPECIFIC IPORTS 
#include "../kernel/util.h"

void set_cursor(int offset) {
    offset /= 2;  // Convert byte offset to character cell offset
    port_byte_out(VGA_CTRL_REGISTER, VGA_OFFSET_HIGH);  // Select high byte register
    port_byte_out(VGA_DATA_REGISTER, (unsigned char) (offset >> 8));  // Send high byte
    port_byte_out(VGA_CTRL_REGISTER, VGA_OFFSET_LOW);  // Select low byte register
    port_byte_out(VGA_DATA_REGISTER, (unsigned char) (offset & 0xff));  // Send low byte
}

int get_cursor() {
    port_byte_out(VGA_CTRL_REGISTER, VGA_OFFSET_HIGH);  // Select high byte register
    int offset = port_byte_in(VGA_DATA_REGISTER) << 8;  // Read high byte and shift left
    port_byte_out(VGA_CTRL_REGISTER, VGA_OFFSET_LOW);  // Select low byte register
    offset += port_byte_in(VGA_DATA_REGISTER);  // Read low byte and add to offset
    return offset * 2;  // Convert character cell offset back to byte offset
}

// to get the off of the character 
int get_offset(int col, int row) {
    return 2 * (row * MAX_COLS + col);
}

// to goto the next line , 1st column ==> NEWLINE 
int get_row_from_offset(int offset) {
    return offset / (2 * MAX_COLS);
}


// to goto next line
int move_offset_to_new_line(int offset) {
    return get_offset(0, get_row_from_offset(offset) + 1);
}


// copy a chunk of memory-bites (similar to memcpy())
void memory_copy(char *source, char *dest, int nbytes) {
    int i;
    for (i = 0; i < nbytes; i++) {
        *(dest + i) = *(source + i);
    }
}

// to print a character on a screen 
void set_char_at_video_memory(char character, int offset) {
    unsigned char *vidmem = (unsigned char *) VIDEO_ADDRESS;
    vidmem[offset] = character;
    vidmem[offset + 1] = WHITE_ON_BLACK;
}

int scroll_ln(int offset) {
    memory_copy(
            (char *) (get_offset(0, 1) + VIDEO_ADDRESS),
            (char *) (get_offset(0, 0) + VIDEO_ADDRESS),
            MAX_COLS * (MAX_ROWS - 1) * 2
    );

    for (int col = 0; col < MAX_COLS; col++) {
        set_char_at_video_memory(' ', get_offset(col, MAX_ROWS - 1));
    }

    return offset - 2 * MAX_COLS;
}


/*
 * TODO:
 * - handle illegal offset (print error message somewhere)
 */
 
// now print each string with new-line case : 
void print_string(char *string) {
    int offset = get_cursor();
    int i = 0;
    while (string[i] != 0) {
        if (offset >= MAX_ROWS * MAX_COLS * 2) {
            offset = scroll_ln(offset);
        }
        if (string[i] == '\n') {
            offset = move_offset_to_new_line(offset);
        } else {
            set_char_at_video_memory(string[i], offset);
            offset += 2;
        }
        i++;
    }
    set_cursor(offset);
}

// print next-line 
void print_nl() {
    int newOffset = move_offset_to_new_line(get_cursor());
    if (newOffset >= MAX_ROWS * MAX_COLS * 2) {
        newOffset = scroll_ln(newOffset);
    }
    set_cursor(newOffset);
}

// to clear our bios fillef from video-memory, cuz of kernel 
void clear_screen() {
    for (int i = 0; i < MAX_COLS * MAX_ROWS; ++i) {
        set_char_at_video_memory(' ', i * 2);
    }
    set_cursor(get_offset(0, 0));
}

