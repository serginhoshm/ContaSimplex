program ContaSimplex;

uses
  MidasLib,
  Forms,
  u_faturamento in 'u_faturamento.pas',
  u_mailmarketing in 'u_mailmarketing.pas',
  u_mailsender in 'u_mailsender.pas',
  u_dm in 'u_dm.pas',
  u_principal in 'u_principal.pas' {FormPrincipal},
  u_bibliotecas in 'u_bibliotecas.pas',
  u_formfaturamento in 'u_formfaturamento.pas' {FormFaturamento},
  u_formenviaemailrec in 'u_formenviaemailrec.pas' {FormEnviaEmailsRec},
  u_acess2pgsql in 'u_acess2pgsql.pas',
  u_formcadastropadrao in 'u_formcadastropadrao.pas' {FormCadastroPadrao},
  u_formalistarpadrao in 'u_formalistarpadrao.pas' {FormListarPadrao},
  u_formlistarprodutos in 'u_formlistarprodutos.pas' {FormListarProdutos},
  u_formregistravenda in 'u_formregistravenda.pas' {FormRegistraVenda},
  u_registrovenda in 'u_registrovenda.pas',
  u_formlistaremail in 'u_formlistaremail.pas' {FormListaEmail},
  u_dmclientes in 'u_dmclientes.pas' {DMClientes: TDataModule},
  u_formcadclientes in 'u_formcadclientes.pas' {FormCadastroClientes},
  u_formlistarclientes in 'u_formlistarclientes.pas' {FormListarClientes},
  u_formlistarfaturpendentes in 'u_formlistarfaturpendentes.pas' {FormListarFaturPendente},
  u_formrecebimento in 'u_formrecebimento.pas' {FormRecebimento},
  u_formprocpadrao in 'u_formprocpadrao.pas' {FormProcPadrao},
  u_formrelpadrao in 'u_formrelpadrao.pas' {FormRelPadrao},
  u_FormRelFaturamentosPendentes in 'u_FormRelFaturamentosPendentes.pas' {FormRelFaturamentosPendetes},
  u_formenviaemail in 'u_formenviaemail.pas' {FormEnviaEmails},
  u_dmregvenda in 'u_dmregvenda.pas' {DMRegVenda: TDataModule};

//{$R *.res}

begin
  Application.Initialize;
  DM := TDM.Create;
  Application.Title := 'ContaSimplex';
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.
