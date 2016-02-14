object FormRecebimento: TFormRecebimento
  Left = 396
  Top = 154
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Receber faturamento'
  ClientHeight = 251
  ClientWidth = 498
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
  object Label6: TLabel
    Left = 34
    Top = 110
    Width = 81
    Height = 13
    Caption = 'Valor recebido'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 76
    Top = 46
    Width = 39
    Height = 13
    Caption = 'Cliente'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 78
    Top = 14
    Width = 37
    Height = 13
    Caption = 'Fatura'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object AdvToolButton1: TRzToolButton
    Left = 181
    Top = 8
    Width = 23
    ImageIndex = 12
    Images = FormPrincipal.Img
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    OnClick = AdvToolButton1Click
  end
  object Label1: TLabel
    Left = 83
    Top = 142
    Width = 32
    Height = 13
    Caption = 'Troco'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 33
    Top = 174
    Width = 82
    Height = 13
    Caption = 'Valor a cr'#233'dito'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 45
    Top = 78
    Width = 67
    Height = 13
    Caption = 'Valor fatura'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object EditValorRecebido: TRzNumericEdit
    Left = 120
    Top = 104
    Width = 169
    Height = 24
    Ctl3D = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Courier New'
    Font.Style = []
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 4
    IntegersOnly = False
    DisplayFormat = ',0.00;-,0.00'
  end
  object Panel1: TPanel
    Left = 0
    Top = 208
    Width = 498
    Height = 43
    Align = alBottom
    Ctl3D = True
    ParentCtl3D = False
    TabOrder = 7
    object BitBtn1: TBitBtn
      Left = 16
      Top = 8
      Width = 89
      Height = 25
      Caption = 'Confirmar'
      TabOrder = 0
      TabStop = False
      OnClick = BitBtn1Click
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333330000333333333333333333333333F33333333333
        00003333344333333333333333388F3333333333000033334224333333333333
        338338F3333333330000333422224333333333333833338F3333333300003342
        222224333333333383333338F3333333000034222A22224333333338F338F333
        8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
        33333338F83338F338F33333000033A33333A222433333338333338F338F3333
        0000333333333A222433333333333338F338F33300003333333333A222433333
        333333338F338F33000033333333333A222433333333333338F338F300003333
        33333333A222433333333333338F338F00003333333333333A22433333333333
        3338F38F000033333333333333A223333333333333338F830000333333333333
        333A333333333333333338330000333333333333333333333333333333333333
        0000}
      NumGlyphs = 2
    end
  end
  object EditClienteID: TRzNumericEdit
    Left = 120
    Top = 40
    Width = 57
    Height = 24
    Ctl3D = False
    Enabled = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Courier New'
    Font.Style = []
    ParentCtl3D = False
    ParentFont = False
    ReadOnly = True
    TabOrder = 1
    DisplayFormat = ',0;(,0)'
  end
  object EditClienteNome: TRzEdit
    Left = 180
    Top = 40
    Width = 305
    Height = 24
    Ctl3D = False
    Enabled = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Courier New'
    Font.Style = []
    ParentCtl3D = False
    ParentFont = False
    ReadOnly = True
    TabOrder = 2
  end
  object EditFaturID: TRzNumericEdit
    Left = 121
    Top = 8
    Width = 57
    Height = 24
    Ctl3D = False
    Enabled = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Courier New'
    Font.Style = []
    ParentCtl3D = False
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
    DisplayFormat = ',0;(,0)'
  end
  object EditTroco: TRzNumericEdit
    Left = 120
    Top = 136
    Width = 169
    Height = 24
    Ctl3D = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Courier New'
    Font.Style = []
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 5
    OnEnter = EditTrocoEnter
    IntegersOnly = False
    DisplayFormat = ',0.00;-,0.00'
  end
  object EditCredito: TRzNumericEdit
    Left = 120
    Top = 168
    Width = 169
    Height = 24
    Ctl3D = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Courier New'
    Font.Style = []
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 6
    OnEnter = EditCreditoEnter
    IntegersOnly = False
    DisplayFormat = ',0.00;-,0.00'
  end
  object EditValorFatura: TRzNumericEdit
    Left = 120
    Top = 72
    Width = 169
    Height = 24
    Ctl3D = False
    Enabled = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Courier New'
    Font.Style = []
    ParentCtl3D = False
    ParentFont = False
    ReadOnly = True
    TabOrder = 3
    IntegersOnly = False
    DisplayFormat = ',0.00;-,0.00'
  end
end
