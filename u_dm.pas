unit u_dm;

interface

uses
  Forms, SysUtils, Classes, DB, ADODB, Dialogs, DBAccess, Uni, UniProvider, PostgreSQLUniProvider;

type
  TDM = class
  private
    { Private declarations }
    FConexao: TUniConnection;
    function ConectarBase: Boolean;
  public
    { Public declarations }
    constructor Create;
    destructor Destroy; override;
    function GetConexao: TUniConnection; overload;
  end;

var
  DM: TDM;

implementation


{ TDM }

function TDM.GetConexao: TUniConnection;
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
    FConexao.Disconnect;
    FConexao.LoginPrompt := false;
    FConexao.ProviderName := 'PostgreSQL';
    FConexao.Server := 'dedomaria.no-ip.org';
    FConexao.Port := 5432;
    FConexao.Username := 'postgres';
    FConexao.Password := 'pgsql81';
    FConexao.Database := 'dedomaria';
    FConexao.SpecificOptions.Clear;
    FConexao.SpecificOptions.Add('PostgreSQL.UseUnicode=True');
    
    try
      FConexao.Connect;
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
  FConexao :=  TUniConnection.Create(nil);
end;

destructor TDM.Destroy;
begin
  FreeAndNil(FConexao);
  inherited;
end;


end.

