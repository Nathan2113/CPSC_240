; Nathan Warner
; nwarner4@csu.fullerton.edu
; CPSC 240-3
; Mar 20, 2024

;Declaration section.  The section has no name other than "Declaration section".  Declare here everything that does
;not have its own place of declaration

global electricity

extern printf
extern stdin
extern scanf
extern current
extern atof
extern strlen
extern isfloat
extern fgets

float_size equ 60
true equ -1
false equ 0

segment .data
;This section (or segment) is for declaring initialized arrays

electric_force_prompt db "Please enter the electric force in the circuit (volts): ", 0
resistance_1_prompt db "Please enter the resistance in circuit number 1 (ohms): ", 0
resistance_2_prompt db "Please enter the resistance in circuit number 2 (ohms): ", 0
thank_you_message db "Thank you.", 10, 0
format db "%lf", 0
print_bad_input db "Invalid input. Try again: ", 0


segment .bss
;This section (or segment) is for declaring empty arrays

align 64
backup_storage_area resb 832


segment .text

electricity:

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

    ;The following values will be stored in the following registers
    ;xmm10 -> volts
    ;xmm11 -> resistance in circuit 1
    ;xmm12 -> resistance in circuit 2

    mov r15, 0

get_electric_force:
    ;Ask for electric force
    mov rax, 0
    mov rdi, electric_force_prompt
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

    ;Adds 1 to r15, which enables the program to jump to get_resistance_1 after invalid inputs
    add r15, 1

    ;Fixes the stack
    add rsp, 4096

    jmp get_resistance_1



get_resistance_1:
    ;Ask for resistance 1
    mov rax, 0
    mov rdi, resistance_1_prompt
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

    ;Adds 1 to r15, which enables the program to jump to get_resistance_2 after invalid inputs
    add r15, 1

    ;Fixes the stack
    add rsp, 4096

    jmp get_resistance_2



get_resistance_2:
    ;Ask for resistance 2
    mov rax, 0
    mov rdi, resistance_2_prompt
    call printf


    ;Gets user input for resistance 2
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


    ;Fixes stack
    add rsp, 4096

    ;Jumps to exit
    jmp exit



bad_input:
;bad_input will have a tracker for which input the user is on (electric force, resistance 1, resistance 2) and
;depending on the number in the register (will use 0 for electric force, 1 for resistance 1, and 2 for resistance 2)
;the program will jump to the correct code block

;if(tracker == 0)
    ;jump to electric force input
;elseif(tracker == 1)
    ;jump to resistance 1 input
;elseif(tracker == 2)
    ;jump to resistance 2 input

    ;Fixes stack
    add rsp, 4096

    ;Tell the user their input is invalid and have them enter another input
    mov rax, 0
    mov rdi, print_bad_input ;"Invalid input. Try again"
    call printf


    ;Gets user input (for electric force or resistance)
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

    ;Jump back to correct input block depending on value of r15
    cmp r15, 0
    je elec_force_bad

    cmp r15, 1
    je resistance_1_bad

    cmp r15, 2
    je resistance_2_bad


;The following three blocks (elec_force_bad, resistance_1_bad, and resistance_2_bad) are used to 
;take in another user input without outputting the whole prompt again
elec_force_bad:
    ;Convert the input from string to float
    mov rax, 0
    mov rdi, rsp
    call atof
    movsd xmm10, xmm0

    add r15, 1

    ;Fixes stack
    add rsp, 4096

    jmp get_resistance_1



resistance_1_bad:
    ;Convert the input from string to float
    mov rax, 0
    mov rdi, rsp
    call atof
    movsd xmm11, xmm0

    add r15, 1

    ;Fixes stack
    add rsp, 4096

    jmp get_resistance_2


resistance_2_bad:
    ;Convert the input from string to float
    mov rax, 0
    mov rdi, rsp
    call atof
    movsd xmm12, xmm0

    ;Fixes stack
    add rsp, 4096

    jmp exit

exit:
    ;Moves values for electric force and resistances to lower registers for use on the next block
    movsd xmm8, xmm10
    movsd xmm9, xmm11
    movsd xmm10, xmm12


    ;Thank you message
    mov rax, 0
    mov rdi, thank_you_message
    call printf



    ;Block to call current
    mov rax, 3
    movsd xmm0, xmm8
    movsd xmm1, xmm9
    movsd xmm2, xmm10
    call current
    movsd xmm14, xmm0 ;moves value of total current to xmm14


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
;End of the function electricity.asm ====================================================================