object DMClientes: TDMClientes
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Left = 218
  Top = 117
  Height = 330
  Width = 412
  object qclientes: TUniQuery
    SQLInsert.Strings = (
      'INSERT INTO clientes'
      '  (clientenome, clienteemail, deptoid, clientemktmail)'
      'VALUES'
      '  (:clientenome, :clienteemail, :deptoid, :clientemktmail)')
    SQLDelete.Strings = (
      'DELETE FROM clientes'
      'WHERE'
      '  clienteid = :Old_clienteid')
    SQLUpdate.Strings = (
      'UPDATE clientes'
      'SET'
      
        '  clienteid = :clienteid, clientenome = :clientenome, clienteema' +
        'il = :clienteemail, deptoid = :deptoid, clientemktmail = :client' +
        'emktmail'
      'WHERE'
      '  clienteid = :Old_clienteid')
    SQLLock.Strings = (
      'SELECT * FROM clientes'
      'WHERE'
      '  clienteid = :Old_clienteid'
      'FOR UPDATE NOWAIT')
    SQLRefresh.Strings = (
      
        'SELECT clienteid, clientenome, clienteemail, deptoid, clientemkt' +
        'mail FROM clientes'
      'WHERE'
      '  clienteid = :clienteid')
    Connection = FormPrincipal.UniConnection1
    SQL.Strings = (
      'select * from clientes where clienteid = :clienteid')
    Left = 48
    Top = 8
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'clienteid'
      end>
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
  object QDepto: TUniQuery
    SQLInsert.Strings = (
      'INSERT INTO clientes'
      
        '  (clienteid, clientenome, clienteemail, deptoid, clientemktmail' +
        ')'
      'VALUES'
      
        '  (:clienteid, :clientenome, :clienteemail, :deptoid, :clientemk' +
        'tmail)')
    SQLDelete.Strings = (
      'DELETE FROM clientes'
      'WHERE'
      '  clienteemail = :Old_clienteemail')
    SQLUpdate.Strings = (
      'UPDATE clientes'
      'SET'
      
        '  clienteid = :clienteid, clientenome = :clientenome, clienteema' +
        'il = :clienteemail, deptoid = :deptoid, clientemktmail = :client' +
        'emktmail'
      'WHERE'
      '  clienteemail = :Old_clienteemail')
    SQLLock.Strings = (
      'SELECT * FROM clientes'
      'WHERE'
      '  clienteemail = :Old_clienteemail'
      'FOR UPDATE NOWAIT')
    SQLRefresh.Strings = (
      
        'SELECT clienteid, clientenome, clienteemail, deptoid, clientemkt' +
        'mail FROM clientes'
      'WHERE'
      '  clienteemail = :clienteemail')
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
