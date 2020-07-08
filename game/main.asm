%include        'functions.asm'

%define     key_buf_size 	512
%define     key_code  		26
%define     key_value  		28
%define     start_x         2
%define     start_y         10
%define     max_x           22
%define     max_y           13
%define     target_x        20
%define     target_y        2

SECTION .data
k_input 		db 		"/dev/input/event3", 0x0
title       	db      '[ welcome to this game ]', 0Ah, 0h      
border    	    db      '|                      |', 0Ah, 0h
w_msg			db		'|  keyboard w pressed  |', 0Ah, 0h
a_msg			db		'|  keyboard a pressed  |', 0Ah, 0h
s_msg			db		'|  keyboard s pressed  |', 0Ah, 0h
d_msg			db		'|  keyboard d pressed  |', 0Ah, 0h
x_msg			db		'|  keyboard x pressed  |', 0Ah, 0h
q_msg			db		'|  keyboard q pressed  |', 0Ah, 0h
space           db      ' ', 0Ah, 0h
tail            db      '|', 0Ah, 0h
normal          db      ' ', 0h
self            db      'o', 0h
line            db      '|', 0h
target          db      'x', 0h

help1           db      '|   This is a sample   |', 0Ah, 0h
help2           db      '|   of consolo game    |', 0Ah, 0h
help3           db      '|  press w to move up  |', 0Ah, 0h
help4           db      '| press s to move down |', 0Ah, 0h
help5           db      '| press a to move left |', 0Ah, 0h
help6           db      '|press d to move right.|', 0Ah, 0h
help7           db      '|----------------------|', 0Ah, 0h
help8           db      '|  Move o to cover x!  |', 0Ah, 0h
help9           db      '|      Good luck!      |', 0Ah, 0h

prize1          db      '|     You succeed!     |', 0Ah, 0h
prize2          db      '|Thank you for playing!|', 0Ah, 0h
prize3          db      '|   Have a nice day!   |', 0Ah, 0h

SECTION .bss
key_buf         resb    key_buf_size


SECTION .text
global  _start

drawpoint:
    cmp     ecx, target_y
    jz      point2

    mov     eax, line
    call    sprint
    push    ecx
    mov     ecx,0
drawloop:
    inc     ecx
    cmp     ecx,23
    jz      drawtail

    cmp     ecx,ebx
    jz      draw_o

    mov     eax,normal
    call    sprint
    jmp     drawloop

draw_o:
    mov     eax, self
    call    sprint
    jmp     drawloop

point2:
    mov     eax, line
    call    sprint
    push    ecx
    mov     ecx,0
    jmp     drawloop2
drawloop2:
    inc     ecx
    cmp     ecx,23
    jz      drawtail

    cmp     ecx, ebx
    jz      draw_o2

    cmp     ecx, target_x
    jz      draw_t2

    mov     eax, normal
    call    sprint
    jmp     drawloop2

draw_t2:
    mov     eax, target
    call    sprint
    jmp     drawloop2

draw_o2:
    mov     eax, self
    call    sprint
    jmp     drawloop2

drawtail:
    mov     eax,tail
    call    sprint
    pop     ecx
    ret

drawtarget:
    mov     eax,line
    call    sprint
    push    ecx
    mov     ecx,0
drawloop_t:
    inc     ecx
    cmp     ecx,23
    jz      drawtail_t
    cmp     ecx,target_x
    jz      draw_o_t
    mov     eax,normal
    call    sprint
    jmp     drawloop_t

draw_o_t:
    mov     eax,target
    call    sprint
    jmp     drawloop_t

drawtail_t:
    mov     eax,tail
    call    sprint
    pop     ecx
    ret

game_readk_input:
    push    ebx
    push    ecx
    push    edx
    mov     eax, 5
    mov     ebx, k_input
    mov     ecx, 0
    int     0x80

    mov     eax, 3
    mov     ebx, eax
    mov     ecx, key_buf
    mov     edx, key_buf_size
    int     0x80

;	mov eax, 4
;	mov ebx, 1
;	mov ecx, key_buf
;	mov edx, key_buf_size
;	int 0x80

    pop     ebx
    pop     ecx
    pop     edx
    ret

analyze_byte:
        push    ebx
        push    ecx
        push    edx
		mov     eax, key_buf
		mov		ebx, key_value
    	add     eax, ebx

		cmp     byte [eax], 1
		jz      pressed
		jmp		released
	pressed:
    	mov     eax, key_buf
		mov		ebx, key_code
    	add     eax, ebx

		cmp     byte [eax], 17		; w
		jz      w_pressed

		cmp     byte [eax], 30		; a
		jz      a_pressed

		cmp     byte [eax], 31		; s
		jz      s_pressed

		cmp     byte [eax], 32		; d
		jz      d_pressed

		cmp     byte [eax], 45		; x
		jz      x_pressed

		cmp     byte [eax], 16		; q
		jz      q_pressed

		jmp     released
	
	w_pressed:
        mov 	eax, space
		call sprint
		mov 	eax, w_msg
		call sprint
		mov		eax, 1
		jmp		finish
	
	a_pressed:
        mov 	eax, space
		call sprint
		mov 	eax, a_msg
		call sprint
		mov		eax, 2
		jmp		finish
	
	s_pressed:
        mov 	eax, space
		call sprint
		mov 	eax, s_msg
		call sprint
		mov		eax, 3
		jmp		finish

	d_pressed:
        mov 	eax, space
		call sprint
		mov 	eax, d_msg
		call sprint
		mov		eax, 4
		jmp		finish

	x_pressed:
        mov 	eax, space
		call sprint
		mov 	eax, x_msg
		call sprint
		mov		eax, 5
		jmp		finish

	q_pressed:
        mov 	eax, space
		call sprint
		mov 	eax, q_msg
		call sprint
		mov		eax, 6
		jmp		finish

	released:
		mov		eax, 0
		jmp		finish


	finish:
;		call    iprintLF
        pop     ebx
        pop     ecx
        pop     edx
		ret

showhelp:
    mov     eax, border
    call sprint
    mov     eax, help1
    call sprint
    mov     eax, help2
    call sprint
    mov     eax, help3
    call sprint
    mov     eax, help4
    call sprint
    mov     eax, help5
    call sprint
    mov     eax, help6
    call sprint
    mov     eax, help7
    call sprint
    mov     eax, help8
    call sprint
    mov     eax, help9
    call sprint
    mov     eax, help7
    call sprint
    mov     eax, border
    call sprint
    mov     eax, border
    call sprint
    ret

showprize:
    mov     eax, border
    call sprint
    mov     eax, border
    call sprint
    mov     eax, border
    call sprint
    mov     eax, help7
    call sprint
    mov     eax, border
    call sprint
    mov     eax, prize1
    call sprint
    mov     eax, prize2
    call sprint
    mov     eax, prize3
    call sprint
    mov     eax, border
    call sprint
    mov     eax, help7
    call sprint
    mov     eax, border
    call sprint
    mov     eax, border
    call sprint
    mov     eax, border
    call sprint

    mov     ebx, start_x
    mov     edx, start_y
    jmp     mloop
    ret

_start:
	mov     eax, title
	call    sprint
    mov     ebx, start_x          ;使用ebx存储点的横坐标1～20
    mov     edx, start_y          ;使用edx存储点的纵坐标1～13
    jmp     displayloop
mloop:
	call    game_readk_input
    call    analyze_byte
    cmp     eax, 0
    jne     judge
    jmp     mloop

win_or_not:
    cmp     edx, target_y
    jz      nearsuccess
    jmp     action

action:
    mov     eax, title
    call    sprint
    mov     ecx, 0
    jmp     displayloop

nearsuccess:
    cmp     ebx, target_x
    jz      success
    jmp     action

success:
    call showprize

judge:
    mov     ecx, 1

    cmp     eax, 1
    jz      w_up
    cmp     eax, 2
    jz      a_left
    cmp     eax, 3
    jz      s_down
    cmp     eax, 4
    jz      d_right
    cmp     eax, 5
    jz      x_quit
    cmp     eax, 6
    jz      q_help

    jmp     action

w_up:
    sub     edx, ecx
    jmp     win_or_not

a_left:
    sub     ebx, ecx
    jmp     win_or_not

s_down:
    add     edx, ecx
    jmp     win_or_not

d_right:
    add     ebx, ecx
    jmp     win_or_not
q_help:
    call    showhelp
    jmp     mloop
x_quit:
    mov     ebx, 0
    mov     eax, 1
    int     80h

displayloop:
    inc     ecx
    cmp     ecx,14
    jz      mloop

    cmp     ecx, edx
    jz      displaypoint

    cmp     ecx, target_y
    jz      displaytarget

    mov     eax, border
    call    sprint

    jmp     displayloop

displaypoint:
    call    drawpoint
    jmp     displayloop

displaytarget:
    call    drawtarget
    jmp     displayloop