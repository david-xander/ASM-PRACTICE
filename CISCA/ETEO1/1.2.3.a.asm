;if (A > B) C = C + 3 else C = C – 1;

mov R0, [A]
mov R1, [B]
mov R2, [C]
if:
    cmp R0, R1
    jle else
    add R2, 3
    jmp endif
else:
    sub R2, 1
endif:
    mov [C], R2

