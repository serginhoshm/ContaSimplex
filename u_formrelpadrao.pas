unit u_formrelpadrao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, ToolWin;

type
  TFormRelPadrao = class(TForm)
    RzToolbar1: TToolbar;
    RzToolButton1: TToolButton;
    RzStatusBar1: TStatusBar;
//    QuickRep1: TQuickRep;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormRelPadrao: TFormRelPadrao;

implementation

uses u_principal;

{$R *.dfm}

end.
