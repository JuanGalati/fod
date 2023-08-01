
Program ejercicio3.dev;

Uses crt, SysUtils;

Const 
  ARCHIVO_PRODUCTOS = 'productos.dat';
  CARPETA_VENTAS = 'Sucursales/Ventas/';

  C_SUCURSALES = 10;

  C_PRODUCTOS = 10;
  MAX_VENTAS = 5;

Type 
  TStr = String[25];

  TProducto = Record
    Codigo: Integer;
    Stock: Integer;
    StockMinimo: Integer;
    Precio: Real;

    Nombre: TStr;
    Descripcion: String;
  End;

  TVenta = Record
    Codigo: Integer;
    c_Ventas: Integer;
  End;

  TProductos = file Of TProducto;
  TVentas = file Of TVenta;

  TArrayVentas = Array[1..C_SUCURSALES] Of TVentas;

Procedure PresioneEnter;
Begin
  WriteLn('Presione ENTER para continuar.');
  ReadLn;
End;

Procedure Leer(Var archivo: TProductos; Var dato: TProducto);
Begin
  If (Not EOF(archivo))
    Then Read(archivo, dato)
  Else
    dato.codigo := MAXINT;
End;

Procedure Leer(Var archivo: TVentas; Var dato: TVenta);
Begin
  If (Not EOF(archivo))
    Then Read(archivo, dato)
  Else
    dato.codigo := MAXINT;
End;

Procedure Escribir(Var archivo: TProductos; dato: TProducto);
Begin
  Write(archivo, dato);
End;

Procedure Escribir(Var archivo: TVentas; dato: TVenta);
Begin
  Write(archivo, dato);
End;

Procedure Imprimir(dato: TProducto);
Begin
  With dato Do
    Begin
      WriteLn(Codigo:2, ' ', Stock:3, ' ', StockMinimo: 3, ' ',
              FormatFloat('00.00', Precio), ' ', nombre);
      WriteLn(descripcion)
    End;
End;

Procedure Imprimir(dato: TVenta);
Begin
  With dato Do
    WriteLn(Codigo:2, ' ', c_Ventas:3);
End;

Procedure Imprimir(Var archivo: TProductos);

Var 
  dato : TProducto;
Begin
  Reset(archivo);

  Leer(archivo, dato);
  While (dato.codigo <> MAXINT) Do
    Begin
      Imprimir(dato);

      Leer(archivo, dato);
    End;

  Close(archivo);
End;

Procedure Imprimir(Var archivo: TVentas);

Var 
  dato : TVenta;
Begin
  Reset(archivo);

  Leer(archivo, dato);
  While (dato.codigo <> MAXINT) Do
    Begin
      Imprimir(dato);

      Leer(archivo, dato);
    End;

  Close(archivo);
End;

Procedure Imprimir(Var archivos: TArrayVentas);

Var 
  i : Integer;
Begin
  For i:= 1 To Length(archivos) Do
    Begin
      WriteLn('Archivo: ', i);
      Imprimir(Archivos[i]);
      WriteLn;
    End;
End;

Procedure Crear(Var dato: TProducto; indice: Integer);
Begin
  With dato Do
    Begin
      codigo := indice;
      stock := 100;
      stockMinimo := 50;
      precio := Random(99) + (Random(99) / 100);

      nombre := Chr(ord('a') + indice);
      descripcion := 'Descripción.';
    End;
End;

Procedure Crear(Var dato: TVenta; indice: Integer);
Begin
  With dato Do
    Begin
      Codigo := indice;
      c_Ventas := Random(10 - 1) + 1;
    End;
End;

Procedure Crear(Var archivo: TProductos);

Var 
  producto: TProducto;
  i : Integer;
Begin
  ReWrite(archivo);

  For i:= 1 To C_PRODUCTOS Do
    Begin
      Crear(producto, i);
      Escribir(archivo, producto);
    End;

  Close(archivo);
End;

Procedure Crear(Var archivo: TVentas);

Var 
  venta : TVenta;
  I, j : Integer;
Begin
  ReWrite(archivo);

  For i:= 1 To Random(C_PRODUCTOS) Do
    For j:= 1 To Random(MAX_VENTAS) Do
      If (random(100) < 50) Then
        Begin
          Crear(venta, i);
          Escribir(archivo, Venta);
        End;


  Close(archivo);
End;

Procedure Crear(Var archivos: TArrayVentas);

Var 
  i : Integer;
Begin
  For i:= 1 To Length(archivos) Do
    Begin
      Crear(Archivos[i]);
    End;
End;

Var 
  maestro: TProductos;
  detalles: TArrayVentas;

  i : Integer;
Begin
  Randomize;
  ClrScr;

  For i:= 1 To C_SUCURSALES Do
    Begin
      Assign(detalles[i], CARPETA_VENTAS + 'venta' + IntToStr(i) + '.dat'
      );
    End;
  Assign(maestro, ARCHIVO_PRODUCTOS);

  Crear(detalles);
  imprimir(detalles);
  PresioneEnter;
  ClrScr;

  Crear(maestro);
  Imprimir(maestro);
  PresioneEnter;
  ClrScr;
End.
