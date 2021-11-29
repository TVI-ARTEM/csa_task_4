%include "macros.mac"

global SQUARE
global DIAGONAL
global LTRIANGLE

section .data
    SQUARE dq 1
    DIAGONAL dq 2
    LTRIANGLE dq 3
    oneDouble   dq  1.0
    erMsg1  db "Incorrect number of arguments = %d: ",10,0
    rndGen  db "-n",0
    fileGen  db "-f",0
    errMessage1 db  "incorrect command line!", 10,"  Waited:",10
                db  "     command -f infile outfile01 outfile02",10,"  Or:",10
                db  "     command -n number outfile01 outfile02",10,0
    errMessage2 db  "incorrect qualifier value!", 10,"  Waited:",10
                db  "     command -f infile outfile01 outfile02",10,"  Or:",10
                db  "     command -n number outfile01 outfile02",10,0
    len         dd  0
section .bss
    argc        resd    1
    num         resd    1
    sum         resq    1
    start       resq    1       
    delta       resq    1       
    startTime   resq    2       
    endTime     resq    2       
    deltaTime   resq    2       
    ifst        resq    1       
    ofst1       resq    1       
    ofst2       resq    1       
    cont        resb    72080000
section .text
    global main 
main:
push rbp
mov rbp, rsp
    mov dword [argc], edi
    mov r12, rdi
    mov r13, rsi
    
    PrintStrLn "The command and arguments:", [stdout]
    xor rbx, rbx
.printArgLoop:
    PrintStrBuf qword [r13 +rbx*8], [stdout]
    PrintStr 10, [stdout]
    inc rbx
    cmp rbx, r12
    jl .printArgLoop
    
    cmp r12, 5
    je .checkArgs
    PrintStrBuf errMessage1, [stdout]
    jmp .return
.checkArgs:
    mov rax, 228
    xor edi, edi
    lea rsi, [startTime]
    syscall
    
    PrintStrLn "Start", [stdout]
    mov rdi, rndGen
    mov rsi, [r13 + 8]
    call strcmp
    cmp rax, 0
    je .genMatrices
    mov rdi, fileGen
    mov rsi, [r13 + 8]
    call strcmp
    cmp rax, 0
    je .readMatrices
    PrintStrBuf errMessage2, [stdout]
    jmp .return
.genMatrices:
    PrintStrLn "generate", [stdout]
    mov rdi, [r13 + 16]
    call atoi
    mov [num], eax
    PrintInt [num], [stdout]
    PrintStrLn "", [stdout]
    mov eax, [num]
    cmp eax, 1
    jl .failPrint
    cmp eax, 10000
    jg .failPrint
    
    xor rdi, rdi
    xor rax, rax
    call time
    mov rdi,  rax
    xor rax, rax
    call srand
    
    mov rdi, cont
    mov rsi, len
    mov edx, [num]
    call InRandomCont
    
    jmp .printMatrices
.readMatrices:
    FileOpen [r13 + 16], "r", ifst
    mov rdi, cont
    mov rsi, len
    mov rdx, [ifst]
    xor rax, rax
    call InContainer
    FileClose [ifst]
    jmp .printMatrices
    
.printMatrices:
    mov rax, 228
    xor edi, edi
    lea rsi, [endTime]
    syscall
  
    mov rax, [endTime]
    sub rax, [startTime]
    mov rbx, [endTime+8]
    mov rcx, [startTime+8]
    cmp rbx, rcx
    jge .printMatricesContinue
    dec rax
    add rbx, 1000000000
.printMatricesContinue:
    sub rbx, [startTime+8]
    mov [deltaTime], rax
    mov [deltaTime+8], rbx
    
    FileOpen [r13+24], "w", ofst1
    PrintStrLn "Filled container:", [ofst1]
    PrintContainer cont, [len], [ofst1]
    PrintStrLn "", [ofst1]
    PrintStrLn "Time: ", [ofst1]
    PrintLLUns [deltaTime], [ofst1]
    PrintStr " sec, ", [ofst1]
    PrintLLUns [deltaTime+8], [ofst1]
    PrintStr " nsec", [ofst1]
    FileClose [ofst1]
    jmp .sortContainer
.sortContainer:
    xor rax, rax
    SortCont cont, [len]
    xor rax, rax
    xor rdi, rdi
    xor rsi, rsi
    
    mov rax, 228
    xor edi, edi
    lea rsi, [endTime]
    syscall
  
    mov rax, [endTime]
    sub rax, [startTime]
    mov rbx, [endTime+8]
    mov rcx, [startTime+8]
    cmp rbx, rcx
    jge .sortContainerContinue
    dec rax
    add rbx, 1000000000
.sortContainerContinue:
    sub rbx, [startTime+8]
    mov [deltaTime], rax
    mov [deltaTime+8], rbx
    
    FileOpen [r13+32], "w", ofst2
    PrintStrLn "Filled container:", [ofst2]
    PrintContainer cont, [len], [ofst2]
    PrintStrLn "", [ofst2]
    PrintStrLn "Time: ", [ofst2]
    PrintLLUns [deltaTime], [ofst2]
    PrintStr " sec, ", [ofst2]
    PrintLLUns [deltaTime+8], [ofst2]
    PrintStr " nsec", [ofst2]
    FileClose [ofst2]
    jmp .return
.failPrint:
    PrintStr "incorrect number of figures = ", [stdout]
    PrintInt [num], [stdout]
    PrintStrLn ". Set 0 < number <= 10000", [stdout]
    jmp .return
.return:
    PrintStrLn "Stop", [stdout]
leave
ret






