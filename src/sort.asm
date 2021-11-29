extern printf

global SortContainer
SortContainer:
section .data
    ElemCount dq 901
    .out db "First = %g, Second = %g", 10,0
section .bss
    .pcont resq 1
    .plen resd 1
    .iIndex resq 1
    .kIndex resq 1
section .text
push rbp
mov rbp, rsp
    mov [.pcont], rdi
    mov [.plen], esi

    mov rax, 1
    mov [.iIndex], rax
.iLoop:

    mov eax, [.plen]
    mov ecx, [.iIndex]
    cmp ecx, eax
    je .return

    mov r12,  [.iIndex]


.jLoop:
    mov rax, 0
    cmp r12, rax
    jle .iLoopEnd

    mov r14, r12 ; j index
    imul r14, 7208
    
    mov r15, r12
    dec r15 ; j - 1 index
    imul r15, 7208

    mov rbx, [.pcont]
    mov r10, [rbx + r14 + 16] ; j sum
    mov r11, [rbx + r15 + 16] ; j - 1 sum
    

    cvtsi2sd xmm0, [rbx + r14 + 16]
    cvtsi2sd xmm2, [rbx + r14 + 8]
    mulsd xmm2, xmm2
    divsd xmm0, xmm2
    
    cvtsi2sd xmm1, [rbx + r15 + 16]
    cvtsi2sd xmm3, [rbx + r15 + 8]
    mulsd xmm3, xmm3
    divsd xmm1,xmm3
    
    ;mov rdi, .out
    ;mov rax, 1
    ;call printf

    comisd xmm1, xmm0
    jae .jLoopEnd 
    

    
    mov rax, 0   
    mov [.kIndex], rax
.moveData:
    mov r8, [.kIndex]
    cmp r8, [ElemCount]
    je .jLoopEnd
   
    mov rbx, [.pcont]
    mov r8, [rbx + r14]
    mov r9, [rbx + r15]
    
  
    mov rbx, [.pcont]
    mov [rbx + r14], r9
    mov [rbx + r15], r8 
    
    add r14, 8
    add r15, 8
    
    mov rax, [.kIndex]
    inc rax   
    mov [.kIndex], rax 
   
    jmp .moveData  
.jLoopEnd:

     
    dec r12
    jmp .jLoop
    
.iLoopEnd:

    mov rax, [.iIndex]
    inc rax
    mov [.iIndex], rax
    
 
    jmp .iLoop
.return:
leave
ret