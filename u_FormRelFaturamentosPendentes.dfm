inherited FormRelFaturamentosPendetes: TFormRelFaturamentosPendetes
  Caption = 'Faturamentos pendentes'
  PixelsPerInch = 96
  TextHeight = 13
  inherited RzToolbar1: TRzToolbar
    ToolbarControls = (
      RzToolButton1
      RzToolButton3
      RzToolButton2)
    inherited RzToolButton1: TRzToolButton
      OnClick = RzToolButton1Click
    end
    object RzToolButton2: TRzToolButton
      Left = 106
      Top = 0
      Width = 52
      Height = 50
      ImageIndex = 16
      Images = FormPrincipal.Img
      Layout = blGlyphTop
      ShowCaption = True
      UseToolbarButtonLayout = False
      UseToolbarShowCaption = False
      Caption = 'Recobrar'
      OnClick = RzToolButton2Click
    end
    object RzToolButton3: TRzToolButton
      Left = 56
      Top = 0
    end
  end
  object Memo1: TMemo [2]
    Left = 8
    Top = 56
    Width = 505
    Height = 249
    TabOrder = 2
  end
  inherited frxReportPadrao: TfrxReport
    ReportOptions.CreateDate = 42380.925057395800000000
    ReportOptions.LastChange = 42414.838948182870000000
    Left = 144
    Top = 64
    Datasets = <
      item
        DataSet = frxDBDatasset_qFatur
        DataSetName = 'frxDBDatasset_qFatur'
      end>
    Variables = <>
    Style = <
      item
        Name = 'Title'
        Color = clNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = [fsBold]
      end
      item
        Name = 'Header'
        Color = clNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
      end
      item
        Name = 'Group header'
        Color = clNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftBottom]
      end
      item
        Name = 'Data'
        Color = clNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
      end
      item
        Name = 'Group footer'
        Color = clNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftTop]
      end
      item
        Name = 'Header line'
        Color = clNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        Frame.Typ = [ftBottom]
        Frame.Width = 2.000000000000000000
      end>
    object Data: TfrxDataPage
      Height = 1000.000000000000000000
      Width = 1000.000000000000000000
    end
    object Page1: TfrxReportPage
      Orientation = poLandscape
      PaperWidth = 297.000000000000000000
      PaperHeight = 210.000000000000000000
      PaperSize = 9
      LeftMargin = 10.000000000000000000
      RightMargin = 10.000000000000000000
      TopMargin = 10.000000000000000000
      BottomMargin = 10.000000000000000000
      object ReportTitle1: TfrxReportTitle
        Height = 26.456710000000000000
        Top = 18.897650000000000000
        Width = 1046.929810000000000000
        object Memo1: TfrxMemoView
          Align = baWidth
          Width = 1046.929810000000000000
          Height = 22.677180000000000000
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Courier New'
          Font.Style = [fsBold]
          HAlign = haCenter
          Memo.UTF8 = (
            'Faturamentos pendentes por cliente')
          ParentFont = False
          VAlign = vaCenter
        end
      end
      object PageHeader1: TfrxPageHeader
        Height = 22.677180000000000000
        Top = 68.031540000000000000
        Width = 1046.929810000000000000
        object Memo2: TfrxMemoView
          Width = 1046.929133860000000000
          Height = 22.677180000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftBottom]
          Frame.Width = 2.000000000000000000
          ParentFont = False
        end
        object Memo3: TfrxMemoView
          Left = 37.795300000000000000
          Width = 78.059540680000000000
          Height = 22.677180000000000000
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Courier New'
          Font.Style = [fsBold]
          Memo.UTF8 = (
            'Fatur.')
          ParentFont = False
        end
        object Memo5: TfrxMemoView
          Left = 117.700836090000000000
          Width = 132.283464566929000000
          Height = 22.677180000000000000
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Courier New'
          Font.Style = [fsBold]
          Memo.UTF8 = (
            'Data ger.')
          ParentFont = False
        end
        object Memo6: TfrxMemoView
          Left = 257.008040000000000000
          Width = 113.385826770000000000
          Height = 22.677180000000000000
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Courier New'
          Font.Style = [fsBold]
          HAlign = haRight
          Memo.UTF8 = (
            'Total')
          ParentFont = False
        end
        object Memo7: TfrxMemoView
          Left = 377.748300000000000000
          Width = 113.385826770000000000
          Height = 22.677180000000000000
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Courier New'
          Font.Style = [fsBold]
          HAlign = haRight
          Memo.UTF8 = (
            'Cancelado')
          ParentFont = False
        end
      end
      object GroupHeader1: TfrxGroupHeader
        Height = 26.456710000000000000
        Top = 151.181200000000000000
        Width = 1046.929810000000000000
        Condition = 'frxDBDatasset_qFatur."clienteid"'
        object Memo10: TfrxMemoView
          Align = baWidth
          Top = 2.779530000000000000
          Width = 1046.929810000000000000
          Height = 18.897650000000000000
          DataSet = frxDBDatasset_qFatur
          DataSetName = 'frxDBDatasset_qFatur'
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Courier New'
          Font.Style = []
          Memo.UTF8 = (
            
              '[frxDBDatasset_qFatur."clientenome"] ([frxDBDatasset_qFatur."cli' +
              'enteid"])')
          ParentFont = False
        end
      end
      object MasterData1: TfrxMasterData
        Height = 18.897650000000000000
        Top = 200.315090000000000000
        Width = 1046.929810000000000000
        DataSet = frxDBDatasset_qFatur
        DataSetName = 'frxDBDatasset_qFatur'
        RowCount = 0
        object Memo9: TfrxMemoView
          Left = 37.795300000000000000
          Width = 74.280010680000000000
          Height = 18.897650000000000000
          DataField = 'faturid'
          DataSet = frxDBDatasset_qFatur
          DataSetName = 'frxDBDatasset_qFatur'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Courier New'
          Font.Style = []
          Memo.UTF8 = (
            '[frxDBDatasset_qFatur."faturid"]')
          ParentFont = False
        end
        object Memo11: TfrxMemoView
          Left = 117.700836090000000000
          Width = 132.283464566929000000
          Height = 18.897650000000000000
          DataField = 'faturdatageracao'
          DataSet = frxDBDatasset_qFatur
          DataSetName = 'frxDBDatasset_qFatur'
          DisplayFormat.DecimalSeparator = ','
          DisplayFormat.FormatStr = 'dd mmm yyyy'
          DisplayFormat.Kind = fkDateTime
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Courier New'
          Font.Style = []
          Memo.UTF8 = (
            '[frxDBDatasset_qFatur."faturdatageracao"]')
          ParentFont = False
        end
        object Memo12: TfrxMemoView
          Left = 257.008040000000000000
          Width = 113.385826770000000000
          Height = 18.897650000000000000
          DataField = 'faturvalortotal'
          DataSet = frxDBDatasset_qFatur
          DataSetName = 'frxDBDatasset_qFatur'
          DisplayFormat.DecimalSeparator = ','
          DisplayFormat.FormatStr = '%2.2f'
          DisplayFormat.Kind = fkNumeric
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Courier New'
          Font.Style = []
          HAlign = haRight
          Memo.UTF8 = (
            '[frxDBDatasset_qFatur."faturvalortotal"]')
          ParentFont = False
        end
        object Memo13: TfrxMemoView
          Left = 377.748300000000000000
          Width = 113.385826770000000000
          Height = 18.897650000000000000
          DataField = 'faturvalorcancelado'
          DataSet = frxDBDatasset_qFatur
          DataSetName = 'frxDBDatasset_qFatur'
          DisplayFormat.DecimalSeparator = ','
          DisplayFormat.FormatStr = '%2.2f'
          DisplayFormat.Kind = fkNumeric
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Courier New'
          Font.Style = []
          HAlign = haRight
          Memo.UTF8 = (
            '[frxDBDatasset_qFatur."faturvalorcancelado"]')
          ParentFont = False
        end
      end
      object GroupFooter1: TfrxGroupFooter
        Height = 22.677180000000000000
        Top = 241.889920000000000000
        Width = 1046.929810000000000000
        object SysMemo1: TfrxSysMemoView
          Left = 257.008040000000000000
          Width = 113.385826770000000000
          Height = 18.897650000000000000
          DisplayFormat.DecimalSeparator = ','
          DisplayFormat.FormatStr = '%2.2f'
          DisplayFormat.Kind = fkNumeric
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftTop]
          HAlign = haRight
          Memo.UTF8 = (
            '[SUM(<frxDBDatasset_qFatur."faturvalortotal">,MasterData1)]')
          ParentFont = False
        end
        object SysMemo2: TfrxSysMemoView
          Left = 377.748300000000000000
          Width = 113.385826770000000000
          Height = 18.897650000000000000
          DisplayFormat.DecimalSeparator = ','
          DisplayFormat.FormatStr = '%2.2f'
          DisplayFormat.Kind = fkNumeric
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftTop]
          HAlign = haRight
          Memo.UTF8 = (
            '[SUM(<frxDBDatasset_qFatur."faturvalorcancelado">,MasterData1)]')
          ParentFont = False
        end
      end
      object PageFooter1: TfrxPageFooter
        Height = 26.456710000000000000
        Top = 389.291590000000000000
        Width = 1046.929810000000000000
        object Memo14: TfrxMemoView
          Align = baWidth
          Width = 1046.929810000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = [ftTop]
          Frame.Width = 2.000000000000000000
          ParentFont = False
        end
        object Memo15: TfrxMemoView
          Top = 1.000000000000000000
          Height = 22.677180000000000000
          AutoWidth = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Courier New'
          Font.Style = []
          Memo.UTF8 = (
            '[Date] [Time]')
          ParentFont = False
        end
        object Memo16: TfrxMemoView
          Align = baRight
          Left = 971.339210000000000000
          Top = 1.000000000000000000
          Width = 75.590600000000000000
          Height = 22.677180000000000000
          HAlign = haRight
          Memo.UTF8 = (
            'Page [Page#]')
        end
      end
      object ReportSummary1: TfrxReportSummary
        Height = 41.574830000000000000
        Top = 325.039580000000000000
        Width = 1046.929810000000000000
        object SysMemo3: TfrxSysMemoView
          Left = 257.008040000000000000
          Top = 3.779530000000000000
          Width = 113.385900000000000000
          Height = 18.897650000000000000
          DisplayFormat.DecimalSeparator = ','
          DisplayFormat.FormatStr = '%2.2f'
          DisplayFormat.Kind = fkNumeric
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Courier New'
          Font.Style = [fsBold]
          Frame.Typ = [ftTop]
          HAlign = haRight
          Memo.UTF8 = (
            '[SUM(<frxDBDatasset_qFatur."faturvalortotal">,MasterData1)]')
          ParentFont = False
        end
        object Memo4: TfrxMemoView
          Width = 78.059540680000000000
          Height = 22.677180000000000000
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Courier New'
          Font.Style = [fsBold]
          Memo.UTF8 = (
            'TOTAL')
          ParentFont = False
        end
        object SysMemo4: TfrxSysMemoView
          Left = 377.953000000000000000
          Top = 3.779530000000000000
          Width = 113.385900000000000000
          Height = 18.897650000000000000
          DisplayFormat.DecimalSeparator = ','
          DisplayFormat.FormatStr = '%2.2f'
          DisplayFormat.Kind = fkNumeric
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Courier New'
          Font.Style = [fsBold]
          Frame.Typ = [ftTop]
          HAlign = haRight
          Memo.UTF8 = (
            '[SUM(<frxDBDatasset_qFatur."faturvalorcancelado">,MasterData1)]')
          ParentFont = False
        end
      end
    end
  end
  object qFatur: TUniQuery
    SQLInsert.Strings = (
      'INSERT INTO faturamentospendentes'
      
        '  (faturid, clientenome, clienteemail, faturdatageracao, faturva' +
        'lortotal, faturvalorbaixado, faturdataenvioemail2, valorpendente' +
        ', faturvalorcancelado, clienteid)'
      'VALUES'
      
        '  (:faturid, :clientenome, :clienteemail, :faturdatageracao, :fa' +
        'turvalortotal, :faturvalorbaixado, :faturdataenvioemail2, :valor' +
        'pendente, :faturvalorcancelado, :clienteid)')
    SQLDelete.Strings = (
      'DELETE FROM faturamentospendentes'
      'WHERE'
      '  faturid = :Old_faturid')
    SQLUpdate.Strings = (
      'UPDATE faturamentospendentes'
      'SET'
      
        '  faturid = :faturid, clientenome = :clientenome, clienteemail =' +
        ' :clienteemail, faturdatageracao = :faturdatageracao, faturvalor' +
        'total = :faturvalortotal, faturvalorbaixado = :faturvalorbaixado' +
        ', faturdataenvioemail2 = :faturdataenvioemail2, valorpendente = ' +
        ':valorpendente, faturvalorcancelado = :faturvalorcancelado, clie' +
        'nteid = :clienteid'
      'WHERE'
      '  faturid = :Old_faturid')
    SQLLock.Strings = (
      'SELECT * FROM faturamentospendentes'
      'WHERE'
      '  faturid = :Old_faturid'
      'FOR UPDATE NOWAIT')
    SQLRefresh.Strings = (
      
        'SELECT faturid, clientenome, clienteemail, faturdatageracao, fat' +
        'urvalortotal, faturvalorbaixado, faturdataenvioemail2, valorpend' +
        'ente, faturvalorcancelado, clienteid FROM faturamentospendentes'
      'WHERE'
      '  faturid = :faturid')
    SQL.Strings = (
      'select * from faturamentospendentes'
      'order by clientenome, faturdatageracao desc')
    Left = 232
    Top = 64
    object qFaturfaturid: TIntegerField
      FieldName = 'faturid'
    end
    object qFaturclientenome: TWideStringField
      FieldName = 'clientenome'
      Size = 255
    end
    object qFaturclienteemail: TWideStringField
      FieldName = 'clienteemail'
      Size = 255
    end
    object qFaturfaturdatageracao: TDateTimeField
      FieldName = 'faturdatageracao'
    end
    object qFaturfaturvalortotal: TFloatField
      FieldName = 'faturvalortotal'
    end
    object qFaturfaturvalorbaixado: TFloatField
      FieldName = 'faturvalorbaixado'
    end
    object qFaturfaturdataenvioemail2: TDateTimeField
      FieldName = 'faturdataenvioemail2'
    end
    object qFaturvalorpendente: TFloatField
      FieldName = 'valorpendente'
    end
    object qFaturfaturvalorcancelado: TFloatField
      FieldName = 'faturvalorcancelado'
    end
    object qFaturclienteid: TIntegerField
      FieldName = 'clienteid'
    end
  end
  object frxDBDatasset_qFatur: TfrxDBDataset
    UserName = 'frxDBDatasset_qFatur'
    CloseDataSource = False
    DataSet = qFatur
    Left = 328
    Top = 64
  end
end
