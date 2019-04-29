.586
.model flat
.stack 100h
.code
public _memmul

_memmul proc ;memmul(const void* X, const void* Y, void* Z, unsigned cb)
push ebp
mov ebp, esp
push esi
push edi
push ebx
mov eax, dword ptr [ebp+16] ;Z
mov dl, 0
mov ecx, dword ptr [ebp+20] ;cb

kek:
mov byte ptr [eax], dl
inc eax
dec ecx
jnz kek

mov ecx, dword ptr [ebp+20] ;rest = cb
loop_j:
cmp ecx, 0
jz finish
push ecx
sub esp, 12

mov ecx, dword ptr [ebp+20] ;rest_x <- cb
xor eax, eax
mov dword ptr [ebp-28], eax ;CF
loop_i:
mov eax, dword ptr [ebp+20] ;cb
sub eax, ecx
mov dword ptr [ebp-20], eax ;i <- cb - rest_x
mov eax, dword ptr [ebp+20] ;cb
sub eax, dword ptr [ebp-16];
mov dword ptr [ebp-24], eax ; j <- cb - rest
mov edi, dword ptr [ebp-20] ;i
add edi, dword ptr [ebp-24] ;+j
cmp edi, dword ptr [ebp+20] ; i + j vs cb
jnc Z_write_end ; if (i + j) >= cb
add edi, dword ptr [ebp+16] ;+Z => Z_(i+j)
mov esi, dword ptr [ebp+8] ; X
add esi, dword ptr [ebp-20] ; +i => X_i
mov ebx, dword ptr [ebp+12] ; Y
add ebx, dword ptr [ebp-24] ; +j => Y+j
mov al, byte ptr [esi] ; [X_i]
mul byte ptr [ebx] ; [X_i] * [Y_j]
add byte ptr [edi], al ; [Z_(i+j)] <- [Z_(i+j)] + ([X_i] * [Y_j]) mod 2^32
pushfd ;CF
mov edx, dword ptr [ebp-20] ; i
add edx, dword ptr [ebp-24] ; +j
inc edx ; +1
cmp edx, dword ptr [ebp + 20] ; (i+j+1) vs. cb
jc Z_adjust ; if (i + j + 1 < cb) jump to Z_adjust
add esp, 4 ;EFLAGS
jmp Z_write_end
Z_adjust:
inc edi ; Z_(i + j + 1)
xor edx, edx
popfd ;CF
adc byte ptr [edi], ah ; [Z_(i + j + 1)] <- [Z_(i + j + 1)] + ([X_i] * [Y_j]) / 2^32
jnc add_1
inc edx
add_1:
mov al, byte ptr [ebp - 28] ;CF'
add byte ptr [edi], al
jnc add_2
inc edx
add_2:
mov byte ptr [ebp - 28], dl ;CF'
Z_write_end:
dec ecx ;rest_x <- rest_x - 1
jnz loop_i ; if (rest_x =/= 0)
add esp, 12
pop ecx ; rest_j
dec ecx ; rest_j <- rest_j - 1
jmp loop_j ; if (rest_j =/= 0)

finish:
pop ebx
pop edi
pop esi
pop ebp
ret
_memmul endp
end