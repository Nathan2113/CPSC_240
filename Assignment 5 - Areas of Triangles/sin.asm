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
;  File name: sin.asm
;  Language: x86_64
;  Max page width: 124 columns
;  Assemble (standard): nasm -f elf64 -l sin.lis -o sin.o sin.asm
;  Optimal print specification: Landscape, 7 points, monospace, 8½x11 paper
;  Prototype of this function: int main(int argc, const char * argv[]);
;***********************************************************************************************************************************/

;Declaration section.  The section has no name other than "Declaration section".  Declare here everything that does
;not have its own place of declaration

global sin

extern multiplier

segment .data
;This section (or segment) is for declaring initialized arrays

segment .bss
;This section (or segment) is for declaring empty arrays

align 64
backup_storage_area resb 832

segment .text

sin:
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


    ;Setting up registers for sin
    mov r14, 0 ;Term counter
    movsd xmm9, xmm0 ;Permanent (constant)
    movsd xmm8, xmm0 ;Current term
    pxor xmm10, xmm10 ;xmm10 will hold sin(x)


multiplier_loop:   
    ;Calling multiplier
    mov rax, 1
    mov rdi, r14 ;Term counter
    movsd xmm0, xmm9 ;Value for x
    call multiplier
    movsd xmm12, xmm0


    mulsd xmm8, xmm12
    inc r14


    addsd xmm10, xmm8


    cmp r14, 20
    jle multiplier_loop

exit:
    addsd xmm9, xmm10


    ;Back up value in xmm9 before restoring registers
    push qword 0
    movsd [rsp], xmm9


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
;End of the function sin.asm ====================================================================