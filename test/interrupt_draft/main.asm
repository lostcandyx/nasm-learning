%include        'functions.asm'

%define key_buf_size 512

SECTION .data
k_input 		db 		"/dev/input/event3", 0x0
title       	db      '[ welcome to this game ]', 0Ah, 0h      
border    	    db      '|                      |', 0Ah, 0h
w_msg			db		'|  keyboard w pressed  |', 0Ah, 0h

SECTION .bss
key_buf resb key_buf_size


SECTION .text
global  _start
 
_start:
	mov     eax, title
	call    sprint
loop:
	call _game_l_readk_input
	jmp loop

_game_l_readk_input:
		mov eax, 5
		mov ebx, k_input
		mov ecx, 0
		int 0x80

		mov eax, 3
		mov ebx, eax
		mov ecx, key_buf
		mov edx, key_buf_size
		int 0x80

;		mov eax, 4
;		mov ebx, 1
;		mov ecx, key_buf
;		mov edx, key_buf_size
;		int 0x80

		call analyze_byte
		ret

analyze_byte:
		mov		edx, 28
		mov     eax, key_buf
		mov     ebx, 28
    	add     eax, ebx
	nextbyte:
    	
		cmp     byte [eax], 1
		jz      pressed
		cmp     byte [eax], 0
		jz      finish
		inc     eax
		inc 	edx
		
		jmp     nextbyte
	
	pressed:
		mov     eax, edx
		call    iprintLF
		jmp finish
	finish:
		mov     eax, title
		call    sprint
		mov		eax, edx

		ret