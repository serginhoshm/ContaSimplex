unit u_formlistarprodutos;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_formalistarpadrao, DB, ADODB, ExtCtrls, Grids,
  DBGrids, ComCtrls, ToolWin;

type
  TFormListarProdutos = class(TFormListarPadrao)
    procedure RzToolButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SQLConsultaPadrao; override;
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
  QLista.Connection := DM.GetConexao;
  QLista.SQL.Text := 'select * from Produtos';
  QLista.Open;
end;

procedure TFormListarProdutos.RzToolButton1Click(Sender: TObject);
begin
  inherited;
  SQLConsultaPadrao;
end;

end.
