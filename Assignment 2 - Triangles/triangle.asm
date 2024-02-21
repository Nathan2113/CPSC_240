;Change Comments

;****************************************************************************************************************************
;Program name: "Driving Time". This program will take in the user's full name, their title, and the distances they have     *
;traveled from Fullerton -> Santa Ana, Santa Ana -> Long Beach, and Long Beach -> Fullerton, as well as their average       *
;speed for each trip. Once the program has the total distance traveled and the average speed of the entire trip, the        *
;program will calculate the total time of the trip, then the assembly file will send the average speed back to the driver
;function                                                                                                                   *
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
;  Program name: Driving Time
;  Programming languages: One module in C, one in X86, and one in bash.
;  Date program began: 2024-Jan-30
;  Date of last update: 2024-Feb-2
;  Files in this program: driving_time.c, average.asm, r.sh.
;  Testing: Alpha testing completed.  All functions are correct.
;  Status: Ready for release to customers
;
;Purpose
;  This program will take in total distance traveled and average speed and find the total time of the trip,
;  as well as sending the average speed of the entirety of the trip back to the driver
;
;This file:
;  File name: average.asm
;  Language: X86-64
;  Max page width: 124 columns
;  Assemble (standard): nasm -l average.lis -o average.o average.asm
;  Assemble (debug): nasm -g dwarf -l average.lis -o average.o average.asm
;  Optimal print specification: Landscape, 7 points, monospace, 8½x11 paper
;  Prototype of this function: double average();
; 
;
;
;
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**

;Declaration section.  The section has no name other than "Declaration section".  Declare here everything that does
;not have its own place of declaration

global triangle_SAS

extern printf
extern fgets
extern stdin
extern strlen
extern scanf
extern cos
extern atof
extern isfloat

name_string_size equ 48
title_string_size equ 48

float_size equ 60
true equ -1
false equ 0

segment .data
;This section (or segment) is for declaring initialized arrays

name_prompt db 10, "Please enter your name: ", 0
title_prompt db 10, "Please enter your title (Sergeant, Chief, CEO, President, Teacher, etc): ", 0
good_morning_msg db 10, "Good morning %s %s. We take care of all your triangles.", 10, 10, 0
first_side_prompt db "Please enter the length of the first side: ", 0
second_side_prompt db "Please enter the length of the second side: ", 0
angle_prompt db "Please enter the angle in degrees: ", 0
format db "%lf", 0
output_values_test db 10, "First side: %1.6lf, Second side: %1.6lf, Angle size: %1.3lf", 0
output_third_length db 10, "The length of the third side is %1.6lf", 10, 0
length_send_message db 10, "The length will be sent to the driver program", 10, 0
print_bad_input db "Invalid input. Try again", 10, 0
thank_you_message db 10, "Thank you %s. You entered %1.6lf %1.6lf and %1.6lf", 10, 0
starting_time db 10, "The starting time on the clock is %lu tics", 10, 0
ending_time db 10, "The final time on the system clock is %lu tics", 10, 0

two dq 2.0
angle_180 dq 180.0
pi dq 3.14159265359


segment .bss
;This section (or segment) is for declaring empty arrays

align 64
backup_storage_area resb 832

user_name resb name_string_size

user_title resb title_string_size

segment .text

triangle_SAS:

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


    ;Get the starting time on the system clock
    cpuid
    rdtsc
    shl rdx, 32
    add rdx, rax
    mov r12, rax

    ;Output starting time on system clock
    mov rax, 0
    mov rdi, starting_time
    mov rsi, r12
    call printf

    ;Output prompt for first and last name
    mov rax, 0
    mov rdi, name_prompt
    call printf

    ;Input user names
    mov rax, 0
    mov rdi, user_name
    mov rsi, name_string_size
    mov rdx, [stdin]
    call fgets

    ;Remove newline
    mov rax, 0
    mov rdi, user_name
    call strlen
    mov [user_name+rax-1], byte 0

    ;Output prompt for user's title
    mov rax, 0
    mov rdi, title_prompt
    call printf

    ;Input user title
    mov rax, 0
    mov rdi, user_title
    mov rsi, title_string_size
    mov rdx, [stdin]
    call fgets

    ;Remove newline
    mov rax, 0
    mov rdi, user_title
    call strlen
    mov [user_title+rax-1], byte 0



    ;Say good morning to the user
    mov rax, 0
    mov rdi, good_morning_msg
    mov rsi, user_title
    mov rdx, user_name
    call printf

    mov r15, 0 ;r15 is used to determine which input block to jump to (0 = first side, 1 = second side, 2 = angle)

get_first_side:
    ;Ask for length of first side
    mov rax, 0
    mov rdi, first_side_prompt
    call printf


    ;Gets user input for first side
    mov rax, 0
    sub rsp, 4096
    mov rdi, rsp
    mov rsi, 4096
    mov rdx, [stdin]
    call fgets

    ;Remove newline
    mov rax, 0
    mov rdi, rsp
    call strlen
    mov [rsp + rax - 1], byte 0

    ;Check if input is a postive float
    mov rax, 0
    mov rdi, rsp
    call isfloat
    cmp rax, false
    je bad_input

    ;Convert the input from string to float
    mov rax, 0
    mov rdi, rsp
    call atof
    movsd xmm10, xmm0

    ;Adds 1 to r15, which enables the program to jump to get_second_side after invalid inputs
    add r15, 1

    ;Fixes the stack
    add rsp, 4096

    jmp get_second_side



