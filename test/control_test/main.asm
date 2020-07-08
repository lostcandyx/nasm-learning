%include        'functions.asm'

%define key_buf_size 	512
%define key_code  		26
%define key_value  		28
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
space       	db    ' ', 0Ah, 0h

SECTION .bss
key_buf resb key_buf_size


SECTION .text
global  _start
 
_start:
	mov     eax, title
	call    sprint
loop:
	call _game_l_readk_input
   mov     eax, title
   call    sprint
   mov     ecx,0
   jmp     displayloop

displayloop:
   inc ecx
   cmp ecx,14
   jz loop
   mov     eax, border
   call    sprint
   jmp displayloop

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
		ret