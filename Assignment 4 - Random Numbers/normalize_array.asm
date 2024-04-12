; /***************************************************************************************************************************
; Program name: "Non-deterministic Random Numbers" - This program will welcome the user to the program, then will ask        *
; for their name and title. After welcoming the user, the program will give a description of what it does for the user       *
;                                                                                                                            *
; This program will generate 64-bit IEEE float numbers.                                                                      *
; How many numbers do you want. Today's limit is 100 per customer:                                                           *
; Your numbers have been stored in an array. Here is that array.                                                             *
;                                                                                                                            *
; The program will then take in user input for the size of the array that they want, if the user inputs a number greater     *
; than 100, or a negative number, the program will tell them that they have entered an invalid input, and to try again       *
;                                                                                                                            *
; "Invalid array size...Try again:                                                                                           *
;                                                                                                                            *
; Once the user has input a valid array size, the program lets them know it is generating n random numbers, where n is the   *
; array size the user input above. Once the array has been filled with random numbers, the program will output the entire    *
; array, then it will normalize the array to be between the values 1.0 and 2.0, and will output the entire array again.      *
; After this second array output, the program will then sort the array (using C++ library functions) and will output the     *
; array one last time for the user, this time sorted from least to greatest                                                  *
;                                                                                                                            *
; The program will then say goodbye to the user, and terminate the program                                                   *
;                                                                                                                            *
; This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License  *
; version 3 as published by the Free Software Foundation.  This program is distributed in the hope that it will be useful,   *
; but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See   *
; the GNU General Public License for more details A copy of the GNU General Public License v3 is available here:             *
; <https://www.gnu.org/licenses/>.                                                                                           *
; ****************************************************************************************************************************/


; /**********************************************************************************************************************************
; Author information
;   Author name: Nathan Warner
;   Author email: nwarner4@csu.fullerton.edu

; Program information
;   Program name: Non-deterministic Random Numbers
;   Programming languages: One module in C, one module in C++, five modules in x86_64 assembly, and one module in bash
;   Date program began: 2024-Apr-8
;   Date of last update: 2024-Apr-11
;   Files in this program: main.c, sort.cpp, manager.asm, fill_random_array.asm, isnan.asm, show_array.asm, normalize_array.asm, r.sh
;   Testing: Alpha testing completed.  All functions are correct.
;   Status: Ready for release to customers

; Purpose
;   The program will create an array of size n, where n is input by the user, and between 1 and 100, and will create a random number
;     array, will normalize the array between 1.0 and 2.0, and then sort the array

; This file:
;   File name: normalize_array.asm
;   Language: x86_64 assembly
;   Max page width: 124 columns
;   Assemble (standard): nasm -f elf64 -l normalize_array.lis -o normalize_array.o normalize_array.asm
;   Optimal print specification: Landscape, 7 points, monospace, 8½x11 paper
;   Prototype of this function: void normalize_array(double *arr, int size);
; ***********************************************************************************************************************************/

;Declaration section.  The section has no name other than "Declaration section".  Declare here everything that does
;not have its own place of declaration

global normalize_array


float_size equ 60

segment .data
;This section (or segment) is for declaring initialized arrays


segment .bss
;This section (or segment) is for declaring empty arrays

align 64
backup_storage_area resb 832


segment .text

normalize_array:

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




    mov r13, rdi ;the array itself
    mov r14, rsi ;array size
    mov r15, 0 ;r15 is the current index of the array

begin:

    ;Ends the loop if the current array index is the same as user input
    cmp r15, r14
    je quit

    mov r11, [r13+r15*8] ;Moves the current index into r11
    shl r11, 12 ;shifts the current index of the array 12 bits to the left
    shr r11, 12 ;shifts the current index of the array 12 bits to the right
    mov rax, 0x3FF0000000000000 ;Creates an empty number with 3FF at the front
    add r11, rax ;Adds the numbers together so that the index of the array is normalized to 3FF

    mov [r13+r15*8], r11


    inc r15
    jmp begin


quit:

    ;Restore the values to non-GPRs
    mov rax, 7
    mov rdx, 0
    xrstor [backup_storage_area]


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
;End of the function normalize_array.asm ====================================================================