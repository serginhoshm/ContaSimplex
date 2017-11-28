unit u_formcadclientes;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_formcadastropadrao, ComCtrls, ExtCtrls, u_dmclientes,
  StdCtrls, Mask, DBCtrls, Vcl.ToolWin;

type
  TFormCadastroClientes = class(TFormCadastroPadrao)
    RzDBEdit1: TDBEdit;
    RzLabel1: TLabel;
    RzDBEdit2: TDBEdit;
    RzLabel2: TLabel;
    RzDBEdit3: TDBEdit;
    RzLabel3: TLabel;
    RzDBLookupComboBox1: TDBLookupComboBox;
    RzLabel4: TLabel;
    DBCheckBox1: TDBCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure RzToolButton1Click(Sender: TObject);
  private
    { Private declarations }
    FDMClientes: TDMClientes;
  public
    { Public declarations }
    procedure Alterar(id: integer); override;
    procedure Incluir; override;                                 
  end;

var
  FormCadastroClientes: TFormCadastroClientes;

implementation


{$R *.dfm}

procedure TFormCadastroClientes.Alterar(id: integer);
begin
  FDMClientes.qclientes.Close;
  FDMClientes.qclientes.Parameters.ParamByName('clienteid').Value := id;
  FDMClientes.qclientes.Open;
  FDMClientes.qclientes.Edit;
end;

procedure TFormCadastroClientes.FormCreate(Sender: TObject);
begin
  inherited;
  FDMClientes := TDMClientes.Create(nil);
end;

procedure TFormCadastroClientes.FormDestroy(Sender: TObject);
begin
  inherited;
  FreeAndNil(FDMClientes);
end;

procedure TFormCadastroClientes.Incluir;
begin
  inherited;
  FDMClientes.qclientes.Close;
  FDMClientes.qclientes.Open;
  FDMClientes.qclientes.Append;
end;

procedure TFormCadastroClientes.RzToolButton1Click(Sender: TObject);
begin
  inherited;
  try
    FDMClientes.qclientes.Post;
    FDMClientes.qclientes.Refresh;
  except
    on E:Exception do
    begin
      FDMClientes.qclientes.Cancel;
      ShowMessage(E.Message);
    end;
  end;
end;

end.
