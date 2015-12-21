inherited FormListarFaturPendente: TFormListarFaturPendente
  Caption = 'Listar faturamentos pendentes'
  PixelsPerInch = 96
  TextHeight = 13
  inherited RzToolbar1: TRzToolbar
    ToolbarControls = (
      RzToolButton1
      RzToolButton2)
  end
  inherited QLista: TUniQuery
    SQL.Strings = (
      'select * from faturamentospendentes')
  end
end
