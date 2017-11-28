inherited FormListarFaturPendente: TFormListarFaturPendente
  Left = 400
  Top = 151
  Caption = 'Listar faturamentos pendentes'
  KeyPreview = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited RzDBGridLista: TDBGrid
    Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    OnDblClick = RzDBGridListaDblClick
    OnKeyDown = RzDBGridListaKeyDown
    Columns = <
      item
        Expanded = False
        FieldName = 'faturid'
        Width = 46
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'clienteid'
        Width = 50
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'clientenome'
        Width = 187
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'faturvalortotal'
        Width = 63
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'faturvalorbaixado'
        Width = 71
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'faturvalorcancelado'
        Width = 62
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'faturdatageracao'
        Visible = True
      end>
  end
  inherited RzToolbar1: TToolBar
    Visible = False
    inherited RzToolButton1: TToolButton
      Visible = False
    end
    inherited RzToolButton2: TToolButton
      Visible = False
    end
  end
  inherited QLista: TADOQuery
    SQL.Strings = (
      'select * from faturamentospendentes'
      'order by clientenome, faturid')
    object QListafaturid: TIntegerField
      DisplayLabel = 'Fatur.'
      FieldName = 'faturid'
    end
    object QListaclienteid: TIntegerField
      DisplayLabel = 'ClienteID'
      FieldName = 'clienteid'
    end
    object QListaclientenome: TWideStringField
      DisplayLabel = 'Cliente'
      FieldName = 'clientenome'
      Size = 255
    end
    object QListafaturvalortotal: TFloatField
      DisplayLabel = 'Valor total'
      FieldName = 'faturvalortotal'
      DisplayFormat = '#0.00'
    end
    object QListafaturvalorbaixado: TFloatField
      DisplayLabel = 'Valor baixado'
      FieldName = 'faturvalorbaixado'
      DisplayFormat = '#0.00'
    end
    object QListafaturdatageracao: TDateTimeField
      DisplayLabel = 'Data ger.'
      FieldName = 'faturdatageracao'
    end
    object QListafaturvalorcancelado: TFloatField
      DisplayLabel = 'Valor canc.'
      FieldName = 'faturvalorcancelado'
    end
  end
end
