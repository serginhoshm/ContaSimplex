object DMClientes: TDMClientes
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Left = 404
  Top = 124
  Height = 330
  Width = 412
  object ds_qclientes: TDataSource
    AutoEdit = False
    DataSet = qclientes
    Left = 120
    Top = 8
  end
  object QDepto: TADOQuery
    ParamCheck = False
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
  object qclientes: TADODataSet
    CommandText = 'select * from clientes where clienteid = :clienteid'
    Parameters = <>
    Left = 48
    Top = 16
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
end
