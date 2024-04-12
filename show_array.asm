;****************************************************************************************************************************
;Program name: "Assignment 4".  This program will generate an array of a size picked by the user of random numbers,         *
;normalize them, then sort them. Will also check if any nan numbers were generated and discard them. Copyright (C) 2024     *
;of Garrett Kostyk.                                                                                                         *
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
;  Program name: Assingment 4
;  Programming languages: One module in C, five in X86, one in c++, and one in bash.
;  Date program began: 2024-Apr-01
;  Date of last update: 
;  Files in this program: main.c, executive.asm, fill_rand_array.asm, isnan.asm, normalize_array.asm, show_array.asm,
;                         sort_array.cpp, r.sh
;  Testing: Alpha testing completed.  All functions are correct.
;  Status: Ready for release to customers
;
;Purpose
;  This program will generate an array of a size picked by the user of random numbers,         
;  normalize them, then sort them. Will also check if any nan numbers were generated and discard them.
; 
;
;
;
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**


extern printf

extern fgets

extern scanf

extern stdin

extern strlen

global show_array

array_size_max equ 100

segment .data
;This section (or segment) is for declaring initialized arrays

list_label db "IEEE754			Scientific Decimal", 10, 0
output_format db "0x%016lx      %-18.13g", 10, 0



segment .bss
;This section (or segment) is for declaring uninitialized arrays

align 64
backup_storage_area resb 832
array_size resb array_size_max


segment .text

show_array:

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

;establish array vars
mov r13, rdi ;r13 is the array
mov r14, rsi ;r14 is max array size
mov r15, 0   ;counter/index

;print the labels for the printing list "IEEE and Scientific"
mov rax, 0
mov rdi, list_label
call printf

;start the loop
begin:

;compare thr index and the array size
cmp r15, r14 
jge quit_loop

;Print the indexed array element in IEEE form
mov rax, 1
mov rdi, output_format
mov rsi, [r13+r15*8]
movsd xmm0, [r13+r15*8]
call printf


;incremnet the counter
inc r15
jmp begin
quit_loop:


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
