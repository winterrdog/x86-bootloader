section .boot
bits 16
; org 0x7c00 -- set in linker script
global boot
boot:
    mov ax, 0x2401                  ; turn on the A20 gate
    int 0x15                        ; turn on the A20 bit which "allows" addressing memory larger than 1MiB

    ; set VGA mode for color mode to show white text in front of a blue bkg
    xor ax, ax
    mov ax, 0x3
    int 0x10

    mov [disk], dl

    xor ax, ax
    mov ah, 0x2                     ; read sectors of a hard disk
    mov al, 0x6                     ; sectors to read
    mov ch, 0x0                     ; cylinder index
    mov dh, 0x0                     ; head index
    mov cl, 0x2                     ; sector index
    mov dl, [disk]                  ; disk index - set BIOS implicitly
    mov bx, copy_target             ; target pointer
    int 0x13                        ; get disk services

    cli

    ; enter protected mode & load the GDT for segmented memory addressing
    lgdt [gdt_ptr]
    mov eax, cr0
    or eax, 0x1             ; set protected mode via cr0
    mov cr0, eax

    xor ax, ax
    mov ax, DATA_SEG        ; setup memory layout of program
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
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

disk:
    db 0x0

CODE_SEG equ gdt_code_seg - gdt_start
DATA_SEG equ gdt_data_seg - gdt_start

times 512 - 0x2 - ($-$$) db 0x0 ; add padding
dw 0xaa55

copy_target:
bits 32

message:
    db "Now lemme show you that it's past 512 bytes!", 0x0

boot2:
    mov esi, message
    mov ebx, 0xb8000 ; set VGA service

.loop:
    lodsb
    test al, al ; is it a NULL terminator?
    jz halt
    or eax, 0x9e00 ; set color of text and its bkg i.e. first byte, 9e
    mov word [ebx], ax ; move curr character and color into VGA buffer for printing
    add ebx, 0x2
    jmp .loop

halt:
    ; prepare for the external C call
    mov esp, kernel_stack_begin
    extern kmain
    call kmain
    cli
    hlt ; stop program

; create stack space for the C program call stack - 16KiB
section .bss
align 0x4
kernel_stack_end: equ $
    resb 16384              ; 16KiB
kernel_stack_begin:
