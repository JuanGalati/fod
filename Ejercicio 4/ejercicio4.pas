
Program ejercicio3;
{$codepage utf-8}

Uses crt;

Type 
  t_Empleado = Record
    numero: integer;
    nombre: string;
    apellido: string;
    dni: string;
  End;

  t_Archivo = File Of t_Empleado;

Procedure ElegirArchivo(Var archivo: t_Archivo);

Var 
  NombreFisico: String;
Begin
  clrScr;
  Write('Ingrese el nombre del archivo: ');
  Readln(NombreFisico);
  Assign(archivo, NombreFisico);
End;

Procedure BuscarPor(Var archivo: t_Archivo);
Begin
  clrScr;
  Reset(Archivo);

  Close(Archivo);
End;

Procedure ImprimirEmpleado(empleado: t_Empleado);
Begin

  With empleado Do
    Begin
      WriteLn('', nombre, ' ', apellido);
      WriteLn('Número: ', numero);
      WriteLn('DNI: ', dni);
      WriteLn;
    End;
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
    End;

  WriteLn('Presione ENTER para continuar.');
  ReadLn;
  Close(Archivo);
End;

Procedure ListarMayoresDe70(Var archivo: t_Archivo);
Begin
  clrScr;
  Reset(Archivo);

  Close(Archivo);
End;

Procedure AbrirArchivoDeEmpleados();

Var 
  opcion: Char;
  archivo: t_Archivo;

Begin
  ElegirArchivo(archivo);

  While (true) Do
    Begin
      clrScr;

      WriteLn('Seleccione una opción:');
      WriteLn('1. Listar empleados con un nombre o apellido determinado');
      WriteLn('2. Listar todos los empleados');
      WriteLn('3. Listar empleados mayores de 70 años');
      WriteLn('0. Volver al menú principal');

      WriteLn;
      Write('> ');
      Readln(opcion);

      Case opcion Of 
        '1': BuscarPor(archivo);
        '2': ListarEmpleados(archivo);
        '3': ListarMayoresDe70(archivo);
        '0': Break;
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

      Write('Ingrese el DNI del empleado: ');
      Readln(empleado.dni);
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
  exit: Boolean;
Begin
  clrScr;
  exit := false;

  While (Not exit) Do
    Begin
      clrScr;
      WriteLn('Seleccione una opción:');
      WriteLn('1. Crear archivo de empleados.');
      WriteLn('2. Abrir archivo de empleados.');
      WriteLn('0. Salir.');

      WriteLn;
      Write('> ');
      Readln(opcion);

      Case opcion Of 
        '1': CrearArchivoDeEmpleados();
        '2': AbrirArchivoDeEmpleados();
        '0': exit := true;
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
