object FormFaturamento: TFormFaturamento
  Left = 230
  Top = 117
  BorderStyle = bsSingle
  Caption = 'Faturamento'
  ClientHeight = 262
  ClientWidth = 354
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 11
    Top = 24
    Width = 51
    Height = 13
    Caption = 'Data inicial'
  end
  object Label2: TLabel
    Left = 16
    Top = 48
    Width = 46
    Height = 13
    Caption = 'Data final'
  end
  object Memo1: TMemo
    Left = 8
    Top = 72
    Width = 337
    Height = 153
    TabOrder = 0
  end
  object Button1: TButton
    Left = 8
    Top = 232
    Width = 75
    Height = 25
    Caption = 'Executar'
    TabOrder = 1
    OnClick = Button1Click
  end
  object DateTimePicker1: TDateTimePicker
    Left = 72
    Top = 16
    Width = 186
    Height = 21
    Date = 42290.427787060190000000
    Time = 42290.427787060190000000
    TabOrder = 2
  end
  object DateTimePicker2: TDateTimePicker
    Left = 72
    Top = 40
    Width = 186
    Height = 21
    Date = 42290.427810208330000000
    Time = 42290.427810208330000000
    TabOrder = 3
  end
end
