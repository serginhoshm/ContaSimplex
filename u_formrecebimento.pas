unit u_formrecebimento;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, Buttons, ExtCtrls, DB, Vcl.ComCtrls, Data.Win.ADODB;

type
  TFormRecebimento = class(TForm)
    Label6: TLabel;
    //EditValorRecebido: TNumericEdit;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
//    EditClienteID: TNumericEdit;
    Label4: TLabel;
    EditClienteNome: TEdit;
//    EditFaturID: TNumericEdit;
    Label5: TLabel;
    AdvToolButton1: TToolButton;
    Label1: TLabel;
//    EditTroco: TNumericEdit;
    Label2: TLabel;
//    EditCredito: TNumericEdit;
//    EditValorFatura: TNumericEdit;
    Label3: TLabel;
    procedure BitBtn1Click(Sender: TObject);
    procedure AdvToolButton1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure EditTrocoEnter(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure EditCreditoEnter(Sender: TObject);
  private
    { Private declarations }
    procedure LimparTela;
    function CarregarFatura(FaturaID: integer): boolean;
    procedure ChecarValores;
  public
    { Public declarations }

  end;

implementation

uses
  u_faturamento, u_principal, u_formlistarfaturpendentes, u_dm, Math;

{$R *.dfm}

procedure TFormRecebimento.BitBtn1Click(Sender: TObject);
var
  FatObj: TFatObj;
  AMsg: string;
begin
  FatObj := TFatObj.Create;
  try
    try
      //if EditFaturID.Value <= 0 then
      //  raise Exception.Create('Informe a fatura');
      ChecarValores;
//      AMsg := FatObj.ReceberFatur(StrToIntDef(EditFaturID.Text, 0), EditValorRecebido.Value, EditTroco.Value, EditCredito.Value);
      if trim(AMsg) <> EmptyStr then
        ShowMessage(AMsg);
      LimparTela;
    except
      on E:Exception do
      begin
        ShowMessage('Erro ao efetuar recebimento: ' + E.Message);
      end;
    end;
  finally
    FreeAndNil(FatObj);
  end;
end;

procedure TFormRecebimento.AdvToolButton1Click(Sender: TObject);
begin
  FormListarFaturPendente := TFormListarFaturPendente.Create(nil);
  try
    FormListarFaturPendente.ShowModal;
    LimparTela;
    if FormListarFaturPendente.FaturID > 0 then
    begin
      CarregarFatura(FormListarFaturPendente.FaturID);
    end;
  finally
    FreeAndNil(FormListarFaturPendente);
  end;
end;

procedure TFormRecebimento.LimparTela;
begin
  (*
  EditFaturID.Value := 0;
  EditClienteID.Value := 0;
  EditClienteNome.Clear;
  EditValorFatura.Value := 0;
  EditValorRecebido.Value := 0;
  EditTroco.Value := 0;
  EditCredito.Value := 0;
  *)
end;

function TFormRecebimento.CarregarFatura(FaturaID: integer): boolean;
var
  QueFatura: TADOQuery;
begin
  Result := false;
  QueFatura := TADOQuery.Create(nil);
  QueFatura.Connection := DM.GetConexao;
  try
    try
      QueFatura.Close;
      QueFatura.SQL.Text := 'select faturid, clienteid, clientenome, faturvalortotal  from faturamentospendentes where faturid = :faturid';
      QueFatura.Parameters.ParamByName('faturid').Value := FaturaID;
      QueFatura.Open;
      if not QueFatura.IsEmpty then
      begin
        (*
        EditFaturID.Value := QueFatura.FieldByName('faturid').AsInteger;
        EditClienteID.Value := QueFatura.FieldByName('clienteid').AsInteger;
        EditClienteNome.Text := QueFatura.FieldByName('clientenome').AsString;
        EditValorFatura.Value := QueFatura.FieldByName('faturvalortotal').AsFloat;
        EditValorRecebido.Value := EditValorFatura.Value;
        *)
      end
      else
        raise Exception.Create('A fatura ' + IntToStr(FaturaID) + ' não foi encontrada!'); 
    except
      on E:Exception do
      begin
        LimparTela;
      end;
    end;
  finally
    FreeAndNil(QueFatura);
  end;

end;

procedure TFormRecebimento.ChecarValores;
begin

  (*
  if EditValorRecebido.Value > EditValorFatura.Value then
  begin
    if (EditValorRecebido.Value - (EditValorFatura.Value + EditTroco.Value + EditCredito.Value) <> 0) then
      raise exception.Create('ATENÇÃO: Fatura + Crédito + Troco = Valor Recebido');
  end
  else
  if EditValorRecebido.Value < EditValorFatura.Value then
    raise Exception.Create('O valor recebido é menor que o valor da fatura');
  *)
end;

procedure TFormRecebimento.BitBtn2Click(Sender: TObject);
begin
  LimparTela;
end;

procedure TFormRecebimento.EditTrocoEnter(Sender: TObject);
begin
  (*
  if EditTroco.Value = 0 then
    EditTroco.Value := EditValorRecebido.Value - (EditValorFatura.Value+EditCredito.Value);
  *)
end;

procedure TFormRecebimento.FormShow(Sender: TObject);
begin
  LimparTela;
end;

procedure TFormRecebimento.EditCreditoEnter(Sender: TObject);
begin
  (*
  if EditCredito.Value = 0 then
    EditCredito.Value := EditValorRecebido.Value - (EditValorFatura.Value+EditTroco.Value);
    *)
end;

end.
