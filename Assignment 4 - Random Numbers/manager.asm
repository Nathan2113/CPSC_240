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
;   File name: manager.asm
;   Language: x86_64 assembly
;   Max page width: 124 columns
;   Assemble (standard): nasm -f elf64 -l manager.lis -o manager.o manager.asm
;   Optimal print specification: Landscape, 7 points, monospace, 8½x11 paper
;   Prototype of this function: char* manager();
; ***********************************************************************************************************************************/

;Declaration section.  The section has no name other than "Declaration section".  Declare here everything that does
;not have its own place of declaration

global manager

extern printf
extern stdin
extern scanf
extern fgets
extern strlen
extern isdigit
extern fill_random_array
extern show_array
extern normalize_array
extern sort


name_string_size equ 48
title_string_size equ 48


segment .data
;This section (or segment) is for declaring initialized arrays

name_prompt db 10, "Please enter your name: ", 0
title_prompt db "Please enter your title (Mr, Ms, Sergeant, Chief, Project Leader, etc): ", 0
meeting_msg db "Nice to meet you %s %s", 10, 0
program_desc db 10, "This program will generate 64-bit IEEE float numbers.", 10, 0
array_size_prompt db "How many numbers do you want? Today's limit is 100 per customer: ", 0
values_stored db "Your numbers have been stored in an array. Here is that array.", 10, 10, 0
invalid_arr_size db "Invalid array size...Try again: ", 0
normalize_array_output db 10, "The array will now be normalized to the range of 1.0 to 2.0. Here is the normalized array", 10, 10, 0
sort_array_output db 10, "The array will now be sorted", 10, 10, 0
goodbye_msg db 10, "Good bye %s. You are welcome any time.", 10, 0
format_int db "%ld", 0

test_output db 10, "The number input is %lu", 10, 0


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
    mov rdi, program_desc ;"This program will generate 64-bit IEEE float numbers."
    call printf

    
    ;Ask the user how many numbers they want to store into the array
    mov rax, 0
    mov rdi, array_size_prompt ;"How many numbers do you want? Today's limit is 100 per customer: "
    call printf

    ;Get user input for array size
    mov rax, 0
    mov rdi, format_int ;"%ld"
    push qword -9 ;rsp points to -9
    push qword -9 ;rsp points to -9
    mov rsi, rsp
    call scanf
    pop r15
    pop r8



    ;Check if the input is in the range
    cmp r15, 100
    jg bad_array_size

    cmp r15, 1
    jl bad_array_size

    jmp array_size_exit

;If the array size entered by the user is not valid, the program jumps here, which reprompts them for a valid input
bad_array_size:
    mov rax, 0
    mov rdi, invalid_arr_size
    call printf


    ;Get user input for array size
    mov rax, 0
    mov rdi, format_int ;"%ld"
    push qword -9 ;rsp points to -9
    push qword -9 ;rsp points to -9
    mov rsi, rsp
    call scanf
    pop r15
    pop r8

    cmp r15, 100
    jg bad_array_size

    cmp r15, 1
    jl bad_array_size

    jmp array_size_exit


array_size_exit:

    ;Calling fill_random_array
    mov rax, 0
    mov rdi, array
    mov rsi, r15 ;array size
    call fill_random_array


    ;Output that the array size has been stored
    mov rax, 0
    mov rdi, values_stored ;"Your numbers have been stored in an array. Here is that array."
    call printf


    ;Calling show array, which outputs the entire array to the screen in hex and scientific format
    mov rax, 0
    mov rdi, array
    mov rsi, r15 ;array size
    call show_array


    ;Output to let the user know the array will now be normalized
    mov rax, 0
    mov rdi, normalize_array_output ;"The array will now be normalized to the range of 1.0 to 2.0. Here is the normalized array"
    call printf

    ;Calling normalize_array
    mov rax, 0
    mov rdi, array
    mov rsi, r15 ;array size
    call normalize_array

    ;Calling show array, which outputs the entire array to the screen in hex and scientific format
    mov rax, 0
    mov rdi, array
    mov rsi, r15 ;array size
    call show_array


    ;Output to let the user know the array is being sorted
    mov rax, 0
    mov rdi, sort_array_output ;"The array will now be sorted"
    call printf

    ;Calling sort_array
    mov rax, 0
    mov rdi, array
    mov rsi, r15 ;array size
    call sort


    ;Calling show array, which outputs the entire array to the screen in hex and scientific format
    mov rax, 0
    mov rdi, array
    mov rsi, r15 ;array size
    call show_array


    ;Output goodbye message
    mov rax, 0
    mov rdi, goodbye_msg ;"Good bye %s. You are welcome any time."
    mov rsi, user_title
    call printf


    ;Restore the values to non-GPRs
    mov rax, 7
    mov rdx, 0
    xrstor [backup_storage_area]

    mov rax, user_name

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