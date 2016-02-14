unit u_principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, DB, ADODB, MemDS,
  DBAccess, Uni, UniProvider, PostgreSQLUniProvider, ImgList;

type
  TFormPrincipal = class(TForm)
    MainMenu1: TMainMenu;
    Cadastros1: TMenuItem;
    Faturamento1: TMenuItem;
    Marketing1: TMenuItem;
    Pesquisas1: TMenuItem;
    Lerresultadosenquete1: TMenuItem;
    Gerarfaturamentos1: TMenuItem;
    Enviaremailfaturamentospend1: TMenuItem;
    este1: TMenuItem;
    Produtod1: TMenuItem;
    Unidadesmedida1: TMenuItem;
    Departamentos1: TMenuItem;
    Clientes1: TMenuItem;
    Fornecedores1: TMenuItem;
    Movimento1: TMenuItem;
    Itenscomprados1: TMenuItem;
    Itensvendidos1: TMenuItem;
    Ativoimobilizado1: TMenuItem;
    Emailsautomticos1: TMenuItem;
    Listaremaill1: TMenuItem;
    PostgreSQLUniProvider1: TPostgreSQLUniProvider;
    UniConnection1: TUniConnection;
    UniQuery1: TUniQuery;
    Img: TImageList;
    Relatrios1: TMenuItem;
    Faturamentospendentes1: TMenuItem;
    Baixacrditos1: TMenuItem;
    Enviaremailrecibospend1: TMenuItem;
    procedure Lerresultadosenquete1Click(Sender: TObject);
    procedure Gerarfaturamentos1Click(Sender: TObject);
    procedure Enviaremailfaturamentospend1Click(Sender: TObject);
    procedure Produtod1Click(Sender: TObject);
    procedure Itensvendidos1Click(Sender: TObject);
    procedure Listaremaill1Click(Sender: TObject);
    procedure Clientes1Click(Sender: TObject);
    procedure este1Click(Sender: TObject);
    procedure Baixacrditos1Click(Sender: TObject);
    procedure Faturamentospendentes1Click(Sender: TObject);
    procedure Enviaremailrecibospend1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

uses u_mailmarketing, u_formfaturamento, u_formenviaemail,
  u_formlistarprodutos, u_formregistravenda, u_formlistaremail, 
  u_formlistarclientes, u_formrecebimento, u_formprocbaixarcreditos,
  u_FormRelFaturamentosPendentes, u_formenviaemailrec;

{$R *.dfm}

procedure TFormPrincipal.Lerresultadosenquete1Click(Sender: TObject);
var
  PesqSat: TPesquisaSat;
begin
  PesqSat := TPesquisaSat.Create;
  try
    PesqSat.ImportarDadosPlanilha;
  finally
    FreeAndNil(PesqSat);
  end;
end;

procedure TFormPrincipal.Gerarfaturamentos1Click(Sender: TObject);
begin
  FormFaturamento := TFormFaturamento.Create(nil);
  try
    FormFaturamento.ShowModal;
  finally
    FreeAndNil(FormFaturamento);
  end;
end;

procedure TFormPrincipal.Enviaremailfaturamentospend1Click(
  Sender: TObject);
begin
  FormEnviaEmails := TFormEnviaEmails.Create(nil);
  try
    FormEnviaEmails.ShowModal;
  finally
    FreeAndNil(FormEnviaEmails);
  end;
end;

procedure TFormPrincipal.Produtod1Click(Sender: TObject);
begin
  FormListarProdutos := TFormListarProdutos.Create(nil);
  try
    FormListarProdutos.ShowModal;
  finally
    FreeAndNil(FormListarProdutos);
  end;
end;

procedure TFormPrincipal.Itensvendidos1Click(Sender: TObject);
begin
  FormRegistraVenda := TFormRegistraVenda.Create(nil);
  try
    FormRegistraVenda.ShowModal;
  finally
    FreeAndNil(FormRegistraVenda);
  end;
end;

procedure TFormPrincipal.Listaremaill1Click(Sender: TObject);
begin
  FormListaEmail := TFormListaEmail.Create(nil);
  try
    FormListaEmail.ShowModal;
  finally
    FreeAndNil(FormListaEmail);
  end;
end;

procedure TFormPrincipal.Clientes1Click(Sender: TObject);
begin
  FormListarClientes := TFormListarClientes.Create(nil);
  try
    FormListarClientes.ShowModal;
  finally
    FreeAndNil(FormListarClientes);
  end;

end;

procedure TFormPrincipal.este1Click(Sender: TObject);
var
  FormRec: TFormRecebimento;
begin
  FormRec := TFormRecebimento.Create(nil);
  try
    FormRec.ShowModal;
  finally
    FreeAndNil(FormRec);
  end;
end;

procedure TFormPrincipal.Baixacrditos1Click(Sender: TObject);
var
  FormBaixarCreditosManual: TFormBaixarCreditosManual;
begin
  FormBaixarCreditosManual := TFormBaixarCreditosManual.Create(nil);
  try
    FormBaixarCreditosManual.ShowModal;
  finally
    FreeAndNil(FormBaixarCreditosManual);
  end;
//
end;

procedure TFormPrincipal.Faturamentospendentes1Click(Sender: TObject);
begin
  FormRelFaturamentosPendetes := TFormRelFaturamentosPendetes.Create(nil);
  try
    FormRelFaturamentosPendetes.ShowModal;
  finally
    FreeAndNil(FormRelFaturamentosPendetes);
  end;
end;

procedure TFormPrincipal.Enviaremailrecibospend1Click(Sender: TObject);
begin
  FormEnviaEmailsRec := TFormEnviaEmailsRec.Create(nil);
  try
    FormEnviaEmailsRec.ShowModal;
  finally
    FreeAndNil(FormEnviaEmailsRec);
  end;
end;

end.
