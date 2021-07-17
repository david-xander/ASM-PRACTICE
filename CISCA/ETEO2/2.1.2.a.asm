; 1: Considerad que no nos interesa el valor final de las variables partial_sum, i y N. 
; Por ello, para optimizar el código debéis usar registros del procesador para almacenar 
; sus valores.

; 2: Suponed que en el programa escrito en el lenguaje de alto nivel se ha definido 
; la variable V como vector de enteros de 32 bits y la variable sum como número 
; entero de 32 bits, y que se encuentran almacenados a partir de las direcciones 
; simbólicas de memoria V y sum respectivamente.

; CÓDIGO EN C

; N = 4; 
; sum = 0;
; partial_sum = 0;
; i = 0;
; while ( i< N)  {
;    partial_sum = partial_sum + V[i];
;    i = i + 1;
; }
; sum = partial_sum;

mov R1, 4 ; N = 0
mov R2, 0 ; partial_sum = 0
mov R3, 0 ; i = 0
mov R4, 0 ; i*4

while:
    cmp R3, R1
    jge endwhile
    mov R4, R1
    mul R4, 4
    add R2, [V+R4]
    inc R1
endwhile:
    mov [sum], R2
