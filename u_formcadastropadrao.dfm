object FormCadastroPadrao: TFormCadastroPadrao
  Left = 245
  Top = 132
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Cadastro'
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
  PixelsPerInch = 96
  TextHeight = 13
  object RzPanel2: TPanel
    Left = 568
    Top = 200
    Width = 185
    Height = 41
    TabOrder = 0
  end
  object ScrollBox1: TScrollBox
    Left = 0
    Top = 50
    Width = 624
    Height = 372
    Align = alClient
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 1
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
    Images = FormPrincipal.Img
    TabOrder = 2
    object RzToolButton1: TToolButton
      Left = 4
      Top = 0
      Caption = 'Salvar'
      ImageIndex = 4
    end
    object RzToolButton3: TToolButton
      Left = 54
      Top = 0
      Caption = 'Excluir'
      ImageIndex = 8
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 422
    Width = 624
    Height = 19
    Panels = <>
  end
end
