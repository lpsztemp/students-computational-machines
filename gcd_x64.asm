.code
gcd proc
test edx, edx
jnz recursion
mov eax, ecx
ret
recursion:
mov eax, ecx
mov ecx,edx
xor edx, edx
div ecx
call gcd
ret
gcd endp
end