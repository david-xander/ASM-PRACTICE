; Tenemos definido un vector, V, de 8 elementos. Cada elemento es un número 
; entero codificado en complemento a 2 con 32 bits:
;      V: 3, -7, 125, 421, -9, 1000, 7, 8
; Escribid un código en ensamblador que cambie el orden en que se encuentran 
; los elementos del vector, dejando el primer elemento en la última posición, 
; el segundo en la antepenúltima etc. Después de la ejecución del código el 
; vector debe quedar así:
;      V: 8, 7, 1000, -9, 421, 125, -7, 3
; El bucle principal del programa debería servir para vectores con un número 
; cualquiera de elementos. Antes de este bucle, habría que iniciar el contenido 
; de ciertos registros con los valores apropiados para este ejemplo (vector 
; de 8 elementos)

; reversed_vector = ()
; vector = (3, -7, 125, 421, -9, 1000, 7, 8)
; size = len(vector)
; for i=0; i<size; i++:
;     reversed_vector[i]=vector[size-1-i]

; [RV] = reversed
; [V] = vector original
mov R1, 8 ; size
mov R2, 0 ; i
mov R3, 0 ; i*4
dec R1 ; size-1
for:
    cmp R2, R1
    jge endfor
    mov R3, R2 ; valor actual de i
    mul R3, 4 ; def. i: posición de memoria exacta del contenido de vector_invertido a modificar
    mov R4, R1 ; (size-1)
    sub R4, R2 ; (size-1)-i del vector a invertir
    mul R4, 4 ; def. w: posición de memoria exacta del contenido del vector a invertir
    mov R5, [V+R4] ; contenido del vector a invertir
    mov [RV+R3], R5 ; vector_invertido[i] = vector[w]
    inc R2
endfor:

