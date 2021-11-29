extern printf
extern fscanf

extern SQUARE
extern DIAGONAL
extern LTRIANGLE


global InSquare
InSquare:
section .data
    .infmt db "%d", 0
section .bss
    .FILE resq 1
    .psquare resq 1
section .text
push rbp
mov rbp, rsp

    mov [.psquare], rdi
    mov [.FILE], rsi
    
    mov rdi, [.FILE]
    mov rsi, .infmt
    mov rdx, [.psquare]
    xor rax, rax
    call fscanf
   
    
    mov r15, 1
    mov r14, 0
    
    mov rbx, [.psquare]
    mov rax, [rbx]
    cmp rax, 0
    jle .fail
    
    mov rbx, [.psquare]
    mov r12, [rbx]
    imul r12, r12
.inLoop:
    mov rax, 1
    mov r9,  r15
    dec r9
    cmp r9, r12
    je .return
    
    inc r15
    
    mov rdi, [.FILE]
    mov rsi,.infmt
    mov rdx, [.psquare]
    mov r8, r15
    mov r9, 8
    imul r8, r9
    add rdx, r8
    mov rax, 0
    call fscanf
    mov rbx, [.psquare]
    mov r9, [rbx + r15*8]
    add r14, r9
    
    jmp .inLoop
.fail:
    mov rax, 0
    jmp .return
.return:
    mov rbx, [.psquare]
    mov [rbx + 8], r14
leave
ret

global InDiagonal
InDiagonal:
section .data
    .infmt db "%d", 0
section .bss
    .FILE resq 1
    .pdiagonal resq 1
section .text
push rbp
mov rbp, rsp

    mov [.pdiagonal], rdi
    mov [.FILE], rsi
    
    mov rdi, [.FILE]
    mov rsi, .infmt
    mov rdx, [.pdiagonal]
    xor rax, rax
    call fscanf
   
    
    mov r15, 1
    mov r14, 0
    
    mov rbx, [.pdiagonal]
    mov rax, [rbx]
    cmp rax, 0
    jle .fail
    
    mov rbx, [.pdiagonal]
    mov r12, [rbx]
    inc r12
.inLoop:
    mov rax, 1
    cmp r15, r12
    je .return
    
    inc r15
    mov rdi, [.FILE]
    mov rsi,.infmt
    mov rdx, [.pdiagonal]
    mov r8, r15
    mov r9, 8
    imul r8, r9
    add rdx, r8
    mov rax, 0
    call fscanf
    mov rbx, [.pdiagonal]
    mov r9, [rbx + r15*8]
    add r14, r9
    jmp .inLoop
.fail:
    mov rax, 0
    jmp .return
.return:
    mov rbx, [.pdiagonal]
    mov [rbx + 8], r14
leave
ret

global InLTriangle
InLTriangle:
section .data
    .mod2 dq 2
    .infmt db "%d", 0

section .bss
    .FILE resq 1
    .pltriangle resq 1
section .text
push rbp
mov rbp, rsp

    mov [.pltriangle], rdi
    mov [.FILE], rsi
    
    mov rdi, [.FILE]
    mov rsi, .infmt
    mov rdx, [.pltriangle]
    xor rax, rax
    call fscanf
   
    

    
    mov rbx, [.pltriangle]
    mov rax, [rbx]
    cmp rax, 0
    jle .fail
    
    mov rbx, [.pltriangle]
    mov r12, [rbx]

    mov r14, r12
    inc r14
    imul r12, r14

    xor rax, rax
    mov rax, r12
    xor rdx, rdx
    idiv qword[.mod2]
    mov r12, rax 
    inc r12
    
    mov r15, 1
    mov r14, 0
.inLoop:
    mov rax, 1
    cmp r15, r12
    je .return
    
    inc r15
    
    mov rdi, [.FILE]
    mov rsi,.infmt
    mov rdx, [.pltriangle]
    mov r8, r15
    mov r9, 8
    imul r8, r9
    add rdx, r8
    mov rax, 0
    call fscanf
    mov rbx, [.pltriangle]
    mov r9, [rbx + r15*8]
    add r14, r9
    
    jmp .inLoop
.fail:
    mov rax, 0
    jmp .return
.return:
    mov rbx, [.pltriangle]
    mov [rbx + 8], r14
leave
ret

global InMatrix
InMatrix:
section .data
    .tagFormat db "%d", 0
    .tagOutFmt   db     "Tag is: %d",10,0
section .bss
    .FILE resq 1
    .pmatrix resq 1
    .shapeTag resq 1
section .text
push rbp
mov rbp, rsp
    mov [.pmatrix], rdi
    mov [.FILE], rsi
    
    mov rdi, [.FILE]
    mov rsi, .tagFormat
    mov rdx, [.pmatrix]
    xor rax, rax
    call fscanf
    
    
    mov rax, [.pmatrix]
    mov r9, [rax]
    
    cmp r9, [SQUARE]
    je .squareIn
    cmp r9, [DIAGONAL]
    je .diagonalIn
    cmp r9, [LTRIANGLE]
    je .ltriangleIn
    xor rax, rax
    jmp .return
.squareIn:

    mov rdi,  [.pmatrix]
    add rdi, 8
    mov rsi, [.FILE]
    call InSquare
    jmp .return
.diagonalIn:
    mov rdi,  [.pmatrix]
    add rdi, 8
    mov rsi, [.FILE]
    call InDiagonal
    jmp .return
.ltriangleIn:
    mov rdi,  [.pmatrix]
    add rdi, 8
    mov rsi, [.FILE]
    call InLTriangle
    jmp .return
.return:   
leave
ret

global InContainer
InContainer:
section .bss
    .pcont  resq    1   ; адрес контейнера
    .plen   resq    1   ; адрес для сохранения числа введенных элементов
    .FILE   resq    1   ; указатель на файл
section .text
push rbp
mov rbp, rsp
    mov [.pcont], rdi
    mov [.plen], rsi
    mov [.FILE], rdx
    
    xor rbx, rbx
    mov rsi, rdx
.genLoop:
    push rdi
    push rbx
    
    mov rsi, [.FILE]
    mov rax, 0
    call InMatrix
    
    cmp rax, 0
    jle .return
    
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