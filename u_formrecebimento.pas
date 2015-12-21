unit u_formrecebimento;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, RzEdit, Buttons, ExtCtrls;

type
  TFormRecebimento = class(TForm)
    Label1: TLabel;
    EditCreditoAnt: TRzNumericEdit;
    Label2: TLabel;
    EditDebitoAnt: TRzNumericEdit;
    EditFaturValor: TRzNumericEdit;
    Label6: TLabel;
    EditValorRecebido: TRzNumericEdit;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    EditClienteID: TRzNumericEdit;
    Label4: TLabel;
    EditClienteNome: TRzEdit;
    EditFaturID: TRzNumericEdit;
    Label5: TLabel;
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

  end;

implementation

uses
  u_faturamento;

{$R *.dfm}

procedure TFormRecebimento.BitBtn1Click(Sender: TObject);
var
  FatObj: TFatObj;
  AMsg: string;
begin
  FatObj := TFatObj.Create;
  try
    //AMsg := FatObj.ReceberFatur(StrToIntDef(EditFaturID.Text, 0), EditValorRecebido.Value);
    AMsg := FatObj.ReceberFatur(StrToIntDef(InputBox('Fatur','Fatur',''),0), 20);
  finally
    FreeAndNil(FatObj);
  end;
end;

end.
