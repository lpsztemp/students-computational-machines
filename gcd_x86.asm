.586
.model flat
.code
_gcd proc
mov eax, dword ptr [esp + 4]
mov ecx, dword ptr [esp + 8]
test ecx, ecx
jz return
xor edx, edx
div ecx
push edx
push ecx
call _gcd
add esp, 8
return:
ret
_gcd endp
end