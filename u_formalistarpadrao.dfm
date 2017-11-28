object FormListarPadrao: TFormListarPadrao
  Left = 432
  Top = 179
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Listar'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object RzDBGridLista: TDBGrid
    Left = 0
    Top = 50
    Width = 624
    Height = 358
    Align = alClient
    Ctl3D = False
    DataSource = ds_QLista
    Options = [dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    ParentCtl3D = False
    ReadOnly = True
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object RzToolbar1: TToolBar
    Left = 0
    Top = 0
    Width = 624
    Height = 50
    AutoSize = True
    ButtonHeight = 50
    ButtonWidth = 50
    Ctl3D = False
    TabOrder = 1
    object RzToolButton1: TToolButton
      Left = 4
      Top = 0
      Caption = 'Editar'
      ImageIndex = 86
      OnClick = RzToolButton1Click
    end
    object RzToolButton2: TToolButton
      Left = 54
      Top = 0
      Caption = 'Incluir'
      ImageIndex = 82
    end
  end
  object RzPanel1: TPanel
    Left = 0
    Top = 408
    Width = 624
    Height = 33
    Align = alBottom
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 2
  end
  object ds_QLista: TDataSource
    DataSet = QLista
    Left = 504
    Top = 128
  end
  object QLista: TADOQuery
    Parameters = <>
    Left = 448
    Top = 128
  end
end
