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

global producer

extern sin
extern atof
extern ftoa
extern strlen


extern printf ;REMOVE


; float_size equ 60

segment .data
;This section (or segment) is for declaring initialized arrays

side_1_prompt db "Please enter the length of side 1: ", 0 ;String size: 35
side_2_prompt db "Please enter the length of side 2: ", 0 ;String size: 35
angle_prompt db "Please enter the degrees of the angle between: ", 0 ;String size: 47
output_area db "The area of the triangle is %1.5lf square feet.", 0 ;String size: 47
area_output db "The area of the triangle is %1.5lf square feet.", 0 ;String size: 47 (MAY BE SUBJECT TO CHANGE)
thank_you_message db "Thank you for using Nathan's product.", 0 ;String size: 37
sin_test db 10, "The sin of x is: %1.5lf", 0 ;String size 24 GET RID OF NEWLINE
test_area db 10, "The area is: %1.6lf", 0 ;REMOVE
test_val db 10, "The value is: %1.6lf", 10, 0 ;REMOVE
format db "%lf", 0
newline db 10


angle_180 dq 180.0
pi dq 3.14159265359
two dq 2.0
side_one dq 13.7
side_two dq 8.955
angle dq 27.455

segment .bss
;This section (or segment) is for declaring empty arrays

align 64
backup_storage_area resb 832
side_1 resb 12
side_2 resb 12
angle_input resb 12

segment .text

producer:

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


    ;Block that outputs the first side prompt
    mov rax, 1 ;1 is the write code
    mov rdi, 1 ;Destination of the output device
    mov rsi, side_1_prompt ;"Please enter the length of side 1: "
    mov rdx, 35 ;String size
    syscall


    ;Block that takes user input for the first side
    mov rax, 0 ;0 = read
    mov rdi, 0 ;0 = stdin
    mov r8, side_1
    mov rdx, 5
    syscall

    ; ;Block that removes the newline
    ; mov rax, 0
    ; mov rdi, rsp
    ; call strlen
    ; mov [rsp + rax - 1], byte 0

    ; ;Block that outputs a newline
    ; mov rax, 1 ;1 is the write code
    ; mov rdi, 1 ;Destination of the output device
    ; mov rsi, newline ;Just a newline character (10)
    ; mov rdx, 1 ;String size
    ; syscall


    ; ;Block that converts the string input by the user for the first side into a float
    ; mov rax, 0
    ; mov rdi, rcx
    ; call atof
    ; movsd xmm8, xmm0

    ; ;TESTING VALUE
    ; mov rax, 0
    ; mov rdi, test_val
    ; mov rsi, format
    ; movsd xmm0, xmm8
    ; call printf



    ;Block that outputs the second side prompt
    mov rax, 1 ;1 is the write code
    mov rdi, 1 ;Destination of the output device
    mov r9, side_2_prompt ;"Please enter the length of side 2: "
    mov rdx, 35 ;String size
    syscall



    ;Block that takes user input for the second side
    mov rax, 0 ;0 = read
    mov rdi, 0 ;0 = stdin
    mov rsi, side_2
    mov rdx, 8
    syscall


    ;Block that outputs a newline
    mov rax, 1 ;1 is the write code
    mov rdi, 1 ;Destination of the output device
    mov rsi, newline ;Just a newline character (10)
    mov rdx, 1 ;String size
    syscall


    ;Block that converts the string input by the user for the second side into a float
    mov rax, 0
    mov rdi, rsp
    call atof
    movsd xmm9, xmm0

    ;TESTING VALUE
    mov rax, 0
    mov rdi, test_val
    mov rsi, format
    movsd xmm0, xmm9
    call printf



    ; ;Block that outputs a newline
    ; mov rax, 1 ;1 is the write code
    ; mov rdi, 1 ;Destination of the output device
    ; mov rsi, newline ;Just a newline character (10)
    ; mov rdx, 1 ;String size
    ; syscall




    ;Block that outputs the angle prompt
    mov rax, 1 ;1 is the write code
    mov rdi, 1 ;Destination of the output device
    mov rsi, angle_prompt ;"Please enter the degrees of the angle between: "
    mov rdx, 47 ;String size
    syscall


    ;Block that takes user input for the angle
    mov rax, 0 ;0 = read
    mov rdi, 0 ;0 = stdin
    mov r10, angle_input
    mov rdx, 8
    syscall


    ;Block that outputs a newline
    mov rax, 1 ;1 is the write code
    mov rdi, 1 ;Destination of the output device
    mov rsi, newline ;Just a newline character (10)
    mov rdx, 1 ;String size
    syscall


    ;Block that converts the string input by the user for the angle into a float
    mov rax, 0
    mov rdi, rsp
    call atof
    movsd xmm10, xmm0


    ;TESTING VALUE
    mov rax, 0
    mov rdi, test_val
    mov rsi, format
    movsd xmm0, xmm10
    call printf

    ; ;Block that outputs a newline
    ; mov rax, 1 ;1 is the write code
    ; mov rdi, 1 ;Destination of the output device
    ; mov rsi, newline ;Just a newline character (10)
    ; mov rdx, 1 ;String size
    ; syscall


    ; ;CONVERTING FROM DEGREES TO RADIANS (OLD FUNCTION)
    ; movsd xmm8, qword [angle]
    ; movsd xmm9, qword [angle_180]
    ; movsd xmm10, qword [pi]
    ; divsd xmm10, xmm9
    ; mulsd xmm8, xmm10

    ;CONVERTING FROM DEGREES TO RADIANS
    movsd xmm12, qword [angle_180]
    movsd xmm11, qword [pi]
    divsd xmm11, xmm12
    mulsd xmm10, xmm11

    ;TESTING SIN FUNCTION
    mov rax, 1
    movsd xmm0, xmm10
    call sin
    movsd xmm15, xmm0

    ;BLOCK TESTING SIN FUNCTION OUTPUT
    mov rax, 1
    mov rdi, sin_test
    mov rsi, format
    movsd xmm0, xmm15
    call printf


    ;Computing the area of the triangle after finding sine
    ;The formula being used is 1/2 * a * b * sin(x) where:
    ;a = the length of the first side
    ;b = the length of the second side
    ;x = the angle in degrees
    ;xmm13 holds side 1
    ;xmm14 holds side 2
    ;xmm15 holds sin(x)

    movsd xmm13, qword [side_one]
    movsd xmm14, qword [side_two]
    mulsd xmm13, xmm14
    mulsd xmm13, xmm15
    divsd xmm13, qword [two]

    ;TESTING AREA
    mov rax, 1
    mov rdi, test_area
    mov rsi, format
    movsd xmm0, xmm13
    call printf
    
    



    ;Block that outputs the area
    mov rax, 1 ;1 is the write code
    mov rdi, 1 ;Destination of the output device
    mov rsi, area_output ;"The area of this triangle is %1.5lf square feet."
    mov rdx, 47 ;String size
    syscall



    ;Block that outputs a newline
    mov rax, 1 ;1 is the write code
    mov rdi, 1 ;Destination of the output device
    mov rsi, newline ;Just a newline character (10)
    mov rdx, 1 ;String size
    syscall




    ;Block that outputs thank you message
    mov rax, 1 ;1 is the write code
    mov rdi, 1 ;Destination of the output device
    mov rsi, thank_you_message ;"Thank you for using Nathan's product."
    mov rdx, 37 ;String size
    syscall




    ;Block that outputs a newline
    mov rax, 1 ;1 is the write code
    mov rdi, 1 ;Destination of the output device
    mov rsi, newline ;Just a newline character (10)
    mov rdx, 1 ;String size
    syscall





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