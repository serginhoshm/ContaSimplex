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
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 13
  object RzToolbar1: TToolBar
    Left = 0
    Top = 0
    Width = 528
    Height = 54
    AutoSize = True
    ButtonHeight = 50
    ButtonWidth = 50
    Ctl3D = False
    TabOrder = 0
    object RzToolButton1: TToolButton
      Left = 0
      Top = 2
      Caption = 'Visualizar'
      ImageIndex = 116
    end
  end
  object RzStatusBar1: TStatusBar
    Left = 0
    Top = 317
    Width = 528
    Height = 19
    Panels = <>
  end
  object QuickRep1: TQuickRep
    Left = 0
    Top = 56
    Width = 794
    Height = 1123
    Frame.Color = clBlack
    Frame.DrawTop = False
    Frame.DrawBottom = False
    Frame.DrawLeft = False
    Frame.DrawRight = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    Functions.Strings = (
      'PAGENUMBER'
      'COLUMNNUMBER'
      'REPORTTITLE')
    Functions.DATA = (
      '0'
      '0'
      #39#39)
    Options = [FirstPageHeader, LastPageFooter]
    Page.Columns = 1
    Page.Orientation = poPortrait
    Page.PaperSize = A4
    Page.Values = (
      100.000000000000000000
      2970.000000000000000000
      100.000000000000000000
      2100.000000000000000000
      100.000000000000000000
      100.000000000000000000
      0.000000000000000000)
    PrinterSettings.Copies = 1
    PrinterSettings.Duplex = False
    PrinterSettings.FirstPage = 0
    PrinterSettings.LastPage = 0
    PrinterSettings.OutputBin = Auto
    PrintIfEmpty = True
    SnapToGrid = True
    Units = MM
    Zoom = 100
  end
end
