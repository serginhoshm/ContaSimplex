unit u_formprocbaixarcreditos;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_formprocpadrao, StdCtrls, ExtCtrls,
  Mask, RzEdit, ComCtrls;

type
  TFormBaixarCreditosManual = class(TFormProcPadrao)
    LabeledEditCli: TLabeledEdit;
    Button1: TButton;
    MoneyEditValor: TRzNumericEdit;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormBaixarCreditosManual: TFormBaixarCreditosManual;

implementation

uses u_faturamento;

{$R *.dfm}

procedure TFormBaixarCreditosManual.Button1Click(Sender: TObject);
var
  FatObj: TFatObj;
  Baixar,
  CredRest,
  CredUsado: Double;
begin
  inherited;
  FatObj := TFatObj.Create;
  try
    Baixar := MoneyEditValor.Value;
    CredRest := 0;
    CredUsado := 0;
    FatObj.BaixarCreditos(StrToIntDef(LabeledEditCli.Text, 0), Baixar, CredRest, CredUsado);
    ShowMessage('Operação concluída. Restando: ' + FloatToStr(CredRest));
  finally
    FreeAndNil(FatObj);
  end;

end;

end.
