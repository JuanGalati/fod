
{
  Agregar al menú del programa del ejercicio 3, opciones para:

  [X] a. Añadir uno o más empleados al final del archivo con sus datos 
         ingresados por teclado. 
         Tener en cuenta que no se debe agregar al archivo un empleado
         con un número de empleado ya registrado (control de unicidad).
  [X] b. Modificar edad a uno o más empleados.
  [X] c. Exportar el contenido del archivo a un archivo de texto llamado 
         “todos_empleados.txt”.
  [X] d. Exportar a un archivo de texto llamado: “faltaDNIEmpleado.txt”, 
         los empleados que no tengan cargado el DNI (DNI en 00).

  NOTA: Las búsquedas deben realizarse por número de empleado.
}

Program ejercicio4;
{$codepage utf-8}

Uses crt;

Const 
  NULO = '###';
  FIN = 'fin';

Type 
  str = string[25];

  t_Empleado = Record
    numero: integer;
    nombre: str;
    apellido: str;
    dni: string[10];
    edad: integer;
  End;

  t_Archivo = File Of t_Empleado;

Procedure PresioneEnter();
Begin
  WriteLn;
  WriteLn('Presione ENTER para continuar.');
  ReadLn;
End;

Procedure Leer(Var archivo: t_Archivo; Var empleado: t_Empleado);
Begin
  If (Not EOF(archivo))
    Then read(archivo, empleado)
  Else empleado.apellido := NULO
End;

Procedure ElegirArchivo(Var archivo: t_Archivo);

Var 
  NombreFisico: str;
Begin
  clrScr;
  Write('Ingrese el nombre del archivo: ');
  Readln(NombreFisico);
  Assign(archivo, NombreFisico);
End;

Procedure ElegirArchivo(Var archivo: text);

Var 
  NombreFisico: str;
Begin
  clrScr;
  Write('Ingrese el nombre del archivo: ');
  Readln(NombreFisico);
  Assign(archivo, NombreFisico);
End;

Procedure ImprimirEmpleado(empleado: t_Empleado);
Begin

  With empleado Do
    Begin
      WriteLn('', nombre, ' ', apellido);
      WriteLn('Número: ', numero);
      WriteLn('DNI: ', dni);
      WriteLn('Edad: ', edad)
    End;
End;

Procedure CargarEmpleado(Var empleado: t_Empleado);

Begin
  ClrScr;
  WriteLn('Ingrese los datos del empleado: ');
  WriteLn;

  Write('Apellido: ');
  Readln(empleado.apellido);

  If (empleado.apellido <> FIN) Then
    Begin
      Write('Nombre: ');
      Readln(empleado.nombre);

      Write('DNI: ');
      Readln(empleado.dni);

      Write('Edad: ');
      Readln(empleado.edad);
    End;
End;

Procedure CrearArchivoDeEmpleados();

Var 
  archivo: t_Archivo;
  empleado: t_Empleado;
  numero: Integer;
Begin
  clrScr;

  ElegirArchivo(archivo);
  Rewrite(archivo);

  numero := fileSize(archivo);

  Repeat
    CargarEmpleado(empleado);

    If (empleado.apellido <> FIN)
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

  Until (empleado.apellido = FIN);

  ClrScr;

  WriteLn;
  WriteLn('Archivo de Empleados creado correctamente.');

  PresioneEnter;

  Close(Archivo);
End;

Procedure BuscarEmpleado(Var archivo: t_Archivo);

Var 
  empleado: t_Empleado;
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
          ImprimirEmpleado(empleado);
          WriteLn;
        End;
    End;

  PresioneEnter;

  Close(Archivo);
End;

Procedure ListarEmpleados(Var archivo: t_Archivo);

Var 
  empleado: t_Empleado;
Begin
  clrScr;
  Reset(Archivo);

  WriteLn('Empleados: ');
  WriteLn;

  While (Not EOF(archivo)) Do
    Begin
      Read(archivo, empleado);
      ImprimirEmpleado(empleado);
      WriteLn;
    End;

  PresioneEnter;

  Close(Archivo);
End;

Procedure ListarMayoresDe70(Var archivo: t_Archivo);

Var 
  empleado: t_Empleado;
Begin
  clrScr;
  Reset(Archivo);

  While (Not EOF(archivo)) Do
    Begin
      Read(archivo, empleado);

      If (empleado.edad > 70) Then
        Begin
          ImprimirEmpleado(empleado);
          WriteLn;
        End;
    End;

  PresioneEnter;

  Close(Archivo);
End;

Procedure AgregarEmpleados(Var archivo: t_Archivo);

Var 
  empleado: t_Empleado;
  numero: Integer;
Begin
  Reset(Archivo);

  numero := fileSize(archivo);

  Seek(archivo, fileSize(Archivo));

  Repeat
    CargarEmpleado(empleado);

    If (empleado.apellido <> FIN) Then
      Begin
        empleado.numero := numero;
        Write(archivo, empleado);
        numero := numero + 1;

        WriteLn('Empleado agregado con éxito.');
        WriteLn;
        WriteLn('Presione ENTER para agregar un nuevo empleado.');
        ReadLn;
      End;

  Until (empleado.apellido = FIN);

  PresioneEnter;

  Close(Archivo);
End;

Procedure ModificarEdad(Var archivo: t_Archivo);

Var 
  empleado: t_Empleado;
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
        Or (empleado.apellido = NULO)
        );

  If (Not (empleado.apellido = NULO)) Then
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


Procedure ExportarATodosEmpleados(Var archivo: t_Archivo);

Var 
  archivoTexto: Text;
  empleado: t_empleado;
Begin
  ClrScr;

  Reset(archivo);

  Assign(archivoTexto, 'todosEmpleados.txt');
  Rewrite(archivoTexto);

  While (Not EOF(archivo)) Do
    Begin
      read(archivo, empleado);

      With empleado Do
        Begin
          WriteLn(archivoTexto, numero, ' ', edad, ' ', dni);
          WriteLn(archivoTexto, nombre);
          WriteLn(archivoTexto, apellido);
        End;
    End;

  Close(archivo);
  Close(archivoTexto);
End;

Procedure ImprimirDesdeTodosEmpleados();

Var 
  archivoTexto: Text;
  empleado: t_Empleado;
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
      ImprimirEmpleado(empleado);
      WriteLn;
    End;

  PresioneEnter;

  Close(archivoTexto);

End;

Procedure ExportarAFaltaDNIEmpleado(Var archivo: t_Archivo);

Var 
  empleado: t_Empleado;
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
  Until (empleado.apellido = NULO);

  Close(archivoTexto);
  Close(archivo);

End;

Procedure AbrirArchivoDeEmpleados();

Var 
  opcion: Char;
  salir: Boolean;
  archivo: t_Archivo;

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
      WriteLn('6. Exportar a todosEmpleados.txt.');
      WriteLn('7. Exportar a empleadosSinDNI.txt.');
      WriteLn('8. Imprimir desde todosEmpleados.txt.');
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

        '6': ExportarATodosEmpleados(archivo);
        '7': ExportarAFaltaDNIEmpleado(archivo);
        '8': ImprimirDesdeTodosEmpleados();

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
        '1': CrearArchivoDeEmpleados();
        '2': AbrirArchivoDeEmpleados();
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
