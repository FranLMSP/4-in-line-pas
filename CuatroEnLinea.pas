{PROGRAMA ELABORADO POR FRANCO ATILIO COLMENAREZ GARCÍA
* C.I: 25.896.369
* 4 EN LÍNEA}
program CuatroEnLinea;

uses crt,libreria;

const
	MAXtablero = 11;
	MINtablero = 4;

label
	gotomenu,title;

type	
	arreglo = array [1..MAXtablero,1..MAXtablero] of byte;
	
	save = record
		tab:arreglo;
		tamX:longint;
		tamY:longint;
		turn:boolean;
	end;

var 
	tablero:arreglo;
	colorJ1,colorJ2,fondo_tablero,color_lineas,pos,x,ganador,seleccion,seleccion2,
	pos_flecha,flechaY,err,xcuadro,ycuadro,i:byte;
	turno:boolean;
	key:char;
	TamanioX,TamanioY:longint;

{Procedimiento que inicializa algunas variables del programa. No tiene datos
 de entrada}
procedure inicializar;
BEGIN
	cursoroff;
	ganador:=0;
	TamanioX:=7;
	TamanioY:=6;
	colorJ1:=blue;
	colorJ2:=green;
	fondo_tablero:=white;
	if fondo_tablero=black then
		color_lineas:=white
	else
		color_lineas:=black;
END;

{Procedimiento que genera el tablero según el tamaño de la matriz deseada.
* Tiene como referencia el tablero de tipo arreglo (matriz)}
procedure generar_tablero(var tab:arreglo);
var
	x,y:byte;
BEGIN
	for y:=1 to MAXtablero do
	begin
		for x:=1 to MAXtablero do
		begin
			tab[x,y]:=0;
		end;
	end;
END;

{Procedimiento que permite al jugador moverse de izquierda a derecha para
realizar una jugada. Tiene como datos de entrada:
* colorJ1: El color del jugador 1
* colorJ2: El color del jugador 2
* fondo: El fondo del tablero
* turno: El turno del jugador
- como referencia:
* pos: Posición donde el jugador dejará caer la ficha}
procedure waiting_turn(colorJ1,colorJ2,fondo:byte; turno:boolean; var pos:byte);
var
	y:byte;
	ficha,key:char;
BEGIN
	pos:=1;
	x:=(80-((TamanioX*2)-2))div 2+1;//estos algoritmos permiten que el tablero
	y:=(25-((TamanioY*2)-2))div 2+1;//siempre esté centrado según el tamaño
	case turno of
		true: begin ficha:='1';textcolor(colorJ1); end;
		false:begin ficha:='2';textcolor(colorJ2); end;
	end;
	textbackground(fondo);
	repeat
	gotoxy(x,y-1); write(ficha);
	key:=readkey;
		case key of
			LEFT:	begin
						if pos>1 then
						begin
							pos:=pos-1;//posición lógica
							x:=x-2;//posición en la pantalla
							gotoxy(x+2,y-1); write(' ');
						end;
					end;
			RIGHT:	begin
						if pos<TamanioX then
						begin
							pos:=pos+1;//posición lógica
							x:=x+2;//posición en la pantalla
							gotoxy(x-2,y-1); write(' ');
						end;
					end;
		end;
	until key=ENTER;
	gotoxy(x,y-1); write(' ');
END;

{Función que permite detectar el fondo de la columna. Tiene como datos de entrada:
* pos: Posición donde el jugador deja caer la ficha (x) de tipo byte (entero)
* tablero: Tablero al que se le detectará el fondo de dicha columna}
function fondo(pos:byte;tablero:arreglo):byte;
BEGIN
	fondo:=tamanioY;
	if (tablero[pos,fondo]<>1) or (tablero[pos,fondo]<>2) then
	begin
		while tablero[pos,fondo]<>0 do
		begin
			fondo:=fondo-1;
		end;
	end;
END;

