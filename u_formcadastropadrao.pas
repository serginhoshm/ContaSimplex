unit u_formcadastropadrao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, RzTray, RzButton, RzPanel, ExtCtrls, ComCtrls;

type
  TFormCadastroPadrao = class(TForm)
    RzPanel2: TRzPanel;
    ScrollBox1: TScrollBox;
    RzToolbar1: TRzToolbar;
    RzToolButton1: TRzToolButton;
    RzToolButton3: TRzToolButton;
    StatusBar1: TStatusBar;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Incluir; virtual;
    procedure Alterar(id: integer); virtual;
    procedure Excluir(id: Integer); virtual;
    procedure Consultar(id: Integer); virtual;
  end;

var
  FormCadastroPadrao: TFormCadastroPadrao;

implementation

uses
  u_principal;

{$R *.dfm}

{ TFormCadastroPadrao }

procedure TFormCadastroPadrao.Alterar(id: integer);
begin

end;

procedure TFormCadastroPadrao.Consultar(id: Integer);
begin

end;

procedure TFormCadastroPadrao.Excluir(id: Integer);
begin

end;

procedure TFormCadastroPadrao.Incluir;
begin

end;

end.
