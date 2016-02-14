unit u_formlistarfaturpendentes;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_formalistarpadrao, DB, MemDS, DBAccess, Uni, RzPanel,
  RzButton, ExtCtrls, Grids, DBGrids, RzDBGrid;

type
  TFormListarFaturPendente = class(TFormListarPadrao)
    QListafaturid: TIntegerField;
    QListaclientenome: TWideStringField;
    QListafaturvalortotal: TFloatField;
    QListafaturvalorbaixado: TFloatField;
    QListaclienteid: TIntegerField;
    QListafaturdatageracao: TDateTimeField;
    QListafaturvalorcancelado: TFloatField;
    procedure RzDBGridListaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure RzDBGridListaDblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FFaturID: integer;
    procedure SetFaturID(const Value: integer);
    { Private declarations }
    procedure RetornaRegistroAtual;
  public
    { Public declarations }
    property FaturID: integer read FFaturID write SetFaturID;
  end;

var
  FormListarFaturPendente: TFormListarFaturPendente;

implementation

uses u_principal, u_dm;

{$R *.dfm}

{ TFormListarFaturPendente }

procedure TFormListarFaturPendente.SetFaturID(const Value: integer);
begin
  FFaturID := Value;
end;

procedure TFormListarFaturPendente.RzDBGridListaKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  inherited;
  if Key = VK_RETURN then
  begin
    RetornaRegistroAtual;
  end;
end;

procedure TFormListarFaturPendente.RetornaRegistroAtual;
begin
  FaturID := RzDBGridLista.DataSource.DataSet.FieldByName('faturid').AsInteger;
  Self.Close;
end;

procedure TFormListarFaturPendente.RzDBGridListaDblClick(Sender: TObject);
begin
  inherited;
  RetornaRegistroAtual;
end;

procedure TFormListarFaturPendente.FormShow(Sender: TObject);
begin
  inherited;
  FaturID := 0;
  QLista.Close;
  QLista.Connection := DM.GetConexao;
  QLista.Open;
end;

end.
