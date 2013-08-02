.386
.model flat, stdcall
option casemap:none                     ; linking is case sensitive

.code
; param1 - Integer value to convert into string
; param2 - String buffer for result (must be large enough to store result!)
;          Function is not safe against possible overflows!
; param3 - Base of the result (2 for binary, 10 for decimal and so on).
;          Allowed bases 2-36.
; result - (Stored in eax). Pointer to resulting null-terminated string, same as param2.
itoa proc value:dword, string:ptr, base:dword
    ; preserve esi (Intel standard)
    push      esi
    
    mov       esi, [base]               ; esi stores base for quick usage
    
    ; check whether the base is in the required interval (2-36)
    cmp       esi, 2
    jl        return
    cmp       esi, 36
    jg        return
    
    mov       eax, [value]              ; initial value stored in eax
    xor       ecx, ecx                  ; empty the ecx
    pushw     0                         ; push \0 into stack to mark the start 
                                        ; (and for null terminator in the string)
    ; check if zero (special case)
    cmp       eax, 0
    jne       negativeCheck
    pushw     48                        ; push '0' into stack
    jmp       writeout
    ; check whether negative number
    negativeCheck:
    cmp       eax, 0
    jge       cycle
    mov       ch, 1                     ; if negative set byte in ecx (ch)
    neg       eax                       ; ..and turn the number into positive
    ; lets start dividing
    cycle:
    cmp       eax, 0                    ; check whether the result of last division is 0
    je        writeout                  ; if so, we're done with dividing
    xor       edx, edx                  ; edx must be nulled
    div       esi                       ; divide eax by base (esi)
    ; idiv stores result into eax and remainder into edx
    ; convert the remainder into char
    mov       cl, dl                    ; take remainder from dl
    cmp       cl, 10                    ; check if larger than 9
    jge       letters                   ; ..if so, use letters for symbols
    ; composing numbers < 10
    add       cl, 48
    jmp       pushIntoStack
    ; composing numbers >= 10
    letters:
    add       cl, 87
    ; pushes resulting char into stack
    ; as we're getting numbers in opposite order, it's good way to reverse them
    pushIntoStack:
    push      cx
    jmp       cycle
    ; next phase after dividing
    writeout:
    mov       eax, [string]
    mov       edx, eax
    ; check whether it is negative number (flag stored in ch)
    cmp       ch, 1
    jne       writeout_cycle
    mov       byte ptr[edx], 45         ; if negative then write '-' to buffer
    inc       edx
    ; write everything from stack to buffer
    writeout_cycle:
    pop       cx
    mov       byte ptr[edx], cl
    inc       edx
    cmp       cl, 0                     ; until null terminator is met in the stack
    jne       writeout_cycle
    return:
    ; preserve esi (Intel standard)
    pop       esi
    ret
itoa endp

end