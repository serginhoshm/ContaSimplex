unit u_formrelpadrao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, frxClass, RzButton, ExtCtrls, RzPanel;

type
  TFormRelPadrao = class(TForm)
    frxReportPadrao: TfrxReport;
    RzToolbar1: TRzToolbar;
    RzToolButton1: TRzToolButton;
    RzStatusBar1: TRzStatusBar;
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
