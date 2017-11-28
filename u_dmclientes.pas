unit u_dmclientes;

interface

uses
  SysUtils, Classes, DB, Data.Win.ADODB;

type
  TDMClientes = class(TDataModule)
    qclientes: TADOQuery;
    ds_qclientes: TDataSource;
    qclientesclienteid: TIntegerField;
    qclientesclientenome: TWideStringField;
    qclientesclienteemail: TWideStringField;
    qclientesdeptoid: TIntegerField;
    qclientesclientemktmail: TBooleanField;
    QDepto: TADOQuery;
    ds_depto: TDataSource;
    QDeptodeptoid: TIntegerField;
    QDeptodeptodescricao: TWideStringField;
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
