bits 16                                         ; 16-bit code 
org 0x7c00                                      ; set origin of the boot sector

boot:
    mov si, hello                               ; point si to our message
    mov ah, 0x0e                                ; write characters in TTY mode

.loop:
    lodsb                                       ; load a single byte from si to al
    test al, al                                 ; have we hit a NULL terminator?
    jz halt                                     ; if al == 0, stop execution
    int 0x10                                    ; allow printing to screen thru video services
    jmp .loop

halt:
    cli                                         ; stop the CPU from responding to external interrupts
    hlt                                         ; stop execution

hello: db "I hear brenda's got a baby!", 0x0    ; our message

times 512 - 0x2 - ($-$$) db 0x0 ; pad all "unfilled" bytes with zeroes apart from the last 2 meant for the magic word
dw 0xaa55 ; define magic value that marks code as bootable
