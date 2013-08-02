;------ string.inc -------
IFNDEF STRING_INC
STRING_INC equ <1>

strlen PROTO :ptr
strrev PROTO :ptr
itoa PROTO :dword, :ptr, :dword
atoi PROTO :ptr

ENDIF