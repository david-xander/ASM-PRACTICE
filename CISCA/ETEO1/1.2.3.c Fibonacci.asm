; Código C:
; Cálculo del término ‘n-éssimo’ (Sn) de la sucesión de Fibonacci. S0=0, S1=1, Sn=Sn-1+Sn- 2.
; Sn: next; Sn-1: second; Sn-2: first.

; i = 0; 
; do {
;     if (n<2){ 
;         next=n;
;     }
;     else {
;         next = first+second; 
;         first = second; 
;         second = next;
;     }
;     i++;
; } while (i < n);

mov R1, 0 ; i
mov R2, 0 ;[first]
mov R3, 0 ;[second]
mov R4, 0 ;[next]
while:
    cmp R1, [n]
    jge endwhile

    if:
        cmp [n], 2
        jge else
        mov R4, [n]
        jmp endif
    else:
        mov R4, R2
        add R4, R3
        mov R2, R3
        mov R3, R4
    endif:
        inc R1
        jmp while
endwhile:

