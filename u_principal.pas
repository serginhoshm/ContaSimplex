unit u_principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, DB, ADODB, ImgList, ActnMan, ActnColorMaps, XPMan,
  ActnList, ToolWin, ComCtrls;

type
  TFormPrincipal = class(TForm)
    Img: TImageList;
    StatusBar1: TStatusBar;
    ToolBar1: TToolBar;
    ActionList1: TActionList;
    actCadClientes: TAction;
    actItensVendidos: TAction;
    actGeraFaturamentos: TAction;
    actEnviarEmailsFatPendentes: TAction;
    actEnviarRecibosPendentes: TAction;
    actEmitirRecibo: TAction;
    actRelFaturamentosPendentes: TAction;
    actRecebeResultEnquete: TAction;
    actMarketingListarEmails: TAction;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    procedure Produtod1Click(Sender: TObject);
    procedure Baixacrditos1Click(Sender: TObject);
    procedure actCadClientesExecute(Sender: TObject);
    procedure actItensVendidosExecute(Sender: TObject);
    procedure actGeraFaturamentosExecute(Sender: TObject);
    procedure actEnviarEmailsFatPendentesExecute(Sender: TObject);
    procedure actEnviarRecibosPendentesExecute(Sender: TObject);
    procedure actEmitirReciboExecute(Sender: TObject);
    procedure actRelFaturamentosPendentesExecute(Sender: TObject);
    procedure actRecebeResultEnqueteExecute(Sender: TObject);
    procedure actMarketingListarEmailsExecute(Sender: TObject);
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

procedure TFormPrincipal.Produtod1Click(Sender: TObject);
begin
  FormListarProdutos := TFormListarProdutos.Create(nil);
  try
    FormListarProdutos.ShowModal;
  finally
    FreeAndNil(FormListarProdutos);
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

procedure TFormPrincipal.actCadClientesExecute(Sender: TObject);
begin
  FormListarClientes := TFormListarClientes.Create(nil);
  try
    FormListarClientes.ShowModal;
  finally
    FreeAndNil(FormListarClientes);
  end;
end;

procedure TFormPrincipal.actItensVendidosExecute(Sender: TObject);
begin
  FormRegistraVenda := TFormRegistraVenda.Create(nil);
  try
    FormRegistraVenda.ShowModal;
  finally
    FreeAndNil(FormRegistraVenda);
  end;
end;

procedure TFormPrincipal.actGeraFaturamentosExecute(Sender: TObject);
begin
  FormFaturamento := TFormFaturamento.Create(nil);
  try
    FormFaturamento.ShowModal;
  finally
    FreeAndNil(FormFaturamento);
  end;
end;

procedure TFormPrincipal.actEnviarEmailsFatPendentesExecute(Sender: TObject);
begin
  FormEnviaEmails := TFormEnviaEmails.Create(nil);
  try
    FormEnviaEmails.ShowModal;
  finally
    FreeAndNil(FormEnviaEmails);
  end;
end;

procedure TFormPrincipal.actEnviarRecibosPendentesExecute(Sender: TObject);
begin
  FormEnviaEmailsRec := TFormEnviaEmailsRec.Create(nil);
  try
    FormEnviaEmailsRec.ShowModal;
  finally
    FreeAndNil(FormEnviaEmailsRec);
  end;
end;

procedure TFormPrincipal.actEmitirReciboExecute(Sender: TObject);
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

procedure TFormPrincipal.actRelFaturamentosPendentesExecute(
  Sender: TObject);
begin
  FormRelFaturamentosPendetes := TFormRelFaturamentosPendetes.Create(nil);
  try
    FormRelFaturamentosPendetes.ShowModal;
  finally
    FreeAndNil(FormRelFaturamentosPendetes);
  end;
end;

procedure TFormPrincipal.actRecebeResultEnqueteExecute(Sender: TObject);
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

procedure TFormPrincipal.actMarketingListarEmailsExecute(Sender: TObject);
begin
  FormListaEmail := TFormListaEmail.Create(nil);
  try
    FormListaEmail.ShowModal;
  finally
    FreeAndNil(FormListaEmail);
  end;
end;

end.
