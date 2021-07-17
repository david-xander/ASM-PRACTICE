section .data               
;Cambiar Nombre i Apellido por vuestros datos.
developer db "DAVID DELGADO",0

;Constantes que también están definidas en C.
ROWDIM  equ 4       ;filas de la matriz.
COLDIM  equ 5       ;columnas de la matriz.

section .text            

;Variables definidas en Ensamblador.
global developer  

;Subrutinas de ensamblador que se llaman desde C.
global posCurScreenP1, showDigitsP1, updateBoardP1,
global calcIndexP1, moveCursorP1, openCardP1
global playP1

;Variables definidas en C.
extern charac, rowScreen, colScreen, value, state
extern pos, moves, pairs, vPos, mCards, mOpenCards 

;Funciones de C que es llaman desde ensamblador
extern clearScreen_C, gotoxyP1_C, getchP1_C, printchP1_C
extern printBoardP1_C, printMessageP1_C


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ATENCIÓN: 
;; Recuerde que en ensamblador las variables y los parámetros
;; de tipo 'char' se asignarán a registros de tipo
;; BYTE (1 byte): el, ah, bl, bh, cl, ch, dl, dh, sil, lun, ..., r15b
;; las de tipo 'short' se asignarán a registros de tipo
;; WORD (2 bytes): ax, bx, cx, dx, si, di, ...., r15w
;; las de tipo 'int' se asignarán a registros de tipo
;; DWORD (4 bytes): eax, EBX, ECX, edx, ESI, edi, ...., r15d
;; las de tipo 'long' se asignarán a registros de tipo
;; QWORD (8 bytes): rax, RBX, RCX, RDX, rsi, RDI, ...., r15
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Las subrutinas en ensamblador que tenéis que implementar son:
;;   posCurScreenP1, showDigitsP1, updateBoardP1,
;;   moveCursorP1, openCardP1.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Esta subrutina se da hecha. NO LA PODÉIS MODIFICAR.
; Situar el cursor en una fila indicada por la variable (rowScreen) y 
; en la columna indicada por la variable (colScreen) de la pantalla
; llamando a la función gotoxyP1_C.
; 
; Variables globales utilizadas:	
; (rowScreen): Fila de la pantalla donde posicionamos el cursor.
; (colScreen): Columna de la pantalla donde posicionamos el cursor.; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
gotoxyP1:
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

   call gotoxyP1_C
 
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
; Esta subrutina se da hecha. NO LA PODÉIS MODIFICAR.
; Mostrar un carácter guardado en la variable (charac) en pantalla, en
; la posición donde está el cursor llamando a la función printchP1_C.
; 
; Variables globales utilizadas:	
; (charac): Carácter que queremos mostrar.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printchP1:
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

   call printchP1_C
 
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
; Esta subrutina se da hecha. NO LA PODÉIS MODIFICAR.
; Leer una tecla y guardar el carácter asociado en la variable (charac) 
; sin mostrarlo en pantalla, llamando a la función getchP1_C
; 
; Variables globales utilizadas:	
; (charac): Carácter que queremos mostrar.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
getchP1:
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
   push rbp

   call getchP1_C
 
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
   pop rax
   
   mov rsp, rbp
   pop rbp
   ret 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; PPosicionar el cursor en la pantalla,dentro el tablero, en función de la
; posición del cursor dentro la matriz, indicada por la variable (pos) 
; de tipo int(DWORD)4 bytes, a partir de la posición [10,12] de la pantalla.
; Para calcular la posición del cursor a pantalla (rowScreen) y 
; (colScreen) utilizar estas fórmulas:
; rScreen=10+(pos/COLDIM)*2)
; cScreen=12+(pos%COLDIM)*4)
; Para posicionar el cursor en la pantalla se tiene que llamar a la 
; subrutina gotoxyP1.
; 
; Variables globales utilizadas:   
; (pos)      : Posición del cursor dentro de la matriz.
; (rowScreen): Fila donde queremos posicionar el cursor en la pantalla.
; (colScreen): Columna donde queremos posicionar el cursor en la pantalla.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
posCurScreenP1:

   push rbp
   mov  rbp, rsp
   
