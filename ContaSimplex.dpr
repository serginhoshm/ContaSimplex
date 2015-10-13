program ContaSimplex;

uses
  Forms,
  u_faturamento in 'u_faturamento.pas',
  u_mailmarketing in 'u_mailmarketing.pas',
  u_mailsender in 'u_mailsender.pas',
  u_dm in 'u_dm.pas',
  u_principal in 'u_principal.pas' {FormPrincipal},
  u_bibliotecas in 'u_bibliotecas.pas';

{$R *.res}

begin
  Application.Initialize;
  DM := TDM.Create;
  Application.Title := 'ContaSimples';
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.
