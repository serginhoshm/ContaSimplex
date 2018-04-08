unit u_formcadclientes;

interface

uses
  DB, ADODB, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_formcadastropadrao, ComCtrls, ExtCtrls, u_dmclientes,
  StdCtrls, Mask, DBCtrls, ToolWin;

type
  TFormCadastroClientes = class(TFormCadastroPadrao)
    EditNome: TEdit;
    RzLabel2: TLabel;
    EditEmail: TEdit;
    RzLabel3: TLabel;
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

uses
  u_dm;


{$R *.dfm}

procedure TFormCadastroClientes.Alterar(id: integer);
begin
  FDMClientes.qclientes.Close;
  FDMClientes.qclientes.CommandText := 'Select * from Clientes where ClienteID = ' + IntToStr(id);
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
end;

procedure TFormCadastroClientes.RzToolButton1Click(Sender: TObject);
var
  qins: TADOQuery;
begin
  inherited;
  qins := TADOQuery.Create(nil);
  try
    try
      qins.Connection := DM.GetConexao;
      qins.SQL.Text := 'INSERT INTO CLIENTES (clientenome, clienteemail, deptoid, clientemktmail, ativo) VALUES (:nome, :email, 1, 1 ,1)';
      qins.Parameters.ParamByName('nome').Value := UpperCase(EditNome.Text);
      qins.Parameters.ParamByName('email').Value := UpperCase(EditEmail.Text);
      qins.ExecSQL;
      Self.Close;
    except
      on E:Exception do
      begin
        qins.Close;
        ShowMessage(E.Message);
      end;
    end;
  finally
    FreeAndNil(qins);
  end;
end;

end.
