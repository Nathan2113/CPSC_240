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

global average

name_string_size equ 48

title_string_size equ 48

segment .data
;This section (or segment) is for declaring initialized arrays

name_prompt db "Please enter your first and last names: ", 0
title_prompt db "Please enter your title such as Lieutenant, Chief, Mr, Ms, Influencer, Chairman, Freshman,", 10, "Foreman, Project Leader, etc: ", 0
thank_you_p1 db "Thank you %s", 0
thank_you_p2 db " %s", 10, 0
fullerton_prompt db 10, "Enter the number of miles traveled from Fullerton to Santa Ana: ", 0
santa_ana_prompt db 10, "Enter the number of miles traveled from Santa Ana to Long Beach: ", 0
long_beach_prompt db 10, "Enter the number of miles traveled from Long Beach to Fullerton: ", 0
speed_prompt db "Enter your average speed during that leg of the trip: ", 0
format db "%lf", 0
process_message db "The inputted data are being processed", 10, 10, 0
total_distance db "The total distance traveled is %1.1lf miles.", 10, 0
trip_time db "The time of trip is %1.8lf", 10, 0
average_speed db "The average speed during the trip is %1.8lf mph.", 10, 0
val dq 3.0




segment .bss
;This section (or segment) is for declaring empty arrays

align 64
backup_storage_area resb 832

user_name resb name_string_size

user_title resb title_string_size

segment .text

average:

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

;Say thank you part 1
mov rax, 0
mov rdi, thank_you_p1
mov rsi, user_title
call printf

;Say thank you part 2
mov rax, 0
mov rdi, thank_you_p2
mov rsi, user_name
call printf




;Ask for number of miles from Fullerton to Santa Ana
mov rax, 0
mov rdi, fullerton_prompt
call printf

;Input number of miles from Fullerton to Santa Ana
mov rdi, format
push qword -9
push qword -9
mov rsi, rsp
call scanf
movsd xmm8, [rsp]
pop rax
pop rax


;Ask for average speed from Fullerton to Santa Ana
mov rax, 0
mov rdi, speed_prompt
call printf

;Input average speed from Fullerton to Santa Ana
mov rdi, format
push qword -9
push qword -9
mov rsi, rsp
call scanf
movsd xmm9, [rsp]
pop rax
pop rax



;Ask for number of miles from Santa Ana to Long Beach
mov rax, 0
mov rdi, santa_ana_prompt
call printf

;Input number of miles from Santa Ana to Long Beach
mov rdi, format
push qword -9
push qword -9
mov rsi, rsp
call scanf
movsd xmm10, [rsp]
pop rax
pop rax



;Ask for average speed from Santa Ana to Long Beach
mov rax, 0
mov rdi, speed_prompt
call printf

;Input average speed from Santa Ana to Long Beach
mov rdi, format
push qword -9
push qword -9
mov rsi, rsp
call scanf
movsd xmm11, [rsp]
pop rax
pop rax



;Ask for number of miles from Long Beach to Fullerton
mov rax, 0
mov rdi, long_beach_prompt
call printf

;Input number of miles from Long Beach to Fullerton
mov rdi, format
push qword -9
push qword -9
mov rsi, rsp
call scanf
movsd xmm12, [rsp]
pop rax
pop rax



;Ask for average speed from Long Beach to Fullerton
mov rax, 0
mov rdi, speed_prompt
call printf

;Input average speed from Long Beach to Fullerton
mov rdi, format
push qword -9
push qword -9
mov rsi, rsp
call scanf
movsd xmm13, [rsp]
pop rax
pop rax



;Get total distance traveled
movsd xmm14, xmm8
addsd xmm14, xmm10
addsd xmm14, xmm12


;Get average speed
movsd xmm15, xmm9
addsd xmm15, xmm11
addsd xmm15, xmm13
movsd xmm7, qword [val]
divsd xmm15, xmm7


;Get total time
movsd xmm9, xmm14
divsd xmm9, xmm15


;Output to let user know that data is being processed
mov rax, 0
mov rdi, process_message
call printf


;Output total distance traveled
mov rax, 1
mov rdi, total_distance
mov rsi, format
movsd xmm0, xmm14
call printf



;Output total time of trip
mov rax, 1
mov rdi, trip_time
mov rsi, format
movsd xmm0, xmm9
call printf



;Output average speed
mov rax, 1
mov rdi, average_speed
mov rsi, format
movsd xmm0, xmm15
call printf



;Back up value in xmm15 before restoring registers
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