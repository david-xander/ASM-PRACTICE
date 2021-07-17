; Código C:
; Cálculo del Máximo Común Divisor por el algoritmo de Euclides
; while (A != B) {
; if (A > B) A = A – B;
; else B=B–A; }
; MCD = A;

mov R1, [A]
mov R2, [B]
while:
    cmp R1, R2
    je endwhile
    if:
        cmp R1, R2 ; no es NECESARIO hacer este CMP aquí
        jle else
        sub R1, R2
        jmp while
    else:
        sub R2, R1
        jmp while
endwhile:
    mov [MOV], R1