;rowScreen=10+((pos/COLDIM)*2);
;eax el cociente de la división
;edx el residuo
mov edx, 0
mov eax, DWORD[pos]
mov ecx, COLDIM
div ecx 
;muevo el valor del residuo para no perderlo en la mult.
mov ecx, edx
;
mov ebx, 2
mul ebx
adc eax, 10
mov DWORD[rowScreen], eax

;colScreen=12+((pos%COLDIM)*4);
mov eax, ecx
mov ebx, 4
mul ebx
adc eax, 12
mov DWORD[colScreen], eax

;gotoxyP1_C();
call gotoxyP1_C

   
   mov rsp, rbp
   pop rbp
   ret



;;;;;
; Convierte un valor (value) de tipo int(4 bytes) (entre 0 y 99) en  
; dos caracteres ASCII que representan este valor. (27 -> '2' '7').
; Se tiene que dividir el valor entre 10, el cociente representará las 
; decenas y el resto las unidades, y después se tiene que convertir a ASCII
; sumando '0' o 48(código ASCII de '0') a las unidades y a les decenas.
; Muestra los dígitos (carácter ASCII) a partir de la fila indicada
; para la variable (rowScreen) y a la columna indicada para la variable
; (colScreen).
; Para posicionar el cursor se llama a la función gotoxyP1 y para 
; mostrar los caracteres ala función printchP1.
; 
; Variables globales utilizadas:	
; (rowScreen): Fila de la pantalla donde posicionamos el cursor.
; (colScreen): Columna de la pantalla donde posicionamos el cursor.
; (charac)   : Carácter que leemos de teclado.
; (value)    : Valor que queremos mostrar.
;;;;;
showDigitsP1:
   push rbp
   mov  rbp, rsp

; Decenas
mov dx, 0
mov ax, 0
mov ax, WORD[value]
mov cx, 10
div cx
adc ax, 48
mov WORD[charac], ax
mov ax, dx

; guardamos en la pila antes de call y recuperamos posteriormente
push rax
push rdx
call gotoxyP1_C
call printchP1_C
pop rdx
pop rax

; Unidades
adc dx, 48
mov WORD[charac], dx
mov ax, WORD[colScreen]
inc ax
mov WORD[colScreen], ax
call gotoxyP1_C
call printchP1_C

   
   mov rsp, rbp
   pop rbp
   ret


;;;;;
; Mostrar los valores de la matriz (mOpenCards) dentro el tablero, en
; las posiciones correspondientes, los intentos que quedan (moves) y 
; de las parejas que faltan por hacer (pairs). 
; Se tiene que recorrer toda la matriz (mOpenCards), de izquierda a 
; derecha y de arriba a bajo, cada posición es de tipo char(BYTE)1byte, 
; y para cada elemento de la matriz hacer:
; Posicionar el cursor en el tablero en función de las variables 
; (rowScreen) fila y (colScreen) columna llamando a la función gotoxyP1.
; Las variables (rowScreen) y (colScreen) se inicializaran a 10 y 14
; respectivamente, que es la posición en pantalla de la casilla [0][0].
; Mostrar los caracteres de cada posición de la matriz (mOpenCards) 
; llamando la función printchP1.
; Después, mostrar los intentos que quedan (moves) de tipo short(WORD)2bytes, 
; a partir de la posición [19,15] de la pantalla y mostrar las parejas
; que faltan hacer (pairs) de tshort(WORD)2bytes, a partir de la 
; posición [19,24] de la pantalla llamando la función showDigitsP1.
; 
; Variables globales utilizadas:		
; rowScreen  : Fila donde queremos posicionar el cursor a la pantalla.
; colScreen  : Columna donde queremos posicionar el cursor a la pantalla.
; mOpenCards : Matriz donde guardamos las tarjetas del juego.
; charac     : Carácter donde queremos mostrar.
; value      : Valor que queremos mostrar.
; moves      : Intentos que quedan.
; pairs      : Parejas que faltan por hacer.
;;;;;;
updateBoardP1:
   push rbp
   mov  rbp, rsp


