unit u_formalistarpadrao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Grids, DBGrids, DB, ADODB, Vcl.ComCtrls, Vcl.ToolWin;

type
  TFormListarPadrao = class(TForm)
    RzDBGridLista: TDBGrid;
    RzToolbar1: TToolbar;
    RzPanel1: TPanel;
    ds_QLista: TDataSource;
    QLista: TADOQuery;
    RzToolButton1: TToolButton;
    RzToolButton2: TToolButton;
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
