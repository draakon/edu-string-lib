.386
.model flat, stdcall
option casemap:none                       ; linking is case sensitive

.code
strrev proc string:ptr
    ; Is it possible to use TEST instead of CMP here? Which faster?

    ; eax - start pointer (just for storing and returning)
    mov       eax, [string]               ; char *eax = &string (start)
    mov       ecx, eax                    ; ecx = eax (start)
    xor       edx, edx
    pushw     0                           ; null-terminator
    ; start pushing chars into the stack
    fillTheStack:
    mov       dl, byte ptr[ecx]           ; move char to dl (low end of edx)
    cmp       dl, 0                       ; compare char with \0
    je        stackFilled                 ; if (char == \0) jump out
    push      dx                          ; otherwise into the stack!
    inc       ecx                         ; (string pointer)++
    jmp       fillTheStack                ; loop
    ; recovers chars from the stack (...and they're in reverse order!)
    stackFilled:
    mov       ecx, eax                    ; reset the counter to start of string
    emptyTheStack:
    pop       dx                          ; pop char from the stack
    cmp       dl, 0                       ; compare char with \0
    je        return                      ; if (char == \0) jump out
    mov       byte ptr[ecx], dl           ; write back to string
    inc       ecx                         ; (string pointer)++
    jmp       emptyTheStack               ; loop
    return:
    ret                                   ; return (eax=&string)
strrev endp

end