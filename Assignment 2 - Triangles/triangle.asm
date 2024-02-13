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

extern printf

extern fgets

extern stdin

extern strlen

extern scanf

extern cos

global triangle_SAS

name_string_size equ 48

title_string_size equ 48

segment .data
;This section (or segment) is for declaring initialized arrays

name_prompt db "Please enter your name: ", 0
title_prompt db "Please enter your title (Sergeant, Chief, CEO, President, Teacher, etc): ", 0
good_morning_msg db 10, "Good morning %s %s. We take care of all your triangles.", 10, 0
first_side_prompt db 10, "Please enter the length of the first side: ", 0
second_side_prompt db 10, "Please enter the length of the second side: ", 0
angle_prompt db 10, "Please enter the angle in degrees: ", 0
format db "%lf", 0
output_values_test db 10, "First side: %1.6lf, Second side: %1.6lf, Angle size: %1.3lf", 0
output_third_length db 10, 10, "The length of the third side is %1.6lf", 10, 0
length_send_message db 10, "The length will be sent to the driver program", 10, 10, 0


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




; Ask for length of first side
mov rax, 0
mov rdi, first_side_prompt
call printf

;Input length of first side
mov rdi, format
push qword -9
push qword -9
mov rsi, rsp
call scanf
movsd xmm8, [rsp]
pop r9
pop r8



;Ask for length of second side
mov rax, 0
mov rdi, second_side_prompt
call printf

;Input length of second side
mov rdi, format
push qword -9
push qword -9
mov rsi, rsp
call scanf
movsd xmm9, [rsp]
pop r9
pop r8


;Ask for size of the angle
mov rax, 0
mov rdi, angle_prompt
call printf

;Input size of angle
mov rdi, format
push qword -9
push qword -9
mov rsi, rsp
call scanf
movsd xmm10, [rsp]
pop r9
pop r8


;TEST OUTPUT ALL VALUES
; SEG FAULT - Check average code
mov rax, 1
mov rdi, output_values_test
mov rsi, format
movsd xmm0, xmm8
movsd xmm1, xmm9
movsd xmm2, xmm10
call printf


;Calculate the length of the third side, answer should come out to 9.01971
;Formula for SAS Triangles: a^2 = b^2 + c^2 - 2bc(cosA)
;The following registers and their respective values they hold:
;b = xmm8
;c = xmm9
;A = xmm10
;a = xmm15 (value of third side being calculated)




;Output length of third side
mov rax, 1
mov rdi, output_third_length
mov rsi, format
movsd xmm3, xmm11
call printf



;Output confirmation that the third length is being sent to driver
mov rax, 1
mov rdi, length_send_message
mov rsi, format
movsd xmm0, xmm3
call printf


;Back up value in xmm14 before restoring registers
push qword 0
movsd [rsp], xmm14


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