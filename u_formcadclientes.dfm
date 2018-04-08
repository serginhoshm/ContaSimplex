inherited FormCadastroClientes: TFormCadastroClientes
  Left = 229
  Top = 134
  Caption = 'Clientes'
  ClientHeight = 276
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inherited ScrollBox1: TScrollBox
    Top = 40
    Height = 217
    object RzLabel2: TLabel
      Left = 51
      Top = 15
      Width = 27
      Height = 13
      Caption = 'Nome'
    end
    object RzLabel3: TLabel
      Left = 54
      Top = 39
      Width = 24
      Height = 13
      Caption = 'Email'
    end
    object EditNome: TEdit
      Left = 81
      Top = 12
      Width = 400
      Height = 19
      CharCase = ecUpperCase
      TabOrder = 0
    end
    object EditEmail: TEdit
      Left = 81
      Top = 36
      Width = 400
      Height = 19
      CharCase = ecUpperCase
      TabOrder = 1
    end
  end
  inherited RzToolbar1: TToolBar
    Height = 40
    ButtonHeight = 36
    ButtonWidth = 38
    ShowCaptions = True
    inherited RzToolButton1: TToolButton
      OnClick = RzToolButton1Click
    end
    inherited RzToolButton3: TToolButton
      Left = 38
    end
  end
  inherited StatusBar1: TStatusBar
    Top = 257
  end
end
