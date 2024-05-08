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
extern gcvt


extern printf ;REMOVE


; float_size equ 60
numeric_string_array_size equ 32
line_feed equ 10
null equ 0

segment .data
;This section (or segment) is for declaring initialized arrays

side_1_prompt db "Please enter the length of side 1: ", 0 ;String size: 35
side_2_prompt db "Please enter the length of side 2: ", 0 ;String size: 35
angle_prompt db "Please enter the degrees of the angle between: ", 0 ;String size: 47
output_area db "The area of the triangle is %1.5lf square feet.", 0 ;String size: 47
area_output_1 db "The area of the triangle is ", 0
area_output_2 db " square feet.", 0
thank_you_message db "Thank you for using Nathan's product.", 0 ;String size: 37
sin_test db 10, "The sin of x is: %1.5lf", 0 ;String size 24 GET RID OF NEWLINE
; test_area db 10, "The area is: %1.6lf", 0 ;REMOVE
; test_val db 10, "The value is: %1.6lf", 10, 0 ;REMOVE
format db "%lf", 0
newline db 10
test_seg db 10, "I am working", 10, 10, 0

angle_180 dq 180.0
pi dq 3.14159265359
two dq 2.0
; side_one dq 13.7
; side_two dq 8.955
; angle dq 27.455

segment .bss
;This section (or segment) is for declaring empty arrays

align 64
backup_storage_area resb 832
first_side resb numeric_string_array_size
second_side resb numeric_string_array_size
angle resb numeric_string_array_size
area_output resb numeric_string_array_size

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

    
    ;Block to obtain the string length of the first side prompt
    mov rax, 0
    mov rdi, side_1_prompt
    call strlen
    mov r12, rax ;r12 holds the string length of the first side prompt


    ;Block that outputs the first side prompt
    mov rax, 1 ;1 is the write code
    mov rdi, 1 ;stdout
    mov rsi, side_1_prompt ;"Please enter the length of side 1: "
    mov rdx, r12 ;String size
    syscall

    ;Preloop initialization
    mov rbx, first_side
    mov r12, 0 ;r12 is the counter of number of bytes inputted
    push qword 0 ;Storage for incoming bytes

first_side_loop:
    mov rax, 0 ;0 = read
    mov rdi, 0 ;0 = stdin
    mov rsi, rsp
    mov rdx, 1 ;one byte will be read from the input buffer
    syscall

    mov al, byte [rsp]

    cmp al, line_feed
    je exit_side_1

    inc r12

    cmp r12, numeric_string_array_size
    ;if(r12 >= input_array_size)
        jge end_side_1_if_else
    ;else (r12 < numeric_string_array_size)
        mov byte [rbx], al
        inc rbx
    end_side_1_if_else:

jmp first_side_loop

exit_side_1:
    mov byte [rbx], null ;Append the null character

    pop rax


    ;Block to obtain the string length of the second side prompt
    mov rax, 0
    mov rdi, side_2_prompt
    call strlen
    mov r12, rax ;r12 holds the string length of the first side prompt


    ;Block that outputs the second side prompt
    mov rax, 1 ;1 is the write code
    mov rdi, 1 ;stdout
    mov rsi, side_2_prompt ;"Please enter the length of side 2: "
    mov rdx, r12 ;String size
    syscall

    ;Preloop initialization
    mov rbx, second_side
    mov r12, 0 ;r12 is the counter of number of bytes inputted
    push qword 0 ;Storage for incoming bytes

second_side_loop:
    mov rax, 0 ;0 = read
    mov rdi, 0 ;0 = stdin
    mov rsi, rsp
    mov rdx, 1 ;one byte will be read from the input buffer
    syscall

    mov al, byte [rsp]

    cmp al, line_feed
    je exit_side_2

    inc r12

    cmp r12, numeric_string_array_size
    ;if(r12 >= input_array_size)
        jge end_side_2_if_else
    ;else (r12 < numeric_string_array_size)
        mov byte [rbx], al
        inc rbx
    end_side_2_if_else:

jmp second_side_loop

exit_side_2:
    mov byte [rbx], null ;Append the null character

    pop rax


    ;Block to obtain the string length of the angle prompt
    mov rax, 0
    mov rdi, angle_prompt
    call strlen
    mov r12, rax ;r12 holds the string length of the angle prompt


    ;Block that outputs the angle prompt
    mov rax, 1 ;1 is the write code
    mov rdi, 1 ;stdout
    mov rsi, angle_prompt ;"Please enter the degree of the angle between: "
    mov rdx, r12 ;String size
    syscall

    ;Preloop initialization
    mov rbx, angle
    mov r12, 0 ;r12 is the counter of number of bytes inputted
    push qword 0 ;Storage for incoming bytes

