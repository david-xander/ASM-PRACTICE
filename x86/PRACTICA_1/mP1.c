/**
 * Implementación en C de la práctica, para que tengáis una
 * versión funcional en alto nivel de todas les funciones que tenéis 
 * que implementar en ensamblador.
 * Desde este código se hacen las llamadas a les subrutinas de ensamblador. 
 * ESTE CÓDIGO NO SE PUEDE MODIFICAR Y NO HAY QUE ENTREGARLO.
 * */
 
#include <stdio.h>
#include <termios.h>    //termios, TCSANOW, ECHO, ICANON
#include <unistd.h>     //STDIN_FILENO

/**
 * Constantes
 */
#define ROWDIM  4        //filas de la matriz
#define COLDIM  5        //columnas de la matriz

extern int developer;//Variable declarada en ensamblador con el nombre del programador

/**
 * Definición de variables globales
 */
char  charac;    //Carácter leído de teclado y para escribir en pantalla.
int   rowScreen; //Fila donde queremos posicionar el cursor en pantalla.
int   colScreen; //Columna donde queremos posicionar el cursor en pantalla.
short value;     //Valor que convertimos a carácter
                  
int   state;     // 0: 0 Tarjetas abiertas.
                 // 1: 1 Tarjeta abierta.
                 // 2: 2 Tarjetas abiertas.               
                 // 5: Salimos, hemos pulsado la tecla 'ESC' para salir.
                 // 7: Pierdes, se han agotado los intentos.
int   pos;       //Posición del cursor dentro de la matriz mCards y mOpenCards
                 //(4x5) Pos [0 : (ROWDIM * COLDIM)-1 = 19].
                 //Fila    = (pos / COLDIM) [0 : (ROWDIM-1)=3]
                 //Columna = (pos % COLDIM) [0 : (COLDIM-1)=4]                 
short moves;     //Intentos que quedan.
short pairs;     //Parejas que faltan por hacer.
  
                 //Vector de 2 posiciones donde guardaremos la posición
                 //dentro de la matriz de las tarjetas abiertas.
int  vPos[2];    // vPos[0]:[vPos+0]: posición de la 1a tarjeta abierta.
                 // vPos[1]:[vPos+4]: posición de la 2a tarjeta abierta.
                 
// Matriz 4x5 con las tarjetas del juego.
char mCards[ROWDIM][COLDIM]     = { 
	              {'0','1','2','3','4'},
                  {'S','@','O','#','$'},
                  {'S','#','O','@','$'},
                  {'4','3','2','1','0'} };  

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
void gotoxyP1_C();
void printchP1_C();
void getchP1_C();

void printMenuP1_C();
void printBoardP1_C();

void posCurScreenP1_C();
void showDigitsP1_C();
void updateBoardP1_C();
void moveCursorP1_C();
void openCardP1_C();

void printMessageP1_C();
void playP1_C();


/**
 * Definición de las subrutinas de ensamblador que se llaman des de C.
 */
void posCurScreenP1();
void showDigitsP1();
void updateBoardP1();
void moveCursorP1();
void calcIndexP1();
void openCardP1();
void checkPairsP1_C();
void playP1();


/**
 * Borrar la pantalla
 * 
 * Variables globales utilizadas:	
 * Ninguna.
 * 
 * Esta función no es llama desde ensamblador
 * y no hay definida una subrutina de ensamblador equivalente.
 */
void clearScreen_C(){
	
    printf("\x1B[2J");
    
}


/**
 * Situar el cursor en una fila indicada por la variable (rowScreen) y 
 * en la columna indicada por la variable (colScreen) de la pantalla.
 * 
 * Variables globales utilizadas:	
 * (rowScreen): Fila de la pantalla donde posicionamos el cursor.
 * (colScreen): Columna de la pantalla donde posicionamos el cursor.
 * 
 * Se ha definido una subrutina en ensamblador equivalente 'gotoxyP1'  
 * para poder llamar a esta función guardando el estado de los registros 
 * del procesador. Esto se hace porque las funciones de C no mantienen 
 * el estado de los registros.
 */
