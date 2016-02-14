unit u_FormRelFaturamentosPendentes;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_formrelpadrao, frxClass, RzButton, ExtCtrls, RzPanel, DB,
  MemDS, DBAccess, Uni, frxDBSet;

type
  TFormRelFaturamentosPendetes = class(TFormRelPadrao)
    qFatur: TUniQuery;
    frxDBDatasset_qFatur: TfrxDBDataset;
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
    procedure RzToolButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormRelFaturamentosPendetes: TFormRelFaturamentosPendetes;

implementation

uses u_principal, u_dm;

{$R *.dfm}

procedure TFormRelFaturamentosPendetes.RzToolButton1Click(Sender: TObject);
begin
  inherited;
  qFatur.Close;
  qFatur.Connection := DM.GetConexao;
  qFatur.Open;
  frxReportPadrao.ShowReport();
end;

end.
