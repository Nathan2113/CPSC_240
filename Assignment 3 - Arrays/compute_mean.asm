;****************************************************************************************************************************
;Program name: "Arrays" - This program will first welcome the user to the program, as well as outputting its developer.     *
;After this initial message, the program will let the user know the directions of the program, which is as follows:         *
;                                                                                                                           *
;"This program will manage your arrays of 64-bit floats                                                                     *
;For the array enter a sequence of 64-bit floats separated by white space.                                                  *
;After the last input press enter followed by Control+D:"                                                                   *
;                                                                                                                           *
;The program will then take in user input, validating each input to make sure they are entering valid float numbers, and    *
;this process is done through the input_array.asm file, using isfloat.asm to validate their inputs. If the user inputs an   *
;invalid input, the program will let them know with the following message:                                                  *
;                                                                                                                           *
;"The last input was invalid and not entered into the array.""                                                              *
;                                                                                                                           *
;Once the array has been fully entered, the program will output the entire array to the screen, which is done in the        *
;output_array.c file using the C language. Once the array has been output, the program will then compute the mean of the    *
;array using compute_mean.asm, and will then use the mean it found to compute the variance using compute_variance.cpp,      *
;which uses C++. Once the variance has been found, the program will output the variance to the screen for the user, and     *
;will then send the variance to main.c, where the program will let the user know that the variance will be kept for         *
;future use, and that a 0 will be sent to the operating system.                                                             *
;                                                                                                                           *
;This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License  *
;version 3 as published by the Free Software Foundation.  This program is distributed in the hope that it will be useful,   *
;but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See   *
;the GNU General Public License for more details A copy of the GNU General Public License v3 is available here:             *
;<https://www.gnu.org/licenses/>.                                                                                           *
;****************************************************************************************************************************




;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
;Author information
;  Author name: Nathan Warner
;  Author email: nwarner4@csu.fullerton.edu
;
;Program information
;  Program name: Arrays
;  Programming languages: Two modules in C, four modules in x86_64, one module in C++, and one module in bash
;  Date program began: 2024-Mar-3
;  Date of last update: 2024-Mar-7
;  Files in this program: main.c, manager.asm, r.sh, output_array.c, compute_mean.asm, compute_variance.cpp, input_array.asm, isfloat.asm
;  Testing: Alpha testing completed.  All functions are correct.
;  Status: Ready for release to customers
;
;Purpose
;  The program will take in an array of valid floating point numbers from the user, find the mean of the array, 
;       and find the variance, which it will output to the screen and send to main.c
;
;This file:
;  File name: compute_mean.asm
;  Language: X86-64
;  Max page width: 124 columns
;  Assemble (standard): nasm -f elf64 -l compute_mean.lis -o compute_mean.o compute_mean.asm
;  Optimal print specification: Landscape, 7 points, monospace, 8½x11 paper
;  Prototype of this function: double compute_mean(double *array, int size);
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**

;Declaration section.  The section has no name other than "Declaration section".  Declare here everything that does
;not have its own place of declaration

global compute_mean

extern printf

segment .data
;This section (or segment) is for declaring initialized arrays
;empty

segment .bss
;This section (or segment) is for declaring empty arrays
align 64
backup_storage_area resb 832


segment .text

compute_mean:
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


    ;Setting up values for compute_mean execution
    mov r13, rdi ;r13 is the array
    mov r14, rsi ;r14 is the size of the array
    mov r15, 0   ;r15 is the current index

    movsd xmm13, [r13]
    cvtsi2sd xmm14, r14 ;Converting size of the array to float and storing value in xmm14


begin:
    ;If the current index (r15) is equal to the size of the array (r14), then the loop terminates
    cmp r15, r14
    je quit

    addsd xmm12, [r13+r15*8]
    inc r15
    jmp begin
    
quit:
    ;Takes the sum of the array and divides it by the number of elements (mean)
    divsd xmm12, xmm14
    

    push qword 0
    movsd [rsp], xmm12


    ; Restore the values to non-GPRs
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
;End of the function compute_mean.asm ====================================================================