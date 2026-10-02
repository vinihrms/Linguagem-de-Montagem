section .data
    v1 : db 'Kart_'
    v2 : dw 'é_'
    v3 : db ' _ _ _ '

section .text
    global _start
_start:
    mov eax, [v1]
    mov bx, [v1]
    mov cl, [v1]
    mov r8, [v1]
fim:
    mov rax, 60
    mov rdi, 0
    syscall