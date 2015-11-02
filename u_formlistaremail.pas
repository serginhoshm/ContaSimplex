unit u_formlistaremail;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, DB, ADODB, Clipbrd;

type
  TFormListaEmail = class(TForm)
    MemoLista: TMemo;
    QueryCli: TADOQuery;
    BitBtn1: TBitBtn;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormListaEmail: TFormListaEmail;

implementation

uses u_dm;

{$R *.dfm}

procedure TFormListaEmail.FormCreate(Sender: TObject);
var
  ALista: string;
begin
  QueryCli.Connection := DM.GetConexao;
  QueryCli.Open;
  MemoLista.Clear;
  ALista := EmptyStr;
  while not QueryCli.Eof do
  begin
    ALista := Alista + QueryCli.Fields[0].AsString + ';';

    QueryCli.Next;
  end;
  MemoLista.Lines.Text := ALista;
  Clipboard.AsText := MemoLista.Text;
  MemoLista.SelectAll;
end;

end.
