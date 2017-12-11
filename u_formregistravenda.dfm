object FormRegistraVenda: TFormRegistraVenda
  Left = 270
  Top = 112
  Caption = 'Registrar vendas'
  ClientHeight = 0
  ClientWidth = 120
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PanelTopo: TPanel
    Left = 0
    Top = 0
    Width = 120
    Height = 57
    Align = alTop
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 0
    ExplicitWidth = 986
    object Label1: TLabel
      Left = 8
      Top = 12
      Width = 63
      Height = 13
      Caption = 'Data registro'
    end
    object RzDateTimePickerReg: TDateTimePicker
      Left = 8
      Top = 28
      Width = 89
      Height = 21
      Date = 42303.961509016200000000
      Time = 42303.961509016200000000
      TabOrder = 0
      TabStop = False
    end
    object ButtonIniciar: TButton
      Left = 104
      Top = 24
      Width = 75
      Height = 25
      Caption = '&Iniciar'
      TabOrder = 1
      TabStop = False
      OnClick = ButtonIniciarClick
    end
  end
  object PanelDigita: TPanel
    Left = 0
    Top = 57
    Width = 120
    Height = 497
    Align = alClient
    BevelOuter = bvNone
    Ctl3D = False
    Enabled = False
    ParentCtl3D = False
    TabOrder = 1
    ExplicitWidth = 986
    object RzDBGridItens: TDBGrid
      Left = 0
      Top = 0
      Width = 986
      Height = 456
      Align = alClient
      Ctl3D = False
      DataSource = DMRegVenda.DS_Itens
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Consolas'
      Font.Style = []
      Options = [dgTitles, dgIndicator, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 0
      TitleFont.Charset = ANSI_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -12
      TitleFont.Name = 'Consolas'
      TitleFont.Style = [fsBold]
      Columns = <
        item
          Expanded = False
          FieldName = 'ItemNro'
          ReadOnly = True
          Title.Caption = 'Ord.'
          Width = 39
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ProdutoNome'
          Width = 350
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ClienteNome'
          PickList.Strings = (
            'Mayara Kaloa dos Santos'
            'Patr'#237'cia Saraiva')
          Width = 350
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'RegVenQtde'
          Width = 80
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'RegVenVlrUnit'
          ReadOnly = True
          Width = 80
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'RegVenVlrTot'
          ReadOnly = True
          Width = 80
          Visible = True
        end>
    end
    object Panel1: TPanel
      Left = 0
      Top = 456
      Width = 986
      Height = 41
      Align = alBottom
      BevelOuter = bvNone
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 1
      DesignSize = (
        120
        41)
      object BitBtnOk: TBitBtn
        Left = 8
        Top = 8
        Width = 75
        Height = 25
        Caption = '&OK'
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
        TabOrder = 0
        OnClick = BitBtnOkClick
      end
      object BitBtnCancel: TBitBtn
        Left = 88
        Top = 8
        Width = 75
        Height = 25
        Cancel = True
        Caption = 'Cancelar'
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
        TabOrder = 1
        OnClick = BitBtnCancelClick
      end
      object Button1: TButton
        Left = 30
        Top = 8
        Width = 75
        Height = 25
        Anchors = [akTop, akRight]
        Caption = 'Clientes'
        TabOrder = 2
        TabStop = False
        OnClick = Button1Click
        ExplicitLeft = 896
      end
      object Button2: TButton
        Left = -58
        Top = 8
        Width = 75
        Height = 25
        Anchors = [akTop, akRight]
        Caption = 'Adic. linhas'
        TabOrder = 3
        TabStop = False
        OnClick = Button2Click
        ExplicitLeft = 808
      end
    end
    object Panel2: TPanel
      Left = 0
      Top = 383
      Width = 877
      Height = 55
      Align = alBottom
      TabOrder = 2
      object Label2: TLabel
        Left = 24
        Top = 8
        Width = 39
        Height = 13
        Caption = 'ItemNro'
        FocusControl = DBEditItem
      end
      object Label3: TLabel
        Left = 87
        Top = 8
        Width = 33
        Height = 13
        Caption = 'Cliente'
        FocusControl = DBLookupComboBox1
      end
      object Label4: TLabel
        Left = 391
        Top = 8
        Width = 38
        Height = 13
        Caption = 'Produto'
        FocusControl = DBLookupComboBox2
      end
      object Label5: TLabel
        Left = 695
        Top = 8
        Width = 24
        Height = 13
        Caption = 'Qtde'
        FocusControl = DBEdit2
      end
      object DBEditItem: TDBEdit
        Left = 24
        Top = 24
        Width = 57
        Height = 19
        TabStop = False
        DataField = 'ItemNro'
        DataSource = DMRegVenda.DS_Itens
        ReadOnly = True
        TabOrder = 0
      end
      object DBLookupComboBox1: TDBLookupComboBox
        Left = 87
        Top = 24
        Width = 300
        Height = 19
        DataField = 'ClienteNome'
        DataSource = DMRegVenda.DS_Itens
        TabOrder = 1
      end
      object DBLookupComboBox2: TDBLookupComboBox
        Left = 391
        Top = 24
        Width = 300
        Height = 19
        DataField = 'ProdutoNome'
        DataSource = DMRegVenda.DS_Itens
        TabOrder = 2
      end
      object DBEdit2: TDBEdit
        Left = 695
        Top = 24
        Width = 130
        Height = 19
        DataField = 'RegVenQtde'
        DataSource = DMRegVenda.DS_Itens
        TabOrder = 3
        OnExit = DBEdit2Exit
      end
    end
  end
end
