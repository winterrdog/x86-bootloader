bits 16
org 0x7c00

boot:
    mov ax, 0x2401          ; turn on the A20 gate
    int 0x15                ; turn on the A20 bit which "allows" addressing memory larger than 1MiB

    ; set VGA mode for color mode to show white text in front of a blue bkg
    xor ax, ax
    mov ax, 0x3
    int 0x10

    ; enter protected mode & load the GDT for segmented memory addressing
    lgdt [gdt_ptr]
    mov eax, cr0
    or eax, 0x1             ; set protected mode via cr0
    mov cr0, eax
    jmp CODE_SEG:boot2      ; jump to the code segment

; define the GDT structure
gdt_start:
    dq 0x0                  ; null segment -- required blank by Intel
gdt_code_seg:
    dw 0xffff               ; limit high
    dw 0x0                  ; base low
    db 0x0                  ; base middle
    db 10011010b            ; access byte
    db 11001111b            ; flags and limit low
    db 0x0                  ; base high
gdt_data_seg:
    dw 0xffff               ; limit high
    dw 0x0                  ; base low
    db 0x0                  ; base middle
    db 10010010b            ; access byte
    db 11001111b            ; flags and limit low
    db 0x0                  ; base high
gdt_end:

gdt_ptr:
    dw gdt_end - gdt_start  ; GDT size
    dd gdt_start            ; ptr to gdt

CODE_SEG equ gdt_code_seg - gdt_start
DATA_SEG equ gdt_data_seg - gdt_start

; enter 32-bit world
bits 32
boot2:
    xor ax, ax
    mov ax, DATA_SEG        ; setup memory layout of program
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    mov esi, message
    mov ebx, 0xb8000        ; use VGA text buffer for printing on screen

.loop:
    lodsb
    test al, al
    jz halt                 ; stop when a NULL terminator is hit
    or eax, 0x0200          ; set foreground color to green( the 1 in 0x100 )
    mov word [ebx], ax      ; move ascii character into ebx for printing
    add ebx, 0x2            ; move ahead 2 bytes since each character on the VGA needs 2 bytes(one for character and one for its attributes )
    jmp .loop

halt:
    cli
    hlt

message: 
    db "i hear brenda's got a baby!", 0x0

times 512 - 0x2 - ($-$$) db 0x0
dw 0xaa55                   ; mark as bootable