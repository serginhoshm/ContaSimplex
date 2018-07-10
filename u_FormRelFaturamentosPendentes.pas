unit u_FormRelFaturamentosPendentes;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_formrelpadrao, ExtCtrls, DB, StdCtrls, ADODB,
  ComCtrls, ToolWin;

type
  TFormRelFaturamentosPendetes = class(TFormRelPadrao)
    qFatur: TADOQuery;
    qFaturfaturid: TIntegerField;
    qFaturclientenome: TWideStringField;
    qFaturclienteemail: TWideStringField;
    qFaturfaturdatageracao: TDateTimeField;
    qFaturfaturvalortotal: TFloatField;
    qFaturfaturvalorbaixado: TFloatField;
    qFaturfaturdataenvioemail2: TDateTimeField;
    qFaturvalorpendente: TFloatField;
    qFaturfaturvalorcancelado: TFloatField;
    qFaturclienteid: TIntegerField;
    Memo1: TMemo;
    RzToolButton3: TToolButton;
    DS_qFatur: TDataSource;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormRelFaturamentosPendetes: TFormRelFaturamentosPendetes;

implementation

uses u_principal, u_dm, u_faturamento;

{$R *.dfm}

procedure TFormRelFaturamentosPendetes.FormShow(Sender: TObject);
begin
  Memo1.Lines.Clear;
  qFatur.Close;
  qFatur.Connection := DM.GetConexao;
  qFatur.Open;
  qFatur.Last;
  Memo1.Lines.Add('Pendentes: ' + IntToStr(qFatur.RecordCount));
  qFatur.First;
end;

end.
