{
	Esta librería se hizo con el fin de simplificar los códigos
	de los juegos. Puede ser usada libremente.
	* "Leer dato" básico.
	* "Recuadro" básico.
	* Abecedario de tamaño grande.
   
	Copyright Franco Colmenarez
}


unit libreria;

INTERFACE
uses 
	crt;
const
	UP    = #72; DOWN  = #80; 
	LEFT  = #75; RIGHT = #77;
	ENTER = #13; EXIT  = #27;
	BORRAR = #8;

//dibuja un recuadro con el largo y ancho deseado, con el caracter, el fondo y el color de la letra
procedure recuadro(x,y,alto,largo,fondo,letra:byte; caracter:char);
//leerdato simple
procedure leerdato(x,y,ancho:byte; valido:string; var cadena:string);
//abecedario en 4x5 pixeles (solo admite mayúsculas)
procedure letrotas(x,y,color:byte; texto:string);
//dibuja un cuadro sólido de un color
procedure cuadro_relleno(x,y,alto,ancho,color:byte);

procedure about_page(colorfondo,colorletra,colorbordes,colorletrasbordes:byte; caracterbordes:char);

procedure bomba_dibujo(x,y,color,fondo:byte);

procedure menu(col,ln,fondo,letra,fondosel,letrasel:byte;menu:string; var ind:byte);

procedure dinamita(x,y,color,fondo:byte);

procedure valor(cad:string; var err:byte;var numero:longint);

procedure paleta_colores(x,y:byte);

procedure mostrar_tablero(x,y,color_fondo,color_lineas,TamanioX,TamanioY:byte);

IMPLEMENTATION

procedure recuadro(x,y,alto,largo,fondo,letra:byte; caracter:char);
var
	i:byte;
BEGIN
	if (alto<>0) then
		alto:=alto-1;
	if (largo<>0) then
		largo:=largo-1;
	textcolor(letra); textbackground(fondo);
	//x to x+18
	for i:=x to x+largo do
	begin
		gotoxy(i,y);	write(caracter);
		gotoxy(i,y+alto); write(caracter);
	end;
	
	for i:=y to y+alto do
	begin
		gotoxy(x,i);	write(caracter);
		gotoxy(x+largo,i);	write(caracter);
	end;
	textbackground(black); textcolor(lightgray);
END;	

procedure leerdato(x,y,ancho:byte; valido:string; var cadena:string);
var l:char;
BEGIN
	cursoron;
	gotoxy(x,y);
	cadena:=''; 
	repeat
		l:=readkey;
		if l=BORRAR then
		begin
			if length(cadena)>0 then
			begin
				gotoxy(wherex-1,wherey); write(' ');
				gotoxy(wherex-1,wherey);
				cadena:=copy(cadena,1,length(cadena)-1);
			end;
		end
		else
		if length(cadena)<ancho then
		begin
			if ((l<>ENTER) or (l<>BORRAR)) and (l=copy(valido,pos(l,valido),1)) then  
			begin
				cadena:=cadena+l;
				gotoxy(x,y);write(cadena);		
			end;
		end;
	until (l=ENTER);
	cursoroff;
	textbackground(black); textcolor(lightgray);
END;

procedure letrotas(x,y,color:byte; texto:string);
var
	cont:byte;
	letra:string;
