.586
.model flat
.stack 100h

.data
LINE_FEED = 10
TERMINATION_BYTE = 0
msg_a db "Input lower bound: ", TERMINATION_BYTE
msg_b db "Input upper bound: ", TERMINATION_BYTE
msg_scan db "%lg", TERMINATION_BYTE
msg_c db "Integral from (%g to %g) equals %g", LINE_FEED, TERMINATION_BYTE
.code
extrn _scanf:proc
extrn _printf:proc
STEPS=10000
_integral proc
push ebp
mov ebp, esp
mov eax, 4
push eax
mov ecx, STEPS
push ecx
fldz ;accum
fld qword ptr [ebp + 8] ;a + i*dx
fld qword ptr [ebp + 16] ;b
fsub st(0), st(1)
fild dword ptr [ebp - 8] ;STEPS
fdivp ;dx

@start:
fadd st(1), st(0) ;a + (i - 1) * dx + dx
fld st(1)
fmul st(0), st(2)
fld1
faddp
fild dword ptr [ebp - 4] ;4
fdivrp
faddp st(3), st(0)
loop @start
fmulp st(2), st(0)

fstp st(0)
mov esp, ebp
pop ebp
ret
_integral endp

_main proc
push ebp
mov ebp, esp
sub esp, 24
lea eax, msg_a
push eax
call _printf
add esp, 4
lea eax, qword ptr [ebp - 24] ;a
push eax
lea eax, msg_scan
push eax
call _scanf
add esp, 8
lea eax, msg_b
push eax
call _printf
add esp, 4
lea eax, qword ptr [ebp - 16] ;b
push eax
lea eax, msg_scan
push eax
call _scanf
add esp, 8
call _integral
fstp qword ptr [ebp - 8] ;result
lea eax, msg_c
push eax
call _printf
mov esp, ebp
pop ebp
xor eax, eax
ret
_main endp
end