mov WORD[rowScreen], 10
mov ebx, 0 ; i=0 (loop)
forrow:
    mov WORD[colScreen], 12
    mov ecx, 0 ; w=0 (loop)
    forcol:
        push rbx
        push rcx    
        call gotoxyP1_C
        pop rcx
        pop rbx

        ; fila: calculamos puntero-matriz de la fila numeroFila * coldim
        mov eax, ebx
        mov r8d, COLDIM
        mul r8d

        ; columna
        adc eax, ecx

        ; charac = mOpenCards[i][j];
        mov al, BYTE[mOpenCards+eax]
        mov WORD[charac], ax
        ;mov WORD[charac], 97 ; prueba de contenido con caracter 'a'
        
        push rax
        push rbx
        push rcx
        call printchP1_C
        pop rcx
        pop rbx
        pop rax

        ; colScreen+=4
        mov ax, WORD[colScreen]
        adc ax, 4
        mov WORD[colScreen], ax

        ; w++
        inc ecx
        ; if w<COLDIM (loop)
        cmp ecx, COLDIM
        jl forcol
    forcoldone:
        ; rowScreen+=2
        mov ax, WORD[rowScreen]
        adc ax, 2
        mov WORD[rowScreen], ax


        inc ebx
        cmp ebx, ROWDIM
        jl forrow

forrowdone:

mov WORD[rowScreen], 19
mov WORD[colScreen], 15
mov ax, WORD[moves]
mov WORD[value], ax

call showDigitsP1

mov WORD[colScreen], 24
mov ax, WORD[pairs]
mov WORD[value], ax

call showDigitsP1

   
   
   mov rsp, rbp
   pop rbp
   ret


;;;;;  
; Actualizar la posición del cursor dentro la matriz actualizando la 
; variable(pos), de tipo int(DWORD)4bytes, en función de la tecla 
; pulsada que tenemos a la variable (charac) de tipo char(BYTE)1byte,
; (i: arriba, j:izquierda, k:abajo, l:derecha).
; Comprobar que no salimos de la matriz, (pos) sólo pued tomar de 
; de posiciones de dentro de la matriz [0 : (ROWDIM*COLDIM)-1].
; Para comprobarlo hay que calcular la fila y columna dentro de la matriz:
; fila    = pos / COLDIM, que puede tomar valores [0 : (ROWDIM-1)].
; columna = pos % COLDIM, que puede tomar valores [0 : (COLDIM-1)].
; Para cambiar de fila sumamos o restamos COLDIM a (pos) y para cambiar de 
; columna sumamos o restamos 1 a (pos) porque cada posición de la matriz
; es de tipo char(BYTE)1byte y tiene ROWDIM filas y COLDIM columnas.
; Si el movimiento sale de la matriz, no hacer el movimiento.
; NO se tiene que posicionar el cursor en pantalla llamando posCurScreenP1.
; 
; Variables globales utilizadas:	
; (charac): Carácter que leemos del teclado.
; (pos)   : Posición del cursor dentro de la matriz.
;;;;;
moveCursorP1:  
   push rbp
   mov  rbp, rsp


mov edx, 0
mov eax, DWORD[pos]
mov ebx, COLDIM
div ebx

switchCharac:
    mov cx, WORD[charac]
    switchCaseArriba:
        cmp cx, 105 ; I
        jg switchCaseIzquierda

        ; if (i > 0) pos=pos-COLDIM
        cmp eax, 0
        jle switchEnd
        mov eax, DWORD[pos]
        sub eax, COLDIM
        mov DWORD[pos], eax
        jmp switchEnd
    switchCaseIzquierda:
        cmp cx, 106 ; J
        jg switchCaseAbajo

        ; if (j > 0) pos=pos-1
        cmp edx, 0
        jle switchEnd
        mov eax, DWORD[pos]
        dec eax
        mov DWORD[pos], eax
        jmp switchEnd
    switchCaseAbajo:
        cmp cx, 107 ; K
        jg switchCaseDerecha

        ; if (i < (ROWDIM-1)) pos=pos+COLDIM
        mov ebx, ROWDIM
        dec ebx
        cmp eax, ebx
        jge switchEnd
        mov eax, DWORD[pos]
        adc eax, COLDIM
        dec eax ; COLDIM - 1
        mov DWORD[pos], eax
        jmp switchEnd
    switchCaseDerecha:
        cmp cx, 108 ; L
        jg switchEnd
        
        ; if (j < (COLDIM-1)) pos=pos+1
        mov ebx, COLDIM
        dec ebx
        cmp edx, ebx
        jge switchEnd
        mov eax, DWORD[pos]
        inc eax
        mov DWORD[pos], eax
    switchEnd:

