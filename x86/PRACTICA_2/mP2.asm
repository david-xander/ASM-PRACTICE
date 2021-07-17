section .data               
;Cambiar Nombre y Apellido por vuestros datos.
developer db "DAVID DELGADO",0

;Constantes que también están definidas en C.
ROWDIM  equ 4       ;files de la matriu.
COLDIM  equ 5       ;columnes de la matriu.

section .text            

;Variables definidas en Ensamblador.
global developer  

;Subrutinas de ensamblador que se llaman desde C.
global posCurScreenP2, showDigitsP2, updateBoardP2,
global moveCursorP2, openCardP2, checkPairsP2
global playP2

;Variables definidas en C.
extern mCards, mOpenCards

;Funciones de C que se llaman desde ensamblador.
extern clearScreen_C, printBoardP2_C, gotoxyP2_C, getchP2_C, printchP2_C
extern printMessageP2_C


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ATENCIÓN: Recordad que en ensamblador las variables y los parámetros 
;;   de tipo 'char' se tienen que asignar a registros de tipo
;;   BYTE (1 byte): al, ah, bl, bh, cl, ch, dl, dh, sil, dil, ..., r15b
;;   las de tipo 'short' se tiene que assignar a registros de tipo 
;;   WORD (2 bytes): ax, bx, cx, dx, si, di, ...., r15w
;;   las de tipo 'int' se tiene que assignar a registros de tipo  
;;   DWORD (4 bytes): eax, ebx, ecx, edx, esi, edi, ...., r15d
;;   las de tipo 'long' se tiene que assignar a registros de tipo 
;;   QWORD (8 bytes): rax, rbx, rcx, rdx, rsi, rdi, ...., r15
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Les subrutinas en ensamblador que hay que modificar para 
;; implementar el paso de parámetros son:
;;   posCurScreenP2, showDigitsP2, updateBoardP2,
;;   moveCursorP2, openCardP2.
;; La subrutina nueva que hay que implementar es:
;;   checkPairsP2.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Esta subrutina se da hecha. NO LA PODEIS MODIFICAR.
; Situar el cursor en una fila y una columna de la pantalla
; en función de la fila (edi) y de la columna (esi) recibidos como 
; parámetro llamando a la función gotoxyP2_C.
; 
; Variables globales utilizadas:   
; Ninguna
; 
; Parámetros de entrada: 
; (rowScreen): rdi(edi): Fila
; (colScreen): rsi(esi): Columna;
; 
; Parámetros de salida : 
; Ninguno
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
gotoxyP2:
   push rbp
   mov  rbp, rsp
   ;guardamos el estado de los registros del procesador porque
   ;las funciones de C no mantienen el estado de los registros.
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15

   ; Cuando llamamos a la función gotoxyP2_C(int rowScreen, int colScreen) 
   ; desde ensamblador el primer parámetro (rowScreen) se tiene que 
   ; pasar por el registro rdi(edi), y el segundo  parámetro (colScreen)
   ; se tiene que pasar por el registro rsi(esi).
   call gotoxyP2_C
 
   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax

   mov rsp, rbp
   pop rbp
   ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Esta subrutina se da hecha. NO LA PODEIS MODIFICAR.
