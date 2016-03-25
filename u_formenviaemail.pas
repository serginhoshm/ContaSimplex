unit u_formenviaemail;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TFormEnviaEmails = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    DateTimePicker1: TDateTimePicker;
    Label1: TLabel;
    LabelProgresso: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormEnviaEmails: TFormEnviaEmails;

implementation

uses DateUtils, u_faturamento;

{$R *.dfm}

procedure TFormEnviaEmails.FormCreate(Sender: TObject);
begin
  DateTimePicker1.DateTime := IncDay(Now,1);
end;

procedure TFormEnviaEmails.Button1Click(Sender: TObject);
var
  FatObj: TFatObj;
begin
  FatObj := TFatObj.Create;
  LabelProgresso.Show;
  try
    FatObj.DataPagamento := StartOfTheDay(DateTimePicker1.DateTime);
    FatObj.LabelProgresso := LabelProgresso;
    FatObj.EnviarEmailFaturPendentes;
    Memo1.Lines := FatObj.Log;
  finally
    FreeAndNil(FatObj);
    LabelProgresso.Hide;
  end;
end;

end.