void gotoxyP1_C(){
	
   printf("\x1B[%d;%dH",rowScreen,colScreen);
   
}


/**
 * Mostrar un carácter guardado en la variable (c) en pantalla,
 * en la posición donde está el cursor.
 * 
 * Variables globales utilizadas:	
 * (charac)   : Carácter que queremos mostrar.
 * 
 * Se ha definido un subrutina en ensamblador equivalente 'printchP1' 
 * para llamar a esta función guardando el estado de los registros del 
 * procesador. Esto se hace porque las funciones de C no mantienen 
 * el estado de los registros.
 */
void printchP1_C(){

   printf("%c",charac);
   
}


/**
 * Leer una tecla y guardar el carácter asociado en la variable (charac)
 * sin mostrarlo en pantalla. 
 * 
 * Variables globales utilizadas:	
 * (charac)   : Carácter que leemos de teclado.
 * 
 * Se ha definido una subrutina en ensamblador equivalente 'getchP1' para
 * llamar a esta función guardando el estado de los registros del procesador.
 * Esto se hace porque las funciones de C no mantienen el estado de los 
 * registros.
 */
void getchP1_C(){

   static struct termios oldt, newt;

   /*tcgetattr obtenir els paràmetres del terminal
   STDIN_FILENO indica que s'escriguin els paràmetres de l'entrada estàndard (STDIN) sobre oldt*/
   tcgetattr( STDIN_FILENO, &oldt);
   /*es copien els paràmetres*/
   newt = oldt;

   /* ~ICANON per a tractar l'entrada de teclat caràcter a caràcter no com a línia sencera acabada amb /n
      ~ECHO per a què no mostri el caràcter llegit*/
   newt.c_lflag &= ~(ICANON | ECHO);          

   /*Fixar els nous paràmetres del terminal per a l'entrada estàndard (STDIN)
   TCSANOW indica a tcsetattr que canvii els paràmetres immediatament. */
   tcsetattr( STDIN_FILENO, TCSANOW, &newt);

   /*Llegir un caràcter*/
   charac = (char) getchar();                 
    
   /*restaurar els paràmetres originals*/
   tcsetattr( STDIN_FILENO, TCSANOW, &oldt);
   
}


/**
 * Mostrar en pantalla el menú del juego y pedir una opción.
 * Sólo acepta una de las opciones correctas del menú ('0'-'8')
 * 
 * Variables globales utilizadas:		
 * (rowScreen): Fila de la pantalla donde posicionamos el cursor.
 * (colScreen): Columna de la pantalla donde posicionamos el cursor.
 * (charac)   : Carácter que leemos de teclado.
 * (developer):((char *)&developer): Variable definida en el código ensamblador.
 * 
 * Esta función no se llama desde ensamblador
 * y no hay definida una subrutina de ensamblador equivalente.
 */
void printMenuP1_C(){
   clearScreen_C();
   rowScreen = 1;
   colScreen = 1;
   gotoxyP1_C();
   printf("                                 \n");
   printf("       P1 Developed by:          \n");
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
   printf("|                               |\n");
   printf("|        7. Play Game           |\n");
   printf("|        8. Play Game C         |\n");
   printf("|        0. Exit                |\n");
   printf("|_______________________________|\n");
   printf("|                               |\n");
   printf("|           OPTION:             |\n");
   printf("|_______________________________|\n"); 

   charac=' ';
   while (charac < '0' || charac > '8') {
      rowScreen = 20;
      colScreen = 21;
      gotoxyP1_C();           //posicionar el cursor
      getchP1_C();            //Leer una opción
      printchP1_C();          //Mostrar opción
   }
   
}


/**
 * Mostrar el tablero de juego en pantalla. Las líneas del tablero.
 * 
 * Variables globales utilizadas:	
 * (rowScreen): Fila de la pantalla donde posicionamos el cursor.
 * (colScreen): Columna de la pantalla donde posicionamos el cursor.
 *  
 * Esta función se llama des de C y desde ensamblador,
 * y no hay definida una subrutina de ensamblador equivalente.
 */
