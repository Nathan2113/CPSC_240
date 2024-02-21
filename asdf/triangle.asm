;****************************************************************************************************************************
;Program name: "Assignment 2".  This program will compute the side of a triangle given 2 sides and an angle, will also test *
;for invalid inputs. Copyright (C) 2024  Garrett Kostyk.                                                                    *
;                                                                                                                           *
;This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License  *
;version 3 as published by the Free Software Foundation.  This program is distributed in the hope that it will be useful,   *
;but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See   *
;the GNU General Public License for more details A copy of the GNU General Public License v3 is available here:             *
;<https://www.gnu.org/licenses/>.                                                                                           *
;****************************************************************************************************************************





;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
;Author information
;  Author name: Garrett Kostyk
;  Author email: gk42gk42@gmail.com
;
;Program information
;  Program name: Assingment 2
;  Programming languages: One module in C, one in X86, and one in bash.
;  Date program began: 2024-Feb-12
;  Date of last update: 
;  Files in this program: driver2.c, triangle.asm, r.sh.
;  Testing: Alpha testing completed.  All functions are correct.
;  Status: Ready for release to customers
;
;Purpose
;  This program is a simple program that will compute the side of a triangle given 2 sides and an angle, will also test for invalid inputs.
;
;This file:
;  File name: triangle.asm
;  Language: X86-64
;  Max page width: 124 columns
;  Assemble (standard): 
;  Assemble (debug):
; 
; 
;
;
;
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**

extern printf

extern fgets

extern scanf

extern stdin

extern atof

extern strlen

extern strtok

extern isfloat

global triangle

name_string_size equ 48
first_side_size equ 48

segment .data
;This section (or segment) is for declaring initialized arrays

starting_clock db "The strating time on the system clock is 12345678 tics", 10, 0
prompt_for_name db "Please enter your name: ",0
prompt_for_title db "Please enter your title such as Sargent, Chief, CEO, President, Teacher, etc: " ,0
good_morning db "Good morning %s %s. We will take care of all your triangles.", 10, 0
prompt_for_side1 db "Please enter the length of the first side: ", 0
prompt_for_side2 db "Please enter the length of the second side: ", 0
prompt_for_angle db "Please enter the size of the angle in degrees: ", 0
invalid_input db "Invalid input. Try again: ", 0
thank_you db "Thank you %s. You entered %f %f and %f.", 10, 0
side3_is db "The length of the third side is: %f", 10, 0
sent_to_driver db "The lenght will be sent to the driver program.", 10, 0
final_clock db "The final time on the system clock is 23456789 tics", 10, 0
goodbye db "Goodbye %s %s. Have a nice day.", 10, 0
test_me db "you entered %s", 10, 0
float_format db "%lf", 0



segment .bss
;This section (or segment) is for declaring uninitialized arrays

align 64
backup_storage_area resb 832
user_name resb name_string_size
user_title resb name_string_size
first_side resb first_side_size


segment .text

triangle:

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

;Print the starting time on the system clock
mov rax, 0
mov rdi, starting_clock
call printf

;Prompt user for thier name
mov rax, 0
mov rdi, prompt_for_name
call printf

;Get the user's name
mov rax, 0
mov rdi, user_name
mov rsi, name_string_size
mov rdx, [stdin]
call fgets

;Remove the newline character from the user's name
mov rax, 0
mov rdi, user_name
call strlen
mov [user_name + rax - 1], byte 0

;Prompt the user for their title
mov rax, 0
mov rdi, prompt_for_title
call printf

;Get the user's title
mov rax, 0
mov rdi, user_title
mov rsi, name_string_size
mov rdx, [stdin]
call fgets

;Remove the newline character from the user's title
mov rax, 0
mov rdi, user_title
call strlen
mov [user_title + rax - 1], byte 0

;Print good morning message
mov rax, 0
mov rdi, good_morning
mov rsi, user_title
mov rdx, user_name
call printf

;Prompt user to insert first side
mov rax, 0
mov rdi, prompt_for_side1
call printf

;Get the lenght of the first side as a string
mov rax, 0
sub rsp, 4096
mov rdi, rsp
mov rsi, 4096
mov rdx, [stdin]
call fgets

;remove the newline character from the string
mov rax, 0
mov rdi, rsp
call strlen
mov [rsp + rax - 1], byte 0

;Check if input is valid float number
mov rax, 0
mov rdi, rsp
call isfloat
cmp rax, 0
je bad_input

;If input is valid, convert string to float
mov rax, 0
mov rdi, rsp
call atof 
movsd xmm10, xmm0

jmp second_side

;If input is invalid, prompt user to try again
bad_input:
add rsp, 4096
mov rax, 0
mov rdi, invalid_input
call printf

mov rax, 0
sub rsp, 4096
mov rdi, rsp
mov rsi, 4096
mov rdx, [stdin]
call fgets

;remove the newline character from the string
mov rax, 0
mov rdi, rsp
call strlen
mov [rsp + rax - 1], byte 0

;Check if input is valid float number
mov rax, 0
mov rdi, rsp
call isfloat
cmp rax, 0
je bad_input

mov rax, 0
mov rdi, rsp
call atof 
movsd xmm10, xmm0

add rsp, 4096




second_side:
;Prompt user to insert second side
mov rax, 1
mov rdi, prompt_for_side2
call printf

;Get the length of second side from user
mov rax, 0
mov rdi, float_format
push qword -9 ;rsp points to -9
push qword -9 ;rsp points to -9
mov rsi, rsp
call scanf
movsd xmm11, [rsp]
pop r9
pop r8

;Prompt user to insert the size of the angle
mov rax, 1
mov rdi, prompt_for_angle
call printf

;Get the size of the angle
mov rax, 0
mov rdi, float_format
push qword -9 ;rsp points to -9
push qword -9 ;rsp points to -9
mov rsi, rsp
call scanf
movsd xmm12, [rsp]
pop r9
pop r8

;++++++++++++++++++++++++++++++++++++++++++++++
;STILL NEED TO SPLIT FIRST AND LAST NAME
;Split user name into first and last name
mov rax, 1
mov rdi, user_name
call strtok

;Print users First name and the data they inputed
mov rax, 1
mov rdi, thank_you
mov rsi, user_name
movsd xmm0, xmm10
movsd xmm1, xmm11
movsd xmm2, xmm12
call printf




;Restore the registers other than the GPRs
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