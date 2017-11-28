inherited FormRelFaturamentosPendetes: TFormRelFaturamentosPendetes
  Caption = 'Faturamentos pendentes'
  PixelsPerInch = 96
  TextHeight = 13
  inherited RzToolbar1: TToolBar
    inherited RzToolButton1: TToolButton
      OnClick = RzToolButton1Click
      ExplicitWidth = 50
    end
    object RzToolButton2: TToolButton
      Left = 106
      Top = 0
      Caption = 'Recobrar'
      ImageIndex = 16
      OnClick = RzToolButton2Click
    end
    object RzToolButton3: TToolButton
      Left = 56
      Top = 0
    end
  end
  object Memo1: TMemo
    Left = 8
    Top = 56
    Width = 505
    Height = 249
    TabOrder = 2
  end
  object qFatur: TADOQuery
    Parameters = <>
    SQL.Strings = (
      'select * from faturamentospendentes'
      'order by clientenome, faturdatageracao desc')
    Left = 232
    Top = 64
    object qFaturfaturid: TIntegerField
      FieldName = 'faturid'
    end
    object qFaturclientenome: TWideStringField
      FieldName = 'clientenome'
      Size = 255
    end
    object qFaturclienteemail: TWideStringField
      FieldName = 'clienteemail'
      Size = 255
    end
    object qFaturfaturdatageracao: TDateTimeField
      FieldName = 'faturdatageracao'
    end
    object qFaturfaturvalortotal: TFloatField
      FieldName = 'faturvalortotal'
    end
    object qFaturfaturvalorbaixado: TFloatField
      FieldName = 'faturvalorbaixado'
    end
    object qFaturfaturdataenvioemail2: TDateTimeField
      FieldName = 'faturdataenvioemail2'
    end
    object qFaturvalorpendente: TFloatField
      FieldName = 'valorpendente'
    end
    object qFaturfaturvalorcancelado: TFloatField
      FieldName = 'faturvalorcancelado'
    end
    object qFaturclienteid: TIntegerField
      FieldName = 'clienteid'
    end
  end
end
