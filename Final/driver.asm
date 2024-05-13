; Nathan Warner
; nwarner4@csu.fullerton.edu
; CPSC 240-3
; May 13, 2024

;Declaration section.  The section has no name other than "Declaration section".  Declare here everything that does
;not have its own place of declaration

global driver

extern printf


float_size equ 60

segment .data
;This section (or segment) is for declaring initialized arrays

test_output db "The test program is working", 10, 0


segment .bss
;This section (or segment) is for declaring empty arrays

align 64
backup_storage_area resb 832


segment .text

driver:

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


    ;TESTING
    mov rax, 0
    mov rdi, test_output
    call printf


    ;Back up value in xmm14 before restoring registers
    push qword 0
    movsd [rsp], xmm14



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