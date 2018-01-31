object DMRegVenda: TDMRegVenda
  OldCreateOrder = False
  Left = 296
  Top = 108
  Height = 365
  Width = 540
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
        Name = 'ItemNro'
        Attributes = [faReadonly]
        DataType = ftAutoInc
      end
      item
        Name = 'RegVenQtde'
        DataType = ftInteger
      end
      item
        Name = 'RegVenVlrUnit'
        DataType = ftFloat
      end
      item
        Name = 'RegVenVlrTot'
        DataType = ftFloat
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
    Left = 32
    Top = 120
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
    object CDSItensRegVenVlrUnit: TFloatField
      DisplayLabel = 'Unit.'
      FieldName = 'RegVenVlrUnit'
      DisplayFormat = '#0.00'
    end
    object CDSItensRegVenQtde: TIntegerField
      FieldName = 'RegVenQtde'
    end
    object CDSItensRegVenVlrTot: TFloatField
      DisplayLabel = 'Total'
      FieldName = 'RegVenVlrTot'
      DisplayFormat = '#0.00'
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
    object CDSItensItemNro: TAutoIncField
      FieldName = 'ItemNro'
    end
  end
  object DS_Itens: TDataSource
    DataSet = CDSItens
    Left = 88
    Top = 120
  end
  object QProdutos: TADOQuery
    BeforeOpen = QProdutosBeforeOpen
    Parameters = <>
    SQL.Strings = (
      'select max(pv.prodprecovendata) prodprecovendata, '
      'p.produtoid, '
      'p.produtonome, '
      'pv.prodprecovenvalor'
      'from produtos p'
      'join produtosprecovenda pv'
      'on pv.produtoid = p.produtoid'
      
        'group by p.produtoid, p.produtonome, pv.prodprecovenvalor,  pv.p' +
        'rodprecovendata'
      
        'having pv.prodprecovendata = (select max(prodprecovendata) from ' +
        'produtosprecovenda pv2 where pv2.produtoid = p.produtoid)'
      'order by p.produtonome')
    Left = 32
    Top = 8
    object QProdutosprodprecovendata: TDateTimeField
      FieldName = 'prodprecovendata'
    end
    object QProdutosprodutoid: TIntegerField
      FieldName = 'produtoid'
    end
    object QProdutosprodutonome: TWideStringField
      FieldName = 'produtonome'
      Size = 255
    end
    object QProdutosprodprecovenvalor: TFloatField
      FieldName = 'prodprecovenvalor'
    end
  end
  object QClientes: TADOQuery
    BeforeOpen = QClientesBeforeOpen
    Parameters = <>
    SQL.Strings = (
      'select clienteid, clientenome'
      'from clientes'
      'order by clientenome')
    Left = 32
    Top = 64
    object QClientesclienteid: TIntegerField
      AutoGenerateValue = arAutoInc
      FieldName = 'clienteid'
    end
    object QClientesclientenome: TWideStringField
      FieldName = 'clientenome'
      Required = True
      Size = 255
    end
  end
end
