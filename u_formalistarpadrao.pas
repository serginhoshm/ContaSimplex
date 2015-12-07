unit u_formalistarpadrao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, RzPanel, Grids, DBGrids, RzDBGrid, DB, ADODB, RzButton,
  Uni, UniProvider, PostgreSQLUniProvider, MemDS, DBAccess;

type
  TFormListarPadrao = class(TForm)
    RzDBGridLista: TRzDBGrid;
    RzToolbar1: TRzToolbar;
    RzPanel1: TRzPanel;
    ds_QLista: TDataSource;
    QLista: TUniQuery;
    RzToolButton1: TRzToolButton;
    RzToolButton2: TRzToolButton;
    procedure FormShow(Sender: TObject);
    procedure RzToolButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SQLConsultaPadrao; virtual;
  end;

var
  FormListarPadrao: TFormListarPadrao;

implementation

uses u_dm, u_principal;

{$R *.dfm}


{ TFormListarPadrao }


procedure TFormListarPadrao.SQLConsultaPadrao;
begin
//
end;

procedure TFormListarPadrao.FormShow(Sender: TObject);
begin
  SQLConsultaPadrao;
end;

procedure TFormListarPadrao.RzToolButton1Click(Sender: TObject);
begin
//
end;

end.
