unit u_dmclientes;

interface

uses
  SysUtils, Classes, DB, ADODB;

type
  TDMClientes = class(TDataModule)
    ds_qclientes: TDataSource;
    QDepto: TADOQuery;
    ds_depto: TDataSource;
    QDeptodeptoid: TIntegerField;
    QDeptodeptodescricao: TWideStringField;
    qclientes: TADODataSet;
    qclientesclienteid: TIntegerField;
    qclientesclientenome: TWideStringField;
    qclientesclienteemail: TWideStringField;
    qclientesdeptoid: TIntegerField;
    qclientesclientemktmail: TBooleanField;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses
  u_principal, u_dm;

{$R *.dfm}

procedure TDMClientes.DataModuleCreate(Sender: TObject);
begin
  QDepto.Connection := DM.GetConexao;
  QDepto.Open;
  qclientes.Connection := DM.GetConexao;
end;

end.
