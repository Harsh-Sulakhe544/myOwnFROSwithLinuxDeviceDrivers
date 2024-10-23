[bits 32] ; Specify that we are using 32-bit protected mode

; Define constants for video memory and character attributes
VIDEO_MEMORY equ 0xb8000 ; Base address for video memory in text mode
WHITE_ON_BLACK equ 0x0f   ; Color attribute for white text on a black background

print32: ; Label for the print32 function
    pusha ; Push all general-purpose registers onto the stack to save their state
    mov edx, VIDEO_MEMORY ; Load the address of video memory into the edx register

print32_loop: ; Start of the loop to print characters
    mov al, [ebx] ; Load the character at the address pointed to by ebx into the al register
    mov ah, WHITE_ON_BLACK ; Set the high byte of ax to the color attribute

    cmp al, 0 ; Compare the character in al with 0 to check for the end of the string
    je print32_done ; If the character is 0 (null terminator), jump to print32_done

    mov [edx], ax ; Store the character and its attribute in video memory at the address in edx
    add ebx, 1 ; Move to the next character in the string by incrementing ebx
    add edx, 2 ; Move to the next position in video memory (each character takes 2 bytes)

    jmp print32_loop ; Repeat the loop for the next character

print32_done: ; Label for the end of the print32 function
    popa ; Restore the state of all general-purpose registers from the stack
    ret ; Return from the print32 function

