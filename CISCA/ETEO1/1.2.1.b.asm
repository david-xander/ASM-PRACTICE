;Escribir en R1 un 1 si se cumple una y sólo una de las dos condiciones siguientes:
;• el contenido de R2 es más grande o igual que el de R3
;• el contenido de R4 es más pequeño que el de R5.
;En cualquiera otro caso escribir en R1 un 0.

;if(R2>=R3 && !R4<R5)
;    R1=1;
;else if(R4<R5 && !R2>=R3)
;    R1=1

if:
    cmp R2, R3
    jl else
    cmp R4, R5
    jl false
    jmp true
else:
    cmp R4, R5
    jge false
true:
    mov R1, 1
    jmp endif
false:
    mov R1, 0
endif: