;;; gdt_start and gdt_end labels are used to compute size

; null segment descriptor
gdt_start:
    dq 0x0  ; A null descriptor, used to avoid null pointer dereferences

; code segment descriptor
gdt_code:
    dw 0xffff    ; segment length, bits 0-15 (maximum size of 64KB)
    dw 0x0       ; segment base, bits 0-15 (base address low)
    db 0x0       ; segment base, bits 16-23 (base address mid)
    db 10011010b ; flags (8 bits): 
                  ; 1. Present (P) = 1
                  ; 2. Descriptor Privilege Level (DPL) = 00 (highest privilege)
                  ; 3. Code Segment (C) = 1 (executable)
                  ; 4. Conforming (C) = 1 (can be executed in lower privilege)
                  ; 5. Readable (R) = 1 (readable)
                  ; 6. Expand Down (E) = 0 (not expandable down)
                  ; 7. Code Segment (S) = 1 (code segment)
                  ; 8. Type (T) = 0 (not a system segment)
    db 11001111b ; flags (4 bits) + segment length, bits 16-19:
                  ; 1. Granularity (G) = 1 (1MB granularity)
                  ; 2. Size (S) = 1 (32-bit segment)
                  ; 3. Segment length, bits 16-19
    db 0x0       ; segment base, bits 24-31 (base address high)

; data segment descriptor
gdt_data:
    dw 0xffff    ; segment length, bits 0-15 (maximum size of 64KB)
    dw 0x0       ; segment base, bits 0-15 (base address low)
    db 0x0       ; segment base, bits 16-23 (base address mid)
    db 10010010b ; flags (8 bits):
                  ; 1. Present (P) = 1
                  ; 2. Descriptor Privilege Level (DPL) = 00 (highest privilege)
                  ; 3. Data Segment (C) = 0 (not executable)
                  ; 4. Expand Down (E) = 0 (not expandable down)
                  ; 5. Writable (W) = 1 (writable)
                  ; 6. Accessed (A) = 0 (not accessed)
                  ; 7. Data Segment (S) = 1 (data segment)
                  ; 8. Type (T) = 0 (not a system segment)
    db 11001111b ; flags (4 bits) + segment length, bits 16-19
    db 0x0       ; segment base, bits 24-31 (base address high)

gdt_end:

; GDT descriptor
gdt_descriptor:
    dw gdt_end - gdt_start - 1 ; size (16 bit) of the GDT
    dd gdt_start ; address (32 bit) of the GDT

; Define segment offsets
CODE_SEG equ gdt_code - gdt_start ; Offset of the code segment descriptor
DATA_SEG equ gdt_data - gdt_start ; Offset of the data segment descriptor

