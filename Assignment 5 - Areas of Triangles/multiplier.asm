;/****************************************************************************************************************************
;Program name: "Areas of Triangles" - This program will prompt the user for the lengths of 2 sides of a triangle and the 
;size of the angle between them. All I/O in this program will be handled in pure assembly using syscalls. The conversions
;atof (string to float) and ftoa (float to string) both use built-in library functions. When computing the area of the 
;triangle, sin(x), where x is the angle, is used in the formula, and sin(x) is computed using a Taylor series, programmed in 
;x86_64. When the user has input 2 sides and the angle between, the program will convert the strings input by the user into
;floats, calculate the area, then convert the area into a string and output the area to the screen. Once the area has been  
;output to the screen, the program will then return the area to the driver function, written in C, and will confirm its 
;retrieval and convey a goobye message to the user.

;WARNING: THIS PROGRAM DOES NOT VALIDATE USER INPUT
;****************************************************************************************************************************/



;/**********************************************************************************************************************************
;Author information
;  Author name: Nathan Warner
;  Author email: nwarner4@csu.fullerton.edu

;Program information
;  Program name: Areas of Triangles
;  Programming languages: One module in C, four modules in x86_64, and one module in bash
;  Date program began: 2024-May-4
;  Date of last update: 2024-Mar-8
;  Files in this program: main.c, producer.asm multiplier.asm sin.asm strlen.asm r.sh
;  Testing: Alpha testing completed.  All functions are correct.
;  Status: Ready for release to customers

;Purpose
;  The program will take in 2 sides of a triangle, as well as the angle between them in degrees from the user.
;    Using the above information, the program will then compute the area of the triangle and output it to the screen.
;    All I/O in this program will be done in pure x86_64 assembly using syscalls

;This file:
;  File name: multiplier.asm
;  Language: x86_64
;  Max page width: 124 columns
;  Assemble (standard): nasm -f elf64 -l multiplier.lis -o multiplier.o multiplier.asm
;  Optimal print specification: Landscape, 7 points, monospace, 8½x11 paper
;  Prototype of this function: int main(int argc, const char * argv[]);
;***********************************************************************************************************************************/


;Declaration section.  The section has no name other than "Declaration section".  Declare here everything that does
;not have its own place of declaration

global multiplier

extern printf

segment .data
;This section (or segment) is for declaring initialized arrays

segment .bss
;This section (or segment) is for declaring empty arrays

align 64
backup_storage_area resb 832

segment .text

multiplier:

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


    ;Setting up registers for multiplier
    mov rbx, rdi ;term counter
    movsd xmm13, xmm0 ;xmm13 = x(constant)
    mulsd xmm13, xmm13 ;xmm13 = x^2
    mov r8, -1

    cvtsi2sd xmm12, r8 ;Converting -1 to -1.0 and storing it into xmm12

    mulsd xmm13, xmm12 ;xmm13 = -x^2

    ;work on denominator
    ;mov the value of 2 into rax to correctly use mul, which multiplies the specified register by rax
    imul rbx, 2
    add rbx, 2 ;rbx = 2n + 2
    mov rcx, rbx
    inc rcx ;rcx = 2n + 3
    imul rbx, rcx
    

    cvtsi2sd xmm14, rbx ;xmm14 is now the denominator


    divsd xmm13, xmm14 ;Final division


    ;Back up value in xmm13 before restoring registers
    push qword 0
    movsd [rsp], xmm13



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
;End of the function multiplier.asm ====================================================================