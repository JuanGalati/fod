
{
  Realizar un algoritmo que, utilizando el archivo de números enteros no 
  ordenados creados en el ejercicio 1:
  [X] Informe por pantalla cantidad de números menores a 1500 
      y el promedio de los números ingresados. 
  [X] El nombre del archivo a procesar debe ser proporcionado por el usuario
      una única vez. 
  [X] Además, el algoritmo deberá listar el contenido del archivo en pantalla.  
}

Program ejercicio2;

Type 
  t_archivo = file Of Integer;
  t_nombreFisico = String[50];

Procedure InformarPorPantalla(Var NombreLogico: t_archivo);

Var 
  numero: Integer;
Begin
  Reset(NombreLogico);

  While (Not Eof(NombreLogico)) Do
    Begin
      Read(NombreLogico, numero);
      Write(numero, ' ');
    End;

  Close(NombreLogico);
End;

Procedure Promedio(Var NombreLogico: t_archivo);

Var 
  numero: Integer;
  suma: Integer;
Begin
  Reset(NombreLogico);
  suma := 0;

  While (Not Eof(NombreLogico)) Do
    Begin
      Read(NombreLogico, numero);
      suma := suma + numero;

    End;

  WriteLn('El promedio es: ', suma / fileSize(NombreLogico): 0: 2);

  Close(NombreLogico);
End;

Procedure MenoresQue(Var NombreLogico: t_archivo; n: Integer);

Var 
  numero: Integer;
  cantidad: Integer;
Begin
  Reset(NombreLogico);
  cantidad := 0;

  While (Not Eof(NombreLogico)) Do
    Begin
      Read(NombreLogico, numero);
      If (numero < n) Then
        Begin
          cantidad := cantidad + 1;
        End;
    End;

  WriteLn('La cantidad de numeros menores a ', n, ' es: ', cantidad,
          ' (de un total de ', fileSize(NombreLogico), ')');

  Close(NombreLogico);
End;

Var 
  NombreLogico: t_archivo;
  NombreFisico: t_nombreFisico;

  numero: Integer;
Begin
  Write('Ingrese el nombre del archivo: ');
  readln(nombreFisico);
  Assign(NombreLogico, NombreFisico);

  InformarPorPantalla(NombreLogico);
  Promedio(NombreLogico);
  MenoresQue(NombreLogico, 3)
End.
