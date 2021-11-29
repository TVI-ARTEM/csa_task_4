extern fprintf

extern SQUARE
extern DIAGONAL
extern LTRIANGLE

global OutSquare
OutSquare:
section .data
    .outfmt1 db "It is a square matrix. Dimension = %d, Sum = %d, Average = %g",10,0
    .outfmt2 db "%d ",0
    .outfmt3 db "%d", 10,0
    
section .bss
    .square resq 1
    .FILE resq 1
section .text
push rbp
mov rbp, rsp
    mov [.square], rdi
    mov [.FILE], rsi
    
    mov rax, [.square]
    mov r12, [rax]
    cvtsi2sd xmm1, [rax + 8]    
    imul r12, r12
    
    cvtsi2sd xmm2, r12
    
    divsd xmm1, xmm2
    
    mov rdi, [.FILE]
    mov rsi, .outfmt1
    mov rax, [.square]
    mov rdx, [rax]
    mov rcx, [rax + 8]
    movsd xmm0, xmm1
    mov rax, 1
    call fprintf    
    
    mov rax, [.square]
    mov r12, [rax]
    mov r14, [rax]
    imul r12, r12
    mov r15, 0
.loop:
    cmp r15, r12
    je .return
    
    inc r15
    

    xor rdx, rdx
    mov rax, r15
    idiv r14
    mov rax, rdx
    mov rdx, 0
    cmp rax, rdx
    je .print
    jmp .printEnd
.print:
    mov rdi, [.FILE]
    mov rsi, .outfmt3
    mov rax, [.square]
    mov r9, r15
    inc r9
    mov rdx, [rax + r9*8]
    
    call fprintf
    jmp .loop
.printEnd:
    mov rdi, [.FILE]
    mov rsi, .outfmt2
    mov rax, [.square]
    mov r9, r15
    inc r9
    mov rdx, [rax + r9*8]
    call fprintf
    jmp .loop
.return:
leave
ret

global OutDiagonal
OutDiagonal:
section .data
    .outfmt1 db "It is a diagonal matrix. Dimension = %d, Sum = %d, Average = %g",10,0
    .outfmt2 db "%d ",0
    .outfmt3 db "%d", 10,0
section .bss
    .diagonal resq 1
    .FILE resq 1
section .text
push rbp
mov rbp, rsp
    mov [.diagonal], rdi
    mov [.FILE], rsi
    
    mov rdi, [.FILE]
    mov rsi, .outfmt1
    mov rax, [.diagonal]
    mov r12, [rax]
    cvtsi2sd xmm1, [rax + 8]    
    imul r12, r12
    
    cvtsi2sd xmm2, r12
    
    divsd xmm1, xmm2
    
    mov rax, [.diagonal]
    mov rdx, [rax]
    mov rcx, [rax + 8]
    movsd xmm0, xmm1
    mov rax, 1
    call fprintf  
    
    
    
    mov rax, [.diagonal]
    mov r12, [rax]

    imul r12, r12
    mov r15, 0
    mov rcx, 0
    mov rbx, 0
    
    mov r14, 2
.loop:
    cmp r15, r12
    je .return
    
    inc r15
    mov rax, [.diagonal]
    mov r8, [rax]
    xor rdx, rdx
    xor rax, rax
    mov rax, r15
    div r8
    
    cmp rax, r8
    je .printNum
    
    inc rax
    cmp rax, rdx
    je .printNum
    jmp .printNull
    
.printNull:
    mov rax, [.diagonal]
    mov r8, [rax]
    xor rdx, rdx
    mov rax, r15
    idiv r8
    mov rax, rdx
    mov rdx, 0
    cmp rax, rdx
    je .printNullJust
    jmp .printNullEnd
.printNum:
    mov rax, [.diagonal]
    mov r8, [rax]
    xor rdx, rdx
    mov rax, r15
    idiv r8
    mov rax, rdx
    mov rdx, 0
    cmp rax, rdx
    je .print
    jmp .printEnd
.print:

    mov rdi, [.FILE]
    mov rsi, .outfmt3
    mov rax, [.diagonal]

    mov rdx, [rax + r14*8]
    call fprintf

    inc r14

    
    jmp .loop
.printEnd:

    mov rdi, [.FILE]
    mov rsi, .outfmt2
    mov rax, [.diagonal]
    mov rdx, [rax + r14*8]

    call fprintf

    inc r14

    
    jmp .loop    
    
.printNullJust:


    
    mov rdi, [.FILE]
    mov rsi, .outfmt3
    mov rdx, 0
    call fprintf
    

    
    jmp .loop
.printNullEnd:

    
    mov rdi, [.FILE]
    mov rsi, .outfmt2
    mov rdx, 0
    call fprintf
    jmp .loop
