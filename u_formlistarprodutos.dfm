inherited FormListarProdutos: TFormListarProdutos
  Caption = 'Listar produtos'
  PixelsPerInch = 96
  TextHeight = 13
  inherited RzToolbar1: TRzToolbar
    ToolbarControls = (
      RzToolButton1
      RzToolButton2
      RzSpacer1
      RzToolButton3)
    inherited RzToolButton1: TRzToolButton
      Width = 58
    end
    inherited RzToolButton2: TRzToolButton
      Left = 62
    end
    inherited RzSpacer1: TRzSpacer
      Left = 87
    end
    inherited RzToolButton3: TRzToolButton
      Left = 95
    end
  end
end
