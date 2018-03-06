unit u_FormRelFaturamentosPendentes;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_formrelpadrao, ExtCtrls, DB, StdCtrls, ADODB,
  ComCtrls, ToolWin, QuickRpt, QRCtrls;

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
    RzToolButton2: TToolButton;
    Memo1: TMemo;
    RzToolButton3: TToolButton;
    DS_qFatur: TDataSource;
    QRBandTitle: TQRBand;
    QRBandDet: TQRBand;
    QRDBText1: TQRDBText;
    QRDBText2: TQRDBText;
    QRDBText3: TQRDBText;
    QRGroupHeader: TQRGroup;
    QRBandSoma: TQRBand;
    QRExpr1: TQRExpr;
    procedure RzToolButton1Click(Sender: TObject);
    procedure RzToolButton2Click(Sender: TObject);
    procedure QRBandSomaAfterPrint(Sender: TQRCustomBand;
      BandPrinted: Boolean);
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

procedure TFormRelFaturamentosPendetes.RzToolButton1Click(Sender: TObject);
begin
  inherited;
  Memo1.Lines.Clear;
  qFatur.Close;
  qFatur.Connection := DM.GetConexao;
  qFatur.Open;
  QuickRep1.Preview;

  qFatur.Last;
  Memo1.Lines.Add('Pendentes: ' + IntToStr(qFatur.RecordCount));
  qFatur.First;
end;

procedure TFormRelFaturamentosPendetes.RzToolButton2Click(Sender: TObject);
var
  FatObj: TFatObj;
begin
  Memo1.Lines.Clear;
  FatObj := TFatObj.Create;
  try
    FatObj.EnviarRecobranca;
    Memo1.Lines := FatObj.Log;
  finally
    FreeAndNil(FatObj);
  end;
end;

procedure TFormRelFaturamentosPendetes.QRBandSomaAfterPrint(
  Sender: TQRCustomBand; BandPrinted: Boolean);
begin
  inherited;
  QRExpr1.Reset;
end;

end.
