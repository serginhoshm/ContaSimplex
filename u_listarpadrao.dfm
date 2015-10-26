object Form2: TForm2
  Left = 253
  Top = 140
  Width = 928
  Height = 480
  Caption = 'Listar'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object RzDBGrid1: TRzDBGrid
    Left = 0
    Top = 29
    Width = 920
    Height = 387
    Align = alClient
    Ctl3D = False
    DataSource = ds_QueryLista
    ParentCtl3D = False
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object RzToolbar1: TRzToolbar
    Left = 0
    Top = 0
    Width = 920
    Height = 29
    BorderInner = fsNone
    BorderOuter = fsGroove
    BorderSides = [sdTop]
    BorderWidth = 0
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 1
  end
  object RzPanel1: TRzPanel
    Left = 0
    Top = 416
    Width = 920
    Height = 33
    Align = alBottom
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 2
  end
  object QueryLista: TADOQuery
    Parameters = <>
    Left = 480
    Top = 104
  end
  object ds_QueryLista: TDataSource
    DataSet = QueryLista
    Left = 544
    Top = 104
  end
end
