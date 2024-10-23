[bits 16]                  ; Specify that the following code is in 16-bit mode
switch_to_32bit:           ; Label for the entry point of the switch function
    cli                     ; 1. Disable interrupts to prevent any interruptions during the transition
    lgdt [gdt_descriptor]   ; 2. Load the Global Descriptor Table (GDT) descriptor from memory
    mov eax, cr0           ; 3. Move the current value of Control Register 0 (CR0) into EAX
    or eax, 0x1            ; 4. Set the PE (Protection Enable) bit in CR0 to enable protected mode
    mov cr0, eax           ; 5. Write the modified value back to CR0
    jmp CODE_SEG:init_32bit ; 6. Perform a far jump to the 32-bit code segment to continue execution

[bits 32]                  ; Specify that the following code is in 32-bit mode
init_32bit:                ; Label for the initialization routine in 32-bit mode
    mov ax, DATA_SEG       ; 7. Load the data segment selector into AX
    mov ds, ax             ; 8. Update the data segment register (DS) with the new segment
    mov ss, ax             ; 9. Update the stack segment register (SS) with the new segment
    mov es, ax             ; 10. Update the extra segment register (ES) with the new segment
    mov fs, ax             ; 11. Update the FS segment register with the new segment
    mov gs, ax             ; 12. Update the GS segment register with the new segment

    mov ebp, 0x90000       ; 13. Set up the base pointer (EBP) for the stack at address 0x90000
    mov esp, ebp           ; 14. Initialize the stack pointer (ESP) to the base pointer (EBP)

    call BEGIN_32BIT       ; 15. Call the function BEGIN_32BIT to continue execution in 32-bit mode

