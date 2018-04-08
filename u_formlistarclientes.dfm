inherited FormListarClientes: TFormListarClientes
  Caption = 'Listar clientes'
  PixelsPerInch = 96
  TextHeight = 13
  inherited RzDBGridLista: TDBGrid
    Top = 25
    Height = 383
  end
  inherited RzToolbar1: TToolBar
    Height = 25
    ButtonHeight = 21
    ButtonWidth = 36
    ShowCaptions = True
    inherited RzToolButton2: TToolButton
      Left = 36
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
