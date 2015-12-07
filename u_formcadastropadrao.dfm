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
  object RzPanel2: TRzPanel
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
  object RzToolbar1: TRzToolbar
    Left = 0
    Top = 0
    Width = 624
    Height = 50
    Images = FormPrincipal.Img
    ButtonLayout = blGlyphTop
    ButtonWidth = 50
    ButtonHeight = 50
    TextOptions = ttoCustom
    AutoSize = True
    BorderInner = fsNone
    BorderOuter = fsGroove
    BorderSides = [sdTop]
    BorderWidth = 0
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 2
    ToolbarControls = (
      RzToolButton1
      RzToolButton3)
    object RzToolButton1: TRzToolButton
      Left = 4
      Top = 0
      ImageIndex = 4
      Layout = blGlyphTop
      ShowCaption = True
      UseToolbarShowCaption = False
      Caption = 'Salvar'
    end
    object RzToolButton3: TRzToolButton
      Left = 54
      Top = 0
      ImageIndex = 8
      Layout = blGlyphTop
      ShowCaption = True
      UseToolbarShowCaption = False
      Caption = 'Excluir'
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
