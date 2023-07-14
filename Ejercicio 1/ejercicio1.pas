
Program ejercicio1;

Type 
  t_archivo = file Of Integer;
  t_nombreFisico = String[50];

Var 
  NombreLogico: t_archivo;
  NombreFisico: t_nombreFisico;

  numero: Integer;
Begin
  Write('Ingrese el nombre del archivo: ');
  readLn(NombreFisico);

  Assign(NombreLogico, NombreFisico);
  Rewrite(NombreLogico);

  Write('Ingrese numeros al archivo, 0 para terminar');

  WriteLn;
  Write('Ingrese un numero: ');
  read(numero);

  While (numero <> 0) Do
    Begin
      Write(NombreLogico, numero);

      Write('Ingrese un numero: ');
      read(numero);
    End;
  test
  Close(NombreLogico);
End.
