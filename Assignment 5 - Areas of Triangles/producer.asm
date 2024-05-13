;/****************************************************************************************************************************
;Program name: "Areas of Triangles" - This program will prompt the user for the lengths of 2 sides of a triangle and the 
;size of the angle between them. All I/O in this program will be handled in pure assembly using syscalls. The conversions
;atof (string to float) and ftoa (float to string) both use built-in library functions. When computing the area of the 
;triangle, sin(x), where x is the angle, is used in the formula, and sin(x) is computed using a Taylor series, programmed in 
;x86_64. When the user has input 2 sides and the angle between, the program will convert the strings input by the user into
;floats, calculate the area, then convert the area into a string and output the area to the screen. Once the area has been  
;output to the screen, the program will then return the area to the driver function, written in C, and will confirm its 
;retrieval and convey a goobye message to the user.

;WARNING: THIS PROGRAM DOES NOT VALIDATE USER INPUT
;****************************************************************************************************************************/



;/**********************************************************************************************************************************
;Author information
;  Author name: Nathan Warner
;  Author email: nwarner4@csu.fullerton.edu

;Program information
;  Program name: Areas of Triangles
;  Programming languages: One module in C, four modules in x86_64, and one module in bash
;  Date program began: 2024-May-4
;  Date of last update: 2024-Mar-8
;  Files in this program: main.c, producer.asm multiplier.asm sin.asm strlen.asm r.sh
;  Testing: Alpha testing completed.  All functions are correct.
;  Status: Ready for release to customers

;Purpose
;  The program will take in 2 sides of a triangle, as well as the angle between them in degrees from the user.
;    Using the above information, the program will then compute the area of the triangle and output it to the screen.
;    All I/O in this program will be done in pure x86_64 assembly using syscalls

;This file:
;  File name: producer.asm
;  Language: x86_64
;  Max page width: 124 columns
;  Assemble (standard): nasm -f elf64 -l producer.lis -o producer.o producer.asm
;  Optimal print specification: Landscape, 7 points, monospace, 8½x11 paper
;  Prototype of this function: int main(int argc, const char * argv[]);
;***********************************************************************************************************************************/

;Declaration section.  The section has no name other than "Declaration section".  Declare here everything that does
;not have its own place of declaration

global producer

extern sin
extern atof
extern strlen
extern gcvt

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
newline db 10


angle_180 dq 180.0
pi dq 3.14159265359
two dq 2.0

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

    ;Block that outputs a newline
    mov byte [newline], 0xa
    mov byte [newline+1], 0
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    
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
    movsd xmm13, xmm0

    ;Convert side 2 to float
    mov rax, 0
    mov rdi, second_side
    call atof
    movsd xmm14, xmm0

    ;Convert angle to float
    mov rax, 0
    mov rdi, angle
    call atof
    movsd xmm15, xmm0


    ;CONVERTING FROM DEGREES TO RADIANS
    ;xmm15 is the radians
    movsd xmm12, qword [angle_180]
    movsd xmm11, qword [pi]
    divsd xmm11, xmm12
    mulsd xmm15, xmm11


    ;Calling sine function
    mov rax, 1
    movsd xmm0, xmm15
    call sin
    movsd xmm15, xmm0


    ;Computing the area of the triangle after finding sine
    ;The formula being used is 1/2 * a * b * sin(x) where:
    ;a = the length of the first side
    ;b = the length of the second side
    ;x = the angle in degrees
    ;xmm13 holds side 1
    ;xmm14 holds side 2
    ;xmm15 holds sin(x)

    mulsd xmm13, xmm14
    mulsd xmm13, xmm15
    divsd xmm13, qword [two] ;xmm13 now holds the area



    ;Convert the area into a string
    mov rax, 1
    movsd xmm0, xmm13
    mov rdi, 10
    mov rsi, area_output
    call gcvt
    mov r15, rax


    ;Block that outputs a newline
    mov byte [newline], 0xa
    mov byte [newline+1], 0
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall



    ;Get the length of the area_output_1 string
    mov rax, 0
    mov rdi, area_output_1
    call strlen
    mov r12, rax


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
    movsd [rsp], xmm13



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
;End of the function producer.asm ====================================================================