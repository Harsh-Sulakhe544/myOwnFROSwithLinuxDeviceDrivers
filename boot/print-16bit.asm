print16:                     ; Entry point for the print16 function
    pusha                    ; Save all general-purpose registers onto the stack

; The strings will be terminated by a 0 byte in memory
print16_loop:               ; Start of the loop to print each character of the string
    mov al, [bx]            ; Load the byte at the address in 'bx' into 'al' (current character)
    cmp al, 0               ; Compare the character in 'al' with 0 (end of string)
    je print16_done         ; If it is 0, jump to print16_done to finish printing

    mov ah, 0x0e            ; Set 'ah' to 0x0e for teletype output (TTY)
    int 0x10                ; Call BIOS interrupt to print the character in 'al'

    ; Increment pointer and continue the loop
    add bx, 1               ; Move to the next character in the string
    jmp print16_loop        ; Repeat the loop for the next character

print16_done:               ; Label for the end of the print16 function
    popa                    ; Restore all general-purpose registers from the stack
    ret                     ; Return from the function

print16_nl:                 ; Entry point for printing a newline
    pusha                   ; Save all general-purpose registers onto the stack

    mov ah, 0x0e           ; Set 'ah' to 0x0e for teletype output (TTY)
    mov al, 0x0a           ; Load 'al' with the ASCII value for newline (LF)
    int 0x10               ; Call BIOS interrupt to print the newline character
    mov al, 0x0d           ; Load 'al' with the ASCII value for carriage return (CR)
    int 0x10               ; Call BIOS interrupt to print the carriage return character

    popa                    ; Restore all general-purpose registers from the stack
    ret                     ; Return from the function

print16_cls:                ; Entry point for clearing the screen
    pusha                   ; Save all general-purpose registers onto the stack

    mov ah, 0x00           ; Set 'ah' to 0x00 for video services
    mov al, 0x03           ; Load 'al' with 0x03 to set text mode 80x25 with 16 colors
    int 0x10               ; Call BIOS interrupt to change the video mode

    popa                    ; Restore all general-purpose registers from the stack
    ret                     ; Return from the function

; Receiving the data in 'dx'
; For the examples, we'll assume that we're called with dx=0x1234
print16_hex:                ; Entry point for printing a hexadecimal value
    pusha                   ; Save all general-purpose registers onto the stack

    mov cx, 0              ; Initialize our index variable 'cx' to 0

; Strategy: get the last char of 'dx', then convert to ASCII
; Numeric ASCII values: '0' (ASCII 0x30) to '9' (0x39), so just add 0x30 to byte N.
; For alphabetic characters A-F: 'A' (ASCII 0x41) to 'F' (0x46) we'll add 0x40
; Then, move the ASCII byte to the correct position on the resulting string
print16_hex_loop:          ; Start of the loop to convert and print hex digits
    cmp cx, 4              ; Compare 'cx' with 4 (we want to process 4 hex digits)
    je print16_hex_end     ; If 'cx' equals 4, jump to print16_hex_end

    ; 1. Convert last char of 'dx' to ASCII
    mov ax, dx             ; Move the value in 'dx' to 'ax' for processing
    and ax, 0x000f         ; Mask the upper 12 bits, keeping only the last hex digit
    add al, 0x30           ; Convert the digit to ASCII by adding 0x30
    cmp al, 0x39           ; Check if the value in 'al' is greater than '9'
    jle print16_hex_step2  ; If less than or equal to '9', proceed to step 2
    add al, 7              ; Adjust for ASCII values 'A' to 'F' (65-58=7)

print16_hex_step2:         ; Step 2: Determine the correct position for the ASCII char
    ; bx <- base address + string length - index of char
    mov bx, PRINT16_HEX_OUT + 5 ; Calculate the base address for output string
    sub bx, cx             ; Adjust 'bx' to point to the correct position
    mov [bx], al           ; Store the ASCII character in the calculated position
    ror dx, 4              ; Rotate 'dx' right by 4 bits to process the next hex digit

    ; Increment index and loop
    add cx, 1              ; Increment the index variable 'cx'
    jmp print16_hex_loop   ; Repeat the loop for the next hex digit

print16_hex_end:           ; End of the hex printing function
    ; Prepare the parameter and call the function
    ; Remember that print receives parameters in 'bx'
    mov bx, PRINT16_HEX_OUT ; Load the address of the output string into 'bx'
    call print16           ; Call the print16 function to display the hex string

    popa                    ; Restore all general-purpose registers from the stack
    ret                     ; Return from the function

PRINT16_HEX_OUT:           ; Reserve memory for the output string
    db '0x0000',0          ; Define a string with a null terminator

