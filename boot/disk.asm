disk_load:
    pusha                ; Save all general-purpose registers onto the stack
    push dx              ; Save the DX register, which may hold the drive number

    mov ah, 0x02        ; Set AH to 0x02 to indicate the read mode for the BIOS interrupt
    mov al, dh          ; Load AL with the number of sectors to read (from DH)
    mov cl, 0x02        ; Set CL to 2, indicating the starting sector (sector 2)
                         ; Note: Sector 1 is typically the boot sector and is not read here
    mov ch, 0x00        ; Set CH to 0, indicating cylinder 0
    mov dh, 0x00        ; Set DH to 0, indicating head 0

    ; dl = drive number is set as input to disk_load
    ; es:bx = buffer pointer is set as input as well
    ; Here, ES:BX should point to the memory location where the data will be read into

    int 0x13            ; Call BIOS interrupt 0x13 to perform the disk read operation
    jc disk_error       ; Jump to disk_error if the carry flag is set (indicating an error)

    pop dx              ; Restore the original value of DX (drive number)
    cmp al, dh          ; Compare the number of sectors actually read (AL) with the requested number (DH)
    jne sectors_error   ; If they are not equal, jump to sectors_error
    popa                ; Restore all general-purpose registers from the stack
    ret                  ; Return from the disk_load function

disk_error:
    jmp disk_loop       ; Loop indefinitely in case of a disk error

sectors_error:
    jmp disk_loop       ; Loop indefinitely in case of a sector read error

disk_loop:
    jmp $               ; Infinite loop to halt execution

