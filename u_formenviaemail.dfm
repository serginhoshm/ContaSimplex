object FormEnviaEmails: TFormEnviaEmails
  Left = 313
  Top = 140
  BorderStyle = bsSingle
  Caption = 'Enviar e-mails faturamento'
  ClientHeight = 240
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
    Width = 48
    Height = 13
    Caption = 'Data pgto'
  end
  object LabelProgresso: TLabel
    Left = 112
    Top = 216
    Width = 9
    Height = 19
    Font.Charset = ANSI_CHARSET
    Font.Color = clMaroon
    Font.Height = -16
    Font.Name = 'Consolas'
    Font.Style = [fsBold]
    ParentFont = False
    Visible = False
  end
  object Memo1: TMemo
    Left = 8
    Top = 48
    Width = 337
    Height = 153
    TabOrder = 0
  end
  object Button1: TButton
    Left = 8
    Top = 208
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
end