get_second_side:
    ;Ask for length of second side
    mov rax, 0
    mov rdi, second_side_prompt
    call printf


    ;Gets user input for second side
    mov rax, 0
    sub rsp, 4096
    mov rdi, rsp
    mov rsi, 4096
    mov rdx, [stdin]
    call fgets

    ;Remove newline
    mov rax, 0
    mov rdi, rsp
    call strlen
    mov [rsp + rax - 1], byte 0

    ;Check if input is a float
    mov rax, 0
    mov rdi, rsp
    call isfloat
    cmp rax, false
    je bad_input

    ;Convert the input from string to float
    mov rax, 0
    mov rdi, rsp
    call atof
    movsd xmm11, xmm0

    ;Adds 1 to r15, which enables the program to jump to get_second_side after invalid inputs
    add r15, 1

    ;Fixes the stack
    add rsp, 4096

    jmp get_angle



get_angle:
    ;Ask for size of the angle
    mov rax, 0
    mov rdi, angle_prompt
    call printf


    ;Gets user input for angle
    mov rax, 0
    sub rsp, 4096
    mov rdi, rsp
    mov rsi, 4096
    mov rdx, [stdin]
    call fgets

    ;Remove newline
    mov rax, 0
    mov rdi, rsp
    call strlen
    mov [rsp + rax - 1], byte 0

    ;Check if input is a float
    mov rax, 0
    mov rdi, rsp
    call isfloat
    cmp rax, false
    je bad_input

    ;Convert the input from string to float
    mov rax, 0
    mov rdi, rsp
    call atof
    movsd xmm12, xmm0

    ;Adds 1 to r15, which enables the program to jump to get_second_side after invalid inputs
    add r15, 1

    ;Fixes stack
    add rsp, 4096

    ;Jumps to exit
    jmp exit



bad_input:
;bad_input will have a tracker for which input the user is on (first side, second side, angle) and
;depending on the number in the register (will use 0 for first side, 1 for second side, and 2 for angle)
;the program will jump to the correct code block

;if(tracker == 0)
    ;jump to first side input
;elseif(tracker == 1)
    ;jump to second side input
;elseif(tracker == 2)
    ;jump to angle input

    add rsp, 4096

    ;Tell the user their input is invalid and have them enter another input
    mov rax, 0
    mov rdi, print_bad_input
    call printf

    cmp r15, 0
    je get_first_side

    cmp r15, 1
    je get_second_side

    cmp r15, 2
    je get_angle

    ;Jump back to correct input block depending on value of r15


exit:
    ;Output thank you message along with values the user entered
    mov rax, 3
    mov rdi, thank_you_message
    mov rsi, user_name
    mov rcx, format
    movsd xmm0, xmm10
    movsd xmm1, xmm11
    movsd xmm2, xmm12
    call printf

    movsd xmm8, xmm10
    movsd xmm9, xmm11
    movsd xmm10, xmm12



    ;Calculate the length of the third side
    ;Formula for SAS Triangles: a = sqrt(b^2 + c^2 - 2bc(cosA))
    ;The following registers and their respective values they hold:
    ;b = xmm8
    ;c = xmm9
    ;A = xmm10
    ;b^2 = xmm11
    ;c^2 = xmm12
    ;2 = xmm13
    ;2*b*c = xmm13 (values will be multiplied into xmm13, which already holds 2)
    ;cos(A) = xmm14
    ;a = xmm15 (value of third side being calculated)
    ;xmm11 will hold the cosine of the angle




    ;Square value of b (xmm8) and store value in xmm11
    movsd xmm11, xmm8
    mulsd xmm11, xmm11


    ;Square value of c (xmm9) and store value in xmm12
    movsd xmm12, xmm9
    mulsd xmm12, xmm12


    ;Add b^2 and c^2 (xmm8 + xmm9) and store result in xmm11
    addsd xmm11, xmm12


    ;Block of code for 2*b*c
    ;2 will be stored in xmm13
    ;Product of 2*b*c
    movsd xmm13, qword [two]
    mulsd xmm13, xmm8
    mulsd xmm13, xmm9


    ;Convert degrees to radians before calling cosine
    movsd xmm8, qword [angle_180]
    movsd xmm9, qword [pi]
    divsd xmm9, xmm8
    mulsd xmm10, xmm9

    ;Cosine function
    mov rax, 1
    movsd xmm0, xmm10
    call cos
    movsd xmm14, xmm0



    ;Multiply (2*b*c) * cos(A)
    mulsd xmm14, xmm13


    ;Subtract b^2 + c^2 - 2bc(cosA) (xmm11 - xmm14)
    subsd xmm11, xmm14


    ;Move the difference into xmm15 and square root the value
    movsd xmm15, xmm11
    sqrtsd xmm15, xmm15


    ;Output length of third side
    mov rax, 1
    mov rdi, output_third_length
    mov rsi, format
    movsd xmm0, xmm15
    call printf



    ;Output confirmation that the third length is being sent to driver
    mov rax, 1
    mov rdi, length_send_message
    mov rsi, format
    movsd xmm0, xmm15
    call printf


    ;Get the ending time on the system clock
    cpuid
    rdtsc
    shl rdx, 32
    add rdx, rax
    mov r12, rax

    ;Output ending time on system clock
    mov rax, 0
    mov rdi, ending_time
    mov rsi, r12
    call printf

    ;Back up value in xmm14 before restoring registers
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
;End of the function average.asm ====================================================================

;Change Comments
;Show what string variables are printing to screen