inherited FormListarClientes: TFormListarClientes
  Caption = 'Listar clientes'
  PixelsPerInch = 96
  TextHeight = 13
  inherited RzToolbar1: TToolBar
    inherited RzToolButton2: TToolButton
      OnClick = RzToolButton2Click
    end
  end
  inherited ds_QLista: TDataSource
    Left = 232
    Top = 64
  end
  inherited QLista: TADOQuery
    Left = 176
    Top = 56
  end
end
