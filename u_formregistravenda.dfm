object FormRegistraVenda: TFormRegistraVenda
  Left = 249
  Top = 125
  Width = 704
  Height = 357
  Caption = 'Registrar vendas'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PanelTopo: TPanel
    Left = 0
    Top = 0
    Width = 696
    Height = 57
    Align = alTop
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 12
      Width = 63
      Height = 13
      Caption = 'Data registro'
    end
    object RzDateTimePickerReg: TRzDateTimePicker
      Left = 8
      Top = 28
      Width = 89
      Height = 21
      Date = 42303.961509016200000000
      Time = 42303.961509016200000000
      TabOrder = 0
      ShowToday = True
      ShowTodayCircle = True
    end
    object ButtonIniciar: TButton
      Left = 104
      Top = 24
      Width = 75
      Height = 25
      Caption = 'Iniciar'
      TabOrder = 1
      OnClick = ButtonIniciarClick
    end
  end
  object PanelDigita: TPanel
    Left = 0
    Top = 57
    Width = 696
    Height = 269
    Align = alClient
    BevelOuter = bvNone
    Ctl3D = False
    Enabled = False
    ParentCtl3D = False
    TabOrder = 1
    object RzDBGridItens: TRzDBGrid
      Left = 0
      Top = 0
      Width = 696
      Height = 228
      Align = alClient
      Ctl3D = False
      DataSource = DS_Itens
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      Options = [dgEditing, dgAlwaysShowEditor, dgTitles, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 0
      TitleFont.Charset = ANSI_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Courier New'
      TitleFont.Style = [fsBold]
      Columns = <
        item
          Expanded = False
          FieldName = 'ProdutoNome'
          Width = 240
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ClienteNome'
          PickList.Strings = (
            'Mayara Kaloa dos Santos'
            'Patr'#237'cia Saraiva')
          Width = 240
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'RegVenQtde'
          Width = 60
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'RegVenVlrUnit'
          ReadOnly = True
          Width = 60
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'RegVenVlrTot'
          ReadOnly = True
          Width = 60
          Visible = True
        end>
    end
    object Panel1: TPanel
      Left = 0
      Top = 228
      Width = 696
      Height = 41
      Align = alBottom
      BevelOuter = bvNone
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 1
      object BitBtnOk: TBitBtn
        Left = 8
        Top = 8
        Width = 75
        Height = 25
        Caption = 'OK'
        TabOrder = 0
        OnClick = BitBtnOkClick
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
      object BitBtnCancel: TBitBtn
        Left = 88
        Top = 8
        Width = 75
        Height = 25
        Cancel = True
        Caption = 'Cancelar'
        TabOrder = 1
        OnClick = BitBtnCancelClick
        Glyph.Data = {
          DE010000424DDE01000000000000760000002800000024000000120000000100
          0400000000006801000000000000000000001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          333333333333333333333333000033338833333333333333333F333333333333
          0000333911833333983333333388F333333F3333000033391118333911833333
          38F38F333F88F33300003339111183911118333338F338F3F8338F3300003333
          911118111118333338F3338F833338F3000033333911111111833333338F3338
          3333F8330000333333911111183333333338F333333F83330000333333311111
          8333333333338F3333383333000033333339111183333333333338F333833333
          00003333339111118333333333333833338F3333000033333911181118333333
          33338333338F333300003333911183911183333333383338F338F33300003333
          9118333911183333338F33838F338F33000033333913333391113333338FF833
          38F338F300003333333333333919333333388333338FFF830000333333333333
          3333333333333333333888330000333333333333333333333333333333333333
          0000}
        NumGlyphs = 2
      end
    end
  end
  object CDSItens: TClientDataSet
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'ProdutoID'
        DataType = ftInteger
      end
      item
        Name = 'ClienteID'
        DataType = ftInteger
      end
      item
        Name = 'RegVenQtde'
        DataType = ftFloat
      end
      item
        Name = 'RegVenVlrUnit'
        DataType = ftCurrency
      end
      item
        Name = 'RegVenVlrTot'
        DataType = ftCurrency
      end
      item
        Name = 'RegVenDataRef'
        DataType = ftDate
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    BeforePost = CDSItensBeforePost
    OnNewRecord = CDSItensNewRecord
    Left = 368
    Top = 184
    object CDSItensProdutoID: TIntegerField
      DisplayLabel = 'Prod.Cd.'
      DisplayWidth = 20
      FieldName = 'ProdutoID'
    end
    object CDSItensClienteID: TIntegerField
      DisplayLabel = 'Cliente cd.'
      DisplayWidth = 20
      FieldName = 'ClienteID'
    end
    object CDSItensRegVenQtde: TFloatField
      DisplayLabel = 'Qtde.'
      DisplayWidth = 20
      FieldName = 'RegVenQtde'
    end
    object CDSItensRegVenVlrUnit: TCurrencyField
      DisplayLabel = 'Unit.'
      DisplayWidth = 20
      FieldName = 'RegVenVlrUnit'
    end
    object CDSItensRegVenVlrTot: TCurrencyField
      DisplayLabel = 'Total'
      DisplayWidth = 20
      FieldName = 'RegVenVlrTot'
    end
    object CDSItensRegVenDataRef: TDateField
      FieldName = 'RegVenDataRef'
      Visible = False
    end
    object CDSItensProdutoNome: TStringField
      DisplayLabel = 'Produto'
      FieldKind = fkLookup
      FieldName = 'ProdutoNome'
      LookupDataSet = QProdutos
      LookupKeyFields = 'ProdutoID'
      LookupResultField = 'ProdutoNome'
      KeyFields = 'ProdutoID'
      Size = 255
      Lookup = True
    end
    object CDSItensClienteNome: TStringField
      DisplayLabel = 'Cliente'
      FieldKind = fkLookup
      FieldName = 'ClienteNome'
      LookupDataSet = QClientes
      LookupKeyFields = 'ClienteID'
      LookupResultField = 'ClienteNome'
      KeyFields = 'ClienteID'
      Size = 255
      Lookup = True
    end
  end
  object DS_Itens: TDataSource
    DataSet = CDSItens
    Left = 424
    Top = 184
  end
  object QProdutos: TADOQuery
    Connection = FormPrincipal.ADOConnection1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select *'
      'from ListaPrecoAtual'
      'order by ProdutoNome ')
    Left = 368
    Top = 72
    object QProdutosProdutoID: TAutoIncField
      FieldName = 'ProdutoID'
      ReadOnly = True
    end
    object QProdutosProdutoNome: TWideStringField
      FieldName = 'ProdutoNome'
      Size = 255
    end
    object QProdutosProdPrecoVenData: TDateTimeField
      FieldName = 'ProdPrecoVenData'
    end
    object QProdutosMaxDeProdPrecoVenData: TDateTimeField
      FieldName = 'MaxDeProdPrecoVenData'
    end
    object QProdutosProdPrecoVenValor: TBCDField
      FieldName = 'ProdPrecoVenValor'
      Precision = 19
    end
  end
  object QClientes: TADOQuery
    Connection = FormPrincipal.ADOConnection1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select ClienteID, ClienteNome'
      'from Clientes'
      'order by ClienteNome')
    Left = 368
    Top = 128
    object QClientesClienteID: TAutoIncField
      FieldName = 'ClienteID'
      ReadOnly = True
    end
    object QClientesClienteNome: TWideStringField
      FieldName = 'ClienteNome'
      Size = 255
    end
  end
end
