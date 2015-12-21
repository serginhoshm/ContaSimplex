unit u_formlistarfaturpendentes;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_formalistarpadrao, DB, MemDS, DBAccess, Uni, RzPanel,
  RzButton, ExtCtrls, Grids, DBGrids, RzDBGrid;

type
  TFormListarFaturPendente = class(TFormListarPadrao)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormListarFaturPendente: TFormListarFaturPendente;

implementation

{$R *.dfm}

end.