void printBoardP1_C(){

   rowScreen = 0;
   colScreen = 0;                                      
   gotoxyP1_C();                                        //Filas
                                                        //Tablero
   printf(" _____________________________________ \n"); //01
   printf("|                                     |\n"); //02
   printf("|         M  E  M  O  R  Y   v_1.0    |\n"); //03
   printf("|                                     |\n"); //04
   printf("|  Choose 2 cards and turn them over. |\n"); //05
   printf("|    Try to match all the pairs!      |\n"); //06
   printf("|                                     |\n"); //07
 //Columnas Tablero   12  16  20  24   28         
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
  //Columnas dígitos      15       24                 
   printf("|           +----+   +----+           |\n"); //18
   printf("|     Moves |    |   |    | Pairs     |\n"); //19
   printf("|           +----+   +----+           |\n"); //20 
   printf("| (ESC) Exit        Turn Over (Space) |\n"); //21
   printf("| (i)Up    (j)Left  (k)Down  (l)Right |\n"); //22
   printf("|                                     |\n"); //23
   printf("| [                                 ] |\n"); //24
   printf("|_____________________________________|\n"); //25
                          
}


/**
 * Posicionar el cursor en la pantalla,dentro el tablero, en función de la
 * posición del cursor dentro la matriz, indicada por la variable (pos) 
 * de tipo int(DWORD)4 bytes, a partir de la posición [10,12] de la pantalla.
 * Para calcular la posición del cursor a pantalla (rowScreen) y 
 * (colScreen) utilizar estas fórmulas:
 * rScreen=10+(pos/COLDIM)*2)
 * cScreen=12+(pos%COLDIM)*4)
 * Para posicionar el cursor en la pantalla se tiene que llamar a la 
 * función gotoxyP1_C.
 * 
 * Variables globales utilizadas:
 * (pos)      : Posición del cursor dentro de la matriz.
 * (rowScreen): Fila donde queremos posicionar el cursor en la pantalla.
 * (colScreen): Columna donde queremos posicionar el cursor en la pantalla.
 * 
 * Esta función no no se llama des de ensamblador.
 * A la subrutina de ensamblador equivalente 'posCurScreenP1',  
 * el paso de parámetros es equivalente.
 */
void posCurScreenP1_C() {

   rowScreen=10+((pos/COLDIM)*2);
   colScreen=12+((pos%COLDIM)*4);
   gotoxyP1_C();
   
}


/**
 * Convierte un valor (value) de tipo short(2 bytes) (entre 0 y 99) en  
 * dos caracteres ASCII que representan este valor. (27 -> '2' '7').
 * Se tiene que dividir el valor entre 10, el cociente representará las 
 * decenas y el resto las unidades, y después se tiene que convertir a ASCII
 * sumando '0' o 48(código ASCII de '0') a las unidades y a les decenas.
 * Muestra los dígitos (carácter ASCII) a partir de la fila indicada
 * para la variable (rowScreen) y a la columna indicada para la variable
 * (colScreen).
 * Para posicionar el cursor se llama a la función gotoxyP1_C y para 
 * mostrar los caracteres ala función printchP1_C.
 * 
 * Variables globales utilizadas:	
 * (rowScreen): Fila de la pantalla donde posicionamos el cursor.
 * (colScreen): Columna de la pantalla donde posicionamos el cursor.
 * (charac)   : Carácter que leemos de teclado.
 * (value)    : Valor que queremos mostrar.
 * 
 * Esta función no se llama des de el ensamblador.
 * Hay una subrutina en ensamblador equivalente 'showDigitsP1',  
 */
 void showDigitsP1_C() {
	
	char d, u;
	d = value / 10;      //Decenas
	d = d + '0';
	charac = d;
    gotoxyP1_C();   
	printchP1_C();
	
	u = value % 10;      //Unidades
	u = u + '0';
	charac = u;
    colScreen++;
	gotoxyP1_C();   
	printchP1_C();
	
}


