unit u_listarpadrao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, RzPanel, Grids, DBGrids, RzDBGrid, DB, ADODB;

type
  TForm2 = class(TForm)
    RzDBGrid1: TDBGrid;
    RzToolbar1: TToolbar;
    RzPanel1: TPanel;
    QueryLista: TADOQuery;
    ds_QueryLista: TDataSource;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

end.
