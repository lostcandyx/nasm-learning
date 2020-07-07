; 这里对显示程序进行测试
; 暂定是控制台宽24字，高16字
; 研究控制台游戏的可行性

%include        'functions.asm'
 
SECTION .data
msg_n       db      '[ welcome to the game  ]', 0Ah, 0h      
msg         db      '|                      |', 0Ah, 0h

SECTION .bss
show:       RESW        1

SECTION .text
global  _start

_start:
    mov     eax, msg_n
    call    sprint
    mov     ecx,0

loop:
    inc ecx
    cmp ecx,15
    jz letsquit
    mov     eax, msg
    call    sprint
    jmp loop

letsquit:
    call quit

