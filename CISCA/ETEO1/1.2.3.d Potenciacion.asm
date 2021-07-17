; Código C:
; Cálculo de power = be (b^e)
; power=1;
; for (i=e; i>0; i--) {
;   power = power * b; 
; }

mov R0, 0 ; result
mov R1, [base]
mov R2, [exponente]

for:



    cmp R2, 0
    jge endfor


endfor: