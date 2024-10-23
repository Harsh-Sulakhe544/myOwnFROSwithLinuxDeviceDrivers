; kernel_entry.asm
; This is a simple bootloader that calls the main function defined in kernel.c
; It is written for a 32-bit architecture.

[bits 32]          ; Specify that we are working in 32-bit mode
[extern main]      ; Declare the external function 'main' which is defined in kernel.c

_start:            ; Entry point of the program
    call main      ; Call the main function to execute the C code
    jmp $          ; Infinite loop to prevent falling through to undefined code

