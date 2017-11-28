object DMClientes: TDMClientes
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 330
  Width = 412
  object qclientes: TADOQuery
    Parameters = <>
    SQL.Strings = (
      'select * from clientes where clienteid = :clienteid')
    Left = 48
    Top = 8
    object qclientesclienteid: TIntegerField
      AutoGenerateValue = arAutoInc
      FieldName = 'clienteid'
    end
    object qclientesclientenome: TWideStringField
      FieldName = 'clientenome'
      Required = True
      Size = 255
    end
    object qclientesclienteemail: TWideStringField
      FieldName = 'clienteemail'
      Size = 255
    end
    object qclientesdeptoid: TIntegerField
      FieldName = 'deptoid'
      Required = True
    end
    object qclientesclientemktmail: TBooleanField
      FieldName = 'clientemktmail'
    end
  end
  object ds_qclientes: TDataSource
    AutoEdit = False
    DataSet = qclientes
    Left = 120
    Top = 8
  end
  object QDepto: TADOQuery
    Parameters = <>
    SQL.Strings = (
      'select * from departamentos order by deptodescricao')
    Left = 48
    Top = 72
    object QDeptodeptoid: TIntegerField
      FieldName = 'deptoid'
    end
    object QDeptodeptodescricao: TWideStringField
      FieldName = 'deptodescricao'
      Size = 255
    end
  end
  object ds_depto: TDataSource
    AutoEdit = False
    DataSet = QDepto
    Left = 120
    Top = 72
  end
end
