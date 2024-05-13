global multiplier

segment .data
;This section (or segment) is for declaring initialized arrays

segment .bss
;This section (or segment) is for declaring uninitialized arrays

align 64
backup_storage_area resb 832

segment .text

multiplier:

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

;make numerator
mov rbx, rdi
movsd xmm13, xmm0
mulsd xmm13, xmm13
mov r8, -1
cvtsi2sd xmm12, r8
mulsd xmm13, xmm12

;make denominator
add rbx, rbx
add rbx, 2
mov rcx, rbx
inc rcx
mov rax, rcx
mul rbx 
cvtsi2sd xmm14, rbx

;final
divsd xmm13, xmm14
movsd xmm0, xmm13

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