;;;;;;;;;    


   mov rsp, rbp
   pop rbp
   ret


;;;;;  
; Abrir la tarjeta de la matriz (mCards) de la posición indicada por el
; cursor dentro de la matriz indicada por la variable (pos).
; Guardar la posición de la tarjeta que estamos abriendo y que tenemos 
; en la variable (pos) de tipo int(DWORD)4bytes en el vector (vPos), de 
; tipo int(DWORD)4bytes, donde en la posición [0] es para guardar la 
; posición de la 1a tarjeta que giramos (cuando state=0) y la posición 
; [1] es para guardar la posición de la 2a tarjeta que giramos (cuando
; state=1).
; vPos[0]:[vPos+0]: Posición de la 1a tarjeta. 
; vPos[1]:[vPos+4]: Posición de la 2a tarjeta.
; Para acceder a la matriz en C hay que calcular la fila y la columna:
; fila    = pos / COLDIM, que pot prendre valors [0 : (ROWDIM-1)].
; columna = pos % COLDIM, que pot prendre valors [0 : (COLDIM-1)].
; En ensamblador no es necesario.
; Si la targeta no está girada (!='x') ponerla en la matriz 
; (mOpenCards) para que se muestre.
; Marcarla con una 'x'(minúscula) en la misma posición de la matriz 
; (mCards) para saber que está volteada.
; Pasar al siguiente estado (state++).
; 
; NO se tiene que mostrar la matriz con los cambios, es fa a updateBoardP1.
; 
; Variables globales utilizadas:
; (mCards)    : Matriz donde guardamos las tarjetas del juego.
; (mOpenCards): Matriz donde tenemos las tarjetas abiertas del juego.
; (pos)       : Posición del cursor dentro de la matriz.
; (state)     : Estado del juego.
; (vPos)      : Dirección del vector con lass posiciones de las tarjetas abiertas.
;;;;;
openCardP1:  
   push rbp
   mov  rbp, rsp

   
; vPos[state] = pos
mov eax, DWORD[pos]
mov ebx, DWORD[state]
mov ecx, ebx
imul ecx, 4
mov DWORD[vPos+ebx], eax

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
    mov DWORD[state], ebx

endSiTarjetaIgualX:

;;;;;;

   mov rsp, rbp
   pop rbp
   ret


;;;;;
; Esta subrutina se da hecha. NO LA PODÉIS MODIFICAR.
; Muestra un mensaje debajo del tablero según el valor de la variable
; (state) llamando la función printMessageP1_C.
; (state) 0: 0 tarjetas abiertas.
;         1: 1 Tarjeta abierta.
;         2: 2 Tarjetas abiertas.
;         5: Salir, hemos pulsado la tecla 'ESC' para salir.
;         7: Pierdes, se han terminado los intentos.
; Si (state>1) pedir que se pulse una tecla para poderlo leer.
;         
; Variables globales utilizadas:	
; (rowScreen): Fila de la pantalla donde posicionamos el cursor.
; (colScreen): Columna de la pantalla donde posicionamos el cursor.
; (state)    : Estado del juego.
;;;;;
printMessageP1:
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
   push rbp

   call printMessageP1_C
 
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
   pop rax

   mov rsp, rbp
   pop rbp
   ret

