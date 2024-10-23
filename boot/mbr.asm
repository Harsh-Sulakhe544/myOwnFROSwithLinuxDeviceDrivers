[bits 16]                ; This directive tells the assembler that the following code is written for 16-bit mode.
[org 0x7c00]            ; This directive sets the origin of the code to address 0x7C00, which is the standard location for bootloaders in memory.

; where to load the kernel to
KERNEL_OFFSET equ 0x1000 ; Define a constant KERNEL_OFFSET that indicates where the kernel will be loaded in memory.

; BIOS sets boot drive in 'dl'; store for later use
mov [BOOT_DRIVE], dl     ; Move the value of the boot drive (stored in register dl) into the BOOT_DRIVE variable for later use.

; setup stack
mov bp, 0x9000           ; Set the base pointer (bp) to 0x9000, which is a common location for the stack in real mode.
mov sp, bp               ; Initialize the stack pointer (sp) to the value of bp, effectively setting up the stack.

call load_kernel         ; Call the load_kernel function to load the kernel into memory.
call switch_to_32bit     ; Call the switch_to_32bit function to switch the CPU to 32-bit mode.

jmp $                    ; Infinite loop to prevent falling through to unintended code.

%include "disk.asm"     ; Include external assembly code for disk operations.
%include "gdt.asm"      ; Include external assembly code for Global Descriptor Table setup.
%include "switch-to-32bit.asm" ; Include external assembly code for switching to 32-bit mode.

[bits 16]               ; Indicate that the following code is still in 16-bit mode.
load_kernel:            ; Define the load_kernel function.
    mov bx, KERNEL_OFFSET ; Move the KERNEL_OFFSET into bx, which will be the destination for loading the kernel.
    mov dh, 2             ; Set dh to 2, indicating the number of sectors to read from the disk.
    mov dl, [BOOT_DRIVE]  ; Load the boot drive value into dl for disk operations.
    call disk_load        ; Call the disk_load function to read the kernel from the disk.
    ret                   ; Return from the load_kernel function.

[bits 32]               ; Switch to 32-bit mode for the following code.
BEGIN_32BIT:            ; Define the entry point for 32-bit code.
    call KERNEL_OFFSET   ; Call the kernel that has been loaded into memory.
    jmp $                ; Infinite loop in case the kernel returns.

; boot drive variable
BOOT_DRIVE db 0         ; Define a byte variable to store the boot drive number, initialized to 0.

; padding
times 510 - ($-$$) db 0 ; Fill the remaining space in the boot sector with zeros until it reaches 510 bytes.

; magic number
dw 0xaa55               ; Define the boot signature (magic number) that indicates a valid boot sector.

