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
;  File name: manager.asm
;  Language: X86-64
;  Max page width: 124 columns
;  Assemble (standard): nasm -f elf64 -l manager.lis -o manager.o manager.asm
;  Assemble (debug): nasm -g dwarf -l manager.lis -o manager.o manager.asm
;  Optimal print specification: Landscape, 7 points, monospace, 8½x11 paper
;  Prototype of this function: double manager();
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**

;Declaration section.  The section has no name other than "Declaration section".  Declare here everything that does
;not have its own place of declaration

global manager

extern printf
extern stdin
extern scanf
extern fgets
extern strlen
extern isfloat
extern atof


name_string_size equ 48
title_string_size equ 48

true equ -1
false equ 0

float_size equ 60

segment .data
;This section (or segment) is for declaring initialized arrays

name_prompt db 10, "Please enter your name: ", 0
title_prompt db 10, "Please enter your title (Mr, Ms, Sergeant, Chief, Project Leader, etc): ", 0
meeting_msg db 10, "Nice to meet you %s %s", 10, 10, 0
program_desc db 10, "This program will generate 64-bit IEEE float numbers.", 10, 0
array_size_prompt db "How many numbers do you want? Today's limit is 100 per customer: ", 0
values_stored db "Your numbers have been stored in an array. Here is that array.", 10, 0
format db "%lf", 0

test_output db 10, "The number is: %1.6lf", 10, 0


segment .bss
;This section (or segment) is for declaring empty arrays

align 64
backup_storage_area resb 832
array resq 100 ;Array of 100 qwords

user_name resb name_string_size

user_title resb title_string_size

segment .text

manager:

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




    ;Output prompt for first and last name
    mov rax, 0
    mov rdi, name_prompt ;"Please enter your name: "
    call printf

    ;Input user names
    mov rax, 0
    mov rdi, user_name
    mov rsi, name_string_size ;48
    mov rdx, [stdin]
    call fgets

    ;Remove newline
    mov rax, 0
    mov rdi, user_name
    call strlen
    mov [user_name+rax-1], byte 0

    ;Ask user for their title
    mov rax, 0
    mov rdi, title_prompt ;"Please enter your title (Sergeant, Chief, CEO, President, Teacher, etc): "
    call printf

    ;Input user title
    mov rax, 0
    mov rdi, user_title
    mov rsi, title_string_size ;48
    mov rdx, [stdin]
    call fgets

    ;Remove newline
    mov rax, 0
    mov rdi, user_title
    call strlen
    mov [user_title+rax-1], byte 0



    ;Say good morning to the user
    mov rax, 0
    mov rdi, meeting_msg ;"Nice to meet you %s %s"
    mov rsi, user_title
    mov rdx, user_name
    call printf


    ;Output the program description for the user
    mov rax, 0
    mov rdi, program_desc
    call printf

    
    ;Ask the user how many numbers they want to store into the array
    mov rax, 0
    mov rdi, array_size_prompt
    call printf

    ;WILL GET VALUE FROM USER LATER, FOR NOW, STORING 6 IN R15
    mov r15, 6

    


    ;Back up value in xmm15 (variance) before restoring registers
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
;End of the function manager.asm ====================================================================