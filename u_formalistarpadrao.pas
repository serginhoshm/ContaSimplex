unit u_formalistarpadrao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, RzPanel, Grids, DBGrids, RzDBGrid, DB, ADODB, RzButton;

type
  TFormListarPadrao = class(TForm)
    RzDBGridLista: TRzDBGrid;
    RzToolbar1: TRzToolbar;
    RzPanel1: TRzPanel;
    QueryLista: TADOQuery;
    ds_QueryLista: TDataSource;
    RzToolButton1: TRzToolButton;
    RzToolButton2: TRzToolButton;
    RzSpacer1: TRzSpacer;
    RzToolButton3: TRzToolButton;
    procedure RzToolButton1Click(Sender: TObject);
  private
    { Private declarations }
    procedure SQLConsultaPadrao; virtual; 
  public
    { Public declarations }
  end;

var
  FormListarPadrao: TFormListarPadrao;

implementation

uses u_dm;

{$R *.dfm}


{ TFormListarPadrao }

procedure TFormListarPadrao.RzToolButton1Click(Sender: TObject);
begin
  SQLConsultaPadrao;
end;

procedure TFormListarPadrao.SQLConsultaPadrao;
begin
//
end;

end.
