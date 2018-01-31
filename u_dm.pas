unit u_dm;

interface

uses
  Forms, SysUtils, Classes, DB, ADODB, Dialogs;

type
  TDM = class
  private
    { Private declarations }
    FConexao: TADOConnection;
    function ConectarBase: Boolean;
  public
    { Public declarations }
    constructor Create;
    destructor Destroy; override;
    function GetConexao: TADOConnection; overload;
  end;

var
  DM: TDM;

implementation


{ TDM }

function TDM.GetConexao: TADOConnection;
begin
  if ConectarBase then
    Result := FConexao
  else
    Result := nil;
end;


function TDM.ConectarBase: Boolean;
var
  qtmp: TADOQuery;
  tbl: string;
begin
  if not FConexao.Connected then
  begin
    FConexao.Close;
    FConexao.LoginPrompt := false;
    //;Initial Catalog=xdb2
    //Database=xdb2;

    FConexao.ConnectionString := 'Provider=SQLNCLI11.1;Integrated Security=SSPI;Persist Security Info=False;User ID="";Data Source=(LOCALDB)\MSSQLLocalDB;Server SPN="";AttachDBFilename=' + ExtractFilePath(Application.ExeName) + 'xdb2.mdf';
    try
      FConexao.Open;
      qtmp := TADOQuery.Create(nil);
      try

        qtmp.Connection := FConexao;
        qtmp.SQL.Text := 'SELECT * FROM INFORMATION_SCHEMA.TABLES';
        qtmp.Open;

        tbl := '';
        while not qtmp.Eof do
        begin
          tbl := tbl + qtmp.FieldByName('TABLE_NAME').AsString + #13#10;
          qtmp.Next;
        end;
        if AnsiPos('CLIENTES', UpperCase(tbl)) < 0 then
          raise Exception.Create('Não foram encontradas as tabelas básicas do sistema. Verifique a conexão!');
      finally
        FreeAndNil(qtmp);
      end

    except
      on E:Exception do
      begin
        ShowMessage(E.Message);
      end;
    end;
  end;
  Result := FConexao.Connected;
end;

constructor TDM.Create;
begin
  FConexao :=  TADOConnection.Create(nil);
end;

destructor TDM.Destroy;
begin
  FreeAndNil(FConexao);
  inherited;
end;


end.


