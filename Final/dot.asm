; Nathan Warner
; nwarner4@csu.fullerton.edu
; CPSC 240-3
; May 13, 2024

;Declaration section.  The section has no name other than "Declaration section".  Declare here everything that does
;not have its own place of declaration

global dot

extern printf
extern isfloat
extern scanf
extern atof
extern fgets
extern stdin
extern strlen
extern sscanf



float_size equ 60
true equ -1
false equ 0

segment .data
;This section (or segment) is for declaring initialized arrays

test_output db "The test program is working", 10, 0
; first_input_prompt db 10, 10, "Please enter two floats separated by ws for the first vector: ", 0
; second_input_prompt db "Thank you. Please enter two floats separated by ws for the second vector: ", 0
first_input db 10, "Please enter the first number of the first vector: ", 0
second_input db "Please enter the second number of the first vector: ", 0
third_input db "Please enter the third number of the second vector: ", 0
fourth_input db "Please enter the fourth number of the second vector: ", 0
thank_you_msg db "Thank you.", 10, 10, 0
dot_product db "The dot product is %1.1lf", 10, 0
goobye_msg db "Enjoy your dot product.", 10, 10, 0
format db "%lf", 0
string_format db "%s", 0
invalid db "The number input is invalid...Please try again: ", 0
input_format db "%s %s", 0

buffer db 20 ; buffer to store the input

num1 dq 0
num2 dq 0


segment .bss
;This section (or segment) is for declaring empty arrays

align 64
backup_storage_area resb 832
array_1 resq 2; array of 2 qwords


segment .text

dot:

    ;Back up the GPRs (General Purpose Registers)
    push rbp
    mov rbp, rsp
    push rbx
    push rcx
    push rdx
    push rdi
    push rsi
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    push r14
    push r15
    pushf

    ;Backup the registers other than the GPRs
    mov rax,7
    mov rdx,0
    xsave [backup_storage_area]


    ; ;TESTING
    ; mov rax, 0
    ; mov rdi, test_output
    ; call printf


get_first_vector:
    ;Output first vector prompt
    mov rax, 0
    mov rdi, first_input
    call printf


    ;Get user input for the first vector
    mov rax, 0
    sub rsp, 4096
    mov rdi, rsp
    mov rsi, 4096
    mov rdx, [stdin]
    call fgets

    ;Remove newline
    mov rax, 0
    mov rdi, rsp
    call strlen
    mov [rsp + rax - 1], byte 0

    ; ;Separate the input into two registers
    ; mov rax, buffer
    ; mov rdi, input_format
    ; mov rsi, num1
    ; mov rbx, num2
    ; call sscanf


    ;Check if input is a float
    mov rax, 0
    mov rdi, rsp
    call isfloat
    cmp rax, false
    je bad_input

    ;Convert the input from string to float
    mov rax, 0
    mov rdi, rsp
    call atof
    movsd xmm12, xmm0

    ;Fixes the stack
    add rsp, 4096

    ; ;TESTING
    ; mov rax, 0
    ; mov rdi, test_output
    ; call printf

    jmp exit


bad_input:
    add rsp, 4096

    ;Tell the user their input is invalid and have them enter another input
    mov rax, 0
    mov rdi, invalid
    call printf

    ;Gets user input (for either angle or side)
    mov rax, 0
    sub rsp, 4096
    mov rdi, rsp
    mov rsi, 4096
    mov rdx, [stdin]
    call fgets

    ;Remove newline
    mov rax, 0
    mov rdi, rsp
    call strlen
    mov [rsp + rax - 1], byte 0

    ; ;Separate the input into two registers
    ; mov rax, buffer
    ; mov rdi, input_format
    ; mov rsi, num1
    ; mov rbx, num2
    ; call sscanf

    ;Check if input is a float
    mov rax, 0
    mov rdi, rsp
    call isfloat
    cmp rax, false
    je bad_input
    
    ;Convert the input from string to float
    mov rax, 0
    mov rdi, rsp
    call atof
    movsd xmm12, xmm0

    ;Fixes stack
    add rsp, 4096

exit:

    ;Prompt for second number of first vector
    mov rax, 0
    mov rdi, second_input
    call printf

    ;Gets user input for second number of first vector
    mov rax, 0
    sub rsp, 4096
    mov rdi, rsp
    mov rsi, 4096
    mov rdx, [stdin]
    call fgets

    ;Remove newline
    mov rax, 0
    mov rdi, rsp
    call strlen
    mov [rsp + rax - 1], byte 0

    ;Check if input is a float
    mov rax, 0
    mov rdi, rsp
    call isfloat
    cmp rax, false
    je bad_input

    ;Convert the input from string to float
    mov rax, 0
    mov rdi, rsp
    call atof
    movsd xmm13, xmm0


    ;Fixes the stack
    add rsp, 4096




    ;Prompt for first number of second vector
    mov rax, 0
    mov rdi, third_input
    call printf

    ;Gets user input for first number of second vector
    mov rax, 0
    sub rsp, 4096
    mov rdi, rsp
    mov rsi, 4096
    mov rdx, [stdin]
    call fgets

    ;Remove newline
    mov rax, 0
    mov rdi, rsp
    call strlen
    mov [rsp + rax - 1], byte 0

    ;Check if input is a float
    mov rax, 0
    mov rdi, rsp
    call isfloat
    cmp rax, false
    je bad_input

    ;Convert the input from string to float
    mov rax, 0
    mov rdi, rsp
    call atof
    movsd xmm14, xmm0


    ;Fixes the stack
    add rsp, 4096




    ;Prompt for second number of second vector
    mov rax, 0
    mov rdi, fourth_input
    call printf

    ;Gets user input for second number of second vector
    mov rax, 0
    sub rsp, 4096
    mov rdi, rsp
    mov rsi, 4096
    mov rdx, [stdin]
    call fgets

    ;Remove newline
    mov rax, 0
    mov rdi, rsp
    call strlen
    mov [rsp + rax - 1], byte 0

    ;Check if input is a float
    mov rax, 0
    mov rdi, rsp
    call isfloat
    cmp rax, false
    je bad_input

    ;Convert the input from string to float
    mov rax, 0
    mov rdi, rsp
    call atof
    movsd xmm15, xmm0


    ;Fixes the stack
    add rsp, 4096


    ;Now computing the dot product
    mulsd xmm12, xmm14
    mulsd xmm13, xmm15
    addsd xmm12, xmm13


    ;Back up value in xmm12 before restoring registers
    push qword 0
    movsd [rsp], xmm12



    ;Restore the values to non-GPRs
    mov rax, 7
    mov rdx, 0
    xrstor [backup_storage_area]


    movsd xmm0, [rsp]
    pop rax
    


    ;Restore the GPRs
    popf
    pop r15
    pop r14
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rsi
    pop rdi
    pop rdx
    pop rcx
    pop rbx
    pop rbp   ;Restore rbp to the base of the activation record of the caller program
    ret
;End of the function electricity.asm ====================================================================