/**
 * Mostrar los valores de la matriz (mOpenCards) dentro el tablero, en
 * las posiciones correspondientes, los intentos que quedan (moves)
 * y las parejas que faltan por hacer (pairs). 
 * Se tiene que recorrer toda la matriz (mOpenCards), de izquierda a derecha
 * y de arriba a bajo, cada posición es de tipo char(BYTE)1byte, 
 * y para cada elemento de la matriz hacer:
 * Posicionar el cursor en el tablero en función de las variables 
 * (rowScreen) fila y (colScreen) columna llamando a la función gotoxyP2_C.
 * Las variables (rowScreen) y (colScreen) se inicializaran a 10 y 14
 * respectivamente, que es la posición en pantalla de la casilla [0][0].
 * Mostrar los caracteres de cada posición de la matriz (mOpenCards) 
 * llamando la función printchP1_C.
 * Después, mostrar los intentos que quedan (moves) de tipo short(WORD)2bytes, 
 * a partir de la posición [19,15] de la pantalla y mostrar las parejas
 * que faltan por hacer (pairs) de tipo short(WORD)2bytes, a partir de la 
 * posición [19,24] de la pantalla llamando la función showDigitsP1_C.
 * 
 * Variables globales utilizadas:		
 * (rowScreen) : Fila donde queremos posicionar el cursor a la pantalla.
 * (colScreen) : Columna donde queremos posicionar el cursor a la pantalla.
 * (charac)    : Carácter donde queremos mostrar.
 * (value)     : Valor que queremos mostrar.
 * (mOpenCards): Matriz donde guardamos las tarjetas del juego.
 * (moves)     : Intentos que quedan.
 * (pairs)     : Parejas que faltan por hacer.
 *  
 * Esta función no se llama des de el ensamblador.
 * Hay una subrutina en ensamblador equivalente 'updateBoardP1'.
 */
void updateBoardP1_C(){
   
   int i,j;
   
   rowScreen=10;
   for (i=0;i<ROWDIM;i++){
	  colScreen=12;
      for (j=0;j<COLDIM;j++){
         gotoxyP1_C();
         charac = mOpenCards[i][j];
         printchP1_C();
         colScreen = colScreen + 4;
      }
      rowScreen = rowScreen + 2;
   }
   
   rowScreen = 19;
   colScreen = 15;
   value = moves;
   showDigitsP1_C();
   colScreen = 24;
   value = pairs;
   showDigitsP1_C();
   
}


/**
 * Actualizar la posición del cursor dentro la matriz indicada por la 
 * variable (pos), de tipo int(DWORD)4bytes, en función de la tecla 
 * pulsada que tenemos a la variable (charac) de tipo char(BYTE)1byte,
 * (i: arriba, j:izquierda, k:abajo, l:derecha).
 * Comprobar que no salimos de la matriz, (pos) sólo puede tomar valores
 * de posiciones dentro de la matriz [0 : (ROWDIM*COLDIM)-1].
 * Para comprobarlo hay que calcular la fila y columna dentro de la matriz:
 * fila    = pos / COLDIM, que puede tomar valores [0 : (ROWDIM-1)].
 * columna = pos % COLDIM, que puede tomar valores [0 : (COLDIM-1)].
 * Para cambiar de fila sumamos o restamos COLDIM a (pos) y para cambiar de 
 * columna sumamos o restamos 1 a (pos) porque cada posición de la matriz 
 * es de tipo char(BYTE)1byte y tiene ROWDIM filas y COLDIM columnas.
 * Si el movimiento sale de la matriz, no hacer el movimiento.
 * NO hay que posicionar el cursor en pantalla llamando posCurScreenP1_C.
 * 
 * Variables globales utilizadas:	
 * (charac): Carácter que leemos del teclado.
 * (pos)   : Posición del cursor dentro de la matriz.
 * 
 * Esta función no se llama des de el ensamblador.
 * Hay una subrutina en ensamblador equivalente 'moveCursorP1'.
 */
