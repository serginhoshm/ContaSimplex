unit u_formregistravenda;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBClient, ADODB, Grids, DBGrids, RzDBGrid, ExtCtrls,
  StdCtrls, Buttons, ComCtrls, RzDTP, DateUtils;

type
  TFormRegistraVenda = class(TForm)
    CDSItens: TClientDataSet;
    DS_Itens: TDataSource;
    CDSItensProdutoID: TIntegerField;
    CDSItensClienteID: TIntegerField;
    CDSItensRegVenQtde: TFloatField;
    QProdutos: TADOQuery;
    CDSItensProdutoNome: TStringField;
    QClientes: TADOQuery;
    QProdutosProdutoID: TAutoIncField;
    QProdutosProdutoNome: TWideStringField;
    QClientesClienteID: TAutoIncField;
    QClientesClienteNome: TWideStringField;
    CDSItensClienteNome: TStringField;
    QProdutosProdPrecoVenData: TDateTimeField;
    QProdutosMaxDeProdPrecoVenData: TDateTimeField;
    QProdutosProdPrecoVenValor: TBCDField;
    PanelTopo: TPanel;
    RzDateTimePickerReg: TRzDateTimePicker;
    Label1: TLabel;
    ButtonIniciar: TButton;
    PanelDigita: TPanel;
    RzDBGridItens: TRzDBGrid;
    Panel1: TPanel;
    BitBtnOk: TBitBtn;
    BitBtnCancel: TBitBtn;
    CDSItensRegVenDataRef: TDateField;
    CDSItensRegVenVlrUnit: TFloatField;
    CDSItensRegVenVlrTot: TFloatField;
    CDSItensItemNro: TAutoIncField;
    procedure FormCreate(Sender: TObject);
    procedure CDSItensNewRecord(DataSet: TDataSet);
    procedure BitBtnOkClick(Sender: TObject);
    procedure ButtonIniciarClick(Sender: TObject);
    procedure BitBtnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CDSItensBeforePost(DataSet: TDataSet);
  private
    { Private declarations }
    procedure CalculaItem;
    procedure ModoInicial;
    procedure ModoDigitacao;
  public
    { Public declarations }
  end;

var
  FormRegistraVenda: TFormRegistraVenda;

implementation

uses u_principal, u_dm, u_bibliotecas, u_registrovenda, Math;

{$R *.dfm}

procedure TFormRegistraVenda.FormCreate(Sender: TObject);
begin
  QProdutos.Connection := DM.GetConexao;
  QProdutos.Open;
  QClientes.Connection := DM.GetConexao;
  QClientes.Open;
  CDSItens.CreateDataSet;
  CDSItens.LogChanges := False;
  RzDateTimePickerReg.MaxDate := DateOf(Now);
end;

procedure TFormRegistraVenda.CDSItensNewRecord(DataSet: TDataSet);
begin
  CDSItensRegVenQtde.AsFloat := 1;
  CDSItensRegVenDataRef.AsDateTime := RzDateTimePickerReg.Date;
end;

procedure TFormRegistraVenda.CalculaItem;
begin
  CDSItensRegVenVlrUnit.AsCurrency := QProdutosProdPrecoVenValor.AsCurrency;
  CDSItensRegVenVlrTot.AsCurrency := CDSItensRegVenQtde.AsFloat * CDSItensRegVenVlrUnit.AsCurrency;
end;

procedure TFormRegistraVenda.BitBtnOkClick(Sender: TObject);
var
  AReg: TRegistraVenda;
begin
  if MensagemSimNao('Deseja finalizar o registro de venda?') = ID_YES then
  begin
    AReg := TRegistraVenda.Create;
    try
      if AReg.RegistrarVenda(CDSItens.XMLData) then
      begin
        ModoInicial;
      end
      else
      begin
        CDSItens.First;
      end;
    finally
      FreeAndNil(AReg);
    end;

  end
end;

procedure TFormRegistraVenda.ModoInicial;
begin
  RzDateTimePickerReg.Enabled := true;
  ButtonIniciar.Enabled := true;
  PanelTopo.Enabled := True;
  PanelDigita.Enabled := False;
  CDSItens.EmptyDataSet;
  BitBtnOk.Enabled := false;
  BitBtnCancel.Enabled := False;
  if RzDateTimePickerReg.CanFocus then
    RzDateTimePickerReg.SetFocus;
end;

procedure TFormRegistraVenda.ModoDigitacao;
begin
  RzDateTimePickerReg.Enabled := false;
  ButtonIniciar.Enabled := false;
  PanelTopo.Enabled := False;
  PanelDigita.Enabled := True;
  BitBtnOk.Enabled := True;
  BitBtnCancel.Enabled := True;
  CDSItens.First;
  if RzDBGridItens.CanFocus then
    RzDBGridItens.SetFocus;
end;

procedure TFormRegistraVenda.ButtonIniciarClick(Sender: TObject);
var
  AReg: TRegistraVenda;
begin
  AReg := TRegistraVenda.Create;
  try
    if not AReg.RegistroVendaExiste(RzDateTimePickerReg.Date) then
      ModoDigitacao
    else
    begin
      ModoInicial;
      MensagemAtencao('O registro de venda para a data informada j� existe!') ;
    end;
  finally
    FreeAndNil(AReg);
  end;
end;

procedure TFormRegistraVenda.BitBtnCancelClick(Sender: TObject);
begin
  if MensagemSimNao('Deseja PERDER o que foi digitado?') = ID_YES then
    ModoInicial;
end;

procedure TFormRegistraVenda.FormShow(Sender: TObject);
begin
  ModoInicial;

end;

procedure TFormRegistraVenda.CDSItensBeforePost(DataSet: TDataSet);
begin
  CalculaItem;
end;

end.