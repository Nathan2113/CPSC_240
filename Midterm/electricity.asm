; Nathan Warner
; nwarner4@csu.fullerton.edu
; CPSC 240-3
; Mar 20, 2024

;Declaration section.  The section has no name other than "Declaration section".  Declare here everything that does
;not have its own place of declaration

global electricity

extern printf
extern stdin
extern scanf


float_size equ 60

segment .data
;This section (or segment) is for declaring initialized arrays

program_desc db 10, "This program will manage your arrays of 64-bit floats", 10, 0
prog_instruction db "For the array enter a sequence of 64-bit floats separated by white space.", 10, 0
exit_instruction db "After the last input press enter followed by Control+D:", 10, 0
numbers_received db 10, "These numbers were received and placed into an array", 10, 0
variance db "The variance of the inputted numbers is %1.6lf", 10, 0
format db "%lf", 0


segment .bss
;This section (or segment) is for declaring empty arrays

align 64
backup_storage_area resb 832
array resq 12 ;Array of 12 qwords, will be used to take in user inputs for floats, as well as computing the mean and variance


segment .text

electricity:

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





    


    ;Back up value in xmm15 before restoring registers
    push qword 0
    movsd [rsp], xmm15



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