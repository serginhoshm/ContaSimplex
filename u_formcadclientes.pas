unit u_formcadclientes;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_formcadastropadrao, ComCtrls, RzButton, RzPanel, ExtCtrls, u_dmclientes,
  StdCtrls, RzLabel, Mask, RzEdit, RzDBEdit, DBCtrls, RzDBCmbo, RzRadChk,
  RzDBChk;

type
  TFormCadastroClientes = class(TFormCadastroPadrao)
    RzDBEdit1: TRzDBEdit;
    RzLabel1: TRzLabel;
    RzDBEdit2: TRzDBEdit;
    RzLabel2: TRzLabel;
    RzDBEdit3: TRzDBEdit;
    RzLabel3: TRzLabel;
    RzDBLookupComboBox1: TRzDBLookupComboBox;
    RzLabel4: TRzLabel;
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
  FDMClientes.qclientes.ParamByName('clienteid').AsInteger := id;
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
