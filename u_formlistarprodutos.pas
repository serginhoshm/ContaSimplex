unit u_formlistarprodutos;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_formalistarpadrao, DB, ADODB, RzPanel, ExtCtrls, Grids,
  DBGrids, RzDBGrid, RzButton;

type
  TFormListarProdutos = class(TFormListarPadrao)
    procedure RzToolButton1Click(Sender: TObject);
  private
    { Private declarations }
    procedure SQLConsultaPadrao;
  public
    { Public declarations }
  end;

var
  FormListarProdutos: TFormListarProdutos;

implementation

uses u_dm;

{$R *.dfm}

{ TFormListarProdutos }

procedure TFormListarProdutos.SQLConsultaPadrao;
begin
  inherited;
  QueryLista.Connection := DM.GetConexao;
  QueryLista.SQL.Text := 'select * from Produtos';
  QueryLista.Open;



end;

procedure TFormListarProdutos.RzToolButton1Click(Sender: TObject);
begin
  inherited;
  SQLConsultaPadrao;
end;

end.
