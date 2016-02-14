object FormRelPadrao: TFormRelPadrao
  Left = 369
  Top = 147
  BorderStyle = bsSingle
  Caption = 'Relat'#243'rio padr'#227'o'
  ClientHeight = 336
  ClientWidth = 528
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
  object RzToolbar1: TRzToolbar
    Left = 0
    Top = 0
    Width = 528
    Height = 50
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
    TabOrder = 0
    ToolbarControls = (
      RzToolButton1)
    object RzToolButton1: TRzToolButton
      Left = 4
      Top = 0
      Width = 52
      Height = 50
      ImageIndex = 116
      Images = FormPrincipal.Img
      Layout = blGlyphTop
      ShowCaption = True
      UseToolbarButtonLayout = False
      UseToolbarShowCaption = False
      Caption = 'Visualizar'
    end
  end
  object RzStatusBar1: TRzStatusBar
    Left = 0
    Top = 317
    Width = 528
    Height = 19
    BorderInner = fsNone
    BorderOuter = fsNone
    BorderSides = [sdLeft, sdTop, sdRight, sdBottom]
    BorderWidth = 0
    TabOrder = 1
  end
  object frxReportPadrao: TfrxReport
    Version = '4.3'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 42380.395792638890000000
    ReportOptions.LastChange = 42380.395792638890000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'begin'
      ''
      'end.')
    Left = 392
    Top = 24
    Datasets = <>
    Variables = <>
    Style = <>
  end
end
