;****************************************************************************************************************************
;Program name: "Amazing Triangles" - This program will take first welcome the user the the program, and then output the     *
;system clock (tics) to the console. After this initial output for the user, the program will then prompt the user for their*
;full name, as well as their title (i.e. Dean, Vice-president, etc.). Once the user has entered their name and title, the   *
;program will tell them good morning, and that this program will take care of their triangles. After, the program will      *
;prompt the user for the sides of the triangle and its angle (this program solves SAS triangles). If the user inputs an     *
;invalid input (negative number, non-float number, or an input that is not a number such as 2.2.3+A), the program will      *
;let the user know that their input is invalid and will then prompt them for another input. After 3 valid inputs are        *
;entered (2 sides and 1 angle), the program will output a thank you message/confirmation of the user's inputted values.     *
;Now that the program has 3 valid inputs, it will use the formula for solving SAS triangles to find the third side, and     *
;will output said answer, as well as letting the user know that the length of the third side will be sent to the driver.    *
;Before this value is sent, the program will output the new system clock (tics). Once back in the driver, it will let the   *
;user know that it has received the value of the third side, and that a zero will be sent to the operating system.          *                                                                                                      
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
;  Program name: Amazing Triangles
;  Programming languages: One module in C, one in X86, and one in bash.
;  Date program began: 2024-Feb-11
;  Date of last update: 2024-Feb-19
;  Files in this program: driving_time.c, average.asm, r.sh.
;  Testing: Alpha testing completed.  All functions are correct.
;  Status: Ready for release to customers
;
;Purpose
;  This program will take in two sides and an angle of a triangle, and will output the length of the
;   thrd side to the console, as well as sending the value to the driver.
;
;This file:
;  File name: triangle.asm
;  Language: X86-64
;  Max page width: 124 columns
;  Assemble (standard): nasm -l average.lis -o average.o average.asm
;  Assemble (debug): nasm -g dwarf -l average.lis -o average.o average.asm
;  Optimal print specification: Landscape, 7 points, monospace, 8½x11 paper
;  Prototype of this function: double triangle_SAS();
; 
;
;
;
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**

;Declaration section.  The section has no name other than "Declaration section".  Declare here everything that does
;not have its own place of declaration

global compute_mean


segment .data
;This section (or segment) is for declaring initialized arrays
    ; string_format db "%s", 0
    ; user_invalid_input db "The last input was invalid and not entered into the array.", 10, 0


segment .bss
;This section (or segment) is for declaring empty arrays
align 64
backup_storage_area resb 832


segment .text

compute_mean:
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






    

    ; Restore the values to non-GPRs
    mov rax, 7
    mov rdx, 0
    xrstor [backup_storage_area]

    mov rax, r15



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
;End of the function compute_mean.asm ====================================================================