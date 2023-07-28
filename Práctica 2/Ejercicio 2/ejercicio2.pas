
(* 
    2. Se dispone de un archivo con información de los alumnos de la Facultad 
    de Informática.
    
    Por cada alumno se dispone de su 
        código de alumno, 
        apellido, 
        nombre, 
        cantidad de materias (cursadas) aprobadas sin final 
        cantidad de materias con final aprobado. 
        
    Además, se tiene un archivo detalle con
        el código de alumno e información correspondiente a una materia (esta 
        información indica si aprobó la cursada o aprobó el final). 
        
        Todos los archivos están ordenados por código de alumno y en el archivo
        detalle puede haber 0, 1 ó más registros por cada alumno del archivo 
        maestro. 
        
        Se pide realizar un programa con opciones para: 
        [X] a. Actualizar el archivo maestro de la siguiente manera: 
            [X] i. Si aprobó el final se incrementa en uno la cantidad de 
            materias con final aprobado. 
            [X] ii. Si aprobó la cursada se incrementa en uno la cantidad de 
            materias aprobadas sin final. 
        [X] b. Listar en un archivo de texto los alumnos que tengan más de 
            cuatro materias con cursada aprobada pero no aprobaron el final. 
            Deben listarse todos los campos. 
            
    NOTA: Para la actualización del inciso a) los archivos deben ser recorridos
    sólo una vez. 

    Precondiciones:
        Existe un archivo detalle, ordenado.
        Existe un archivo maestro, ordenado.
        El archivo detalle y el archivo maestro están ordenados por el mismo 
        criterio.

        El archivo maestro contiene información de TODOS los alumnos (si existe
        en el detalle, seguro existe en el maestro).
        El archivo maestro puede ser modificado por 0, 1 o más registros del 
        archivo detalle.

        Los archivos deben recorrerse una sola vez.

    Notas:
        t_  = Type ...
        fo_ = File of ...
        
        c_  = Cantidad de ...
*)

Program ejercicio2;
{$codepage utf-8}

Uses crt;

Const 
  NULO = MAXINT * -1;

  ARCHIVO_ALUMNOS = 'alumnos.dat';
  ARCHIVO_APROBADOS = 'aprobados.dat';
  ARCHIVO_CURSADAS_SIN_FINAL = 'cursadasSinFinal.txt';

  MATERIAS_SIN_FINAL = 4;

Type 
  str = String[25];

  t_Alumno  = Record
    Codigo    : integer;
    Apellido  : str;
    Nombre    : str;
    c_AprobadasSinFinal : integer;
    c_AprobadasConFinal : integer;
  End;

  t_Aprobado  = Record
    codigo  : integer;
    conFinal      : Boolean;
  End;

  fo_Alumnos    = file Of t_Alumno;
  fo_Aprobados  = file Of t_Aprobado;

Procedure PresioneEnter;
Begin
  WriteLn;
  Write('Presione Enter para continuar.');
  ReadLn;
End;

Procedure Leer(Var archivo: fo_alumnos; Var dato: t_Alumno);
Begin
  If (Not EOF(archivo))
    Then read(archivo, dato)
  Else dato.codigo := NULO;
End;

Procedure Leer(Var archivo: fo_aprobados; Var dato: t_Aprobado);
Begin
  If (Not EOF(archivo))
    Then read(archivo, dato)
  Else dato.codigo := NULO;
End;

Procedure Leer(Var archivo: Text; Var dato: t_Alumno);
Begin
  With dato Do
    Begin
      ReadLn(archivo, codigo, c_AprobadasSinFinal, c_AprobadasConFinal,
             Apellido);
      ReadLn(archivo, Nombre);
    End;
End;

Procedure Imprimir(dato: t_Alumno);
Begin
  WriteLn(dato.codigo:2, '  | ',
          dato.apellido, ' ',
          dato.nombre, ' | ',
          dato.c_AprobadasSinFinal:2, '  | ',
          dato.c_AprobadasConFinal:2
  );
End;

Procedure Imprimir(dato: t_Aprobado);
Begin
  WriteLn(dato.codigo:2, ' | ', dato.conFinal);
End;

Procedure Escribir(Var destino: Text; dato: t_Alumno);
Begin
  WriteLn(destino,
          dato.codigo, ' ',
          dato.c_AprobadasSinFinal, ' ',
          dato.c_AprobadasConFinal, ' ',
          dato.apellido);
  WriteLn(destino, dato.nombre)
End;

Procedure CrearDetalle(Var detalle: fo_Aprobados);

Var 
  aprobado: t_Aprobado;
  i, j: integer;
Begin
  Rewrite(detalle);
  Seek(detalle, 0);

  For i := 0 To 10 Do
    Begin
      If ((Random(4) = 0))
        Then WriteLn('Skip: ', i)
      Else
        Begin
          For j := 0 To Random(10) Do
            Begin
              aprobado.codigo := i;
              aprobado.conFinal := (Random(2) = 1);

              Write(detalle, aprobado);
            End;
        End;
    End;

  Close(detalle);
  PresioneEnter;
End;

Procedure ImprimirDetalle(Var detalle: fo_Aprobados);

Var 
  aprobado: t_Aprobado;
Begin
  ClrScr;
  Reset(detalle);

  Leer(detalle, aprobado);
  While (aprobado.codigo <> NULO) Do
    Begin
      Imprimir(aprobado);
      Leer(detalle, aprobado);
    End;

  Close(detalle);
  PresioneEnter;
End;

Procedure CrearMaestro(Var maestro: fo_Alumnos);

Var 
  alumno: t_Alumno;
  i : integer;
Begin
  Rewrite(maestro);

  For i := 0 To 10 Do
    Begin
      alumno.codigo := i;

      alumno.Apellido := Chr(ord('A') + i);
      alumno.Nombre := Chr(ord('a') + i);

      alumno.c_AprobadasSinFinal := 0;
      alumno.c_AprobadasConFinal := 0;

      write(maestro, alumno);
    End;

  Close(maestro);
End;

Procedure ImprimirMaestro(Var maestro: fo_Alumnos);

Var 
  alumno: t_alumno;
Begin
  ClrScr;
  Reset(maestro);

  Leer(maestro, alumno);
  While (alumno.codigo <> NULO) Do
    Begin
      Imprimir(alumno);
      Leer(maestro, alumno);
    End;

  Close(maestro);
  PresioneEnter;
End;

Procedure ActualizarMaestro(Var maestro: fo_Alumnos; Var detalle: fo_Aprobados
);

Var 
  alumno: t_Alumno;
  aprobado: t_Aprobado;
Begin
  ClrScr;

  Reset(maestro);
  Reset(detalle);

  Leer(detalle, aprobado);
  While (aprobado.codigo <> NULO) Do
    Begin

      Leer(maestro, alumno);
      While (alumno.codigo <> aprobado.codigo) Do
        Leer(maestro, alumno);

      While (alumno.codigo = aprobado.codigo) Do
        Begin
          If (aprobado.conFinal)
            Then alumno.c_AprobadasConFinal := alumno.c_AprobadasSinFinal + 1
          Else alumno.c_AprobadasSinFinal :=  alumno.c_AprobadasSinFinal + 1;

          Leer(detalle, aprobado);
        End;

      Seek(maestro, FilePos(maestro) - 1);
      Write(maestro, alumno);
    End;

  Close(maestro);
  Close(detalle);
End;

Procedure ExportarDesde(Var origen: fo_alumnos; Var destino: Text);

Var 
  alumno: t_Alumno;
Begin
  ClrScr;

  Reset(origen);
  Rewrite(destino);

  Leer(origen, alumno);
  While (alumno.codigo <> NULO) Do
    Begin
      If (alumno.c_AprobadasSinFinal > MATERIAS_SIN_FINAL) Then
        Escribir(destino, alumno);
      Leer(origen, alumno);
    End;

  Close(origen);
  Close(destino);

  PresioneEnter;
End;

Procedure ImprimirSinFinal(Var sinFinal: Text);

Var 
  alumno: t_Alumno;
Begin
  ClrScr;

  Reset(SinFinal);

  While (Not EOF(sinFinal)) Do
    Begin
      Leer(sinFinal, alumno);
      Imprimir(alumno);
    End;
  Close(SinFinal);
  PresioneEnter;
End;

Procedure Test(Var maestro: fo_Alumnos;
               Var detalle: fo_Aprobados;
               Var sinFinal: Text);
Begin
  clrScr;
  CrearMaestro(maestro);
  ImprimirMaestro(maestro);

  CrearDetalle(detalle);
  ImprimirDetalle(detalle);

  ActualizarMaestro(maestro, detalle);
  ActualizarMaestro(maestro, detalle);
  ActualizarMaestro(maestro, detalle);
  ActualizarMaestro(maestro, detalle);

  ExportarDesde(maestro, sinFinal);
  ImprimirSinFinal(sinFinal);
End;

Var 
  opc : char;
  salir : Boolean;

  maestro: fo_Alumnos;
  detalle: fo_Aprobados;
  sinFinal: Text;
Begin
  Randomize;

  Assign(maestro, ARCHIVO_ALUMNOS);
  Assign(detalle, ARCHIVO_APROBADOS);
  Assign(sinFinal, ARCHIVO_CURSADAS_SIN_FINAL);

  salir := false;
  While (Not salir) Do
    Begin
      ClrScr;

      WriteLn('Seleccione una opción: ');
      WriteLn('1. Actualizar archivo ', ARCHIVO_ALUMNOS);
      WriteLn('2. Exportar alumnos con ', MATERIAS_SIN_FINAL,
              ' o más materias sin final.');
      WriteLn;
      WriteLn('0. Salir.');

      WriteLn;

      Write('> ');
      ReadLn(opc);

      Case opc Of 
        '1': ActualizarMaestro(maestro, detalle);
        '2': ExportarDesde(maestro, sinFinal);

        'a': CrearDetalle(detalle);
        'b': ImprimirDetalle(detalle);
        'c': CrearMaestro(maestro);
        'd': ImprimirMaestro(maestro);
        'e': ImprimirSinFinal(sinFinal);

        't': Test(maestro, detalle, sinFinal);

        '0': salir := true

             Else
               Begin
                 WriteLn('ERROR: Opcion invalida.');
                 PresioneEnter;
               End;
      End;
    End;
End.
