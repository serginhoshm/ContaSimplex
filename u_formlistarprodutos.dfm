inherited FormListarProdutos: TFormListarProdutos
  Width = 690
  Caption = 'Listar produtos'
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  inherited RzDBGridLista: TRzDBGrid
    Width = 674
  end
  inherited RzToolbar1: TRzToolbar
    Width = 674
    ToolbarControls = (
      RzToolButton1
      RzToolButton2
      RzSpacer1
      RzToolButton3)
  end
  inherited RzPanel1: TRzPanel
    Width = 674
  end
  inherited QLista: TUniQuery
    Left = 384
    Top = 152
  end
end
