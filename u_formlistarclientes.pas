unit u_formlistarclientes;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_formalistarpadrao, DB, ExtCtrls, Grids, DBGrids, Data.Win.ADODB,
  Vcl.ComCtrls, Vcl.ToolWin;

type
  TFormListarClientes = class(TFormListarPadrao)
    procedure RzToolButton1Click(Sender: TObject);
    procedure RzToolButton2Click(Sender: TObject);
  private
    { Private declarations }
    procedure SQLConsultaPadrao; override;
  public
    { Public declarations }
  end;

var
  FormListarClientes: TFormListarClientes;

implementation

uses
  u_dm, u_formcadclientes;

{$R *.dfm}

{ TFormListarClientes }

procedure TFormListarClientes.SQLConsultaPadrao;
begin
  inherited;
  QLista.Connection := DM.GetConexao;
  QLista.SQL.Add('select clienteid, clientenome');
  QLista.SQL.Add('from clientes');
  QLista.SQL.Add('order by clientenome');
  QLista.Open;
end;

procedure TFormListarClientes.RzToolButton1Click(Sender: TObject);
var
  ABmk: TBookmark;
begin
  inherited;
  FormCadastroClientes := TFormCadastroClientes.Create(nil);
  try
    ABmk := RzDBGridLista.DataSource.DataSet.GetBookmark;
    FormCadastroClientes.Alterar(RzDBGridLista.DataSource.DataSet.FieldByName('clienteid').AsInteger);
    FormCadastroClientes.ShowModal;
    QLista.Refresh;
    if RzDBGridLista.DataSource.DataSet.BookmarkValid(ABmk) then
      RzDBGridLista.DataSource.DataSet.GotoBookmark(ABmk);
  finally
    FreeAndNil(FormCadastroClientes);
  end;

end;

procedure TFormListarClientes.RzToolButton2Click(Sender: TObject);
begin
  inherited;
  FormCadastroClientes := TFormCadastroClientes.Create(nil);
  try
    FormCadastroClientes.Incluir;
    FormCadastroClientes.ShowModal;
  finally
    FreeAndNil(FormCadastroClientes);
  end;
end;

end.