{"drop". Animación que simula la caída de la ficha. Como valores de entrada tiene:
* X: La posición X de la pantalla donde se efectuará la "caída"
* Pos: La posición lógica donde el jugador deja caer la ficha
* lentitud: La lentitud con la que va a caer la ficha (en "ms"
* colorJ1 y colorJ2: Colores de los jugadores
* turno: Turno del jugador
- Como referencia:
* Tablero: el tablero de tipo arreglo (matriz)}
procedure drop(x,pos,lentitud,colorJ1,colorJ2:byte; turno:boolean; var tablero:arreglo);
var
	y,i:byte;
	ficha:char;
BEGIN
	y:=(25-((TamanioY*2)-2))div 2+1;
	case turno of
		true: begin ficha:='1'; textcolor(colorJ1); end;
		false:begin ficha:='2'; textcolor(colorJ2); end;
	end;
	gotoxy(x,y);write(ficha);
	if fondo(pos,tablero)>0 then
	begin
		for i:=1 to fondo(pos,tablero)-1 do
		begin
			y:=y+2; gotoxy(x,y);write(ficha);
			gotoxy(x,y-2); write(' ');
			delay(lentitud);
		end;
		case turno of
			true: tablero[pos,fondo(pos,tablero)]:=1;
			false:tablero[pos,fondo(pos,tablero)]:=2;
		end;
	end;
END;

{Procedimiento que escanea el tablero y determina si un jugador ganó.
Como datos de entrada tiene:
* pos: posición donde se dejó caer la ficha
* tablero: de tipo arreglo
* como referencia: Ganador: determina quién ganó. Si saca los valores:
- 0: No ha ganado nadie.
- 1: Ganó jugador 1.
- 2: Ganó jugador 2.
- 3: Empate.}
procedure scan(pos:byte;tablero:arreglo;var ganador:byte);
var
	cont,i,x,y:byte;
BEGIN
	x:=pos;
	y:=(fondo(pos,tablero))+1;
	//de forma diagonal
	if ganador=0 then
		if (tablero[x,y]=1) and (tablero[x-1,y+1]=1) and (tablero[x-2,y+2]=1)and(tablero[x-3,y+3]=1)then
			ganador:=1
		else
		if (tablero[x,y]=2) and (tablero[x-1,y+1]=2) and (tablero[x-2,y+2]=2)and(tablero[x-3,y+3]=2) then
			ganador:=2;
			
	if ganador=0 then
		if (tablero[x,y]=1) and (tablero[x+1,y+1]=1) and (tablero[x+2,y+2]=1)and(tablero[x+3,y+3]=1)then
			ganador:=1
		else
		if (tablero[x,y]=2) and (tablero[x+1,y+1]=2) and (tablero[x+2,y+2]=2)and(tablero[x+3,y+3]=2) then
			ganador:=2;
	if ganador=0 then
		if (tablero[x,y]=1) and (tablero[x-1,y+1]=1) and (tablero[x-2,y+2]=1)and(tablero[x-3,y+3]=1)then
			ganador:=1
		else
		if (tablero[x,y]=2) and (tablero[x-1,y+1]=2) and (tablero[x-2,y+2]=2)and(tablero[x-3,y+3]=2) then
			ganador:=2;
			
	if ganador=0 then
		if (tablero[x,y]=1) and (tablero[x+1,y-1]=1) and (tablero[x+2,y-2]=1)and(tablero[x+3,y-3]=1)then
			ganador:=1
		else
		if (tablero[x,y]=2) and (tablero[x+1,y-1]=2) and (tablero[x+2,y-2]=2)and(tablero[x+3,y-3]=2) then
			ganador:=2;
	//de forma horizontal/vertical (se puede mejorar (work in progress))
	cont:=0;
	if ganador=0 then
	begin
		for i:=1 to TamanioX do
		begin
			if (tablero[i,y]=tablero[i-1,y]) then
				cont:=cont+1
			else
				cont:=0;
			if cont=3 then
			begin
				if tablero[i,y]=1 then
					ganador:=1
				else
				if tablero[i,y]=2 then
					ganador:=2;
			end;
		end;
	end;
	cont:=0;
	if ganador=0 then
	begin
		for i:=1 to TamanioY do
		begin
			if (tablero[x,i]=tablero[x,i-1]) then
				cont:=cont+1
			else
				cont:=0;
			if cont=3 then
			begin
				if tablero[x,i]=1 then
					ganador:=1
				else
				if tablero[x,i]=2 then
					ganador:=2;
			end;
		end;		
	end;
	cont:=0;
	for i:=1 to TamanioX do
	begin
		if tablero[i,1]<>0 then
			cont:=cont+1;			
	end;
	if cont=TamanioX then
		ganador:=3;
	cont:=0;
END;

{Muestra el título del juego. No tiene datos de entrada puesto que es solo
una animacón. Usa solo procedimientos de la librería.}
procedure launch_title;
var
	i:byte;
BEGIN
	for i:=1 to 11 do
	begin
		letrotas(19,i-1,black,'4');
		cuadro_relleno(15,10,7,51,white);
		recuadro(14,9,9,53,darkgray,white,'+');
		letrotas(19,i,blue,'4');
		delay(100);
	end;
	letrotas(19,11,blue,'4');
	for i:=1 to 11 do
	begin
		letrotas(19,11,blue,'4');
		letrotas(26,i-1,black,'EN');
		cuadro_relleno(15,10,7,51,white);
		recuadro(14,9,9,53,darkgray,white,'+');
		letrotas(26,i,GREEN,'EN');
		delay(100);
	end;
	letrotas(19,11,blue,'4');letrotas(26,11,GREEN,'EN');
	for i:=1 to 11 do
	begin
		letrotas(19,11,blue,'4');
		letrotas(26,11,green,'en');
		letrotas(38,i-1,black,'linea');
		cuadro_relleno(15,10,7,51,white);
		recuadro(14,9,9,53,darkgray,white,'+');
		letrotas(38,i,blue,'linea');
		delay(100);
	end;
	letrotas(19,11,blue,'4');letrotas(26,11,GREEN,'EN');letrotas(38,11,blue,'linea');
	textbackground(lightcyan);textcolor(black);
	gotoxy(29,21);write('Press any key to start');
	readkey;
	textbackground(black);textcolor(lightgray);
	clrscr;
	textbackground(black);textcolor(lightgray);
END;

{Solo muestra en la pantalla algunas opciones de la configuración}
procedure recuadro_opciones;
BEGIN
	//recuadro(x,y,alto,largo,fondo,letra:byte; caracter:char);
	//cuadro_relleno(x,y,alto,ancho,color:byte);
	cuadro_relleno(19,7,3,20,lightcyan);
	cuadro_relleno(19,11,7,17,lightcyan);
	recuadro(18,6,13,19,lightgray,white,'#');
	recuadro(18,6,5,22,lightgray,white,'#');
	recuadro(18,8,3,22,lightgray,white,'#');
	recuadro(18,10,3,19,lightgray,white,'#');
	recuadro(18,12,3,19,lightgray,white,'#');
	recuadro(18,14,3,19,lightgray,white,'#');
	recuadro(18,16,3,19,lightgray,white,'#');
	textbackground(lightcyan);textcolor(white);
	gotoxy(19,7);	write('Largo del tablero');
	gotoxy(19,9);	write('Alto del tablero');
	gotoxy(19,11);	write('Color J1');
	gotoxy(19,13);	write('Color J2');
	gotoxy(19,15);	write('Color de fondo');
	gotoxy(19,17);	write('Predeterminado');
	paleta_colores(37,11);paleta_colores(37,13);paleta_colores(37,15);
	gotoxy(4,22); write('Si cambia opciones y cargas el estado guardado, podría causar errores.');
	gotoxy(4,23); write('Pulse ESC para volver.');
	gotoxy(4,2);  write('Pulse ENTER para cambiar los tamaños y ENTER para aceptar.');
END;

{Procedimiento que permite al usuario desplazarse por el menú de opciones
* Como único valor de referencia tiene: pos_flecha:
* Expulsa el valor lógico de la posición de lsa flechas}
procedure mover_flechas(var pos_flecha:byte);
BEGIN
	key:=readkey;
	case key of
		DOWN: 	if pos_flecha <6 then
				begin
					pos_flecha:=pos_flecha+1;
					flechaY:=flechaY+2;
					gotoxy(17,flechaY-2);write(' ');
				end;
		UP:		if pos_flecha >1 then
				begin
					pos_flecha:=pos_flecha-1;
					flechaY:=flechaY-2;
					gotoxy(17,flechaY+2);write(' ');
				end;
	end;
END;

{procedimiento que le permite al usuario seleccionar un color.
* Tiene como datos de entrada:
- x,y: Posiciones X,Y donde se desea que se ponga la opción
- key: Tecla que se pulsó
Como referencia:
- colorJ: Valor al cual se le va a modificar el color.}
procedure seleccion_color(x,y:byte;key:char; var colorJ:byte);
var
	flechaX:byte;
BEGIN
	flechaX:=colorJ;
	gotoxy(x+flechaX,y);write('^');
	if (key=LEFT)or(key=RIGHT)then
	begin
		case key of
			RIGHT:	begin
						if flechaX<15 then
						begin
							gotoxy(x+flechaX,y);write(' ');
							flechaX:=flechaX+1;
							gotoxy(x+flechaX,y);write('^');
						end;
					end;
			LEFT:	begin
						if flechaX>0 then
						begin
							gotoxy(x+flechaX,y);write(' ');
							flechaX:=flechaX-1;
							gotoxy(x+flechaX,y);write('^');
						end;	
					end;
		end;
	end;
	colorJ:=flechaX;
END;

{Procedimiento que le permite al usuario seleccionar el tamaño del tablero
Como datos de entrada tiene:
- x,y: Coordenadas donde se desea que se ponga la opción
- key: Valor de la tecla pulsada (como entrada)
Como referencia:
- Tamanio: el tamaño elegido por el usuario}
procedure seleccion_tamanio(x,y:byte;key:char;var Tamanio:longint);
var
	TamanioC:shortstring;
BEGIN
	if key=ENTER then
	begin
		repeat
			textbackground(lightcyan);textcolor(lightgray);
			gotoxy(x,y);write('  ');
			{"leerdato" de la librería. Permite una entrada de datos.
			* posiciones X,Y donde se desea, dos caracteres de ancho, solo números permitidos
			* y el tamaño del valor a modificar}
			leerdato(x,y,2,'0123456789',TamanioC);
			valor(TamanioC,err,Tamanio);
			if (Tamanio<MINtablero) or (Tamanio>MAXtablero) then
				begin
					textbackground(red);textcolor(white);
					gotoxy(x+3,y);write('MAX 11. MIN 4.');
				end;
		until (Tamanio>=MINtablero)and(Tamanio<=MAXtablero);
		textbackground(black);textcolor(lightgray);
		gotoxy(x+3,y);write('              ');
	end;
END;

//Solo muestra un recuadro con el ganador y como datos de entrada tiene el ganador.
//Valores que recibe: 1 o 2. 3 en caso de que sea empate.
procedure ganador_es(ganador:byte);
BEGIN
	//cuadro_relleno(x,y,alto,ancho,color:byte);
	recuadro(32,10,7,17,3,15,'*');
	cuadro_relleno(33,11,5,15,white);
	textbackground(white);
	case ganador of
		1:textcolor(colorJ1);
		2:textcolor(colorJ2);
		3:textcolor(cyan);
	end;
	if (ganador=1) or (ganador=2) then
	begin
		gotoxy(33,12); write('  Ganador: J',ganador);
		gotoxy(33,14); write('   GAME OVER   ');
		
	end
	else
	begin
		gotoxy(33,13); write('    EMPATE    ');
	end;
	textbackground(black);
END;

{Procedimiento que permite crear un estado guardado de la partida en caso de que
algo salga mal (un corte de luz o algo similar) y poder retomar la partida.
Tiene como datos de entrada:
* El tablero: de tipo arreglo.
* TamanioX y TamanioY: Para que sepa el tamaño de la matriz y evitar errores
* turno: Guarda en qué turno quedaron.}
procedure savestate(tablero:arreglo; TamanioX,TamanioY:longint; turno:boolean);
var
	arch:file of save;
	datos:save;
BEGIN
	datos.tab:=tablero;
	datos.tamX:=TamanioX;
	datos.tamY:=TamanioY;
	if turno then
		turno:=false
	else
		turno:=true;
	datos.turn:=turno;
	assign(arch,'savestate.dat');
	rewrite(arch);
	reset(arch);
	write(arch,	datos);
	close(arch);
END;

{Carga el estado guardado si el jugador lo desea y lo muestra en pantalla.
* colorj1 y colorj2: Colores en valores entero de los jugadores.
- como referencia:
* tablero: de tipo arreglo. Modificará el arreglo para retomar la partida.
* TamanioX y TamanioY: Modifica el tamaño de la matriz.
* Turno: Carga el último turno}
procedure loadstate(colorj1,colorj2,colorfondo:byte; var tablero:arreglo; var TamanioX,TamanioY:longint;var turno:boolean);
var
	arch:file of save;
	datos:save;
	x,y,i,j:byte;
BEGIN
	assign(arch, 'savestate.dat');
	{$I-}
	reset(arch);
	{$I+}
	if ioresult <> 0 then
	begin
		turno:=true;
		TamanioX:=7;
		TamanioY:=8;
		for i:=1 to TamanioY do
			for j:=1 to TamanioX do
				tablero[j,i]:=0;
	end
	else
	begin
		read(arch,datos);
		TamanioX:=datos.tamX;
		TamanioY:=datos.tamY;
		turno:=datos.turn;
		x:=(80-((datos.tamX*2)-2))div 2+1;//
		y:=(25-((datos.tamY*2)-2))div 2+1;//permiten que siempre esté centrado
		textbackground(colorfondo);
		for j:=1 to datos.tamY do
		begin
			for i:=1 to datos.tamX do
			begin
				if datos.tab[i,j]>0 then
				begin
					if datos.tab[i,j]=1 then
						textcolor(colorj1)
					else
					if datos.tab[i,j]=2 then
						textcolor(colorj2);
					gotoxy(x,y);
					write(datos.tab[i,j]);
				end;
				x:=x+2;
			end;
			y:=y+2;
			x:=(80-((datos.tamX*2)-2))div 2+1;
		end;
		tablero:=datos.tab;
		close(arch);
	end;
END;

procedure IA(TamanioX:longint; tablero:arreglo; var posjugar:byte);
var
	pos:byte;
BEGIN
	randomize;
	repeat
		pos:=random(TamanioX)+1;
	until (fondo(pos,tablero)>1);
	posjugar:=pos;
END;

BEGIN
	inicializar;
	title:
	launch_title;
	gotomenu:
	gotoxy(34,7);write('¡Bienvenido!');
	recuadro(35,9,6,10,black,white,'+');
	menu(36,10,white,black,blue,green,'Jugar   ,Opciones,About   ,Salir   ',seleccion);
	textbackground(black);textcolor(lightgray);
	clrscr;
	textbackground(black);textcolor(lightgray);
	case seleccion of
		1:begin
			generar_tablero(tablero);
			gotoxy(24,8);write('¿Cargar el último estado guardado?');
			recuadro(35,9,4,4,black,white,'+');
			menu(36,10,white,black,blue,green,'Sí,No',seleccion);
			textbackground(black);textcolor(lightgray);
			clrscr;
			if seleccion=1 then
				loadstate(colorJ1,colorJ2,fondo_tablero,tablero,TamanioX,TamanioY,turno)
			else
			begin
				gotoxy(24,7);write('¿Qué jugador empieza?');
				recuadro(35,9,4,11,black,white,'+');
				menu(36,10,white,black,blue,green,'Jugador 1,Jugador 2',seleccion2);
				if seleccion2=1 then
					turno:=true
				else
				if seleccion2=2 then
					turno:=false;
				textbackground(black);textcolor(lightgray);
				clrscr;			
			end;
			textbackground(black);textcolor(lightgray);
			clrscr;
			xcuadro:=(80-((TamanioX*2)-2))div 2+1;//estos dos algoritmos
			ycuadro:=(25-((TamanioY*2)-2))div 2+1;//hacen que el tablero siempre quede centrado
			mostrar_tablero(xcuadro,ycuadro,fondo_tablero,color_lineas,TamanioX,TamanioY);
			recuadro(xcuadro-1,ycuadro-2,(TamanioY*2)+2,(TamanioX*2)+1,lightgray,white,'#');
			textbackground(fondo_tablero);
			//esto hace que imprima una barra de color solido donde se va a mover la ficha
			//(esperando el turno
			for i:=xcuadro to (xcuadro+((TamanioX*2)-1))-1 do
			begin
				gotoxy(i,ycuadro-1);write(' ');
			end;
			if seleccion=1 then
				loadstate(colorJ1,colorJ2,fondo_tablero,tablero,TamanioX,TamanioY,turno);
			repeat
				repeat
					waiting_turn(colorJ1,colorJ2,fondo_tablero,turno,pos);
				until fondo(pos,tablero)>0;
				drop(x,pos,200,colorJ1,colorJ2,turno,tablero);
				scan(pos,tablero,ganador);
				savestate(tablero,TamanioX,TamanioY,turno);
				case turno of
					true: turno:=false;
					false: turno:=true;
				end;
			until ganador>0;
			ganador_es(ganador);readkey;clrscr;
			generar_tablero(tablero);
			savestate(tablero,TamanioX,TamanioY,turno);
			ganador:=0;
			goto title;
		end;
		2:begin
			recuadro_opciones;
			gotoxy(37,7);	write(TamanioX);
			gotoxy(37,9);	write(TamanioY);
			pos_flecha:=1;
			flechaY:=7;
			textbackground(black);textcolor(white);
			repeat
				mover_flechas(pos_flecha);
				gotoxy(17,flechaY);write('>');
				case pos_flecha of
					1: 	seleccion_tamanio(37,7,key,TamanioX);
					2:	seleccion_tamanio(37,9,key,TamanioY);
					3:	seleccion_color(37,12,key,colorJ1);
					4:	seleccion_color(37,14,key,colorJ2);
					5:	seleccion_color(37,16,key,fondo_tablero);
					6:	if key=ENTER then	inicializar;
				end;
			until (key=EXIT) or ((pos_flecha=6) and (key=ENTER));
			clrscr;
			goto gotomenu;
		end;
		3:begin
			about_page(yellow,black,white,black,'+');textbackground(black);textcolor(lightgray);
			readkey;clrscr; goto gotomenu;
			textbackground(black);textcolor(lightgray);
		end;
		4:begin
			textbackground(black);textcolor(lightgray);
			gotoxy(38,12);write('Bye!');readkey;
		end;
	end;
END.
