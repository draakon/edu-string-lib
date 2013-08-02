.386
.model flat, stdcall
option casemap:none                       ; linking is case sensitive

.code
atoi proc string:ptr
    ; empty eax, edx and registers
    xor       eax, eax
    xor       edx, edx
    
    mov       ecx, [string]
    ; check for sign
    cmp       byte ptr[ecx], 45           ; check for '-'    
    jne       cycle
    inc       ecx
    cycle:
    mov       dl, byte ptr[ecx]
    cmp       dl, 0                       ; end of string (\0)
    je        setsign
    cmp       dl, 48                      ; less than ascii 48 ('0')
    jl        setsign
    cmp       dl, 57                      ; greater than ascii 57 ('9')
    jg        setsign
    sub       dl, 48                      ; transform to number
    imul      eax, 10                     ; multiply output by 10
    add       eax, edx                    ; move to output
    inc       ecx
    jmp       cycle
    ; Sets sign by using neg if negative value
    setsign:
    ; Is it possible to combine the next two lines?
    mov       edx,  [string]
    cmp       byte ptr[edx], 45           ; check for '-'
    jne       return
    neg       eax
    return:
    ret
atoi endp

end