BEGIN
		cont:=0;
		textbackground(color);
		repeat
			cont:=cont+1;
			letra:=copy(texto,cont,1);
			case upcase(letra[1]) of
			'A': begin
					gotoxy(x+1,y);write('  ');
					gotoxy(x,y+1);write(' ');gotoxy(x+3,y+1);write(' ');
					gotoxy(x,y+2);write('    ');
					gotoxy(x,y+3);write(' ');gotoxy(x+3,y+3);write(' ');
					gotoxy(x,y+4);write(' ');gotoxy(x+3,y+4);write(' ');
				end;
			'B': begin
					gotoxy(x,y);write('   ');
					gotoxy(x,y+1);write(' ');gotoxy(x+3,y+1);write(' ');
					gotoxy(x,y+2);write('   ');
					gotoxy(x,y+3);write(' ');gotoxy(x+3,y+3);write(' ');
					gotoxy(x,y+4);write('   ');
				end;
			'C': begin
					gotoxy(x+1,y);write('   ');
					gotoxy(x,y+1);write(' ');
					gotoxy(x,y+2);write(' ');
					gotoxy(x,y+3);write(' ');
					gotoxy(x+1,y+4);write('   ');
				end;
			'D': begin
					gotoxy(x,y);write('   ');
					gotoxy(x,y+1);write(' ');gotoxy(x+3,y+1);write(' ');
					gotoxy(x,y+2);write(' ');gotoxy(x+3,y+2);write(' ');
					gotoxy(x,y+3);write(' ');gotoxy(x+3,y+3);write(' ');
					gotoxy(x,y+4);write('   ');
				end;
			'E': begin
					gotoxy(x,y);write('    ');
					gotoxy(x,y+1);write(' ');
					gotoxy(x,y+2);write('   ');
					gotoxy(x,y+3);write(' ');
					gotoxy(x,y+4);write('    ');
				end;
			'F': begin
					gotoxy(x,y);write('    ');
					gotoxy(x,y+1);write(' ');
					gotoxy(x,y+2);write('   ');
					gotoxy(x,y+3);write(' ');
					gotoxy(x,y+4);write(' ');
				end;
			'G': begin
					gotoxy(x+1,y);write('   ');
					gotoxy(x,y+1);write(' ');
					gotoxy(x,y+2);write('    ');
					gotoxy(x,y+3);write(' ');gotoxy(x+3,y+3);write(' ');
					gotoxy(x+1,y+4);write('   ');
				end;
			'H': begin
					gotoxy(x,y);write(' ');gotoxy(x+3,y);write(' ');
					gotoxy(x,y+1);write(' ');gotoxy(x+3,y+1);write(' ');
					gotoxy(x,y+2);write('    ');
					gotoxy(x,y+3);write(' ');gotoxy(x+3,y+3);write(' ');
					gotoxy(x,y+4);write(' ');gotoxy(x+3,y+4);write(' ');
				end;
			'I': begin
					gotoxy(x,y);write('    ');
					gotoxy(x+1,y+1);write('  ');
					gotoxy(x+1,y+2);write('  ');
					gotoxy(x+1,y+3);write('  ');
					gotoxy(x,y+4);write('    ');
				end;
			'J': begin
					gotoxy(x,y);write('    ');
					gotoxy(x+2,y+1);write(' ');
					gotoxy(x+2,y+2);write(' ');
					gotoxy(x,y+3);write(' ');gotoxy(x+2,y+3);write(' ');
					gotoxy(x+1,y+4);write(' ');
				end;
			'K': begin
					gotoxy(x,y);write(' ');gotoxy(x+3,y);write(' ');
					gotoxy(x,y+1);write(' ');gotoxy(x+2,y+1);write(' ');
					gotoxy(x,y+2);write('  ');
					gotoxy(x,y+3);write(' ');gotoxy(x+2,y+3);write(' ');
					gotoxy(x,y+4);write(' ');gotoxy(x+3,y+4);write(' ');
				end;
			'L': begin
					gotoxy(x,y);write(' ');
					gotoxy(x,y+1);write(' ');
					gotoxy(x,y+2);write(' ');
					gotoxy(x,y+3);write(' ');
					gotoxy(x,y+4);write('    ');
				end;
			'M': begin
					gotoxy(x,y);write(' ');gotoxy(x+3,y);write(' ');
					gotoxy(x,y+1);write('    ');
					gotoxy(x,y+2);write(' ');gotoxy(x+2,y+2);write('  ');
					gotoxy(x,y+3);write(' ');gotoxy(x+3,y+3);write(' ');
					gotoxy(x,y+4);write(' ');gotoxy(x+3,y+4);write(' ');
				end;
			'N': begin
					gotoxy(x,y);write(' ');gotoxy(x+3,y);write(' ');
					gotoxy(x,y+1);write('  ');gotoxy(x+3,y+1);write(' ');
					gotoxy(x,y+2);write(' ');gotoxy(x+2,y+2);write('  ');
					gotoxy(x,y+3);write(' ');gotoxy(x+3,y+3);write(' ');
					gotoxy(x,y+4);write(' ');gotoxy(x+3,y+4);write(' ');
				end;
			'O': begin
					gotoxy(x+1,y);write('  ');
					gotoxy(x,y+1);write(' ');gotoxy(x+3,y+1);write(' ');
					gotoxy(x,y+2);write(' ');gotoxy(x+3,y+2);write(' ');
					gotoxy(x,y+3);write(' ');gotoxy(x+3,y+3);write(' ');
					gotoxy(x+1,y+4);write('  ');
				end;
			'P': begin
					gotoxy(x,y);write('   ');
					gotoxy(x,y+1);write(' ');gotoxy(x+3,y+1);write(' ');
					gotoxy(x,y+2);write('   ');
					gotoxy(x,y+3);write(' ');
					gotoxy(x,y+4);write(' ');
				end;
			'Q': begin
					gotoxy(x+1,y);write('  ');
					gotoxy(x,y+1);write(' ');gotoxy(x+3,y+1);write(' ');
					gotoxy(x,y+2);write(' ');gotoxy(x+3,y+2);write(' ');
					gotoxy(x,y+3);write(' ');gotoxy(x+2,y+3);write('  ');
					gotoxy(x+1,y+4);write('   ');
				end;
			'R': begin
					gotoxy(x,y);write('   ');
					gotoxy(x,y+1);write(' ');gotoxy(x+3,y+1);write(' ');
					gotoxy(x,y+2);write('   ');
					gotoxy(x,y+3);write(' ');gotoxy(x+2,y+3);write(' ');
					gotoxy(x,y+4);write(' ');gotoxy(x+3,y+4);write(' ');
				end;
			'S': begin
					gotoxy(x+1,y);write('   ');
					gotoxy(x,y+1);write(' ');
					gotoxy(x+1,y+2);write('  ');
					gotoxy(x+3,y+3);write(' ');
					gotoxy(x,y+4);write('   ');
				end;
			'T': begin
					gotoxy(x,y);write('    ');
					gotoxy(x+1,y+1);write('  ');
					gotoxy(x+1,y+2);write('  ');
					gotoxy(x+1,y+3);write('  ');
					gotoxy(x+1,y+4);write('  ');
				end;
			'U': begin
					gotoxy(x,y);write(' ');gotoxy(x+3,y);write(' ');
					gotoxy(x,y+1);write(' ');gotoxy(x+3,y+1);write(' ');
					gotoxy(x,y+2);write(' ');gotoxy(x+3,y+2);write(' ');
					gotoxy(x,y+3);write(' ');gotoxy(x+3,y+3);write(' ');
					gotoxy(x+1,y+4);write('  ');
				end;
			'V': begin
					gotoxy(x,y);write(' ');gotoxy(x+3,y);write(' ');
					gotoxy(x,y+1);write(' ');gotoxy(x+3,y+1);write(' ');
					gotoxy(x,y+2);write(' ');gotoxy(x+3,y+2);write(' ');
					gotoxy(x+1,y+3);write(' ');gotoxy(x+3,y+3);write(' ');
					gotoxy(x+2,y+4);write(' ');
				end;
			'W': begin
					gotoxy(x,y);write(' ');gotoxy(x+3,y);write(' ');
					gotoxy(x,y+1);write(' ');gotoxy(x+2,y+1);write('  ');
					gotoxy(x,y+2);write(' ');gotoxy(x+2,y+2);write('  ');
					gotoxy(x,y+3);write(' ');gotoxy(x+2,y+3);write('  ');
					gotoxy(x+1,y+4);write(' ');gotoxy(x+3,y+4);write(' ');
				end;
			'X': begin
					gotoxy(x,y);write(' ');gotoxy(x+3,y);write(' ');
					gotoxy(x,y+1);write(' ');gotoxy(x+3,y+1);write(' ');
					gotoxy(x+1,y+2);write('  ');
					gotoxy(x,y+3);write(' ');gotoxy(x+3,y+3);write(' ');
					gotoxy(x,y+4);write(' ');gotoxy(x+3,y+4);write(' ');
				end;
			'Y': begin
					gotoxy(x,y);write(' ');gotoxy(x+3,y);write(' ');
					gotoxy(x,y+1);write(' ');gotoxy(x+3,y+1);write(' ');
					gotoxy(x,y+2);write('    ');
					gotoxy(x+2,y+3);write(' ');
					gotoxy(x+2,y+4);write(' ');
				end;
			'1': begin
					gotoxy(x+2,y);write(' ');
					gotoxy(x+1,y+1);write('  ');
					gotoxy(x,y+2);write(' ');gotoxy(x+2,y+2);write(' ');
					gotoxy(x+2,y+3);write(' ');
					gotoxy(x,y+4);write('    ');
				end;
			'Z': begin
					gotoxy(x,y);write('    ');
					gotoxy(x+3,y+1);write(' ');
					gotoxy(x+2,y+2);write(' ');
					gotoxy(x+1,y+3);write(' ');
					gotoxy(x,y+4);write('    ');
				end;
			'4': begin
					gotoxy(x,y);write(' ');gotoxy(x+3,y);write(' ');
					gotoxy(x,y+1);write(' ');gotoxy(x+3,y+1);write(' ');
					gotoxy(x+1,y+2);write('   ');
					gotoxy(x+3,y+3);write(' ');
					gotoxy(x+3,y+4);write(' ');
				end;
			'9': begin
					gotoxy(x+1,y);write('  ');
					gotoxy(x,y+1);write(' ');gotoxy(x+3,y+1);write(' ');
					gotoxy(x+1,y+2);write('   ');
					gotoxy(x+3,y+3);write(' ');
					gotoxy(x+3,y+4);write(' ');
				end;
			'-': begin
					gotoxy(x,y+2);write('    ');
				end;
			' ': begin
				end;
			end;
			x:=x+5;
		until (cont=length(texto));
		textbackground(black); textcolor(lightgray);
