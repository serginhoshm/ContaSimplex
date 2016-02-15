unit u_dmregvenda;

interface

uses
  SysUtils, Classes, DB, DBClient, MemDS, DBAccess, Uni;

type
  TDMRegVenda = class(TDataModule)
    CDSItens: TClientDataSet;
    CDSItensProdutoID: TIntegerField;
    CDSItensClienteID: TIntegerField;
    CDSItensRegVenQtde: TFloatField;
    CDSItensRegVenVlrUnit: TFloatField;
    CDSItensRegVenVlrTot: TFloatField;
    CDSItensRegVenDataRef: TDateField;
    CDSItensProdutoNome: TStringField;
    CDSItensClienteNome: TStringField;
    CDSItensItemNro: TAutoIncField;
    DS_Itens: TDataSource;
    QProdutos: TUniQuery;
    QProdutosprodprecovendata: TDateTimeField;
    QProdutosprodutoid: TIntegerField;
    QProdutosprodutonome: TWideStringField;
    QProdutosmaxdeprodprecovendata: TDateTimeField;
    QProdutosprodprecovenvalor: TFloatField;
    QClientes: TUniQuery;
    QClientesclienteid: TIntegerField;
    QClientesclientenome: TWideStringField;
    procedure CDSItensBeforePost(DataSet: TDataSet);
    procedure CDSItensNewRecord(DataSet: TDataSet);
    procedure QProdutosBeforeOpen(DataSet: TDataSet);
    procedure QClientesBeforeOpen(DataSet: TDataSet);
  private
    FGlobalDataRef: TDateTime;
    { Private declarations }
    procedure CalculaItem;
    procedure SetGlobalDataRef(const Value: TDateTime);
  public
    { Public declarations }
    property GlobalDataRef: TDateTime read FGlobalDataRef write SetGlobalDataRef;
  end;

implementation

uses u_principal, u_dm;

{$R *.dfm}

procedure TDMRegVenda.CDSItensBeforePost(DataSet: TDataSet);
begin
  CalculaItem;
end;

procedure TDMRegVenda.CalculaItem;
begin
  CDSItensRegVenVlrUnit.AsCurrency := QProdutosProdPrecoVenValor.AsCurrency;
  CDSItensRegVenVlrTot.AsCurrency := CDSItensRegVenQtde.AsFloat * CDSItensRegVenVlrUnit.AsCurrency;
end;


procedure TDMRegVenda.CDSItensNewRecord(DataSet: TDataSet);
begin
  CDSItensRegVenQtde.AsFloat := 1;
  CDSItensRegVenDataRef.AsDateTime := GlobalDataRef;
end;

procedure TDMRegVenda.SetGlobalDataRef(const Value: TDateTime);
begin
  FGlobalDataRef := Value;
end;

procedure TDMRegVenda.QProdutosBeforeOpen(DataSet: TDataSet);
begin
  QProdutos.Connection := DM.GetConexao;
end;

procedure TDMRegVenda.QClientesBeforeOpen(DataSet: TDataSet);
begin
  QClientes.Connection := DM.GetConexao;
end;

end.
