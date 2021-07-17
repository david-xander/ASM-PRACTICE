;Escribir en R1 un 1 si el contenido de R2 es más grande o igual que el de R3 y además el de R4 
;es más pequeño que el de R5. Si no pasa todo el anterior, escribir un 0.

if:
    cmp R2, R3
    jl else
    cmp R4, R5
    jge else
    mov R1, 1
    jmp endif
else:
    mov R1, 0
endif: