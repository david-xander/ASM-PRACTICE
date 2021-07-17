/**
 * Implementación en C de la práctica, para que tengáis una
 * versión funcional en alto nivel de todas les funciones que tenéis 
 * que implementar en ensamblador.
 * Desde este código se hacen las llamadas a les subrutinas de ensamblador. 
 * ESTA CÓDIGO NO SE PUEDE MODIFICAR Y HAY QUE ENTREGARLO
 * */

#include <stdlib.h>
#include <stdio.h>
#include <termios.h>     //termios, TCSANOW, ECHO, ICANON
#include <unistd.h>      //STDIN_FILENO

/**
 * Constantes
 */
#define ROWDIM  4        //filas de la matriz
#define COLDIM  5        //columnas de la matriz

extern int developer;   //Variable declarada en ensamblador que indica el nombre del programador

/**
 * Definición de variables globales
 */
// Matriz 4x5 con las tarjetas del juego.
char mCards[ROWDIM][COLDIM] = { 
	               {'0','0','#','1','1'},
                   {'S','@','O','E','$'},
                   {'S','@','O','E','$'},
                   {'2','2','#','3','3'} };  

// Matriz 4x5 con las tarjetas abiertas.       
char mOpenCards[ROWDIM][COLDIM] = { 
	               {'X','X','X','X','X'},
                   {'X','X','X','X','X'},
                   {'X','X','X','X','X'},
                   {'X','X','X','X','X'} };

/**
 * Definición de las funciones de C
 */
void clearscreen_C();
void gotoxyP2_C(int, int);
void printchP2_C(char);
char getchP2_C();

char printMenuP2_C();
void printBoardP2_C();

void posCurScreenP2_C(int);
void showDigitsP2_C(int, int, short);
void updateBoardP2_C(short, short);
int  moveCursorP2_C(char, int);
int  openCardP2_C(int, int, int[2]);
int  checkPairsP2_C(int[2]);

void printMessageP2_C(int);
void playP2_C();


/**
 * Definición de las subrutinas de ensamblador que es llaman desde C.
 */
void posCurScreenP2(int);
void showDigitsP2(int, int, short);
void updateBoardP2(short, short);
int  moveCursorP2(char, int);
int  openCardP2(int, int, int[2]);
int  checkPairsP2(int[2]);
void playP2();


/**
 * Borrar la pantalla
 * 
 * Variables globales utilizadas:   
 * Ninguna
 * 
 * Parámetros de entrada: 
 * Ninguno
 *   
 * Parámetros de salida : 
 * Ninguno
 * 
 * Esta función no es llama desde ensamblador
 * y no hay definida una subrutina de ensamblador equivalente.
 */
void clearScreen_C(){
   
    printf("\x1B[2J");
    
}


/**
 * Situar el cursor en una fila y una columna de la pantalla
 * en función de la fila (rowScreen) y de la columna (colScreen) 
 * recibidos como parámetro.
 * 
 * Variables globales utilizadas:   
 * Ninguna
 * 
 * Parámetros de entrada: 
 * (rowScreen): rdi(edi): Fila
 * (colScreen): rsi(esi): Columna
 * 
 * Parámetros de salida : 
 * Ninguno
 * 
 * Se ha definido un subrutina en ensamblador equivalente 'gotoxyP2' 
 * para poder llamar a esta función guardando el estado de los registros 
 * del procesador. Esto se hace porque las funciones de C no mantienen 
 * el estado de los registros.
 * El paso de parámetros es equivalente.
 */
void gotoxyP2_C(int rowScreen, int colScreen){
   
   printf("\x1B[%d;%dH",rowScreen,colScreen);
   
}


/**
 * Mostrar un carácter (c) en pantalla, recibido como parámetro, 
 * en la posición donde está el cursor.
 * 
 * Variables globales utilizadas:   
 * Ninguna
 * 
 * Parámetros de entrada: 
 * (c): rdi(dil): Carácter que queremos mostrar.
 * 
 * Parámetros de salida : 
 * Ninguno
 * 
 * Se ha definido un subrutina en ensamblador equivalente 'printchP2' 
 * para llamar a esta función guardando el estado de los registros del 
 * procesador. Esto se hace porque las funciones de C no mantienen 
 * el estado de los registros.
 * El paso de parámetros es equivalente.
 */
void printchP2_C(char c){
   
   printf("%c",c);
   
}


/**
 * Leer una tecla y retornar el carácter asociado 
 * sin mostrarlo en pantalla. 
 * 
 * Variables globales utilizadas:   
 * Ninguna
 * 
 * Parámetros de entrada: 
 * Ninguno
 * 
 * Parámetros de salida : 
 * (c): rax(al): Carácter que leemos de teclado
 * 
 * Se ha definido un subrutina en ensamblador equivalente 'getchP2' para
 * llamar a esta función guardando el estado de los registros del procesador.
 * Esto se hace porque las funciones de C no mantienen el estado de los 
 * registros.
 * El paso de parámetros es equivalente.
 */
char getchP2_C(){

   int c;   

   static struct termios oldt, newt;

   /*tcgetattr obtener los parámetros del terminal
   STDIN_FILENO indica que se escriban los parámetros de la entrada estándar (STDIN) sobre oldt*/
   tcgetattr( STDIN_FILENO, &oldt);
   /*se copian los parámetros*/
   newt = oldt;

    /* ~ICANON para tratar la entrada de teclado carácter a carácter no como línea entera acabada en /n
    ~ECHO para que no se muestre el carácter leído.*/
   newt.c_lflag &= ~(ICANON | ECHO);          

   /*Fijar los nuevos parámetros del terminal para la entrada estándar (STDIN)
   TCSANOW indica a tcsetattr que cambie los parámetros inmediatamente. */
   tcsetattr( STDIN_FILENO, TCSANOW, &newt);

   /*Leer un carácter*/
   c=getchar();                 
    
   /*restaurar los parámetros originales*/
   tcsetattr( STDIN_FILENO, TCSANOW, &oldt);

   /*Retornar el carácter leído*/
   return (char)c;
   
}


/**
 * Mostrar en pantalla el menú del juego y pedir una opción.
 * Sólo acepta una de las opciones correctas del menú ('0'-'9')
 * 
 * Variables globales utilizadas:   
 * developer:((char *)&developer): Variable definida en el código ensamblador.
 * 
 * Parámetros de entrada: 
 * Ninguno
 * 
 * Parámetros de salida : 
 * (charac): rax(al): Opción escogida del menú, leída de teclado.
 * 
 * Esta función no se llama desde ensamblador
 * y no hay definida una subrutina de ensamblador equivalente.
 */
char printMenuP2_C(){
	
   clearScreen_C();
   gotoxyP2_C(1,1);
   printf("                                 \n");
   printf("       P2 Developed by:          \n");
   printf("       ( %s )   \n",(char *)&developer);
   printf(" _______________________________ \n");
   printf("|                               |\n");
   printf("|           MAIN MENU           |\n");
   printf("|_______________________________|\n");
   printf("|                               |\n");
   printf("|        1. PosCurScreen        |\n");
   printf("|        2. ShowDigits          |\n");
   printf("|        3. UpdateBoard         |\n");
   printf("|        4. moveCursor          |\n");
   printf("|        5. OpenCard            |\n");
   printf("|        6. CheckPairs          |\n");
   printf("|        7. Play Game           |\n");
   printf("|        8. Play Game C         |\n");
   printf("|        0. Exit                |\n");
   printf("|_______________________________|\n");
   printf("|                               |\n");
   printf("|           OPTION:             |\n");
   printf("|_______________________________|\n"); 

   char charac =' ';
   while (charac < '0' || charac > '9') {
     gotoxyP2_C(20,21);          //Posicionar el cursor
     charac = getchP2_C();       //Leer una opción
   }
   return charac;
}


/**
 * Mostrar el tablero de juego en pantalla. Las líneas del tablero.
 * 
 * Variables globales utilizadas:   
 * Ninguna
 * 
 * Parámetros de entrada: 
 * Ninguno
 * 
 * Parámetros de salida : 
 * Ninguno
 * 
 * Esta función se llama des de C y desde ensamblador,
 * y no hay definida una subrutina de ensamblador equivalente.
 * No hay paso de parámetros.
 */
void printBoardP2_C(){

   gotoxyP2_C(1,1);                                     //Filas
                                                        //Tablero                                 
   printf(" _____________________________________ \n"); //01
   printf("|                                     |\n"); //02
   printf("|       M  E  M  O  R  Y   v_2.0      |\n"); //03
   printf("|                                     |\n"); //04
   printf("|  Choose 2 cards and turn them over. |\n"); //05
   printf("|    Try to match all the pairs!      |\n"); //06
   printf("|                                     |\n"); //07
 //Columnas Tablero  12  16  20  24  28         
   printf("|          0   1   2   3   4          |\n"); //08
   printf("|        +---+---+---+---+---+        |\n"); //09
   printf("|      0 |   |   |   |   |   |        |\n"); //10
   printf("|        +---+---+---+---+---+        |\n"); //11
   printf("|      1 |   |   |   |   |   |        |\n"); //12
   printf("|        +---+---+---+---+---+        |\n"); //13
   printf("|      2 |   |   |   |   |   |        |\n"); //14
   printf("|        +---+---+---+---+---+        |\n"); //15
   printf("|      3 |   |   |   |   |   |        |\n"); //16
   printf("|        +---+---+---+---+---+        |\n"); //17
  //Columnas dígitos     15       24                 
   printf("|           +----+   +----+           |\n"); //18
   printf("|     Moves |    |   |    | Pairs     |\n"); //19
   printf("|           +----+   +----+           |\n"); //20 
   printf("| (ESC) Exit        (Space) Turn Over |\n"); //21
   printf("| (i)Up    (j)Left  (k)Down  (l)Right |\n"); //22
   printf("|                                     |\n"); //23
   printf("| [                                 ] |\n"); //24
   printf("|_____________________________________|\n"); //25
                          
}


/**
 * Posicionar el cursor en pantalla, dentro del tablero, en función de
 * la posición del cursor dentro de la matriz, indicada por la variable 
 * (pos), recibida como parámetro, de tipo int(DWORD)4bytes, a partir 
 * de la posición [10,12] de la pantalla.
 * Para calcular la posición del cursor en pantalla (rowScreen) y 
 * (colScreen) utilizar estas fórmulas:
 * rScreen=10+(pos/COLDIM)*2)
 * cScreen=12+(pos%COLDIM)*4)
 * Para posicionar el cursor en pantalla se tiene que llamar a la 
 * función gotoxyP2_C.
 * 
 * Variables globales utilizadas:   
 * Ninguna.
 * 
 * Parámetros de entrada: 
 * (pos): rdi(edi): Posición del cursor dentro de la matriz.
 * 
 * Parámetros de salida : 
 * Ninguno.
 * 
 * Esta función no se llama desde ensamblador.
 * Hay una subrutina de ensamblador equivalente 'posCurScreenP2',  
 * el paso de parámetros es equivalente. 
 */
void posCurScreenP2_C(int pos) {

   int rScreen=10+((pos/COLDIM)*2);
   int cScreen=12+((pos%COLDIM)*4);
   gotoxyP2_C(rScreen, cScreen);
   
}


/**
 * Convierte un valor (val) de tipo short(WORD)2bytes (entre 0 y 99)
 * en 2 caracteres ASCII que representen este valor. (27 -> '2' '7').
 * Hay que dividir el valor entre 10, el cociente representará las 
 * decenas y el residuo las unidades, y después hay que convertir a ASCII
 * sumando '0' o 48(código ASCII de '0') a las unidades y a las decenas.
 * Mostrar los dígitos (carácter ASCII) a partir de la fila indicada
 * por la variable (rScreen) y en la columna indicada por la variable
 * (cScreen).
 * Para posicionar el cursor hay que llamar a la función gotoxyP2_C y 
 * para mostrar los caracteres a la función printchP2_C.
 * 
 * Variables globales utilizadas:   
 * Ninguna.
 * 
 * Parámetros de entrada: 
 * (rScreen): rdi(edi): Fila de la pantalla donde posicionamos el cursor.
 * (cScreen): rsi(esi): Columna de la pantalla donde posicionamos el cursor.
 * (val)    : rdx(dx) : Valor que queremos mostrar.
 * 
 * Parámetros de salida : 
 * Ninguno.
 * 
 * Esta función no se llama desde ensamblador.
 * Hay una subrutina de ensamblador equivalente 'showDigitsP2',
 * el paso de parámetros es equivalente.   
 */
 void showDigitsP2_C(int rScreen, int cScreen, short val) {
	
	char d, u;
	d = val / 10;      //Decenas
	d = d + '0';
    gotoxyP2_C(rScreen, cScreen);   
	printchP2_C(d);

	u = val % 10;      //Unidades
	u = u + '0';
    cScreen++;
	gotoxyP2_C(rScreen, cScreen);   
	printchP2_C(u);
	
}


/**
 * Mostrar los valores de la matriz (mOpenCards) dentro del tablero, 
 * en las posiciones correspondientes, los intentos que quedan
 * (moves) y las parejas que faltan por hacer (pairs), recibidos com paràmetro. 
 * Se tiene que recorrer toda la matriz (mOpenCards), de izquierda a 
 * derecha y de arriba a bajo, cada posición es de tipo char(BYTE)1byte, 
 * y para cada elemento de la matriz hacer:
 * Posicionar el cursor en el tablero en función de las variables 
 * (rScreen) fila y (cScreen) columna llamando a la función gotoxyP2_C.
 * Les variables (rScreen) y (cScreen) se inicializan a 10 y 14
 * respectivamente, que es la posición en pantalla de la casilla [0][0].
 * Mostrar los caracteres de cada posición de la matriz (mOpenCards) 
 * llamando a la función printchP2_C.
 * Después, mostrar los intentos que quedan (moves) de tipo short(WORD)2bytes, 
 * a partir de la posición [19,15] de la pantalla y mostrar les parejas
 * que faltan por hacer (pairs) de tipo short(WORD)2bytes, a partir de la 
 * posición [19,24] de la pantalla llamando a la función showDigitsP2_C.
 * 
 * Variables globales utilizadas:	
 * (mOpenCards): Matriz donde guardamos las tarjetas del juego.
 * 
 * Parámetros de entrada: 
 * (moves): rdi(di): Intentos que quedan.
 * (pairs): rsi(si): Parejas que faltan por hacer.
 * 
 * Parámetros de salida : 
 * Ninguno.
 * 
 * Esta función no se llama desde ensamblador.
 * Hay una subrutina de ensamblador equivalente 'updateBoardP2',
 * el paso de parámetros es equivalente.   
 */
void updateBoardP2_C(short moves, short pairs){
   
   int i,j;
   int c;
   int rScreen, cScreen;
   rScreen = 10;
   for (i=0;i<ROWDIM;i++){
	  cScreen = 12;
      for (j=0;j<COLDIM;j++){
         gotoxyP2_C(rScreen, cScreen);
         c = mOpenCards[i][j];
         printchP2_C(c);
         cScreen = cScreen + 4;
      }
      rScreen = rScreen + 2;
   }
   
   showDigitsP2_C(19, 15, moves);
   showDigitsP2_C(19, 24, pairs);
   
}


/**
 * Actualizar la posición del cursor dentro la matriz indicada por la 
 * variable (pos), de tipo int(DWORD)4bytes, recibida como parámetro, 
 * en función de la tecla pulsada (c), de tipo char(BYTE)1byte, 
 * recibida como a parámetro, (i: arriba, j:izquierda, k:abajo l:derecha).
 * Comprobar que no salimos de la matriz, (pos) sólo puede tomar valores
 * de posiciones dentro de la matriz [0 : (ROWDIM*COLDIM)-1].
 * Para comprobarlo hay que calcular la fila y columna dentro de la matriz:
 * fila    = pos / COLDIM, que puede tomar valores [0 : (ROWDIM-1)].
 * columna = pos % COLDIM, que puede tomar valores [0 : (COLDIM-1)].
 * Para cambiar de fila sumamos o restamos COLDIM a (pos) y para cambiar de 
 * columna sumamos o restamos 1 a (pos) porque cada posición de la matriz 
 * es de tipo char(BYTE)1byte y tiene ROWDIM filas y COLDIM columnas.
 * Si el movimiento sale de la matriz, no hacer el movimiento.
 * Retornar la posición del cursor (pos) actualizada.
 * 
 * NO se tiene que posicionar el cursor, se hace en posCurScreenP2_C.
 * 
 * Variables globales utilizadas:	
 * Ninguna.
 * 
 * Parámetros de entrada: 
 * (c)  : rdi(dil): Carácter leído de teclado.
 * (pos): rsi(esi): Posición del cursor dentro de la matriz.
 * 
 * Parámetros de salida : 
 * (pos): rax(eax): Posición del cursor dentro de la matriz.
 * 
 * Esta función no se llama desde ensamblador.
 * Hay una subrutina de ensamblador equivalente 'moveCursorP2',
 * el paso de parámetros es equivalente.   
 */
int moveCursorP2_C(char c, int pos){
 
   int i = pos / COLDIM;
   int j = pos % COLDIM;
 
   switch(c){
      case 'i': //arriba
         if (i > 0) pos=pos-COLDIM;
      break;
      case 'k': //abajo
         if (i < (ROWDIM-1)) pos=pos+COLDIM;
      break;
      case 'j': //izquierda
         if (j > 0) pos=pos-1;
      break;
      case 'l': //derecha
         if (j < (COLDIM-1)) pos=pos+1;
      break;
      
   }
   return pos;

}


/**
 * Abrir la tarjeta de la matriz (mCards) de la posición del
 * cursor dentro de la matriz indicada por la variable (pos), recibida 
 * como parámetro.
 * Guardar la posición de la tarjeta que estamos abriendo y que tenemos en
 * la variable (pos) de tipo int(DWORD)4bytes en el vector (vPos), recibida
 * como parámetro, de tipo int(DWORD)4bytes, donde en la posición [0] es 
 * para guardar la posición de la 1a tarjeta que volteamos (cuando status=0)
 * y en la posición [1] es para guardar la posición de la 2a tarjeta que
 * volteamos (cuando status=1), la variable (status) recibida como parámetro.
 * vPos[0]:[vPos+0]: posición de la 1a tarjeta. 
 * vPos[1]:[vPos+4]: posición de la 2a tarjeta.
 * Para acceder a la matriz en C hay que calcular la fila y la columna:
 * fila    = pos / COLDIM, que puede tomar valores [0 : (ROWDIM-1)].
 * columna = pos % COLDIM, que puede tomar valores [0 : (COLDIM-1)].
 * En ensamblador no es necesario hacer este cálculo.
 * Si la tarjeta no está volteada (!='x') ponerla en la matriz 
 * (mOpenCards) para que se muestre.
 * Marcarla con una 'x'(minúscula) en la misma posición de la matriz 
 * (mCards) para saber que está volteada.
 * Pasar al siguiente estado (status++) y devolver el estado actualizado.
 * 
 * NO hay que mostrar la matriz con los cambios, se hace en updateBoardP2_C().
 * 
 * Variables globales utilizadas:
 * (mCards)    : Matriz donde guardamos las tarjetas del juego.
 * (mOpenCards): Matriz donde tenemos las tarjetas abiertas del juego.
 * 
 * Paràmetres d'entrada:
 * (pos)   : rdi(edi): Posición del cursor dentro de la matriz.
 * (status): rsi(esi): Estado del juego.
 * (vPos)  : rdx(rdx): Dirección del vector con las posiciones de las tarjetas abiertas.
 * 
 * Parámetros de salida : 
 * (status): rax(eax): Estado del juego.
 * 
 * Esta función no se llama desde ensamblador.
 * Hay una subrutina de ensamblador equivalente 'openCardP2',
 * el paso de parámetros es equivalente.   
 */
int openCardP2_C(int pos, int status, int vPos[2]){

   int i = pos / COLDIM; // En ensamblador no es necesario
   int j = pos % COLDIM; // calcular la 'i' y la 'j'. Utilizamos 'pos'.
   
   vPos[status] = pos;
   
   if (mCards[i][j] != 'x') {
      mOpenCards[i][j] = mCards[i][j];
      mCards[i][j] = 'x';
      status++;
   }
   return status;
}


/**
 * Comprobar si las dos tarjetas abiertas son iguales.
 * Si les tarjetas son iguales cambiar al estado de 'hay pareja' (status=3).
 * Si no son iguales volver a voltearlas. Para hacerlo hay que volver a poner
 * los valores de les tarjetas que ahora tenemos en la matriz (mOpenCards), 
 * en la matriz (mCards) y en la matriz (mOpenCards) poner una 'X'
 * (mayúscula) para indicar que están cerradas. Cambiar al estado
 * de 'no hay pareja' (status=4). Devolver el estado actualizado.
 * El vector (vPos) de tipo int(DWORD)4bytes, recibido como parámetro,
 * contiene las posiciones de las tarjetas abiertas.
 * vPos[0]:[vPos+0]: posición de la 1a tarjeta.
 * vPos[1]:[vPos+4]: posición de la 2a tarjeta.
 * Para acceder a la matriz en C hay que calcular la fila y la columna:
 * fila    = pos / COLDIM, que puede tomar valores [0 : (ROWDIM-1)].
 * columna = pos % COLDIM, que puede tomar valores [0 : (COLDIM-1)].
 * En ensamblador no es necesario hacer este cálculo.
 * 
 * Variables globales utilizadas:
 * (mCards)    : Matriz donde guardamos las tarjetas del juego.
 * (mOpenCards): Matriz donde tenemos les tarjetas abiertas del juego.
 * 
 * Paràmetres d'entrada:
 * (vPos)  : rdi(rdi): Dirección del vector con las posiciones de las tarjetas abiertas.
 * 
 * Parámetros de salida : 
 * (status): rax(eax): Estado del juego.
 * 
 * Esta función no se llama desde ensamblador.
 * Hay una subrutina de ensamblador equivalente 'checkPairsP2',
 * el paso de parámetros es equivalente
 */
int checkPairsP2_C(int vPos[2]){

   char aux;
   int status;
   
   int i0 = vPos[0] / COLDIM; // En ensamblador no es necesario
   int j0 = vPos[0] % COLDIM; // calcular la 'i' y la 'j'. 
   int i1 = vPos[1] / COLDIM; // Utilizamos directamente 'pos'.
   int j1 = vPos[1] % COLDIM; //
   
   if ( mOpenCards[i0][j0] == mOpenCards[i1][j1] ) {
      status = 3; //Hay pareja
   } else {       //Voltear tarjetas
	  mCards[i0][j0]     = mOpenCards[i0][j0];
      mOpenCards[i0][j0] = 'X';
      mCards[i1][j1]     = mOpenCards[i1][j1];
      mOpenCards[i1][j1] = 'X';
      status = 4; //No hay pareja
   }
   return status;
}


/**
 * Mostrar un mensaje debajo del tablero según el valor de la variable 
 * (status), recibida como parámetro:
 *          0: 0 tarjetas abiertas.
 *          1: 1 targeta abierta.
 *          2: 2 tarjetas abiertas.
 *          3: Hay pareja.
 *          4: No hay pareja.
 *          5: Salir, hemos pulsado la tecla 'ESC' para salir.
 *          6: Gana, todas las parejas hechas.
 *          7: Pierde, se han terminado los intentos.
 * Si (status>1) pedir que se pulse una tecla para poderlo leer.
 *  
 * Variables globales utilizadas:	
 * Ninguna.
 * 
 * Parámetros de entrada: 
 * (status): rdi(edi): Estado del juego.
 * 
 * Parámetros de salida : 
 * Ninguno.
 *  
 * Se ha definido un subrutina en ensamblador equivalente 'printMessageP2' 
 * para llamar a esta función guardando el estado de los registros del 
 * procesador. Esto se hace porque las funciones de C no mantienen 
 * el estado de los registros.
 * El paso de parámetros es equivalente 
 */
void printMessageP2_C(int status) {

   gotoxyP2_C(24,4);
   switch(status){
	  case 0:
         printf("...  Turn Over FIRST card !!! ...");
      break;
      case 1:
         printf("...  Turn Over SECOND card!!! ...");
      break; 
      case 3:
         printf("PERFECT! New pair. Press any key.");
      break;
      case 4:
         printf("Ooooh! Not a pair. Press any key.");
      break; 
      case 5:
         printf("<<<<<< EXIT: (ESC) Pressed >>>>>>");
      break;
      case 6:
         printf("FINISH. You WIN! Congratulations.");
      break; 
      case 7:
         printf("GAME OVER. Oh! Not more attempts.");
      break;
   }
   if (status > 1) getchP2_C();     
}


/**
 * Juego del Memory
 * Función principal del juego.
 * Encontrar todas las parejas del tablero (10 parejas), volteando las
 * tarjetas de dos en dos. Como máximo se pueden hacer 15 intentos.
 * 
 * Pseudo-código:
 * Inicializar el estado del juego, (state=0).
 * Borrar la pantalla  (llamar a la función clearScreen_C).
 * Mostrar el tablero de juego (llamar a la función printBoardP2_C).
 * Actualizar el tablero de juego, el valor de los intentos que quedan 
 * (moves) y de las parejas que faltan por hacer (pairs) llamando a la 
 * función updateBoardP2_C.
 * Mientras (state<3) hacer:
 *   Mostrar un mensaje,  según el valor de la variable (state),
 *   para indicar que hay que hacer, llamando a la función printMessageP2_C.
 *   Actualizar la posición del cursor en pantalla a partir de la 
 *   variable (pos) con la posición del cursor dentro de la matriz, 
 *   llamando a la función posCurScreenP2_C.
 *   Leer una tecla, llamar  la función getchP2_C. 
 *   Según la tecla leida llamaremos a las subrutinas que correspondan.
 *     - ['i','j','k' o 'l'] desplazar el cursor según la dirección 
 *       escogida, llamando a la función moveCursorP2_C).
 *     - '<SPACE>'(codi ASCII 32) voltear la tarjeta donde hay el cursor
 *       llamando a la función openCardP2_C.
 *       Actualizar el tablero de juego, los valores de los intentos que
 *       quedan (moves) y las parejas que faltan por hacer (pairs) llamando 
 *       a la función updateBoardP2_C.
 *       Si se han volteado dos tarjetas (state>1) decrementar los 
 *       intentos que quedan (moves).
 *       Verificar si las dos tarjetas que se han volteado son iguales
 *       llamando a la función checkPairsP2_C.
 *       Si son iguales (state==3) decrementar las parejas que faltan
 *       por hacer(pairs).
 *       Si no quedan intentos (moves==0), cambiar al estado 
 *          de intentos agotados (state=7). 
 *       Si se han hecho todas las parejas (pairs==0), cambiar al estado
 *          de juego ganado (state=6).
 *       Mostrar un mensaje,  según el valor de la variable (state),
 *       para indicar que ha pasado, llamando a la función printMessageP2_C. 
 *       Si no hay que salir (state<5) poner (state=0) para volver a 
 *       intentar hacer una nueva pareja.
 *       Actualizar el tablero de juego, los valores de los intentos que
 *       quedan (moves) y las parejas que faltan por hacer (pairs) llamando 
 *       a la función updateBoardP2_C.
 *    - '<ESC>'  (codi ASCII 27) poner (state = 5) para salir.
 *       No saldrá si sólo se ha volteado una tarjeta (state!=1).
 * Fin mientras.
 * Salir: Se acaba el juego.
 *  
 * Variables globales utilizadas:	
 * Ninguna.
 * 
 * Parámetros de entrada: 
 * Ninguno.
 * 
 * Parámetros de salida : 
 * Ninguno.
 * 
 * Esta función no se llama desde ensamblador.
 * Hay una subrutina de ensamblador equivalente 'playP1' para llamar
 * las subrutinas del juego definidas en ensamblador (posCurScreenP2, 
 * showDigitsP2, updateBoardP2, moveCursorP2, openCardP2, checkPairsP2).
 */
void playP2_C(){

   int state;       //0: 0 tarjetas abiertas.
                    //1: 1 tarjeta abierta.
                    //2: 2 tarjetas abiertas.
                    //3: Hay pareja.
                    //4: No hay pareja.
                    //5: Salir, hemos pulsado la tecla 'ESC' para salir.
                    //6: Gana, todas las parejas hechas.
                    //7: Pierde, se han terminado los intentos.
   int pos;         //Posición del cursor dentro de la matriz mCards y mOpenCards
                    //(4x5) Pos [0 : (ROWDIM * COLDIM)-1 = 19].
	                //Fila    = (pos / COLDIM) [0 : (ROWDIM-1)=3]
                    //Columna = (pos % COLDIM) [0 : (COLDIM-1)=4]                 
   short moves;     //Intentos que quedan.
   short pairs;     //Parejas que faltan por hacer.
   char  charac;    //Carácter leido de teclado y para escribir en pantalla.
   
                    //Vector de 2 posiciones donde guardaremos la posición
                    //dentro de la matriz de les tarjetas abiertas.
   int vPos[2];     // vPos[0]:[vPos+0]: posición de la 1a tarjeta abierta.
                    // vPos[1]:[vPos+4]: posición de la 2a tarjeta abierta.


   state = 0;       //Estado para empezar a jugar.
   moves = 15;      //Intentos que se pueden hacer.
   pairs = (ROWDIM * COLDIM)/2;//(5*4)/2=10://Parejas que hay que hacer.
   pos = 8;         //Posición inicial del cursor dentro de la matriz.
                    //Fila    = (8 / COLDIM) = 1
                    //Columna = (8 % COLDIM) = 3
   
   
   clearScreen_C();
   printBoardP2_C();
   updateBoardP2_C(moves, pairs);
   
   while (state < 3) {        //Bucle principal.
	  printMessageP2_C(state);
      posCurScreenP2_C(pos);     
      charac = getchP2_C();   
   
      if (charac>='i' && charac<='l') {
         pos = moveCursorP2_C(charac, pos);
      }
      else if (charac==32) {
         state = openCardP2_C(pos, state, vPos);
         updateBoardP2_C(moves, pairs);
         
         if (state > 1) {
			moves--;
			state = checkPairsP2_C(vPos);
			if (state == 3) pairs--;
            if (moves == 0) state = 7;
			if (pairs == 0) state = 6;
			printMessageP2_C(state);
            if (state < 5) state = 0;
            updateBoardP2_C(moves, pairs);
         }
      }  
      else if ( (charac==27) && (state!=1) ) {
         state = 5;
      }
   }
   
}


/**
 * Programa Principal
 * 
 * ATENCIÓN: Podéis probar la funcionalidad de las subrutinas que hay que
 * desarrollar sacando los comentarios de la llamada a la función 
 * equivalente implementada en C que hay debajo de cada opción.
 * Para el juego completo hay una opción para la versión en ensamblador
 * y una opción para el juego en C.
*/
int main(void){
   
   int   op=0;
   int   state = 0;    
   int   pos   = 11;
   int   moves = 15;
   int   pairs = 10;
   char  charac;
   int   vPos[2];
   
   while (op!='0') {
      clearScreen_C();
      op = printMenuP2_C();    //Mostrar menú y pedir opción
      switch(op){
          case '1': //Posicionar el cursor en pantalla, dentro del tablero.
            printf(" %c",op);
            clearScreen_C();    
            printBoardP2_C();   
            gotoxyP2_C(26,12);
            printf(" Press any key ");
            pos = 11;
            //=======================================================        
              posCurScreenP2(pos);
              //posCurScreenP2_C(pos);
            //=======================================================
            getchP2_C();
         break;    //Convierte un valor (entre 0 y 99) en 2 dos caracteres ASCII
         case '2': //y muestra los dígitos en pantalla. 
            printf(" %c",op);
            clearScreen_C();    
            printBoardP2_C();
            int   rowScreen = 19;
            int   colScreen = 15;
            short value     = 99;
            //=======================================================        
              showDigitsP2(rowScreen, colScreen, value);
              //showDigitsP2_C(rowScreen, colScreen, value);
            //=======================================================
            gotoxyP2_C(26,12);
            printf(" Press any key ");
            getchP2_C();
         break;
         case '3': //Actualizar el contenido del tablero.
            clearScreen_C();       
            printBoardP2_C();
            moves =  9;
            pairs = 10;      
            //=======================================================
              updateBoardP2(moves, pairs);
              //updateBoardP2_C(moves, pairs);
            //=======================================================
            gotoxyP2_C(26,12);
            printf(" Press any key ");
            getchP2_C();
         break;
         case '4': //Actualizar la posición del cursor en el tablero.  
            clearScreen_C();
            printBoardP2_C();
            updateBoardP2_C(moves, pairs);
            gotoxyP2_C(26,12);
            printf(" Press i,j,k,l ");
            pos = 17;
            posCurScreenP2_C(pos);
            charac = getchP2_C();   
            if (charac>='i' && charac<='l') {
			//=======================================================
              pos = moveCursorP2(charac, pos);
              //pos = moveCursorP2_C(charac, pos);  
            //=======================================================
            }
            gotoxyP2_C(26,12);
            printf(" Press any key ");
            posCurScreenP2_C(pos);
            getchP2_C();
         break;
         case '5': ////Abrir una tarjeta donde está el cursor.
            clearScreen_C();
            printBoardP2_C();
            gotoxyP2_C(26,12);
            printf("Press <space> ");
            updateBoardP2_C(moves, pairs);
            pos = 19;
            posCurScreenP2_C(pos);
            state = 0;
            charac = getchP2_C(); 
            if (charac>=' ') {
			//=======================================================
              state = openCardP2(pos, state, vPos);
              //state = openCardP2_C(pos, state, vPos);
            //=======================================================
            }
            updateBoardP2_C(moves, pairs);
            printMessageP2_C(state);
            gotoxyP2_C(26,12);
            printf(" Press any key ");
            getchP2_C();
         break;
         case '6': //Comprobar si las dos tarjetas abiertas son iguales
            clearScreen_C();
            printBoardP2_C();
            state = 0;
            pos = 7;
            state = openCardP2_C(pos, state, vPos);
            printMessageP2_C(state);
            pos = 11;//Si es vol fer una parella posar 12
            state = openCardP2_C(pos, state, vPos);
            gotoxyP2_C(26,12);
            printf("Press <space> ");
            updateBoardP2_C(moves, pairs);
            posCurScreenP2_C(pos);
            charac = getchP2_C(); 
            if (charac>=' ') {
			//=======================================================
			  state = checkPairsP2(vPos);
              //state = checkPairsP2_C(vPos);;
            //=======================================================
            }
            updateBoardP2_C(moves, pairs);
            printMessageP2_C(state);
         break;
         case '7': //Juego completo en Ensamblador.
            //=======================================================
              playP2();
            //=======================================================
         break;
         case '8': //Juego completo en C.
            //=======================================================
            playP2_C();
            //=======================================================
         break;
     }
   }
   printf("\n\n");
   
   return 0;
   
}