; Mostrar un carácter (dil) en pantalla, recibido como parámetro, 
; en la posición donde está el cursor llamando a la función printchP2_C.
; 
; Variables globales utilizadas:   
; Ninguna
; 
; Parámetros de entrada: 
; (c): rdi(dil): carácter que queremos mostrar
; 
; Parámetros de salida : 
; Ninguno
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printchP2:
   push rbp
   mov  rbp, rsp
   ;guardamos el estado de los registros del procesador porque
   ;las funciones de C no mantienen el estado de los registros.
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15

   ; Cuando llamamos a la función printchP2_C(char c) desde ensamblador, 
   ; el parámetro (c) se tiene que pasar por el registro rdi(dil).
   call printchP2_C
 
   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax

   mov rsp, rbp
   pop rbp
   ret
   

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Esta subrutina se da hecha. NO LA PODEIS MODIFICAR.
; Leer una tecla y retornar el carácter asociado (al) sin
; mostrarlo en pantalla, llamando a la función getchP2_C
; 
; Variables globales utilizadas:   
; Ninguna
; 
; Parámetros de entrada: 
; Ninguno
; 
; Parámetros de salida : 
; (c): rax(al): carácter que leemos de teclado
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
getchP2:
   push rbp
   mov  rbp, rsp
   ;guardamos el estado de los registros del procesador porque
   ;las funciones de C no mantienen el estado de los registros.
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15
   push rbp

   mov rax, 0
   ; llamamos a la función getchP2_C(char c) desde ensamblador, 
   ; retorna sobre el registro rax(al) el carácter leído.
   call getchP2_C
 
   pop rbp
   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   
   mov rsp, rbp
   pop rbp
   ret 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Posicionar el cursor en pantalla, dentro del tablero, en función de
; la posición del cursor dentro de la matriz, indicada por la variable 
; (pos), recibida como parámetro, de tipo int(DWORD)4bytes, a partir 
; de la posición [10,12] de la pantalla.
; Para calcular la posición del cursor en pantalla (rowScreen) y 
; (colScreen) utilizar estas fórmulas:
; rScreen=10+(pos/COLDIM)*2)
; cScreen=12+(pos%COLDIM)*4)
; Para posicionar el cursor en pantalla se tiene que llamar a la 
; subrutina gotoxyP2.
; 
; Variables globales utilizadas:   
; Ninguna.
; 
; Parámetros de entrada: 
; (pos): rdi(edi): Posición del cursor dentro de la matriz.
; 
; Parámetros de salida : 
; Ninguno.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
posCurScreenP2:
   push rbp
   mov  rbp, rsp
   
push rax
push rbx
push rcx
push rdx         
push rsi
push rdi
push r8
push r9
push r10 

;rowScreen=10+((pos/COLDIM)*2);
;eax el cociente de la división
;edx el residuo
mov edx, 0
mov eax, edi
mov ecx, COLDIM
div ecx 
;muevo el valor del residuo para no perderlo en la mult.
mov ecx, edx
;
mov ebx, 2
mul ebx
adc eax, 10
mov rdi, 0
mov edi, eax

;colScreen=12+((pos%COLDIM)*4);
mov eax, ecx
mov ebx, 4
mul ebx
adc eax, 12
mov rsi, 0
mov esi, eax


;  * (rScreen): rdi(edi): Fila de la pantalla donde posicionamos el cursor.
;  * (cScreen): rsi(esi): Columna de la pantalla donde posicionamos el cursor.
;  * (val)    : rdx(dx) : Valor que queremos mostrar.

call gotoxyP2_C  

pop r10
pop r9
pop r8
pop rdi
pop rsi
pop rdx
pop rcx
pop rbx
pop rax   
   
   mov rsp, rbp
   pop rbp
   ret



;;;;;
; Convierte un valor (val) de tipo short(WORD)2bytes (entre 0 y 99)
; en 2 caracteres ASCII que representen este valor. (27 -> '2' '7').
; Hay que dividir el valor entre 10, el cociente representará las 
; decenas y el residuo las unidades, y después hay que convertir a ASCII
; sumando '0' o 48(código ASCII de '0') a las unidades y a las decenas.
; Mostrar los dígitos (carácter ASCII) a partir de la fila indicada
; por la variable (rScreen) y en la columna indicada por la variable
; (cScreen).
; Para posicionar el cursor hay que llamar a la subrutina gotoxyP2 y 
; para mostrar los caracteres a la subrutina printchP2.
; 
; Variables globales utilizadas:   
; Ninguna.
; 
; Parámetros de entrada: 
; (rScreen): rdi(edi): Fila de la pantalla donde posicionamos el cursor.
; (cScreen): rsi(esi): Columna de la pantalla donde posicionamos el cursor.
; (val)    : rdx(dx) : Valor que queremos mostrar.
; 
; Parámetros de salida : 
; Ninguno.
;;;;;
showDigitsP2:
   push rbp
   mov  rbp, rsp
   
