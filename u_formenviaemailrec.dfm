object FormEnviaEmailsRec: TFormEnviaEmailsRec
  Left = 313
  Top = 140
  BorderStyle = bsSingle
  Caption = 'Enviar e-mails recebimento'
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
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 8
    Top = 16
    Width = 337
    Height = 185
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
end