angle_loop:
    mov rax, 0 ;0 = read
    mov rdi, 0 ;0 = stdin
    mov rsi, rsp
    mov rdx, 1 ;one byte will be read from the input buffer
    syscall

    mov al, byte [rsp]

    cmp al, line_feed
    je exit_angle

    inc r12

    cmp r12, numeric_string_array_size
    ;if(r12 >= input_array_size)
        jge end_angle_if_else
    ;else (r12 < numeric_string_array_size)
        mov byte [rbx], al
        inc rbx
    end_angle_if_else:

jmp angle_loop

exit_angle:
    mov byte [rbx], null ;Append the null character

    pop rax


    ;Convert side 1 to float
    mov rax, 0
    mov rdi, first_side
    call atof
    movsd xmm8, xmm0

    ;Convert side 2 to float
    mov rax, 0
    mov rdi, second_side
    call atof
    movsd xmm9, xmm0

    ;Convert angle to float
    mov rax, 0
    mov rdi, angle
    call atof
    movsd xmm10, xmm0


    ;CONVERTING FROM DEGREES TO RADIANS
    ;xmm10 is the radians
    movsd xmm12, qword [angle_180]
    movsd xmm11, qword [pi]
    divsd xmm11, xmm12
    mulsd xmm10, xmm11

    ;Calling sine function
    mov rax, 1
    movsd xmm0, xmm10
    call sin
    movsd xmm15, xmm0



    ; ;TESTING block to find seg fault
    ; mov rax, 0
    ; mov rdi, test_seg
    ; call printf



    ;Computing the area of the triangle after finding sine
    ;The formula being used is 1/2 * a * b * sin(x) where:
    ;a = the length of the first side
    ;b = the length of the second side
    ;x = the angle in degrees
    ;xmm8 holds side 1
    ;xmm9 holds side 2
    ;xmm15 holds sin(x)

    ; movsd xmm8, qword [side_one]
    ; movsd xmm9, qword [side_two]
    mulsd xmm8, xmm9
    mulsd xmm8, xmm15
    divsd xmm8, qword [two] ;xmm8 now holds the area

    
    ; ;Block outputting sin(x)
    ; mov rax, 1
    ; mov rdi, sin_test
    ; mov rsi, format
    ; movsd xmm0, xmm15
    ; call printf


    ;Convert the area into a string
    mov rax, 1
    movsd xmm0, xmm8
    call gcvt
    mov r15, rax



    ;Get the length of the area_output_1 string
    mov rax, 0
    mov rdi, area_output_1
    call strlen
    mov r12, rax

    ; ;Block that outputs a newline
    ; mov byte [newline], 0xa
    ; mov byte [newline+1], 0
    ; mov rax, 1
    ; mov rdi, 1
    ; mov rsi, newline
    ; mov rdx, 1
    ; syscall

    ;Output the first part of the area string
    mov rax, 1 ;1 is the write code
    mov rdi, 1 ;stdout
    mov rsi, area_output_1 ;"The area of this triangle is "
    mov rdx, r12 ;String size
    syscall


    ;Use strlen to get the string length of the area
    mov rax, 0
    mov rdi, r15 ;r15 holds the area string
    call strlen
    mov r12, rax

    ;Output the area string
    mov rax, 1 ;1 is the write code
    mov rdi, 1 ;stdout
    mov rsi, r15 ;r15 holds the string area
    mov rdx, r12 ;String size  
    syscall

    ;Get the length of the area_output_2 string
    mov rax, 0
    mov rdi, area_output_2
    call strlen
    mov r12, rax



    ;Output the second part of the area string
    mov rax, 1 ;1 is the write code
    mov rdi, 1 ;stdout
    mov rsi, area_output_2 ;" square feet."
    mov rdx, r12 ;String size
    syscall


    ;Block that outputs a newline
    mov byte [newline], 0xa
    mov byte [newline+1], 0
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall


    ;Block that outputs thank you message
    mov rax, 1 ;1 is the write code
    mov rdi, 1 ;Destination of the output device
    mov rsi, thank_you_message ;"Thank you for using Nathan's product."
    mov rdx, 37 ;String size
    syscall


    ;Block that outputs a newline
    mov byte [newline], 0xa
    mov byte [newline+1], 0
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall



    ;Back up value in xmm8 area before restoring registers
    push qword 0
    movsd [rsp], xmm8



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