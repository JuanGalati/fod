
Program GeneradorDetalles;

{$CODEPAGE UTF8}

Uses crt, SysUtils;

Const 
  RUTA_TEMP = 'var/temp/';

  C_MAQUINAS = 5;

{* Genéricos *}
  RUTA_ARCHIVOS = '../' + RUTA_TEMP;
  NOMBRE_ARCHIVOS = 'temp';
  EXTENSION_ARCHIVOS = '.dat';

  C_DETALLES = C_MAQUINAS;
  C_DETALLES_DATO = 10;

Type 

  TFecha = Integer;

  TSesion = Record
    Codigo: Integer;
    Fecha: TFecha;
    TiempoDeSesion: Integer;
  End;

  {* Genéricos *}
  TDato = TSesion;
  fo_TDato = file Of TSesion;
  a_TDato = Array[1..C_DETALLES] Of TDato;
  a_fo_TDato = Array[1..C_DETALLES] Of fo_TDato;


Procedure PresioneEnter;
Begin
  WriteLn('Presione ENTER para continuar.');
  ReadLn;
End;

{* ESPECÍFICOS *}


Procedure Crear(Var dato: TDato; indice: Integer);
Begin
  With dato Do
    Begin
      Codigo := indice;
      Fecha := indice;
      TiempoDeSesion := Random(1440); {* Minutos en un día *}
    End;
End;

{* GENÉRICOS *}

Procedure Crear(Var archivo: fo_TDato);

Var 
  dato : TDato;
  i : Integer;
Begin
  For i := 1 To Random(C_DETALLES_DATO) Do
    If (Random(100) > 50) Then
      Begin
        Crear(dato, i);
        Write(archivo, dato);
      End;
End;

Procedure Crear(Var archivos: a_fo_TDato);

Var 
  i: Integer;
Begin
  For i:= 1 To C_MAQUINAS Do
    Begin
      Rewrite(archivos[i]);
      Crear(archivos[i]);
      Close(archivos[i]);
    End;
End;

Var 
  detalles: a_fo_TDato;
  i : Integer;
Begin
  Randomize;
  ClrScr;

  For i:= 1 To C_MAQUINAS Do
    Assign(detalles[i],
           RUTA_ARCHIVOS
           + NOMBRE_ARCHIVOS
           + IntToStr(i)
    + EXTENSION_ARCHIVOS
    );

  Crear(detalles);
  PresioneEnter;
End.
