; Nathan Warner
; nwarner4@csu.fullerton.edu
; CPSC 240-3
; Mar 20, 2024

;Declaration section.  The section has no name other than "Declaration section".  Declare here everything that does
;not have its own place of declaration

global current

extern printf


float_size equ 60

segment .data
;This section (or segment) is for declaring initialized arrays

; program_desc db 10, "This program will manage your arrays of 64-bit floats", 10, 0
format db "%lf", 0
current_first_circuit db "The current on the first circuit is %1.5lf amps.", 10, 0
current_second_circuit db "The current on the second circuit is %1.5lf amps.", 10, 0
total_current db "The total current is %1.5lf amps.", 10, 10, 0


segment .bss
;This section (or segment) is for declaring empty arrays

align 64
backup_storage_area resb 832


segment .text

current:

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

    ;move values to higher registers to prevent losing the data
    ;xmm10 = electric force
    ;xmm11 = resistance of the first circuit
    ;xmm12 = resistance of the second circuit
    ;xmm13 = electric force (moved twice to prevent losing data from first division)
    movsd xmm10, xmm0
    movsd xmm11, xmm1
    movsd xmm12, xmm2
    movsd xmm13, xmm10



    ;Block to get the current of the first circuit
    divsd xmm10, xmm11
    movsd xmm11, xmm10 ;move the result into xmm11

    ;Block to get the current of the second circuit
    divsd xmm13, xmm12
    movsd xmm12, xmm13 ;move the result into xmm12

    ;Output the current of the first circuit to the screen
    mov rax, 1
    mov rdi, current_first_circuit
    movsd xmm0, xmm11
    call printf


    ;Output the current of the second circuit to the screen
    mov rax, 1
    mov rdi, current_second_circuit
    movsd xmm0, xmm12
    call printf


    ;Block to add currents together and set return value
    addsd xmm11, xmm12

    
    ;Output the total current to the screen
    mov rax, 1
    mov rdi, total_current
    movsd xmm0, xmm11
    call printf


    ;Back up value in xmm11 before restoring registers
    push qword 0
    movsd [rsp], xmm11



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
;End of the function current.asm ====================================================================