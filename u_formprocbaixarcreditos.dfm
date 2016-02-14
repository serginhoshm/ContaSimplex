inherited FormBaixarCreditosManual: TFormBaixarCreditosManual
  Left = 230
  Top = 116
  Caption = 'Baixar cr'#233'ditos manual'
  ClientHeight = 345
  ClientWidth = 484
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel [0]
    Left = 16
    Top = 58
    Width = 66
    Height = 13
    Caption = 'Valor a baixar'
  end
  inherited AdvOfficeStatusBar1: TAdvOfficeStatusBar
    Top = 332
    Width = 484
  end
  object LabeledEditCli: TLabeledEdit
    Left = 16
    Top = 32
    Width = 121
    Height = 21
    EditLabel.Width = 81
    EditLabel.Height = 13
    EditLabel.Caption = 'Informe o cliente'
    TabOrder = 1
  end
  object Button1: TButton
    Left = 16
    Top = 100
    Width = 75
    Height = 25
    Caption = 'Baixar'
    TabOrder = 2
    OnClick = Button1Click
  end
  object MoneyEditValor: TMoneyEdit
    Left = 16
    Top = 74
    Width = 121
    Height = 21
    CalculatorLook.ButtonWidth = 24
    CalculatorLook.ButtonHeight = 24
    CalculatorLook.ButtonColor = clSilver
    CalculatorLook.Color = clWhite
    CalculatorLook.Flat = False
    CalculatorLook.Font.Charset = DEFAULT_CHARSET
    CalculatorLook.Font.Color = clWindowText
    CalculatorLook.Font.Height = -11
    CalculatorLook.Font.Name = 'Tahoma'
    CalculatorLook.Font.Style = []
    TabOrder = 3
    Version = '1.1.1.0'
  end
end
