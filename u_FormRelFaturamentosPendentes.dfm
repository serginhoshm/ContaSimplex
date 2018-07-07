inherited FormRelFaturamentosPendetes: TFormRelFaturamentosPendetes
  Left = 142
  Top = 103
  Caption = 'Faturamentos pendentes'
  ClientHeight = 292
  ClientWidth = 490
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  inherited QuickRep1: TQuickRep [0]
    Left = 32
    Top = 64
    DataSet = qFatur
    Functions.DATA = (
      '0'
      '0'
      #39#39)
    Page.Values = (
      100.000000000000000000
      2970.000000000000000000
      100.000000000000000000
      2100.000000000000000000
      100.000000000000000000
      100.000000000000000000
      0.000000000000000000)
    object QRBandTitle: TQRBand
      Left = 38
      Top = 38
      Width = 718
      Height = 40
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      Color = clWhite
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        105.833333333333300000
        1899.708333333333000000)
      BandType = rbTitle
    end
    object QRBandDet: TQRBand
      Left = 38
      Top = 118
      Width = 718
      Height = 40
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      Color = clWhite
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        105.833333333333300000
        1899.708333333333000000)
      BandType = rbDetail
      object QRDBText1: TQRDBText
        Left = 8
        Top = 16
        Width = 71
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.979166666666670000
          21.166666666666670000
          42.333333333333330000
          187.854166666666700000)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = True
        Color = clWhite
        DataSet = qFatur
        DataField = 'clientenome'
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object QRDBText2: TQRDBText
        Left = 296
        Top = 16
        Width = 97
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.979166666666670000
          783.166666666666700000
          42.333333333333330000
          256.645833333333300000)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Color = clWhite
        DataSet = qFatur
        DataField = 'faturdatageracao'
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object QRDBText3: TQRDBText
        Left = 636
        Top = 16
        Width = 77
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.979166666666670000
          1682.750000000000000000
          42.333333333333330000
          203.729166666666700000)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Color = clWhite
        DataSet = qFatur
        DataField = 'faturvalortotal'
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
    end
    object QRGroupHeader: TQRGroup
      Left = 38
      Top = 78
      Width = 718
      Height = 40
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      Color = clWhite
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        105.833333333333300000
        1899.708333333333000000)
      FooterBand = QRBandSoma
      Master = QuickRep1
      ReprintOnNewPage = False
    end
    object QRBandSoma: TQRBand
      Left = 38
      Top = 158
      Width = 718
      Height = 40
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AfterPrint = QRBandSomaAfterPrint
      AlignToBottom = False
      Color = clWhite
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        105.833333333333300000
        1899.708333333333000000)
      BandType = rbGroupFooter
      object QRExpr1: TQRExpr
        Left = 560
        Top = 8
        Width = 151
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.979166666666670000
          1481.666666666667000000
          21.166666666666670000
          399.520833333333300000)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Color = clWhite
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'sum(qFatur.faturvalortotal)'
        FontSize = 10
      end
    end
  end
  inherited RzToolbar1: TToolBar [1]
    Width = 490
    Height = 25
    ButtonHeight = 21
    ButtonWidth = 10
    ShowCaptions = True
    inherited RzToolButton1: TToolButton
      AutoSize = True
      Caption = ''
      Visible = False
    end
    object RzToolButton3: TToolButton
      Left = 14
      Top = 2
      Visible = False
    end
  end
  inherited RzStatusBar1: TStatusBar [2]
    Top = 273
    Width = 490
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
