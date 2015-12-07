inherited FormListarClientes: TFormListarClientes
  Caption = 'Listar clientes'
  PixelsPerInch = 96
  TextHeight = 13
  inherited RzToolbar1: TRzToolbar
    ToolbarControls = (
      RzToolButton1
      RzToolButton2)
    inherited RzToolButton2: TRzToolButton
      OnClick = RzToolButton2Click
    end
  end
  inherited ds_QLista: TDataSource
    Left = 232
    Top = 64
  end
  inherited QLista: TUniQuery
    Left = 176
    Top = 56
  end
end