.return:  
leave
ret

global OutLTriangle
OutLTriangle:
section .data
    .outfmt1 db "It is a low triangle matrix. Dimension = %d, Sum = %d, Average = %g",10,0
    .outfmt2 db "%d ",0
    .outfmt3 db "%d", 10,0
section .bss
    .ltriangle resq 1
    .FILE resq 1
section .text
push rbp
mov rbp, rsp
    mov [.ltriangle], rdi
    mov [.FILE], rsi
    
    
    
    mov rdi, [.FILE]
    mov rsi, .outfmt1
    mov rax, [.ltriangle]
    mov r12, [rax]
    cvtsi2sd xmm1, [rax + 8]    
    imul r12, r12
    
    cvtsi2sd xmm2, r12
    
    divsd xmm1, xmm2
    
    mov rax, [.ltriangle]
    mov rdx, [rax]
    mov rcx, [rax + 8]
    movsd xmm0, xmm1
    mov rax, 1
    call fprintf 
    
    
    mov rax, [.ltriangle]
    mov r12, [rax]

    imul r12, r12
    mov r15, 0
    mov rcx, 0
    mov rbx, 0
    
    mov r14, 2
.loop:
    cmp r15, r12
    je .return
    
    inc r15
    mov rax, [.ltriangle]
    mov r8, [rax]

    xor rdx, rdx
    xor rax, rax
    mov rax, r15
    idiv r8
    
    
    inc rax
    mov r9, 0
    cmp rdx, r9
    je .checkColumn
.continue:
    cmp rax, rdx
    jge .printNum
    jmp .printNull
.checkColumn:
     dec rax
     mov rdx, r8
     jmp .continue
.printNull:
    mov rax, [.ltriangle]
    mov r8, [rax]

    xor rdx, rdx
    mov rax, r15
    idiv r8
    mov rax, rdx
    mov rdx, 0
    cmp rax, rdx
    je .printNullJust
    jmp .printNullEnd
.printNum:
    mov rax, [.ltriangle]
    mov r8, [rax]
    xor rdx, rdx
    mov rax, r15
    idiv r8
    mov rax, rdx
    mov rdx, 0
    cmp rax, rdx
    je .print
    jmp .printEnd
.print:

    mov rdi, [.FILE]
    mov rsi, .outfmt3
    mov rax, [.ltriangle]

    mov rdx, [rax + r14*8]
    call fprintf

    inc r14

    
    jmp .loop
.printEnd:

    mov rdi, [.FILE]
    mov rsi, .outfmt2
    mov rax, [.ltriangle]
    mov rdx, [rax + r14*8]

    call fprintf

    inc r14

    
    jmp .loop    
    
.printNullJust:


    
    mov rdi, [.FILE]
    mov rsi, .outfmt3
    mov rdx, 0
    call fprintf
    

    
    jmp .loop
.printNullEnd:

    
    mov rdi, [.FILE]
    mov rsi, .outfmt2
    mov rdx, 0
    call fprintf
    jmp .loop
.return:  
leave
ret

global OutMatrix
OutMatrix:
section .data
    .erMatrix db "Incorrect matrix!",10,0
section .text
push rbp
mov rbp, rsp

    mov rax, [rdi]
    cmp rax, [SQUARE]
    je squareOut
    cmp rax, [DIAGONAL]
    je diagonalOut
    cmp rax, [LTRIANGLE]
    je ltriangleOut
    mov rdi, .erMatrix
    mov rax, 0
    call fprintf
    jmp     return
squareOut:
    add     rdi, 8
    call    OutSquare
    jmp     return
diagonalOut:
    add     rdi, 8
    call    OutDiagonal
    jmp     return
ltriangleOut:
    add     rdi, 8
    call    OutLTriangle
    
return:
leave
ret

global OutContainer
OutContainer:
section .data
    numFmt  db  "%d: ", 0
section .bss
    .pcont  resq    1
    .len    resd    1   
    .FILE   resq    1   
section .text
push rbp
mov rbp, rsp

    mov [.pcont], rdi   
    mov [.len],   esi     
    mov [.FILE],  rdx  

    
    mov rbx, rsi            
    xor rcx, rcx            
    mov rsi, rdx            
.loop:
    cmp rcx, rbx 
    jge .return

    push rbx
    push rcx
    mov rdi, [.FILE]
    mov rsi, numFmt
    mov rdx,  rcx
    xor rax, rax
    call fprintf

    mov     rdi, [.pcont]
    mov     rsi, [.FILE]
    call OutMatrix    

    pop rcx
    pop rbx
    inc rcx                 

    mov     rax, [.pcont]
    add     rax, 7208
    mov     [.pcont], rax
    jmp .loop
.return:
leave
ret
