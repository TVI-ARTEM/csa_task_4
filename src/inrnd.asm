extern rand

extern SQUARE
extern DIAGONAL
extern LTRIANGLE

extern printf

global Random
Random:
section .data
    mod20 dq 20
section .text
push rbp
mov rbp, rsp

    xor rax, rax
    call rand
    xor rdx, rdx
    idiv qword[mod20]
    mov rax, rdx
    inc rax
    
leave
ret

global RandomKey
RandomKey:
section .data
    mod3 dq 3
section .text
push rbp
mov rbp, rsp

    xor rax, rax
    call rand
    xor rdx, rdx
    idiv qword[mod3]
    mov rax, rdx
    inc rax
    
leave
ret

global InRandomSquare
InRandomSquare:
section .bss
    .square resq 1
section .text
push rbp
mov rbp, rsp
    mov [.square],  rdi
    call Random
    mov rbx, [.square]
    mov [rbx], rax
    mov r12, rax
    imul r12, r12
    
    mov r15, 1
    mov r14, 0
.genLoop:
    mov r9, r15
    dec r9
    cmp r9, r12
    je .return
    
    inc r15
    
    call Random
    mov rbx, [.square]
    add rax, -10
    mov r9, rax
    mov [rbx + r15*8], r9
    add r14, r9
    jmp .genLoop
    
.return:
    mov rbx, [.square]
    mov [rbx + 8], r14
leave
ret

global InRandomDiagonal
InRandomDiagonal:
section .data
    .out db "Sum = %d",  10, 0
section .bss
    .diagonal resq 1
section .text
push rbp
mov rbp, rsp
    mov [.diagonal],  rdi
    call Random
    mov rbx, [.diagonal]
    mov [rbx], rax
    mov r12, rax
    inc r12

    mov r15, 1
    mov r14, 0
.genLoop:
    cmp r15, r12
    je .return
    
    inc r15
    
    call Random
    mov rbx, [.diagonal]
    add rax, -10
    mov r9, rax

    mov [rbx + r15*8], r9
    add r14, r9

    jmp .genLoop
    
.return:
    mov rbx, [.diagonal]
    mov [rbx + 8], r14
    
    
    
leave
ret

global InRandomLTriangle
InRandomLTriangle:
section .data
    mod2 dq 2
section .bss
    .ltriangle resq 1
section .text
push rbp
mov rbp, rsp
    mov [.ltriangle],  rdi
    call Random
    mov rbx, [.ltriangle]
    mov [rbx], rax
    mov r12, rax

    mov r14, r12
    inc r14
    imul r12, r14

    xor rax, rax
    mov rax, r12
    xor rdx, rdx
    idiv qword[mod2]
    mov r12, rax 

    mov r15, 1
    xor r14, r14
    mov r14, 0
.genLoop:
    dec r15
    cmp r15, r12
    je .return
    
    add r15, 2
    
    call Random
    mov rbx, [.ltriangle]
    add rax, -10
    mov r9, rax

    mov [rbx + r15*8], r9
    add r14, r9

    jmp .genLoop
    
.return:
    mov rbx, [.ltriangle]
    mov [rbx + 8], r14
leave
ret

global InRandomMatrix
InRandomMatrix:
section .bss
    .pmatrix resq 1
    .key resq 1
section .text
push rbp
mov rbp, rsp
    mov [.pmatrix], rdi
    call RandomKey
    mov rdi, [.pmatrix]
    mov [rdi], rax
    mov r12, rax 

    cmp r12, [SQUARE]
    je .square
    cmp r12, [DIAGONAL]
    je .diagonal
    cmp r12, [LTRIANGLE]
    je .ltriangle
    xor rax, rax
    xor r12, r12
    jmp .return
.square:

    add rdi, 8
    call InRandomSquare
    mov rax, 1
    jmp .return
.diagonal:

    add rdi, 8
    call InRandomDiagonal
    mov rax, 1
    jmp .return
.ltriangle:
 
    add rdi, 8
    call InRandomLTriangle
    mov rax, 1
    jmp .return
.return:
leave
ret

global InRandomCont
InRandomCont:
section .bss
    .pcont resq 1
    .plen resq 1
    .psize resd 1
section .text
push rbp
mov rbp, rsp
    mov [.pcont], rdi  
    mov [.plen], rsi    
    mov [.psize], edx
    
    xor ebx, ebx
.genLoop:
    cmp ebx, edx
    jge .return
    
    push rdi
    push rbx
    push rdx
    
    call InRandomMatrix
    
    cmp rax, 0
    jle .return
    
    pop rdx
    pop rbx
    inc rbx
    
    pop rdi
    add rdi, 7208
    
    jmp .genLoop
.return:
    mov rax, [.plen]
    mov [rax], ebx
leave
ret





















