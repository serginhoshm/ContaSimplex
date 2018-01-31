unit u_formrecebimento;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, Buttons, ExtCtrls, DB, ComCtrls, ADODB;

type
  TFormRecebimento = class(TForm)
    Label6: TLabel;
    EditValorRecebido: TEdit;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    EditClienteID: TEdit;
    Label4: TLabel;
    EditClienteNome: TEdit;
    EditFaturID: TEdit;
    Label5: TLabel;
    AdvToolButton1: TToolButton;
    Label1: TLabel;
    EditTroco: TEdit;
    Label2: TLabel;
    EditCredito: TEdit;
    EditValorFatura: TEdit;
    Label3: TLabel;
    qry1: TADOQuery;
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
  public
    { Public declarations }

  end;

implementation

uses
  u_faturamento, u_principal, u_formlistarfaturpendentes, u_dm, Math;

{$R *.dfm}

procedure TFormRecebimento.BitBtn1Click(Sender: TObject);
var
  NrFatura: integer;
  ValorFatura,
  Recebido,
  Troco,
  Credito: Double;
  FatObj: TFatObj;
  AMsg: string;

  procedure ChecarValores;
  begin
    if Recebido > ValorFatura then
    begin
      if (Recebido - (ValorFatura + Troco + Credito) <> 0) then
        raise exception.Create('ATENÇÃO: Fatura + Crédito + Troco = Valor Recebido');
    end
    else
    if Recebido < ValorFatura then
      raise Exception.Create('O valor recebido é menor que o valor da fatura');
  end;

begin
  FatObj := TFatObj.Create;
  try
    try
      NrFatura := StrToIntDef(EditFaturID.Text, 0);
      if NrFatura <= 0 then
        raise Exception.Create('Informe a fatura');

      ValorFatura := StrToFloatDef(EditValorFatura.Text, 0);
      Recebido := StrToFloatDef(EditValorRecebido.Text, 0);
      Troco := StrToFloatDef(EditTroco.Text, 0);
      Credito := StrToFloatDef(EditCredito.Text, 0);
      ChecarValores;
      AMsg := FatObj.ReceberFatur(NrFatura, Recebido, Troco, Credito);
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
  EditFaturID.Text :='0';
  EditClienteID.Text :='0';
  EditClienteNome.Clear;
  EditValorFatura.Text :='0';
  EditValorRecebido.Text :='0';
  EditTroco.Text :='0';
  EditCredito.Text :='0';
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
        EditFaturID.Text := QueFatura.FieldByName('faturid').AsString;
        EditClienteID.Text := QueFatura.FieldByName('clienteid').AsString;
        EditClienteNome.Text := QueFatura.FieldByName('clientenome').AsString;
        EditValorFatura.Text := QueFatura.FieldByName('faturvalortotal').AsString;
        EditValorRecebido.Text := EditValorFatura.Text;
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



procedure TFormRecebimento.BitBtn2Click(Sender: TObject);
begin
  LimparTela;
end;

procedure TFormRecebimento.EditTrocoEnter(Sender: TObject);
begin
  if StrToFloatDef(EditTroco.Text, 0) = 0 then
    EditTroco.Text := FloatToStr(StrToFloatDef(EditValorRecebido.Text, 0) - (StrToFloatDef(EditValorFatura.Text, 0) + StrToFloatDef(EditCredito.Text, 0)));
end;

procedure TFormRecebimento.FormShow(Sender: TObject);
begin
  LimparTela;
end;

procedure TFormRecebimento.EditCreditoEnter(Sender: TObject);
begin
  if StrToFloatDef(EditCredito.Text, 0) = 0 then
    EditCredito.Text := FloatToStr(StrToFloatDef(EditValorRecebido.Text, 0) - (StrToFloatDef(EditValorFatura.Text, 0)+StrToFloatDef(EditTroco.Text, 0)));
end;

end.
