MOV R1, 36 ; 9 * 4 = 36. lleva el puntero i, comienza con el último elemento: 9
MOV R2, M ; R2 es la posición de memoria del vector M
ADD R2, 396 ; 40 * 9 = 360 + 44. Aquí lo llevan a M[9][9]

DO:	 	
    CMP 0, [TARGET+R1] ; compara con cero el valor de target actual
    JE CONT ; si es igual a cero, se salta las siguientes lineas
    MOV R3, R2 ; le trasladamos el valor de M[R2] a R3.
    ADD R3, R3 ;  R3 = R3+R3 = 2 * R3
    MOV [TARGET+R1], R3 ; guardamos el valor de M[R2]*2 de la diagonal actual
CONT:	
    SUB R2, 44 ; aquí variamos la posición de memoria de R2. Va de 44 en 44 para ir por la diagonal
    SUB R1, 4 ; resta 4 la posición R1 porque va de 4 en 4
    CMP R1, 0 ; por esta comparación con cero sospecho que resta
    JG DO ; si no es igual a cero, continuamos en el loop, en caso contrario: END
END: