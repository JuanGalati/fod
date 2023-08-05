
Program ejercicio1;
{$CODEPAGE UTF8}

Uses crt, sysutils;

Const 
  CONDICION_DE_CORTE = 'fin';

  VALOR_NULO = '###';

Type 
  Str = string[25];

  TEmpleado = Record
    numero: integer;
    nombre: str;
    apellido: str;
    dni: string[10];
    edad: integer;
  End;

  fo_TEmpleado = File Of TEmpleado;

{* General *}
Procedure PresioneEnter;
Begin
  WriteLn('Presione ENTER para continuar.');
  ReadLn;
End;

Procedure _ElegirArchivo(Var NombreFisico: Str);
Begin
  clrScr;
  Write('Ingrese el nombre del archivo: ');
  Readln(NombreFisico);
End;

{* TEmpleado *}
Procedure Cargar(Var empleado: TEmpleado);

Begin
  ClrScr;
  WriteLn('Ingrese los datos del empleado: ');
  WriteLn;

  Write('Apellido: ');
  Readln(empleado.apellido);

  If (empleado.apellido <> CONDICION_DE_CORTE) Then
    Begin
      Write('Nombre: ');
      Readln(empleado.nombre);

      Write('DNI: ');
      Readln(empleado.dni);

      Write('Edad: ');
      Readln(empleado.edad);
    End;
End;

Procedure Imprimir(Empleado: TEmpleado);
Begin

  With empleado Do
    Begin
      WriteLn(nombre, ' ', apellido);
      WriteLn('Número: ', numero);
      WriteLn('DNI: ', dni);
      WriteLn('Edad: ', edad)
    End;
End;


{* fo_TEmpleado *}
Procedure Leer(Var archivo: fo_TEmpleado; Var dato: TEmpleado);
Begin
  If (Not EOF(archivo))
    Then read(archivo, dato)
  Else dato.apellido := VALOR_NULO
End;

Procedure ElegirArchivo(Var archivo: fo_TEmpleado);

Var 
  NombreFisico: str;
Begin
  _ElegirArchivo(NombreFisico);
  Assign(archivo, NombreFisico);
End;

Procedure CrearArchivo;

Var 
  archivo: fo_TEmpleado;
  empleado: TEmpleado;
  numero: Integer;
Begin
  clrScr;

  ElegirArchivo(archivo);
  Rewrite(archivo);

  numero := fileSize(archivo);

  Repeat
    Cargar(empleado);

    If (empleado.apellido <> CONDICION_DE_CORTE)
      Then
      Begin
        empleado.numero := numero;
        Write(archivo, empleado);
        numero := numero + 1;

        WriteLn('Empleado cargado con éxito.');
        WriteLn;
        WriteLn('Presione ENTER para agregar un nuevo empleado.');
        Read;
      End;

  Until (empleado.apellido = CONDICION_DE_CORTE);

  ClrScr;

  WriteLn;
  WriteLn('Archivo de Empleados creado correctamente.');

  WriteLn;
  PresioneEnter;

  Close(Archivo);
End;


Procedure BuscarEmpleado(Var archivo: fo_TEmpleado);

Var 
  empleado: TEmpleado;
  query: str;
Begin
  clrScr;
  Reset(Archivo);

  Write('Ingrese el nombre o apellido a buscar: ');
  ReadLn(query);

  While (Not EOF(archivo)) Do
    Begin
      Read(archivo, empleado);

      If (empleado.nombre = query) Or (empleado.apellido = query)
        Then
        Begin
          Imprimir(empleado);
          WriteLn;
        End;
    End;

  PresioneEnter;

  Close(Archivo);
End;

Procedure ListarEmpleados(Var archivo: fo_TEmpleado);

Var 
  empleado: TEmpleado;
Begin
  clrScr;
  Reset(Archivo);

  WriteLn('Empleados: ');
  WriteLn;

  While (Not EOF(archivo)) Do
    Begin
      Read(archivo, empleado);
      Imprimir(empleado);
      WriteLn;
    End;

  PresioneEnter;

  Close(Archivo);
End;

Procedure ListarMayoresDe70(Var archivo: fo_TEmpleado);

Var 
  empleado: TEmpleado;
Begin
  clrScr;
  Reset(Archivo);

  While (Not EOF(archivo)) Do
    Begin
      Read(archivo, empleado);

      If (empleado.edad > 70) Then
        Begin
          Imprimir(empleado);
          WriteLn;
        End;
    End;

  PresioneEnter;

  Close(Archivo);
End;

Procedure AgregarEmpleados(Var archivo: fo_TEmpleado);

Var 
  empleado: TEmpleado;
  numero: Integer;
Begin
  Reset(Archivo);

  numero := fileSize(archivo);

  Seek(archivo, fileSize(Archivo));

  Repeat
    Cargar(empleado);

    If (empleado.apellido <> CONDICION_DE_CORTE) Then
      Begin
        empleado.numero := numero;
        Write(archivo, empleado);
        numero := numero + 1;

        WriteLn('Empleado agregado con éxito.');
        WriteLn;
        WriteLn('Presione ENTER para agregar un nuevo empleado.');
        ReadLn;
      End;

  Until (empleado.apellido = CONDICION_DE_CORTE);

  PresioneEnter;

  Close(Archivo);
End;

Procedure ModificarEdad(Var archivo: fo_TEmpleado);

Var 
  empleado: TEmpleado;
  query: str;
Begin

  Reset(archivo);

  WriteLn('Ingrese el nombre o apellido del empleado a modificar: ');
  Write('> ');
  ReadLn(query);

  Repeat
    Leer(archivo, empleado);
  Until (
        (empleado.nombre = query)
        Or (empleado.apellido = query)
        Or (empleado.apellido = VALOR_NULO)
        );

  If (Not (empleado.apellido = VALOR_NULO)) Then
    Begin
      WriteLn('Ingrese la edad del empleado:');
      Write('> ');
      ReadLn(empleado.edad);

      Seek(archivo, FilePos(archivo) - 1);
      Write(archivo, empleado);

      WriteLn('Edad del empleado modificada con éxito.');
    End
  Else
    WriteLn('Empleado no encontrado.');

  PresioneEnter;

  Close(archivo);
End;

Procedure ExportarATodosEmpleados(Var archivo: fo_TEmpleado);

Var 
  archivoTexto: Text;
  empleado: TEmpleado;
Begin
  ClrScr;

  Reset(archivo);

  Assign(archivoTexto, 'todosEmpleados.txt');
  Rewrite(archivoTexto);

  While (Not EOF(archivo)) Do
    Begin
      read(archivo, empleado);

      With Empleado Do
        Begin
          WriteLn(archivoTexto, numero, ' ', edad, ' ', dni);
          WriteLn(archivoTexto, nombre);
          WriteLn(archivoTexto, apellido);
        End;
    End;

  Close(archivo);
  Close(archivoTexto);
End;

Procedure EliminarEmpleado(Var archivo: fo_TEmpleado);

Var 
  Empleado : TEmpleado;
  Pos : Integer;
  Query : Str;
Begin
  Reset(archivo);

  Write('Ingrese el nombre o apellido a buscar: ');
  ReadLn(Query);

  WriteLn('Buscando empleado...');
  While ((Not EOF(archivo))
        And (Query <> Empleado.apellido)
        And (Query <> Empleado.nombre)) Do
    Read(Archivo, Empleado);

  If (empleado.nombre = query) Or (empleado.apellido = query) Then
    Begin
      WriteLn('Empleado encontrado.');
      WriteLn('Eliminando Empleado...');
      Pos := FilePos(archivo) - 1;

      Seek(archivo, FileSize(archivo) - 1);
      Read(archivo, Empleado);

      Seek(archivo, Pos);
      Write(archivo, Empleado);

      Seek(archivo, FileSize(archivo) - 1);
      Truncate(archivo);

      WriteLn('Empleado eliminado con éxito.');
    End
  Else
    WriteLn('Empleado no encontrado.');

  PresioneEnter;

  Close(Archivo);
End;

{* Text *}
Procedure ElegirArchivo(Var archivo: text);

Var 
  NombreFisico: str;
Begin
  _ElegirArchivo(NombreFisico);
  Assign(archivo, NombreFisico);
End;

Procedure ImprimirDesdeTodosEmpleados();

Var 
  archivoTexto: Text;
  empleado: TEmpleado;
Begin
  ClrScr;

  Assign(archivoTexto, 'todosEmpleados.txt');
  Reset(archivoTexto);

  While (Not EOF(archivoTexto)) Do
    Begin
      With empleado Do
        Begin
          readLn(archivoTexto, numero, edad, dni);
          readLn(archivoTexto, nombre);
          readLn(archivoTexto, apellido);
        End;
      Imprimir(empleado);
      WriteLn;
    End;

  PresioneEnter;

  Close(archivoTexto);
End;

Procedure ExportarAFaltaDNIEmpleado(Var archivo: fo_TEmpleado);

Var 
  empleado: TEmpleado;
  archivoTexto: Text;
Begin
  Reset(Archivo);

  Assign(archivoTexto, 'sinDNI.txt');
  Rewrite(archivoTexto);

  Repeat
    Leer(archivo, empleado);

    If (empleado.DNI = '00') Then
      With empleado Do
        Begin
          WriteLn(archivoTexto, numero, ' ', edad, ' ', dni);
          WriteLn(archivoTexto, nombre);
          WriteLn(archivoTexto, apellido);
        End;
  Until (empleado.apellido = VALOR_NULO);

  Close(archivoTexto);
  Close(archivo);
End;

{* ---- *}
Procedure AbrirArchivo;

Var 
  opcion: Char;
  salir: Boolean;
  archivo: fo_TEmpleado;

Begin
  salir := false;
  ElegirArchivo(archivo);

  While (Not salir) Do
    Begin
      clrScr;

      WriteLn('Seleccione una opción:');
      WriteLn('1. Buscar empleados por nombre o apellido.');
      WriteLn('2. Listar todos los empleados.');
      WriteLn('3. Listar empleados mayores de 70 años.');
      WriteLn;
      WriteLn('4. Agregar empleados al archivo.');
      WriteLn('5. Modificar edad de un empleado.');
      WriteLn;
      WriteLn('6. Eliminar empleado.');
      WriteLn;
      WriteLn('7. Exportar a todosEmpleados.txt.');
      WriteLn('8. Exportar a empleadosSinDNI.txt.');
      WriteLn('9. Imprimir desde todosEmpleados.txt.');
      WriteLn;
      WriteLn('0. Volver al menú principal.');

      WriteLn;
      Write('> ');
      Readln(opcion);

      Case opcion Of 
        '1': BuscarEmpleado(archivo);
        '2': ListarEmpleados(archivo);
        '3': ListarMayoresDe70(archivo);

        '4': AgregarEmpleados(archivo);
        '5': ModificarEdad(archivo);

        '6': EliminarEmpleado(archivo);

        '7': ExportarATodosEmpleados(archivo);
        '8': ExportarAFaltaDNIEmpleado(archivo);
        '9': ImprimirDesdeTodosEmpleados;

        '0': salir := true;
        Else
          Begin
            WriteLn;
            WriteLn('Opción inválida.');

            PresioneEnter;
          End;
      End;
    End;
End;

Var 
  opcion: Char;
  salir: Boolean;
Begin
  salir := false;

  While (Not salir) Do
    Begin
      clrScr;
      WriteLn('Seleccione una opción:');
      WriteLn('1. Crear archivo de empleados.');
      WriteLn('2. Abrir archivo de empleados.');
      WriteLn;
      WriteLn('0. Salir.');

      WriteLn;
      Write('> ');
      Readln(opcion);

      Case opcion Of 
        '1': CrearArchivo;
        '2': AbrirArchivo;
        '0': salir := true;
        Else
          Begin
            WriteLn;
            WriteLn('Opción inválida.');

            PresioneEnter;
          End;
      End;
    End;

  clrScr;
End.
