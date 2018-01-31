unit u_dmregvenda;

interface

uses
  SysUtils, Classes, DB, DBClient, ADODB, Variants;

type
  TDMRegVenda = class(TDataModule)
    CDSItens: TClientDataSet;
    CDSItensProdutoID: TIntegerField;
    CDSItensClienteID: TIntegerField;
    CDSItensRegVenVlrUnit: TFloatField;
    CDSItensRegVenVlrTot: TFloatField;
    CDSItensRegVenDataRef: TDateField;
    CDSItensProdutoNome: TStringField;
    CDSItensClienteNome: TStringField;
    CDSItensItemNro: TAutoIncField;
    DS_Itens: TDataSource;
    QProdutos: TADOQuery;
    QProdutosprodprecovendata: TDateTimeField;
    QProdutosprodutoid: TIntegerField;
    QProdutosprodutonome: TWideStringField;
    QProdutosprodprecovenvalor: TFloatField;
    QClientes: TADOQuery;
    QClientesclienteid: TIntegerField;
    QClientesclientenome: TWideStringField;
    CDSItensRegVenQtde: TIntegerField;
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
  QProdutos.Filter := 'produtoid = ' + CDSItensProdutoID.AsString;
  QProdutos.Filtered := true;
  if not QProdutos.Eof then
  begin
    CDSItensRegVenVlrUnit.AsFloat := QProdutosProdPrecoVenValor.AsFloat;
    CDSItensRegVenVlrTot.AsFloat := CDSItensRegVenQtde.AsInteger * CDSItensRegVenVlrUnit.AsFloat;
  end
  else
    raise Exception.Create('Produto não localizado -> ProdutoID: ' + CDSItensProdutoID.AsString);
end;


procedure TDMRegVenda.CDSItensNewRecord(DataSet: TDataSet);
begin
  CDSItensRegVenQtde.AsInteger := 1;
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
