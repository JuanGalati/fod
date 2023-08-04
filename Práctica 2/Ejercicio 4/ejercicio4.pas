
Program ejercicio4;

{$CODEPAGE UTF8}

Uses crt, sysUtils;

Const 
  RUTA_TEMP = './var/temp/';
  RUTA_LOGS = './var/logs/log.txt';

  C_MAQUINAS = 5;

Type 
  TFecha = Integer;

  TSesion = Record
    Codigo: Integer;
    Fecha: TFecha;
    TiempoDeSesion: Integer;
  End;

  fo_TSesion = file Of TSesion;
  a_TSesion = Array[1..C_MAQUINAS] Of TSesion;
  a_fo_TSesion = Array[1..C_MAQUINAS] Of fo_TSesion;

{* DATOS SIMPLES *}
{* TSesion *}
Procedure Imprimir(dato: TSesion);
Begin
  With dato Do
    WriteLn(Codigo, ' ', Fecha, ' ', TiempoDeSesion)
End;

{* ARCHIVOS *}
{* Text *}
Procedure Leer(Var archivo: Text; dato: TSesion);
Begin
  If (Not EOF(archivo)) Then
    With dato Do
      ReadLn(archivo, Codigo, Fecha, TiempoDeSesion);
End;
Procedure Escribir(Var archivo: Text; dato: TSesion);
Begin
  With dato Do
    WriteLn(archivo, Codigo, ' ', Fecha, ' ', TiempoDeSesion);
End;
Procedure Imprimir(Var archivo: Text);

Var 
  dato: TSesion;
Begin
  Leer(archivo, dato);
  With dato Do
    While (Not Codigo = MAXINT) Do
      Begin
        Imprimir(dato);
        Leer(archivo, dato);
      End;
End;

{* fo_TSesion *}
Procedure Leer(Var archivo: fo_TSesion; Var dato: TSesion);
Begin
  If (Not EOF(archivo)) Then
    Read(archivo, dato);
End;
Procedure Escribir(Var archivo: fo_TSesion; Var dato: TSesion);
Begin
  Write(archivo, dato);
End;
Procedure Imprimir(Var archivo: fo_TSesion);

Var 
  dato: TSesion;
Begin
  Reset(archivo);

  Leer(archivo, dato);
  With dato Do
    While (Not Codigo = MAXINT) Do
      Begin
        Imprimir(dato);
        Leer(archivo, dato);
      End;
  Close(Archivo);
End;

Procedure PresioneEnter;
Begin
  Write('Presione ENTER para continuar');
  ReadLn;
End;

{* ARREGLOS *}
{* a_TSesion *}
Procedure Imprimir(datos: a_TSesion);

Var 
  i: Integer;
Begin
  For i := 1 To Length(datos) Do
    Imprimir(datos[i]);
End;

{* a_fo_TSesion *}
Procedure Leer(Var archivos: a_fo_TSesion; Var datos: a_TSesion);

Var 
  i: Integer;
Begin
  For i := 1 To Length(datos) Do
    Leer(archivos[i], datos[i]);
End;

Procedure Imprimir(Var archivos: a_fo_TSesion);

Var 
  i: Integer;
Begin
  For i := 1 To Length(archivos) Do
    Begin
      WriteLn('Archivo', i);
      Imprimir(archivos[i]);
      WriteLn;
    End;
End;

{* Otras operaciones *}
Function MismoUsuario(Usuario1, Usuario2: TSesion): Boolean;
Begin
  MismoUsuario := Usuario1.Codigo = Usuario2.Codigo;
End;

Function MismaFecha(Fecha1: TFecha; Fecha2: TFecha): Boolean;
Begin
  MismaFecha := Fecha1 = Fecha2;
End;

Procedure Minimo(archivos: a_fo_TSesion; Var datos: a_TSesion; Var resultado:
                 TSesion);
Begin
End;
Procedure GenerarMaestro(Var archivo: Text; archivos: a_fo_TSesion);

Var 
  i : Integer;
  datos : a_TSesion;
  min, total: TSesion;
Begin
  Rewrite(archivo);
  For i:= 1 To Length(archivos) Do
    Begin
      Reset(archivos[i]);
      Leer(archivos[i], datos[i]);
    End;

  Minimo(archivos, datos, min);
  While (Not min.Codigo = MAXINT) Do
    Begin
      total := min;
      total.TiempoDeSesion := 0;

      While ((min.Codigo = total.Codigo) And mismaFecha(min.Fecha, total.Fecha))
        Do
        Begin
          total.TiempoDeSesion := total.TiempoDeSesion + min.TiempoDeSesion;

          Minimo(archivos, datos, min);
        End;

      Escribir(archivo, total);
    End;

  Close(archivo);
  For i:= 1 To Length(archivos) Do
    Begin
      Close(archivos[i]);
    End;


End;

Var 
  maestro: Text;
  detalles: a_fo_TSesion;

  i : Integer;
Begin
  Assign(maestro, RUTA_LOGS);
  For i:= 1 To Length(a_fo_TSesion) Do
    Assign(detalles[i], RUTA_TEMP + 'temp' + IntToStr(i) + '.dat');

  Imprimir(detalles);

  GenerarMaestro(maestro, detalles);
  Imprimir(maestro);

  PresioneEnter;
End.
