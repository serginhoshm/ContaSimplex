unit u_formenviaemailrec;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TFormEnviaEmailsRec = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormEnviaEmailsRec: TFormEnviaEmailsRec;

implementation

uses DateUtils, u_faturamento;

{$R *.dfm}

procedure TFormEnviaEmailsRec.Button1Click(Sender: TObject);
var
  FatObj: TFatObj;
begin
  FatObj := TFatObj.Create;
  try
    FatObj.EnviarEmailPagamentosRecebidosPendentes;
    Memo1.Lines := FatObj.Log;
  finally
    FreeAndNil(FatObj);
  end;
end;

end.
