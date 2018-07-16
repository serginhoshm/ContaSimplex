inherited FormRelFaturamentosPendetes: TFormRelFaturamentosPendetes
  Left = 142
  Top = 103
  Caption = 'Faturamentos pendentes'
  ClientHeight = 292
  ClientWidth = 490
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  inherited RzToolbar1: TToolBar
    Width = 490
    Height = 21
    ButtonHeight = 21
    ButtonWidth = 10
    ShowCaptions = True
    ExplicitWidth = 490
    ExplicitHeight = 21
    inherited RzToolButton1: TToolButton
      Top = 0
      AutoSize = True
      Caption = ''
      Visible = False
      ExplicitTop = 0
    end
    object RzToolButton3: TToolButton
      Left = 14
      Top = 0
      Visible = False
    end
  end
  inherited RzStatusBar1: TStatusBar
    Top = 273
    Width = 490
    ExplicitTop = 273
    ExplicitWidth = 490
  end
  object Memo1: TMemo
    Left = 0
    Top = 24
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
      DisplayFormat = '#,0.00'
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
  object DS_qFatur: TDataSource
    DataSet = qFatur
    Left = 280
    Top = 64
  end
end