END;

procedure cuadro_relleno(x,y,alto,ancho,color:byte);
var
	i,j:byte;
BEGIN
	
	if (alto<>0) then
		alto:=alto-1;
	if (ancho<>0) then
		ancho:=ancho-1;
	textbackground(color);
	for j:=y to y+alto do
	begin
		for i:=x to x+ancho do
		begin
			gotoxy(i,j); write(' ');
		end;
	end;
	textbackground(black); textcolor(lightgray);
END;

procedure bomba_dibujo(x,y,color,fondo:byte);
BEGIN
	textbackground(fondo); textcolor(color);
	gotoxy(x,y);	write('                 .');
	gotoxy(x,y+1);	write('                 .');
	gotoxy(x,y+2);	write('                 .       :');
	gotoxy(x,y+3);	write('                 :      .');
	gotoxy(x,y+4);	write('        :..   :  : :  .');
	gotoxy(x,y+5);	write('           ..  ; :: .');
	gotoxy(x,y+6);	write('              ... .. :..');
	gotoxy(x,y+7);	write('             ::: :...');
	gotoxy(x,y+8);	write('         ::.:.:...;; .....');
	gotoxy(x,y+9);	write('      :..     .;.. :;     ..');
	gotoxy(x,y+10);	write('            . :. .  ;.');
	gotoxy(x,y+11);	write('             .: ;;: ;.');
	gotoxy(x,y+12);	write('            :; .BRRRV;');
	gotoxy(x,y+13);	write('               YB BMMMBR');
	gotoxy(x,y+14);	write('              ;BVIMMMMMt');
	gotoxy(x,y+15);	write('        .=YRBBBMMMMMMMB');
	gotoxy(x,y+16);	write('      =RMMMMMMMMMMMMMM;');
	gotoxy(x,y+17);	write('    ;BMMR=VMMMMMMMMMMMV.');
	gotoxy(x,y+18);	write('   tMMR::VMMMMMMMMMMMMMB:');
	gotoxy(x,y+19);	write('  tMMt ;BMMMMMMMMMMMMMMMB.');
	gotoxy(x,y+20);	write(' ;MMY ;MMMMMMMMMMMMMMMMMMV');
	gotoxy(x,y+21);	write(' XMB .BMMMMMMMMMMMMMMMMMMM:');
	gotoxy(x,y+22);	write(' BMI +MMMMMMMMMMMMMMMMMMMMi');
	gotoxy(x,y+23);	write('.MM= XMMMMMMMMMMMMMMMMMMMMY');
	gotoxy(x,y+24);	write(' BMt YMMMMMMMMMMMMMMMMMMMMi');

END;

procedure dinamita(x,y,color,fondo:byte);
BEGIN
	gotoxy(x,y);	write('                                                         c=====e');
	gotoxy(x,y+1);	write('                                                            H');
	gotoxy(x,y+2);	write('   ____________                                         _,,_H_');
	gotoxy(x,y+3);	write('  (__((__((___()                                       //|     |');
	gotoxy(x,y+4);	write(' (__((__((___()()_____________________________________// |ACME |');
	gotoxy(x,y+5);	write('(__((__((___()()()------------------------------------"  |_____|');
END;

procedure menu(col,ln,fondo,letra,fondosel,letrasel:byte;menu:string; var ind:byte);
var
   p:byte;
   opciones,opcion:string;
   cont,colorfondo,colorletra,x,y:byte;
   tecla:char;
begin
	ind:=1;
     opciones:=menu; x:=col; y:=ln-1;
     repeat
           cont:=0;
           repeat
                 cont:=cont+1;
                 y:=y+1;
                 if (y+1-ln=ind) then
                    begin
                         colorfondo:=fondosel; colorletra:=letrasel;
                    end;
                 p:=pos(',',opciones);
                 if (p=0) then
                    opcion:=opciones
                 else
                     begin
                          opcion:=copy(opciones,1,p-1);
                          delete(opciones,1,p);
                     end;
                 gotoxy(x,y);textbackground(colorfondo);textcolor(colorletra);
                 writeln(opcion);
                 colorfondo:=fondo; colorletra:=letra;
           until(p=0);
           y:=ln-1; opciones:=menu;
           tecla:=readkey;
           case tecla of
                DOWN:if (ind < cont) then ind:=ind+1;
                UP:if (ind <> 1) then ind:=ind-1;
           end;
     until(tecla=ENTER);
end;

procedure about_page(colorfondo,colorletra,colorbordes,colorletrasbordes:byte; caracterbordes:char);
BEGIN
	recuadro(31,9,7,19,colorbordes,colorletrasbordes,caracterbordes);
	cuadro_relleno(32,10,5,17,colorfondo);
	textcolor(colorletra); textbackground(colorfondo);
	gotoxy(32,10); write('Franco Colmenarez');
	gotoxy(32,11); write('C.I:25.896.369');
	gotoxy(32,12); write('Trayecto 1');
	gotoxy(32,13); write('Sección B');
	gotoxy(32,14); write('Septiembre 2015');
END;

procedure paleta_colores(x,y:byte);
var i:byte;
BEGIN
	for i:=0 to 15 do
	begin
		textbackground(i);
		gotoxy(x+i,y); write(' ')
	end;
	textbackground(black);textcolor(lightgray);
END;

procedure valor(cad:string; var err:byte; var numero:longint);
var
	c:string;
	m,num:byte;
BEGIN
	m:=1;
	num:=0;
	repeat
		c:=copy(cad,length(cad),1);
		err:=pos(c,cad);
		if (c='1') or(c='2') or(c='3') or(c='4') or(c='5') or(c='6') or(c='7') or(c='8') or(c='9') or(c='0') then
		begin
			case c[1] of
				'1': num:=num+(1*m);
				'2': num:=num+(2*m);
				'3': num:=num+(3*m);
				'4': num:=num+(4*m);
				'5': num:=num+(5*m);
				'6': num:=num+(6*m);
				'7': num:=num+(7*m);
				'8': num:=num+(8*m);
				'9': num:=num+(9*m);
				'0': num:=num*10;
			end;
			m:=10;
			delete(cad,length(cad),1);
		end
		else
			writeln('Caracter erroneo: ');
	until cad='';
	numero:=num;
END;

procedure mostrar_tablero(x,y,color_fondo,color_lineas,TamanioX,TamanioY:byte);
var
	i,j:byte;
	linea_divisora,ficha:boolean;
BEGIN
	textbackground(color_fondo); textcolor(color_lineas);
	linea_divisora:=false; ficha:=true;
	for j:=y to (y+((TamanioY*2)-1)) do
	begin
		for i:=x to (x+((TamanioX*2)-1)) do
		begin
			gotoxy(i,j);
			if linea_divisora then
			begin
				if ficha then
					write('-')
				else
					write('+');
			end
			else
				if ficha then
					write(' ')
				else
					write('|');
			case ficha of
				true: ficha:=false;
				false: ficha:=true;
			end;
		end;
		case linea_divisora of
			false: linea_divisora:=true;
			true: linea_divisora:=false;
		end;
		ficha:=true;
	end;
END;
END.
