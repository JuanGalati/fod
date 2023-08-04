
Program Prueba1;

Const 
  VALOR_ALTO = 'ZZZZZZZZ';

Type 
  shortStr = string[30];

  TVenta = Record
    Vendedor: integer;
    Monto: real;
    Sucursal: shortStr;
    Ciudad: shortStr;
    Provincia: shortStr;
  End;

  fo_TVenta = file Of TVenta;

Procedure Leer(Var Archivo: fo_TVenta; Var dato: TVenta);
Begin
  If (Not(EOF(Archivo)))
    Then read (Archivo, dato)
  Else dato.Provincia := VALOR_ALTO;
End;

Procedure TotalVendedor(archivo, ): Real;

Procedure CorteDeControl(Var Archivo: fo_TVenta);

Type 
  TTotal = Record
    Empresa,
    Provincia,
    Ciudad,
    Sucursal,
    Monto: Real;
  End;

Var 
  Venta, Auxiliar: TVenta;
  Total : TTotal;

Begin
  Reset(Archivo);

  Leer(Archivo, Venta);
  Total.Empresa := 0;
  While (Venta.Provincia <> VALOR_ALTO) Do
    Begin
      WriteLn('Provincia:', Venta.Provincia);
      Auxiliar.Provincia := Venta.Provincia;
      Total.Provincia := 0;

      While (Auxiliar.Provincia = Venta.Provincia) Do
        Begin
          WriteLn('Ciudad:', Venta.Ciudad);
          Auxiliar.Ciudad := Venta.Ciudad;
          Total.Ciudad := 0;

          While (Auxiliar.Provincia = Venta.Provincia) And
                (Auxiliar.Ciudad = Venta.Ciudad) Do
            Begin
              WriteLn('Sucursal:', Venta.Sucursal);
              Auxiliar.Sucursal := Venta.Sucursal;
              Total.Sucursal := 0;

              While (Auxiliar.Provincia = Venta.Provincia) And
                    (Auxiliar.Ciudad = Venta.Ciudad) And
                    (Auxiliar.Sucursal = Venta.Sucursal) Do
                Begin
                  Write('Vendedor:', Venta.Vendedor);
                  Auxiliar.Vendedor := Venta.Vendedor;
                  Total.Vendedor := Venta.Monto;

                  Leer(Archivo, Venta);

                  WriteLn('Total Vendedor', Total.Vendedor);
                  Total.Sucursal := Total.Sucursal + Total.Vendedor;

                End;
              WriteLn('Total Sucursal', Total.Sucursal);

              Total.Ciudad := Total.Ciudad + Total.Sucursal;
            End;
          WriteLn('Total Ciudad', Total.Ciudad);

          Total.Provincia := Total.Provincia + Total.Ciudad;
        End;
      WriteLn('Total Provincia', Total.Provincia);

      Total.Empresa := Total.Empresa + Total.Provincia;
    End;
  WriteLn('Total Empresa', Total.Empresa);

  Close(Archivo);
End;

Var 
  Archivo: fo_TVenta;
Begin
  Assign(Archivo, 'archivo_ventas');

  CorteDeControl(Archivo);
End.
