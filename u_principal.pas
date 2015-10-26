unit u_principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, SkinCaption, WinSkinData;

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
    SkinData1: TSkinData;
    SkinCaption1: TSkinCaption;
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
    procedure Lerresultadosenquete1Click(Sender: TObject);
    procedure Gerarfaturamentos1Click(Sender: TObject);
    procedure Enviaremailfaturamentospend1Click(Sender: TObject);
    procedure Produtod1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

uses u_mailmarketing, u_formfaturamento, u_formenviaemail,
  u_formlistarprodutos;

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

end.
