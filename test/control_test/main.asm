; Hello World Program (Getting input)
; Compile with: nasm -f elf helloworld-input.asm
; Link with (64 bit systems require elf_i386 option): ld -m elf_i386 helloworld-input.o -o helloworld-input
; Run with: ./helloworld-input
 
%include        'functions.asm'
 
SECTION .data
msg_n       db      '[ welcome to the game  ]', 0Ah, 0h      
msg         db      '|                      |', 0Ah, 0h
 
SECTION .bss
sinput:     resb    1                                ; 为控制信号预留两个字节
 
SECTION .text
global  _start
 
_start:
 
    mov     eax, msg_n
    call    sprint
 
 loop:
    mov     edx, 1          ; number of bytes to read
    mov     ecx, sinput     ; reserved space to store our input (known as a buffer)
    mov     ebx, 0          ; write to the STDIN file
    mov     eax, 3          ; invoke SYS_READ (kernel opcode 3)
    int     80h

    cmp     sinput, 120     ; 选取x作为退出键
    jz      letsquit
 
    mov     eax, 0Ah
    call    sprint
 
    mov     eax, sinput     ; move our buffer into eax (Note: input contains a linefeed)
    call    sprint          ; call our print function

    jmp loop

 letsquit:
    call    quit