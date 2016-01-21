global long_mode_start

section .text
bits 64
long_mode_start:
	; call the kernel main
	extern kmain
	call kmain

	; print 'flintOS' to screen
	mov word [0xb8000], 0x0266 ; f
	mov word [0xb8002], 0x026c ; l
	mov word [0xb8004], 0x0269 ; i
	mov word [0xb8006], 0x026e ; n
	mov word [0xb8008], 0x0274 ; t
	mov word [0xb800a], 0x024f ; O
	mov word [0xb800c], 0x0253 ; S
	hlt
	
