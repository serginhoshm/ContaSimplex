unit u_formfaturamento;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls;

type
  TFormFaturamento = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormFaturamento: TFormFaturamento;

implementation

uses u_faturamento, DateUtils;

{$R *.dfm}

procedure TFormFaturamento.Button1Click(Sender: TObject);
var
  FatObj: TFatObj;
begin
  FatObj := TFatObj.Create;
  try
    FatObj.DataInicial := StartOfTheDay(DateTimePicker1.DateTime);
    FatObj.DataFinal := EndOfTheDay(DateTimePicker2.DateTime);
    FatObj.Exec;
    Memo1.Lines := FatObj.Log;
  finally
    FreeAndNil(FatObj);
  end;
end;

procedure TFormFaturamento.FormCreate(Sender: TObject);
begin
  DateTimePicker1.DateTime := IncDay(Now, -30);
  DateTimePicker2.DateTime := Now; 
end;

end.
