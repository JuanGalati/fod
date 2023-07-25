
{
    1. Una empresa posee un archivo con información de los ingresos percibidos por
    diferentes empleados en concepto de comisión, de cada uno de ellos se conoce: 
    código de empleado, nombre y monto de la comisión. 
    
    La información del archivo se encuentra ordenada por código de empleado 
    y cada empleado puede aparecer más de una vez en el archivo de comisiones.

    [X] Realice un procedimiento que reciba el archivo anteriormente descripto 
        y lo compacte. En consecuencia, deberá generar un nuevo archivo en el cual,
        cada empleado aparezca una única vez con el valor total de sus comisiones.
        
    NOTA: No se conoce a priori la cantidad de empleados. 
    Además, el archivo debe ser recorrido una única vez.
}

Program ejercicio1;
{$codepage utf-8}

Uses crt;

Const 
  ARCHIVO_DE_COMISIONES = 'comisiones.dat';
  ARCHIVO_DE_EMPLEADOS = 'empleados.dat';

  NULO = MAXINT * -1;

Type 
  str = String[20];

  t_Empleado = Record
    codigo: integer;
    nombre: str;
    comision: real;
  End;

  t_Archivo = file Of t_Empleado;

Procedure Leer(Var archivo: t_Archivo; Var empleado: t_Empleado);
Begin
  If (Not EOF(archivo))
    Then Read(archivo, empleado)
  Else empleado.codigo := NULO;
End;

Var 
  maestro, detalle: t_Archivo;
  actual, empleado: t_Empleado;
Begin
  Assign(detalle, ARCHIVO_DE_COMISIONES);
  Reset(detalle);

  Assign(maestro, ARCHIVO_DE_EMPLEADOS);
  Rewrite(maestro);

  Leer(detalle, empleado);
  While (empleado.codigo <> NULO) Do
    Begin
      actual := empleado;
      actual.comision := 0;

      While (empleado.codigo = actual.codigo) Do
        Begin
          actual.comision := actual.comision + empleado.comision;

          Leer(detalle, empleado);
        End;

      Write(maestro, actual);
    End;

  Close(maestro);
  Close(detalle);

  ReadLn;
End.
