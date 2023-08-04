
Program ejercicio3;


Uses crt, SysUtils;

Const 
  MININT = MAXINT * -1;

  ARCHIVO_PRODUCTOS = 'productos.dat';
  CARPETA_VENTAS = 'Sucursales/Ventas/';
  CARPETA_INFORMES = 'Informes/';

  C_SUCURSALES = 10;

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

  TArrayVenta = ArraY[1..C_SUCURSALES] Of TVenta;
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

Procedure Leer(Var archivos: TArrayVentas; Var datos: TArrayVenta);

Var 
  i : Integer;
Begin
  For i:= 1 To Length(archivos) Do
    Leer(archivos[i], datos[i]);
End;

Procedure Escribir(Var archivo: TProductos; dato: TProducto);
Begin
  Write(archivo, dato);
End;

Procedure Escribir(Var archivo: TVentas; dato: TVenta);
Begin
  Write(archivo, dato);
End;

Procedure Escribir(Var archivo: Text; dato: TProducto);
Begin
  With dato Do
    Begin
      WriteLn(archivo, Codigo, ' ', Stock, ' ', StockMinimo, ' ',
              Precio, ' ', nombre);
      WriteLn(archivo, descripcion);
    End;
End;

Procedure Imprimir(dato: TProducto);
Begin
  With dato Do
    Begin
      WriteLn(Codigo, ' ', Stock, ' ', StockMinimo, ' ',
              FormatFloat('00.00', Precio), ' ', nombre);
      WriteLn(descripcion)
    End;
End;

Procedure Imprimir(dato: TVenta);
Begin
  With dato Do
    WriteLn(Codigo:2, ' ', c_Ventas:3);
End;

Procedure Imprimir(datos: TArrayVenta);

Var 
  i: Integer;
Begin
  For i:= 1 To Length(datos) Do
    Imprimir(datos[i]);
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


Procedure Minimo(Var archivos : TArrayVentas;
                 Var datos    : TArrayVenta;
                 Var min      : TVenta
);

Var 
  i, minIndex: Integer;
Begin
  MinIndex := 0;
  Min.Codigo := MAXINT;

  For i := 1 To C_SUCURSALES Do
    If (datos[i].Codigo < Min.Codigo) Then
      Begin
        min := datos[i];
        minIndex := i;
      End;

  If (minIndex <> 0) Then
    Leer(archivos[minIndex], datos[minIndex]);
End;

Procedure Actualizar(Var maestro: TProductos; Var detalles: TArrayVentas);

Var 
  dato: TProducto;
  Ventas : TArrayVenta;

  total, min : TVenta;
  i : Integer;
Begin
  Reset(maestro);
  For i := 1 To C_SUCURSALES Do
    Begin
      Reset(detalles[i]);
      Leer(detalles[i], ventas[i]);
    End;
  PresioneEnter;

  Minimo(detalles, ventas, min);
  While (min.codigo <> MAXINT) Do
    Begin
      total.Codigo := min.Codigo;
      total.c_Ventas := 0;

      While (min.codigo = total.codigo) Do
        // Totalizo las ventas de un producto
        Begin
          total.c_Ventas := total.c_ventas + min.c_Ventas;
          Minimo(detalles, ventas, min);
        End;

      // Busco el producto en el maestro
      Leer(maestro, dato);
      While (dato.Codigo <> total.Codigo) Do
        Leer(maestro, dato);

      // Actualizo el maestro
      dato.Stock := dato.Stock - total.c_Ventas;
      Seek(maestro, FilePos(maestro) - 1);
      Escribir(maestro, dato);
    End;

  Close(maestro);
  For i := 1 To Length(detalles) Do
    Begin
      Close(detalles[i]);
    End;
End;

Procedure Exportar(Var archivo: TProductos);

Var 
  informe : Text;
  Producto : TProducto;
Begin
  Assign(informe, CARPETA_INFORMES + 'informe.txt');
  Rewrite(informe);

  Reset(archivo);

  Leer(Archivo, Producto);
  While (Producto.Codigo <> MAXINT) Do
    Begin
      Imprimir(Producto);
      WriteLn(Producto.Stock < Producto.stockMinimo);
      If (Producto.Stock < Producto.stockMinimo) Then
        Begin
          WriteLn('Test');
          Escribir(informe, Producto);
        End;

      Leer(Archivo, Producto);
    End;

  Close(archivo);
  Close(informe);
End;

Var 
  maestro: TProductos;
  detalles: TArrayVentas;
  informe : Text;

  i : Integer;
Begin
  ClrScr;

  For i:= 1 To C_SUCURSALES Do
    Assign(detalles[i], CARPETA_VENTAS + 'venta' + IntToStr(i) + '.dat');

  Assign(maestro, ARCHIVO_PRODUCTOS);

  (* Actualizar(maestro, detalles); *)
  (* Imprimir(maestro); *)
  Exportar(maestro);

  PresioneEnter;
End.
