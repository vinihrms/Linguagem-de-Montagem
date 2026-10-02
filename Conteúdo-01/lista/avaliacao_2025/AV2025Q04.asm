section .data
    n1 : db "a"
    n2 : dw 1024
    n3 : dw 2048,4096
    n4 : dd -2147483648

section .bss
    v1 : resb 1
    v2 : resw 1
    v3 : resd 1
    v4 : resq 1

section .text
    global _start:

_start:
    ; i = 1
    mov al, [n1]
    mov [v1], al

    ; i = 2
    mov bx, [n2]
    mov [v2], bx

    ; i = 3
    movzx edx, word [n3]
    mov [v3], edx

    ; i = 4
    movsx rcx, dword [n4]
    mov [v4], rcx

fim:
    mov eax, 60
    mov rdi, 0
    syscall