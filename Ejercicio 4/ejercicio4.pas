
Program ejercicio3;
{$codepage utf-8}

Uses crt;

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

Procedure ElegirArchivo(Var archivo: t_Archivo);

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

  WriteLn('Presione ENTER para continuar.');
  ReadLn;

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

  WriteLn('Presione ENTER para continuar.');
  ReadLn;
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

  WriteLn('Presione ENTER para continuar.');
  ReadLn;

  Close(Archivo);
End;

Procedure AgregarEmpleados(Var archivo: t_Archivo);
Begin
End;

Procedure ModificarEdad(Var archivo: t_Archivo);
Begin
End;

Procedure ExportarATodosEmpleados(Var archivo: t_Archivo);
Begin
End;

Procedure ExportarAFaltaDNIEmpleado(Var archivo: t_Archivo);
Begin
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
      WriteLn('6. Exportar a todos los empleados.');
      WriteLn('7. Exportar a los empleados que no tienen DNI.');
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

        '0': salir := true;
        Else
          Begin
            WriteLn;
            WriteLn('Opción inválida. Presione ENTER para continuar.');
            readln;
          End;
      End;
    End;
End;

Procedure CargarEmpleado(Var empleado: t_Empleado);

Begin
  ClrScr;
  WriteLn('Ingrese los datos del empleado: ');
  WriteLn;

  Write('Apellido: ');
  Readln(empleado.apellido);

  If (empleado.apellido <> 'fin') Then
    Begin
      Write('Nombre: ');
      Readln(empleado.nombre);

      Write('Número: ');
      Readln(empleado.numero);

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
Begin
  clrScr;

  ElegirArchivo(archivo);
  Rewrite(archivo);

  Repeat
    CargarEmpleado(empleado);

    If (empleado.apellido <> 'fin')
      Then
      Begin
        WriteLn;
        Write(archivo, empleado);
        WriteLn('Empleado cargado con éxito.');

        Write('Presione ENTER para agregar un nuevo empleado.');
        ReadLn;
      End;

  Until (empleado.apellido = 'fin');

  ClrScr;

  WriteLn;
  WriteLn('Archivo de Empleados creado correctamente.');
  WriteLn('Presione ENTER para continuar.');
  Readln;
  Close(Archivo);
End;

Var 
  opcion: Char;
  salir: Boolean;
Begin
  clrScr;
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
            WriteLn('Opción inválida. Presione ENTER para continuar.');
            readln;
          End;
      End;
    End;

  clrScr;
End.
