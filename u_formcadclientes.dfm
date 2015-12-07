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
    object RzLabel1: TRzLabel
      Left = 67
      Top = 19
      Width = 11
      Height = 13
      Caption = 'ID'
    end
    object RzLabel2: TRzLabel
      Left = 51
      Top = 43
      Width = 27
      Height = 13
      Caption = 'Nome'
    end
    object RzLabel3: TRzLabel
      Left = 54
      Top = 67
      Width = 24
      Height = 13
      Caption = 'Email'
    end
    object RzLabel4: TRzLabel
      Left = 9
      Top = 91
      Width = 69
      Height = 13
      Caption = 'Departamento'
    end
    object RzDBEdit1: TRzDBEdit
      Left = 81
      Top = 16
      Width = 121
      Height = 19
      DataSource = DMClientes.ds_qclientes
      DataField = 'clienteid'
      ReadOnly = True
      Alignment = taRightJustify
      TabOrder = 0
    end
    object RzDBEdit2: TRzDBEdit
      Left = 81
      Top = 40
      Width = 400
      Height = 19
      DataSource = DMClientes.ds_qclientes
      DataField = 'clientenome'
      CharCase = ecUpperCase
      TabOrder = 1
    end
    object RzDBEdit3: TRzDBEdit
      Left = 81
      Top = 64
      Width = 400
      Height = 19
      DataSource = DMClientes.ds_qclientes
      DataField = 'clienteemail'
      CharCase = ecUpperCase
      TabOrder = 2
    end
    object RzDBLookupComboBox1: TRzDBLookupComboBox
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
      ValueChecked = 'True'
      ValueUnchecked = 'False'
    end
  end
  inherited RzToolbar1: TRzToolbar
    ToolbarControls = (
      RzToolButton1
      RzToolButton3)
    inherited RzToolButton1: TRzToolButton
      OnClick = RzToolButton1Click
    end
  end
  inherited StatusBar1: TStatusBar
    Top = 257
  end
end
