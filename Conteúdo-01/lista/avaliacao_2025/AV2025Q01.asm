section .data
	vet             dd      12, 16, -20, 24, 28, 32, -36, 40
	vetS            dd      8
section .bss
	vetor           resd    8
section .text
	global _start
_start:
	mov     ecx, [vetS]
	mov     esi, 0
laco:
	cmp     esi, ecx
	jz      _fim
	mov     eax, [vet + esi*4]
	sar     eax, 2
	mov     [vetor + esi*4], eax
	inc     esi
	jmp     laco
_fim:
	mov     rax, 60
	mov     rsi, 0
	syscall