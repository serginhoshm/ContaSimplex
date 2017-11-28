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
begin
  if not FConexao.Connected then
  begin
    FConexao.Close;
    FConexao.LoginPrompt := false;
    FConexao.ConnectionString := 'Provider=SQLNCLI11.1;Integrated Security=SSPI;Persist Security Info=False;User ID="";Initial Catalog=xdb;Data Source=(LOCALDB)\MSSQLLocalDB;Initial File Name="";Server SPN=""';
    try
      FConexao.Open;
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