push rax
push rbx
push rcx
push rdx         
push rsi
push rdi
push r8
push r9
push r10  

;  * (rScreen): rdi(edi): Fila de la pantalla donde posicionamos el cursor.
;  * (cScreen): rsi(esi): Columna de la pantalla donde posicionamos el cursor.
;  * (val)    : rdx(dx) : Valor que queremos mostrar.

mov rax, rdx

; Decenas
mov dx, 0
mov cx, 10
div cx
adc ax, 48

; guardamos en la pila antes de call y recuperamos posteriormente
push rax
push rdx
push rdi
push rsi
;  * Parámetros de entrada: 
;  * (moves): rdi(di): Intentos que quedan.
;  * (pairs): rsi(si): Parejas que faltan por hacer.
call gotoxyP2_C
pop rsi
pop rdi
pop rdx
pop rax

push rax
push rdx
push rdi
push rsi
mov rdi, rax
;  * Parámetros de entrada: 
;  * (c): rdi(dil): Carácter que queremos mostrar.
call printchP2_C
pop rsi
pop rdi
pop rdx
pop rax

; Unidades
adc dx, 48
mov ax, si ;ax, WORD[colScreen]
inc ax
mov si, ax

push rax
push rdx
push rdi
push rsi
;  * Parámetros de entrada: 
;  * (moves): rdi(di): Intentos que quedan.
;  * (pairs): rsi(si): Parejas que faltan por hacer.
call gotoxyP2_C
pop rsi
pop rdi
pop rdx
pop rax

push rax
push rdx
push rdi
push rsi
mov rdi, rdx
;  * Parámetros de entrada: 
;  * (c): rdi(dil): Carácter que queremos mostrar.
call printchP2_C
pop rsi
pop rdi
pop rdx
pop rax


pop r10
pop r9
pop r8
pop rdi
pop rsi
pop rdx
pop rcx
pop rbx
pop rax   
   
   mov rsp, rbp
   pop rbp
   ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Mostrar los valores de la matriz (mOpenCards) dentro del tablero, 
; en las posiciones correspondientes, los intentos que quedan (moves) 
; y las parejas que faltan por hacer (pairs), recibidos como parámetro. 
; Se tiene que recorrer toda la matriz (mOpenCards), de izquierda a 
; derecha y de arriba a bajo, cada posición es de tipo char(BYTE)1byte, 
; y para cada elemento de la matriz hacer:
; Posicionar el cursor en el tablero en función de las variables 
; (rScreen) fila y (cScreen) columna llamando a la subrutina gotoxyP2.
; Les variables (rScreen) y (cScreen) se inicializan a 10 y 14
; respectivamente, que es la posición en pantalla de la casilla [0][0].
; Mostrar los caracteres de cada posición de la matriz (mOpenCards) 
; llamando a la subrutina printchP2.
; Después, mostrar los intentos que quedan (moves) de tipo short(WORD)2bytes, 
; a partir de la posición [19,15] de la pantalla y mostrar les parejas
; que faltan por hacer (pairs) de tipo short(WORD)2bytes, a partir de la 
; posición [19,24] de la pantalla llamando a la subrutina showDigitsP2.
; 
; Variables globales utilizadas:	
; (mOpenCards): Matriz donde guardamos las tarjetas del juego.
; 
; Parámetros de entrada: 
; (moves): rdi(di): Intentos que quedan.
; (pairs): rsi(si): Parejas que faltan por hacer.
; 
; Parámetros de salida : 
; Ninguno.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
updateBoardP2:
   push rbp
   mov  rbp, rsp
   
push rax
push rbx
push rcx
push rdx         
push rsi
push rdi
push r8
push r9
push r10  


mov r10, 10 ;WORD[rowScreen], 10
mov ebx, 0 ; i=0 (loop)
forrow:
    mov r11, 12 ;WORD[colScreen], 12
    mov ecx, 0 ; w=0 (loop)
    forcol:
        push r10
        push r11
        push rbx
        push rcx
        push rdi
        push rsi
        mov rdi, r10
        mov rsi, r11
        ;  * Parámetros de entrada: 
        ;  * (rowScreen): rdi(edi): Fila
        ;  * (colScreen): rsi(esi): Columna          
        call gotoxyP2_C
        pop rsi
        pop rdi        
        pop rcx
        pop rbx
        pop r11
        pop r10

        ; fila: calculamos puntero-matriz de la fila numeroFila * coldim
        mov eax, ebx
        mov r8d, COLDIM
        mul r8d

        ; columna
        adc eax, ecx

        ; charac = mOpenCards[i][j];
        mov al, BYTE[mOpenCards+eax]
        mov r12, rax
        
        push r10
        push r11        
        push rax
        push rbx
        push rcx
        push rdi
        push rsi
        mov rdi, r12
        ;  * Parámetros de entrada: 
        ;  * (c): rdi(dil): Carácter que queremos mostrar.
        call printchP2_C
        pop rsi
        pop rdi
        pop rcx
        pop rbx
        pop rax
        pop r11
        pop r10

        ; colScreen+=4
        adc r11, 4
        ; w++
        inc ecx
        ; if w<COLDIM (loop)
        cmp ecx, COLDIM
        jl forcol
    forcoldone:
        ; rowScreen+=2
        adc r10, 2
        ; i++
        inc ebx
        ; if i<ROWDIM (loop)
        cmp ebx, ROWDIM
        jl forrow

forrowdone:


push rax
push rdx
push rdi
push rsi
mov rdx, rdi
mov rdi, 19
mov rsi, 15
;  * (rScreen): rdi(edi): Fila de la pantalla donde posicionamos el cursor.
;  * (cScreen): rsi(esi): Columna de la pantalla donde posicionamos el cursor.
;  * (val)    : rdx(dx) : Valor que queremos mostrar.
call showDigitsP2
pop rsi
pop rdi
pop rdx
pop rax


push rax
push rdx
push rdi
push rsi
mov rdx, rsi
mov rdi, 19
mov rsi, 24
;  * (rScreen): rdi(edi): Fila de la pantalla donde posicionamos el cursor.
;  * (cScreen): rsi(esi): Columna de la pantalla donde posicionamos el cursor.
;  * (val)    : rdx(dx) : Valor que queremos mostrar.
call showDigitsP2  
pop rsi
pop rdi
pop rdx
pop rax  
   
pop r10
pop r9
pop r8
pop rdi
pop rsi
pop rdx
pop rcx
pop rbx
pop rax   
   
   mov rsp, rbp
   pop rbp
   ret


;;;;;  
; Actualizar la posición del cursor dentro la matriz indicada por la 
; variable (pos), de tipo int(DWORD)4bytes, recibida como parámetro, 
; en función de la tecla pulsada (c), de tipo char(BYTE)1byte, 
; recibida como a parámetro, (i: arriba, j:izquierda, k:abajo l:derecha).
; Comprobar que no salimos de la matriz, (pos) sólo puede tomar valores
; de posiciones dentro de la matriz [0 : (ROWDIM*COLDIM)-1].
; Para comprobarlo hay que calcular la fila y columna dentro de la matriz:
; fila    = pos / COLDIM, que puede tomar valores [0 : (ROWDIM-1)].
; columna = pos % COLDIM, que puede tomar valores [0 : (COLDIM-1)].
; Para cambiar de fila sumamos o restamos COLDIM a (pos) y para cambiar de 
; columna sumamos o restamos 1 a (pos) porque cada posición de la matriz 
; es de tipo char(BYTE)1byte y tiene ROWDIM filas y COLDIM columnas.
; Si el movimiento sale de la matriz, no hacer el movimiento.
; Retornar la posición del cursor (pos) actualizada.
; 
; NO se tiene que posicionar el cursor, se hace en posCurScreenP2.
; 
; Variables globales utilizadas:	
; Ninguna.
; 
; Parámetros de entrada: 
; (c)  : rdi(dil): Carácter leído de teclado.
; (pos): rsi(esi): Posición del cursor dentro de la matriz.
; 
; Parámetros de salida : 
; (pos): rax(eax): Posición del cursor dentro de la matriz.
;;;;;
moveCursorP2:  
   push rbp
   mov  rbp, rsp

push rbx
push rcx
push rdx         
push rsi
push rdi
push r8
push r9
push r10  

mov edx, 0
mov rax, rsi
mov ebx, COLDIM
div ebx

switchCharac:
    mov rcx, rdi
    switchCaseArriba:
        cmp cx, 105 ; I
        jg switchCaseIzquierda

        ; if (i > 0) pos=pos-COLDIM
        cmp eax, 0
        jle switchEnd
        mov rax, rsi
        sub eax, COLDIM
        mov rsi, rax
        jmp switchEnd
    switchCaseIzquierda:
        cmp cx, 106 ; J
        jg switchCaseAbajo

        ; if (j > 0) pos=pos-1
        cmp edx, 0
        jle switchEnd
        mov rax, rsi
        dec eax
        mov rsi, rax
        jmp switchEnd
    switchCaseAbajo:
        cmp cx, 107 ; K
        jg switchCaseDerecha

        ; if (i < (ROWDIM-1)) pos=pos+COLDIM
        mov ebx, ROWDIM
        dec ebx
        cmp eax, ebx
        jge switchEnd
        mov rax, rsi
        adc eax, COLDIM
        dec eax ; COLDIM - 1
        mov rsi, rax
        jmp switchEnd
    switchCaseDerecha:
        cmp cx, 108 ; L
        jg switchEnd
        
        ; if (j < (COLDIM-1)) pos=pos+1
        mov ebx, COLDIM
        dec ebx
        cmp edx, ebx
        jge switchEnd
        mov rax, rsi
        inc eax
        mov rsi, rax
    switchEnd:

; return rsi <-rax
mov rax, rsi
;;;;;;;;;  

pop r10
pop r9
pop r8
pop rdi
pop rsi
pop rdx
pop rcx
pop rbx   
         
   mov rsp, rbp
   pop rbp
   ret


;;;;;  
; Abrir la tarjeta de la matriz (mCards) de la posición del
; cursor dentro de la matriz indicada por la variable (pos), recibida 
; como parámetro.
; Guardar la posición de la tarjeta que estamos abriendo y que tenemos en
; la variable (pos) de tipo int(DWORD)4bytes en el vector (vPos), recibida
; como parámetro, de tipo int(DWORD)4bytes, donde en la posición [0] es 
; para guardar la posición de la 1a tarjeta que volteamos (cuando status=0)
; y en la posición [1] es para guardar la posición de la 2a tarjeta que
; volteamos (cuando status=1), la variable (status) recibida como parámetro.
; vPos[0]:[vPos+0]: posición de la 1a tarjeta. 
; vPos[1]:[vPos+4]: posición de la 2a tarjeta.
; Si la tarjeta no está volteada (!='x') ponerla en la matriz 
; (mOpenCards) para que se muestre.
; Marcarla con una 'x'(minúscula) en la misma posición de la matriz 
; (mCards) para saber que está volteada.
; Pasar al siguiente estado (status++) y devolver el estado actualizado.
; 
; NO hay que mostrar la matriz con los cambios, se hace en updateBoardP2().
; 
; Variables globales utilizadas:
; (mCards)    : Matriz donde guardamos las tarjetas del juego.
; (mOpenCards): Matriz donde tenemos las tarjetas abiertas del juego.
; 
; Paràmetres d'entrada:
; (pos)   : rdi(edi): Posición del cursor dentro de la matriz.
; (status): rsi(esi): Estado del juego.
; (vPos)  : rdx(rdx): Dirección del vector con las posiciones de las tarjetas abiertas.
; 
; Parámetros de salida : 
; (status): rax(eax): Estado del juego.
;;;;;
openCardP2:  
   push rbp
   mov  rbp, rsp

push rbx
push rcx
push rdx         
push rsi
push rdi
push r8
push r9
push r10

; vPos[state] = pos

; mov rax, rdi ; pos
; mov rbx, rsi ; estado
; mov rcx, rbx
; imul rcx, 4 ; si state es cero será igual a cero | si es 1 será igual a 4
; mov [rdx+rcx], rax ; vPos(rdx)

mov eax, edi ; pos
mov ebx, esi ; estado
mov ecx, ebx
imul ecx, 4 ; si state es cero será igual a cero | si es 1 será igual a 4
mov [rdx+rcx], eax ; RARO RARO : NO PUEDE SER rdx _vPos(rdx)_ Segmentation fault cuando se cierra el juego


siTarjetaIgualX:
    ;if (mCards[i][j] != 'x')
    mov cl, BYTE[mCards+eax]
    cmp cl, 120 ; caracter 'x'=120
    je endSiTarjetaIgualX
    ; mOpenCards[i][j] = mCards[i][j];
    mov BYTE[mOpenCards+eax], cl
    ; mCards[i][j] = 'x';
    mov BYTE[mCards+eax], 120
    ; state++
    inc ebx
    mov rsi, rbx

endSiTarjetaIgualX:

; return rsi <- rax
mov rax, rsi
;;;;;; 

pop r10
pop r9
pop r8
pop rdi
pop rsi
pop rdx
pop rcx
pop rbx   
         
   mov rsp, rbp
   pop rbp
   ret


;;;;;  
; Comprobar si las dos tarjetas abiertas son iguales.
; Si les tarjetas son iguales cambiar al estado de 'hay pareja' (status=3).
; Si no son iguales volver a voltearlas. Para hacerlo hay que volver a poner
; los valores de les tarjetas que ahora tenemos en la matriz (mOpenCards), 
; en la matriz (mCards) y en la matriz (mOpenCards) poner una 'X'
; (mayúscula) para indicar que están cerradas. Cambiar al estado
; de 'no hay pareja' (status=4). Devolver el estado actualizado.
; El vector (vPos) de tipo int(DWORD)4bytes, recibido como parámetro,
; contiene las posiciones de las tarjetas abiertas.
; vPos[0]:[vPos+0]: posición de la 1a tarjeta.
; vPos[1]:[vPos+4]: posición de la 2a tarjeta.
; 
; Variables globales utilizadas:
; (mCards)    : Matriz donde guardamos las tarjetas del juego.
; (mOpenCards): Matriz donde tenemos les tarjetas abiertas del juego.
; 
; Paràmetres d'entrada:
; (vPos)  : rdi(rdi): Dirección del vector con las posiciones de las tarjetas abiertas.
; 
; Parámetros de salida : 
; (status): rax(eax): Estado del juego.
;;;;;  
checkPairsP2:
   push rbp
   mov  rbp, rsp

push rbx
push rcx
push rdx         
push rsi
push rdi
push r8
push r9
push r10


; BYTE[mOpenCards+eax]
mov eax, DWORD[rdi+0]
mov ebx, DWORD[rdi+4]

; if ( mOpenCards[pos+0][pos+0] == mOpenCards[pos+4][pos+4] )
mov cl, BYTE[mOpenCards+eax]
mov dl, BYTE[mOpenCards+ebx]
cmp cl, dl
je hayPareja
noHayPareja:
    ; mCards[i0][j0] = mOpenCards[i0][j0];
    mov r8b, BYTE[mOpenCards+eax]
    mov BYTE[mCards+eax], r8b
    ; mOpenCards[i0][j0] = 'X';
    mov BYTE[mOpenCards+eax], 120
    ; mCards[i1][j1] = mOpenCards[i1][j1];
    mov r8b, BYTE[mOpenCards+ebx]
    mov BYTE[mCards+ebx], r8b
    ; mOpenCards[i1][j1] = 'X';
    mov BYTE[mOpenCards+ebx], 120
    mov rax, 4 ; status no hay pareja
    jmp end
hayPareja:
    mov rax, 3 ; status hay pareja
end:

pop r10
pop r9
pop r8
pop rdi
pop rsi
pop rdx
pop rcx
pop rbx   
   
   mov rsp, rbp
   pop rbp
   ret   


;;;;;
; Aquesta subrutina es dóna feta. NO LA PODEU MODIFICAR.
; Mostrar un mensaje debajo del tablero llamando a la función printMessageP2_C(status)
; según el valor de la variable (status), recibida como parámetro:
;          0: 0 tarjetas abiertas.
;          1: 1 targeta abierta.
;          2: 2 tarjetas abiertas.
;          3: Hay pareja.
;          4: No hay pareja.
;          5: Salir, hemos pulsado la tecla 'ESC' para salir.
;          6: Gana, todas las parejas hechas.
;          7: Pierde, se han terminado los intentos.
; Si (status>1) pedir que se pulse una tecla para poderlo leer.
;  
; Variables globales utilizadas:	
; Ninguna.
; 
; Parámetros de entrada: 
; (status): rdi(edi): Estado del juego.
; 
; Parámetros de salida : 
; Ninguno.
;;;;;
printMessageP2:
   push rbp
   mov  rbp, rsp
   ;guardamos el estado de los registros del procesador porque
   ;las funciones de C no mantienen el estado de los registros.
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15

   ; Llamamos a la función printMessageP2_C(status) desde ensamblador.
   ; el parámetro (status) hay que pasarlo a través del registro rdi(edi).
   call printMessageP2_C
 
   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax

   mov rsp, rbp
   pop rbp
   ret


;;;;;
; Juego del Memory
; Función principal del juego.
; Encontrar todas las parejas del tablero (10 parejas), volteando las
; tarjetas de dos en dos. Como máximo se pueden hacer 15 intentos.
; 
; Pseudo-código:
; Inicializar el estado del juego, (state=0).
; Borrar la pantalla  (llamar a la función clearScreen_C).
; Mostrar el tablero de juego (llamar a la función printBoardP2_C).
; Actualizar el tablero de juego, el valor de los intentos que quedan 
; (moves) y de las parejas que faltan por hacer (pairs) llamando a la 
; subrutina updateBoardP2.
; Mientras (state<3) hacer:
;   Mostrar un mensaje,  según el valor de la variable (state),
;   para indicar que hay que hacer, llamando a la subrutina printMessageP2.
;   Actualizar la posición del cursor en pantalla a partir de la 
;   variable (pos) con la posición del cursor dentro de la matriz, 
;   llamando a la subrutina posCurScreenP2.
;   Leer una tecla, llamar  la subrutina getchP2. 
;   Según la tecla leida llamaremos a las subrutinas que correspondan.
;     - ['i','j','k' o 'l'] desplazar el cursor según la dirección 
;       escogida, llamando a la subrutina moveCursorP2).
;     - '<SPACE>'(codi ASCII 32) voltear la tarjeta donde hay el cursor
;       llamando a la subrutina openCardP2.
;       Actualizar el tablero de juego, los valores de los intentos que
;       quedan (moves) y de las parejas que quedan por hacer (pairs) 
;       llamando a la subrutina updateBoardP2.
;       Si se han volteado dos tarjetas (state>1) decrementar los 
;       intentos que quedan (moves).
;       Verificar si las dos tarjetas que se han volteado son iguales
;       llamando a la subrutina checkPairsP2.
;       Si son iguales (state==3) decrementar las parejas que quedan por hacer (pairs).
;       Si no quedan intentos (moves==0), cambiar al estado 
;          de intentos agotados (state=7). 
;       Si se han hecho todas las parejas (pairs==0), cambiar al estado
;          de juego ganado (state=6).
;       Mostrar un mensaje,  según el valor de la variable (state),
;       para indicar que ha pasado, llamando a la subrutina printMessageP2. 
;       Si no hay que salir (state<5) poner (state=0) para volver a 
;       intentar hacer una nueva pareja.
;       Actualizar el tablero de juego, los valores de los intentos que
;       quedan (moves) y de las parejas que quedan por hacer (pairs) 
;       llamando a la subrutina updateBoardP2.
;    - '<ESC>'  (codi ASCII 27) poner (state = 5) para salir.
;       No saldrá si sólo se ha volteado una tarjeta (state!=1).
; Fin mientras.
; Salir: Se acaba el juego.
;  
; Variables globales utilizadas:	
; Ninguna.
; 
; Parámetros de entrada: 
; Ninguno.
; 
; Parámetros de salida : 
; Ninguno.
;;;;;  
playP2:
   push rbp
   mov  rbp, rsp
   
   call clearScreen_C    ;clearScreen_C
   call printBoardP2_C   ;printBoard2_C();
   
					;Declaración de variables locales.
   sub  rsp, 8      ;Reservamos espacio para el vector vPos.
                    
   push rax
   push rbx
   push rcx
   push rdx         
   push rsi
   push rdi
   push r8
   push r9
   push r10
     
   mov rbx, rbp     
   sub rbx, 8       ;vPos
      
   mov ecx, 0       ;state = 0;//Estado para empezar a jugar
   mov r8w, 15      ;moves = 15;
   mov r9w, (ROWDIM * COLDIM)/2 ;pairs = (ROWDIM * COLDIM)/2; 
   mov r10d, 8       ;pos = 8;

   mov di, r8w
   mov si, r9w
   call updateBoardP2  
   
   playP2_Loop:               ;while  {  //Bucle principal.
   cmp  ecx, 3                ;(state < 3)
   jge  playP2_End
      
      mov  edi, ecx
      call printMessageP2     ;printMessageP2_C(state);
      
      mov  edi, r10d
      call posCurScreenP2     ;posCurScreenP2_C(pos); 

      call getchP2            ;al = charac = getchP2_C();   

      cmp al, 'i'             ;if (charac>='i'
      jl  playP2_TurnUp
      cmp al, 'l'             ;&& charac<='l') {
      jg  playP2_TurnUp
         mov dil, al
         mov esi, r10d
         call moveCursorP2    ;pos = moveCursorP2_C(charac, pos);
         mov r10d, eax
         jmp playP2_EndLoop
      playP2_TurnUp:
      cmp al, 32              ;else if (charac==32) {
      jne playP2_Esc
         mov  edi, r10d
         mov  esi, ecx
         mov  rdx, rbx 
         call openCardP2      ;state = openCardP2_C(pos, state, vPos);
         mov  ecx, eax
         mov  di, r8w
         mov  si, r9w
         call updateBoardP2   ;updateBoardP2_C(moves, pairs);
         
         cmp ecx, 1           ;if (state > 1) {
         jle playP2_EndLoop
			dec r8d           ;moves--;
			mov rdi, rbx
			call checkPairsP2 ;state = checkPairsP2_C(vPos);
			mov ecx, eax
			cmp ecx, 3        ;if (state == 3) 
			jne playP2_Moves
			   dec r9w        ;pairs--;
			playP2_Moves:
            cmp r8w, 0        ;if (moves == 0) 
            jne playP2_Pairs
               mov ecx, 7     ;state = 7;
            playP2_Pairs:
            cmp r9w, 0        ;if (pairs == 0) 
            jne playP2_Message
               mov ecx, 6     ;state = 6;
            playP2_Message:
            mov edi, ecx
			call printMessageP2;printMessageP2_C(state);
            cmp ecx, 5        ;if (state < 5) 
            jge playP2_UpdateBoard
               mov ecx, 0     ;state = 0;
            playP2_UpdateBoard:
			mov di, r8w
            mov si, r9w
            call updateBoardP2;updateBoardP2_C(moves, pairs);
            jmp playP2_EndLoop
      playP2_Esc:
      cmp al, 27              ;if ( (charac==27) 
      jne playP2_EndLoop
      cmp ecx, 1              ;&& (state!=1) ) {
      je  playP2_EndLoop
         mov ecx, 5          ;state = 5;
      playP2_EndLoop:
   jmp playP2_Loop
   
   playP2_End:
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax  
   
   mov rsp, rbp
   pop rbp
   ret