;;;;;
; Juego del Memory
; subrutina principal del juego.
; Encontrar todas las parejas el tablero (10 parejas), volteando las
; tarjetas de dos en dos. Como máximo se pueden hacer 15 intentos.
; 
; Pseudo-código:
; Inicializar el estado del juego, (state=0).
; Borrar la pantalla  (llamar a la función clearScreen_C).
; Mostrar el tablero de juego (llamar a la función printBoardP1_C).
; Actualizar el tablero de juego y los valores de los intentos que 
; quedan (moves) y de las parejas que faltan por hacer (pairs) llamando
; a la subrutina updateBoardP1.
; Mientras (state<3) hacer:
;   Mostrar un mensaje,  según el valor de la variable (state),
;   para indicar que se tiene que hacer, llamando a la subrutina printMessageP1.
;   Actualizar la posición del cursor a la pantalla a partir del vector
;   ([rowcol]) (fila (rowcol[0]) y la columna (rowcol[1])) con la posición
;   del cursor dentro la matriz, llamando la subrutina posCurScreenP1.
;   Leer una tecla, llamando a la subrutina getchP1. 
;   Según la tecla leída llamaremos a las subrutinas que correspondan.
;     - ['i','j','k' o 'l'] desplazar el cursor según la dirección 
;       escogida, llamando a la fsubrutina moveCursorP1).
;     - '<SPACE>'(codi ASCII 32) voltearla tarjeta donde haya el cursor
;       llamando a la subrutina openCardP1.
;       [No se comprueba que se hagan parejas].
;       Si se han volteado dos tarjetas (state>1) poner (state=0) y
;          decrementar los movimientos que quedan (moves).
;          Si no quedan movimientos (moves==0), cambiar al estado de 
;             movimientos agotados (state=7).
;          Mostrar un mensaje,  según el valor de la variable (state)
;          para indicar que ha pasado, llamando a la función printMessageP2. 
;       Actualizar el tablero de juego, los valores de los intentos 
;       que quedan (moves) y de las parejas que faltan hacer (pairs) 
;       llamando a la subrutina updateBoardP1.
;    - '<ESC>'  (codi ASCII 27) poner (state = 5) para salir.
;       No saldrá si sólo se ha volteado una tarjeta (state!=1).
; Fin mientras.
; Salir: Se termina el juego.
; 
; Variables globales utilizadas:	
; (state) : Indica el estado del juego. 0:salir, 1:jugar.
; (charac): Carácter que leemos de teclado.
; (moves) : Intentos que quedan.
; (pairs) : Parejas que quedan por hacer.
;;;;;  
playP1:
   push rbp
   mov  rbp, rsp
   
   push rax
   
   mov DWORD[state], 0        ;state = 0;
   mov WORD[moves], 10        ;moves = 10;
   mov WORD[pairs], (ROWDIM * COLDIM)/2 ;pairs = (ROWDIM * COLDIM)/2;
   mov DWORD[pos], 8          ;pos = 8;
   
   call clearScreen_C
   call printBoardP1_C        ;printBoard1_C();
     
   call updateBoardP1

   playP1_Loop:               ;while  {  //Bucle principal.
   cmp  DWORD[state], 3       ;(state < 3)
   jge  playP1_End
      
      call printMessageP1     ;printMessageP1_C();
      call posCurScreenP1     ;posCurScreenP1_C();     
      call getchP1            ;charac = getchP1_C();   
      mov  al, BYTE[charac]
      
      playP2_ijkl:
      cmp al, 'i'             ;if (charac>='i' {
      jl  playP1_TurnUp
      cmp al, 'l'             ;&& charac<='l') 
      jg  playP1_TurnUp
         call moveCursorP1    ;moveCursorP1_C();
         jmp playP1_EndLoop
      playP1_TurnUp:
      cmp al, 32              ;if (charac==32) {
      jne playP1_Esc
         call openCardP1      ;state = openCardP1_C();
         cmp DWORD[state], 1       ;if (state > 1) {
         jle playP1_Update
			mov DWORD[state], 0    ;state = 0;
			dec WORD[moves]        ;moves--;
			cmp WORD[moves], 0     ;if (moves == 0) 
			jne playP1_EndIf
			   mov DWORD[state], 7 ;state = 7;
			playP1_EndIf:
			call printMessageP1    ;printMessageP1_C();
         playP1_Update:
         call updateBoardP1   ;updateBoardP1_C();
         jmp playP1_EndLoop
      playP1_Esc:
      cmp al, 27              ;if ( (charac==27)
      jne playP1_EndLoop
      cmp DWORD[state], 1     ;&& (state!=1) ) {
      je  playP1_EndLoop
         mov DWORD[state], 5  ;state = 5;
      playP1_EndLoop:
   jmp playP1_Loop
   
   playP1_End:
   pop rax  
   
   mov rsp, rbp
   pop rbp
   ret
