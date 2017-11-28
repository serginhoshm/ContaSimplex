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
    Height = 207
    ExplicitHeight = 207
    object RzLabel1: TLabel
      Left = 67
      Top = 19
      Width = 11
      Height = 13
      Caption = 'ID'
    end
    object RzLabel2: TLabel
      Left = 51
      Top = 43
      Width = 27
      Height = 13
      Caption = 'Nome'
    end
    object RzLabel3: TLabel
      Left = 54
      Top = 67
      Width = 24
      Height = 13
      Caption = 'Email'
    end
    object RzLabel4: TLabel
      Left = 9
      Top = 91
      Width = 69
      Height = 13
      Caption = 'Departamento'
    end
    object RzDBEdit1: TDBEdit
      Left = 81
      Top = 16
      Width = 121
      Height = 19
      DataField = 'clienteid'
      DataSource = DMClientes.ds_qclientes
      ReadOnly = True
      TabOrder = 0
    end
    object RzDBEdit2: TDBEdit
      Left = 81
      Top = 40
      Width = 400
      Height = 19
      CharCase = ecUpperCase
      DataField = 'clientenome'
      DataSource = DMClientes.ds_qclientes
      TabOrder = 1
    end
    object RzDBEdit3: TDBEdit
      Left = 81
      Top = 64
      Width = 400
      Height = 19
      CharCase = ecUpperCase
      DataField = 'clienteemail'
      DataSource = DMClientes.ds_qclientes
      TabOrder = 2
    end
    object RzDBLookupComboBox1: TDBLookupComboBox
      Left = 81
      Top = 88
      Width = 145
      Height = 19
      DataField = 'deptoid'
      DataSource = DMClientes.ds_qclientes
      KeyField = 'deptoid'
      ListField = 'deptodescricao'
      ListSource = DMClientes.ds_depto
      TabOrder = 3
    end
    object DBCheckBox1: TDBCheckBox
      Left = 80
      Top = 112
      Width = 300
      Height = 17
      Caption = 'Deseja receber e-mails de marketing?'
      DataField = 'clientemktmail'
      DataSource = DMClientes.ds_qclientes
      TabOrder = 4
    end
  end
  inherited RzToolbar1: TToolBar
    inherited RzToolButton1: TToolButton
      OnClick = RzToolButton1Click
    end
  end
  inherited StatusBar1: TStatusBar
    Top = 257
    ExplicitTop = 257
  end
end