void moveCursorP1_C(){
 
   int i = pos / COLDIM;
   int j = pos % COLDIM;
 
   switch(charac){
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


}


/**
 * Abrir la tarjeta de la matriz (mCards) de la posición indicada por el
 * cursor dentro de la matriz indicada por la variable (pos). 
 * Guardar la posición de la tarjeta que estamos abriendo y que tenemos en
 * la variable (pos) de tipo int(DWORD)4bytes al vector (vPos), de tipo
 * int(DWORD)4bytes, donde la posición [0] es para guardar la posición de
 * la 1a tarjeta que volteamos (cuando state=0) y a la posición [1] es para  
 * guardar la posición de la 2a tarjeta que giramos (cuando state=1).
 * vPos[0]:[vPos+0]: Posición de la 1a tarjeta. 
 * vPos[1]:[vPos+4]: Posición de la 2a tarjeta.
 * Para acceder a la matriz en C hay que calcular la fila y la columna:
 * fila    = pos / COLDIM, que puede tomar valores [0 : (ROWDIM-1)].
 * columna = pos % COLDIM, que puede tomar valores [0 : (COLDIM-1)].
 * En ensamblador no es necesario.
 * Si la tarjeta no está volteada (!='x') ponerla en la matriz (mOpenCards)
 * para que se muestre.
 * Marcarla con una 'x'(minúscula) en la misma posición de la matriz 
 * (mCards) para saber que está volteada.
 * Pasar al siguiente estado (state++)
 * 
 * NO se tiene que mostrar la matriz con los cambios, se hace en updateBoardP1_C().
 * 
 * Variables globales utilizadas:
 * (mCards)    : Matriz donde guardamos las tarjetas del juego.
 * (mOpenCards): Matriz donde tenemos las tarjetas abiertas del juego.
 * (pos)       : Posición del cursor dentro de la matriz.
 * (state)     : Estado del juego.
 * (vPos)      : Dirección del vector con lass posiciones de las tarjetas abiertas.
 * 
 * Esta función no se llama des de ensamblador.
 * Hay una subrutina en ensamblador equivalente 'openCardP1'.
 */
void openCardP1_C(){

   int i = pos / COLDIM; // En ensamblador no es necesario calcular
   int j = pos % COLDIM; // la 'i' y la 'j'. Utilizamos 'pos'.
   
   vPos[state] = pos;
   
   if (mCards[i][j] != 'x') {
      mOpenCards[i][j] = mCards[i][j];
      mCards[i][j] = 'x';
      state++;
   }
   
}


/**
 * Muestra un mensaje debajo del tablero según el valor de la variable
 * state)  0: 0 tarjetas abiertas.
 *         1: 1 Tarjeta abierta.
 *         2: 2 Tarjetas abiertas.
 *         5: Salir, hemos pulsado la tecla 'ESC' para salir.
 *         7: Pierdes, se han agotado los intentos.
 * Si (state>1) pedir que se pulse una tecla para poderlo leer.
 *         
 * Variables globales utilizadas:	
 * (rowScreen): Fila de la pantalla donde posicionamos el cursor.
 * (colScreen): Columna de la pantalla donde posicionamos el cursor.
 * (state)    : Estado del juego.
 *  
 *  
 * Se ha definido una subrutina en ensamblador equivalente 'printMessageP1' para
 * llamar esta función guardando el estado de los registros del procesador.
 * Esto se hace porque les funciones de C no mantienen el estado de los 
 * registros.
 */
void printMessageP1_C() {

   rowScreen = 24;
   colScreen = 4;
   gotoxyP1_C();
   switch(state){
	  case 0:
         printf("...  Turn Over FIRST card !!! ...");
      break;
      case 1:
         printf("...  Turn Over SECOND card!!! ...");
      break; 
      case 5:
         printf("<<<<<< EXIT: (ESC) Pressed >>>>>>");
      break;
      case 7:
         printf("GAME OVER. Oh! Not more attempts.");
      break;
   }
   if (state > 1) getchP1_C();     
}


/**
 * Juego del Memory
 * Función principal del juego.
 * Encontrar todas las parejas el tablero (10 parejas), volteando las
 * tarjetas de dos en dos. Como máximo se pueden hacer 10 intentos.
 * 
 * Pseudo-código:
 * Inicializar el estado del juego, (state=0).
 * Borrar la pantalla  (llamar a la función clearScreen_C).
 * Mostrar el tablero de juego (llamar a la función printBoardP1_C).
 * Actualizar el tablero de juego, los valores de los intentos que 
 * quedan (moves) y de las parejas que faltan por hacer (pairs) llamando
 * a la función updateBoardP1_C.
 * Mientras (state<3) hacer:
 *   Mostrar un mensaje,  según el valor de la variable (state), para
 *   indicar que se tiene que hacer, llamando a la función printMessageP1_C.
 *   Actualizar la posición del cursor a la pantalla a partir de la 
 *   variable (pos) con la posición del cursor dentro de la matriz, 
 *   llamando a la función posCurScreenP1_C
 *   Leer una tecla, llamando a la función getchP1_C. 
 *   Según la tecla leída llamaremos a las subrutinas que correspondan.
 *     - ['i','j','k' o 'l'] desplazar el cursor según la dirección 
 *       escogida, llamando a la función moveCursorP1_C).
 *     - '<SPACE>'(codi ASCII 32) voltearla tarjeta donde haya el cursor
 *       llamando a la función openCardP1_C.
 *       [No se comprueba que se hagan parejas].
 *       Si se han volteado dos tarjetas (state>1) poner (state=0) y
 *          decrementar los intentos que quedan (moves).
 *          Si no quedan intentos (moves==0), cambiar al estado de 
 *             intentos agotados (state=7).
 *          Mostrar un mensaje,  según el valor de la variable (state)
 *          para indicar que ha pasado, llamando a la función printMessageP2_C. 
 *       Actualizar el tablero de juego, los valores de los intentos que
 *       quedan (moves) y de las parejas que faltan por hacer (pairs) 
 *       llamando a la función updateBoardP1_C.
 *    - '<ESC>'  (codi ASCII 27) poner (state = 5) para salir.
 *       No saldrá si sólo se ha volteado una tarjeta (state!=1).
 * Fin mientras.
 * Salir: Se termina el juego.
 * 
 * Variables globales utilizadas:	
 * (state) : Indica el estado del juego. 0:salir, 1:jugar.
 * (charac): Carácter que leemos de teclado.
 * (moves) : Intentos que quedan.
 * (pairs) : Parejas que quedan por hacer.
 * 
 * Esta función no se llama des de el ensamblador.
 * Se ha definido una subrutina de ensamblador equivalente 'playP1' para llamar
 * las subrutinas del juego definidas en ensamblador (posCurScreenP1,
 * showDigitsP1, updateBoardP1(), moveCursorP1(), openCardP1).
 */
void playP1_C(){

   state = 0;       //Estado para empezar a jugar.
   moves = 10;      //Intentos que se pueden hacer.
   pairs = (ROWDIM * COLDIM)/2;//(5*4)/2=10://Parejas que hay que hacer.
   pos = 8;         //Posición inicial del cursor dentro de la matriz.
                    //Fila    = (8 / COLDIM) = 1
                    //Columna = (8 % COLDIM) = 3
   
   clearScreen_C();
   printBoardP1_C();
   updateBoardP1_C();
   
   while (state < 3) {   //Bucle principal.
	  printMessageP1_C();
      posCurScreenP1_C();
      getchP1_C();       
   
      if (charac>='i' && charac<='l') {
         moveCursorP1_C();
      }
      else if (charac==32) {
         openCardP1_C();
         if (state > 1) {
			 state = 0;
			 moves--;
			 if (moves == 0) state = 7;
			 printMessageP1_C();
		 }
		 updateBoardP1_C();
      }  
      else if ((charac==27) && (state!=1)) {
         state = 5;
      }
   }
   
}


/**
 * Programa Principal
 * 
 * ATENCIÓN: Podeis probar la funcionalidad de las subrutinas que se tienen que
 * desarrollar sacando los comentarios de la llamada a la función 
 * equivalente implementada en C que hay debajo en cada opción.
 * Paro el juego completo hay una opción para la versión en ensamblador y 
 * una opción para el juego en C.
 */
int main(void){
   
   int   op=0;
   
   state = 0;    
   pos   = 11;
   moves = 10;
   pairs = 10;
   
   while (op!='0') {
      clearScreen_C();
      printMenuP1_C();    //Mostrar menú y pedir opción
      op = charac;
      switch(op){
          case '1': //Posicionar el cursor en la pantalla, dentro del tablero.
            printf(" %c",op);
            clearScreen_C();    
            printBoardP1_C();   
            rowScreen = 26;
            colScreen = 12;
            gotoxyP1_C();
            printf(" Press any key ");
            pos = 11;
            //=======================================================        
              posCurScreenP1();
              //posCurScreenP1_C();
            //=======================================================
            getchP1_C();
         break;    //Convertir un valor (entre 0 y 99) en 2 dos caracteres ASCII.
         case '2': //y muestra los dos dígitos en pantalla
            printf(" %c",op);
            clearScreen_C();    
            printBoardP1_C();
            rowScreen = 19;
            colScreen = 15;
            value = 99;
            //=======================================================        
              showDigitsP1();
              //showDigitsP1_C();
            //=======================================================
            rowScreen = 26;
            colScreen = 12;
            gotoxyP1_C();
            printf(" Press any key ");
            getchP1_C();
         break;
         case '3': //Actualizar el contenido del tablero.
            clearScreen_C();       
            printBoardP1_C(); 
            moves =  9;
            pairs = 10;     
            //=======================================================
              updateBoardP1();
              //updateBoardP1_C();
            //=======================================================
            rowScreen = 26;
            colScreen = 12;
            gotoxyP1_C();
            printf(" Press any key ");
            getchP1_C();
         break;
         case '4': //Actualizar posición del cursor en el tablero. 
            clearScreen_C();
            printBoardP1_C();
            updateBoardP1_C();
            rowScreen = 26;
            colScreen = 12;
            gotoxyP1_C();
            printf(" Press i,j,k,l ");
            pos = 17;
            posCurScreenP1_C();
            getchP1_C();   
            if (charac>='i' && charac<='l') {
			//=======================================================
              moveCursorP1();
              //moveCursorP1_C();  
            //=======================================================
            }
            rowScreen = 26;
            colScreen = 12;
            gotoxyP1_C();
            printf(" Press any key ");
            posCurScreenP1_C();
            getchP1_C();
         break;
         case '5': //Abrir una tarjeta donde hay el cursor
            clearScreen_C();
            printBoardP1_C();
            rowScreen = 26;
            colScreen = 12;
            gotoxyP1_C();
            printf("Press <space> ");
            updateBoardP1_C();
            pos = 19;
            posCurScreenP1_C();
            state = 0;
            getchP1_C(); 
            if (charac>=' ') {
			//=======================================================
               openCardP1();
               //openCardP1_C();
            //=======================================================
            }
            updateBoardP1_C();
            printMessageP1_C();
            rowScreen = 26;
            colScreen = 12;
            gotoxyP1_C();
            printf(" Press any key ");
            getchP1_C();
         break;
       
         case '7': //Juego completo en Ensamblador  
            //=======================================================
            playP1();
            //=======================================================
         break;
         case '8': //Juego completo en C
            //=======================================================
            playP1_C();
            //=======================================================
         break;
     }
   }
   printf("\n\n");
   
   return 0;
   
}
