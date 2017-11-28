unit u_formregistravenda;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBClient, ADODB, Grids, DBGrids, ExtCtrls,
  StdCtrls, Buttons, ComCtrls, DateUtils, u_dmregvenda;

type
  TFormRegistraVenda = class(TForm)
    PanelTopo: TPanel;
    RzDateTimePickerReg: TDateTimePicker;
    Label1: TLabel;
    ButtonIniciar: TButton;
    PanelDigita: TPanel;
    RzDBGridItens: TDBGrid;
    Panel1: TPanel;
    BitBtnOk: TBitBtn;
    BitBtnCancel: TBitBtn;
    Button1: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure BitBtnOkClick(Sender: TObject);
    procedure ButtonIniciarClick(Sender: TObject);
    procedure BitBtnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    DMReg: TDMRegVenda;
    procedure ModoInicial;
    procedure ModoDigitacao;
  public
    { Public declarations }
  end;

var
  FormRegistraVenda: TFormRegistraVenda;

implementation

uses u_principal, u_dm, u_bibliotecas, u_registrovenda, Math, Printers,
  u_formlistarclientes;

{$R *.dfm}

procedure TFormRegistraVenda.FormCreate(Sender: TObject);
begin
  DMReg := TDMRegVenda.Create(nil);
  DMReg.QProdutos.Connection := DM.GetConexao;
  DMReg.QProdutos.Open;
  DMReg.QClientes.Connection := DM.GetConexao;
  DMReg.QClientes.Open;
  DMReg.CDSItens.CreateDataSet;
  DMReg.CDSItens.LogChanges := False;
  RzDateTimePickerReg.Date := DateOf(Now);
  RzDateTimePickerReg.MaxDate := IncYear( DateOf(Now), 1);
end;


procedure TFormRegistraVenda.BitBtnOkClick(Sender: TObject);
var
  AReg: TRegistraVenda;
begin
  if MensagemSimNao('Deseja finalizar o registro de venda?') = ID_YES then
  begin
    AReg := TRegistraVenda.Create;
    try
      if AReg.RegistrarVenda(DMReg.CDSItens.XMLData) then
      begin
        ModoInicial;
      end
      else
      begin
        DMReg.CDSItens.First;
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
  DMReg.CDSItens.Close;
  DMReg.CDSItens.CreateDataSet;
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
  DMReg.GlobalDataRef := RzDateTimePickerReg.DateTime;
  DMReg.CDSItens.First;
  if RzDBGridItens.CanFocus then
    RzDBGridItens.SetFocus;
end;

procedure TFormRegistraVenda.ButtonIniciarClick(Sender: TObject);
var
  AReg: TRegistraVenda;
  AXML: string;
begin
  AReg := TRegistraVenda.Create;
  try
    if not AReg.RegistroVendaExiste(RzDateTimePickerReg.Date) then
      ModoDigitacao
    else
    begin
      try
        AXML := AReg.GetXMLRegistroVenda(RzDateTimePickerReg.Date);
        DMReg.CDSItens.EmptyDataSet;
        DMReg.CDSItens.XMLData := AXML;
        ModoDigitacao;
      except
        on E:Exception do
        begin
          ShowMessage('Erro ao carregar o registro de venda existente: ' + E.Message);
        end;
      end;


      //ModoInicial;
      //MensagemAtencao('O registro de venda para a data informada já existe!') ;
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

procedure TFormRegistraVenda.Button1Click(Sender: TObject);
begin
  FormListarClientes := TFormListarClientes.Create(nil);
  try
    FormListarClientes.ShowModal;
    DMReg.QClientes.Close;
    DMReg.QClientes.Open;
  finally
    FreeAndNil(FormListarClientes);
  end;

end;

procedure TFormRegistraVenda.Button2Click(Sender: TObject);
var
  ANumLinhas,
  aux,
  Ultimo: Integer;
  ABmk: TBookmark;
begin
  ANumLinhas := StrToIntDef(InputBox('Adicionar linhas', 'Número de linhas', '1'),0);
  ABmk := DMReg.CDSItens.GetBookmark;
  try
    for aux := 1 to ANumLinhas do
    begin
      DMReg.CDSItens.Append;
      DMReg.CDSItensRegVenQtde.AsFloat := 1;
      DMReg.CDSItensRegVenVlrUnit.AsFloat := 1;
      DMReg.CDSItensRegVenVlrTot.AsFloat := 1;
      DMReg.CDSItens.Post;
    end;
  finally
    if ABmk <> nil then
    begin
      if DMReg.CDSItens.BookmarkValid(ABmk) then
        DMReg.CDSItens.GotoBookmark(ABmk);
    end;
  end;
end;


procedure TFormRegistraVenda.FormDestroy(Sender: TObject);
begin
  FreeAndNil(DMReg);
end;

end.
