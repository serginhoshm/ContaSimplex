program ContaSimplex;

uses
  Forms,
  u_faturamento in 'u_faturamento.pas',
  u_mailmarketing in 'u_mailmarketing.pas',
  u_mailsender in 'u_mailsender.pas',
  u_dm in 'u_dm.pas',
  u_principal in 'u_principal.pas' {FormPrincipal},
  u_bibliotecas in 'u_bibliotecas.pas',
  u_formfaturamento in 'u_formfaturamento.pas' {FormFaturamento},
  u_formenviaemail in 'u_formenviaemail.pas' {FormEnviaEmails},
  u_acess2pgsql in 'u_acess2pgsql.pas',
  u_formcadastropadrao in 'u_formcadastropadrao.pas' {FormCadastroPadrao},
  u_formalistarpadrao in 'u_formalistarpadrao.pas' {FormListarPadrao},
  u_formlistarprodutos in 'u_formlistarprodutos.pas' {FormListarProdutos};

{$R *.res}

begin
  Application.Initialize;
  DM := TDM.Create;
  Application.Title := 'ContaSimples';
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.
