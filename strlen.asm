.386
.model flat, stdcall
option casemap:none                     ; linking is case sensitive

.code
strlen proc string:ptr
    ; How to improve?
    ; Read 4 bytes at once
    mov     edx, [string]               ; set start pointer
    mov     eax, edx                    ; store start pointer for later
    count:
    cmp     byte ptr[eax],0             ; compare char with \0
    je      return                      ; if (char == \0), jump out
    inc     eax                         ; pointer++
    jmp     count                       ; loop
    return:
    sub     eax, edx                    ; curPointer - startPointer = len
    ret                                 ; return (eax=len)
strlen endp

end