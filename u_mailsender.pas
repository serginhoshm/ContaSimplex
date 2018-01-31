unit u_mailsender;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ComCtrls, {Psock, NMsmtp,} IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdMessageClient, IdSMTP, IdIOHandler,
  IdIOHandlerSocket, IdSSLOpenSSL, IdMessage, IniFiles;


type
  TMailConfig = record
    ContentType: string;
    FromAddress: string;
    FromName: string;
    AuthenticationType: TAuthenticationType;
    Host: string;
    IOHandler: TIdIOHandler;
    Password: string;
    Port: integer;
    Username: string;
    SSLMethod: integer;
    SSLMode: integer;
    Debug: boolean;
  end;

  TMailSender = class
  private
    FDestinatarioEmail: string;
    FDestinatarioNome: string;
    FTextoEmail: TStringList;
    FMailClient: TIdSMTP;
    FIOHandler: TIdSSLIOHandlerSocket;
    FMessage: TIdMessage;
    FAssuntoEmail: string;
    FConfig: TMailConfig;
    function ConfigComponente: Boolean;
    procedure SetDestinatarioNome(const Value: string);
    procedure SetDestinatarioEmail(const Value: string);
    procedure SetTextoEmail(const Value: TStringList);
    procedure SetAssuntoEmail(const Value: string);
    function ConfigFileName: string;
    procedure LeConfig;
  public
    constructor Create;
    destructor Destroy; override;
    property DestinatarioNome: string read FDestinatarioNome write SetDestinatarioNome;
    property DestinatarioEmail: string read FDestinatarioEmail write SetDestinatarioEmail;
    property TextoEmail: TStringList read FTextoEmail write SetTextoEmail;
    property AssuntoEmail: string read FAssuntoEmail write SetAssuntoEmail;
    function Enviar(var RetMsg: string): Boolean;
  end;


implementation

{ TMailSender }

function TMailSender.ConfigComponente: Boolean;
begin
  try
    FIOHandler.SSLOptions.Method := TIdSSLVersion(FConfig.SSLMethod);
    FIOHandler.SSLOptions.Mode := TIdSSLMode(FConfig.SSLMode);
    
    FMailClient.AuthenticationType := FConfig.AuthenticationType;
    FMailClient.Host := FConfig.Host;
    FMailClient.IOHandler := FIOHandler;
    FMailClient.Password := FConfig.Password;
    FMailClient.Port := FConfig.Port;
    FMailClient.Username := FConfig.Username;

    Result := true;
  except
    on E:Exception do
    begin
      Result := False;
      ShowMessage(E.Message);
    end;
  end;
end;

constructor TMailSender.Create;
begin
  inherited;
  FTextoEmail := TStringList.Create;
  FMailClient := TIdSMTP.Create(nil);
  FIOHandler := TIdSSLIOHandlerSocket.Create(nil);
  FMessage := TIdMessage.Create(nil);
  LeConfig;
  ConfigComponente;
end;

destructor TMailSender.Destroy;
begin
  FreeAndNil(FTextoEmail);
  FreeAndNil(FMailClient);
  FreeAndNil(FIOHandler);
  FreeAndNil(FMessage);
  inherited;
end;

function TMailSender.Enviar(var RetMsg: string): Boolean;

  procedure AdicionaTextoFormatado;
  var
    i: Integer;
  begin
    //Adiciona quebras de linha <br> ao texto
    FMessage.Body.Clear;
    for i:= 0 to TextoEmail.Count -1 do
      FMessage.Body.Add('<br>' + TextoEmail.Strings[i]);
  end;

var
  IniConf: TIniFile;
begin
  try
    FMessage.ContentType := FConfig.ContentType;
    FMessage.From.Address := FConfig.FromAddress;
    FMessage.From.Name := FConfig.FromName;

    FMessage.Recipients.Add;
    if not FConfig.Debug then
    begin
      FMessage.Recipients.Items[0].Address := DestinatarioEmail;
      FMessage.Recipients.Items[0].Name := DestinatarioNome; //opcional
    end
    else
    begin
      FMessage.Recipients.Items[0].Address := 'nowhere_johndoe@hotmail.com';
      FMessage.Recipients.Items[0].Name := 'John Doe'; //opcional
    end;

    FMessage.Subject := AssuntoEmail;
    AdicionaTextoFormatado;

    FMessage.Body.SaveToFile(ExtractFilePath(Application.ExeName) + 'EnviarEmail.html');

    FMailClient.Connect();
    FMailClient.Send(FMessage);
    FMailClient.Disconnect;
    Result := true;
    RetMsg := EmptyStr;
  except
    on E:Exception do
    begin
      Result := false;
      RetMsg := E.Message;
    end;
  end;
end;

procedure TMailSender.SetAssuntoEmail(const Value: string);
begin
  FAssuntoEmail := Value;
end;

procedure TMailSender.SetDestinatarioNome(const Value: string);
begin
  FDestinatarioNome := Value;
end;

procedure TMailSender.SetDestinatarioEmail(const Value: string);
begin
  FDestinatarioEmail := Value;
end;

procedure TMailSender.SetTextoEmail(const Value: TStringList);
begin
  FTextoEmail := Value;
end;

function TMailSender.ConfigFileName: string;
begin
  Result := ExtractFilePath(Application.ExeName) + 'email.conf';
end;

procedure TMailSender.LeConfig;
var
  Ini: TIniFile;
  sec: string;
begin
  sec := 'Config';
  if FileExists(ConfigFileName) then
  begin
    Ini := TIniFile.Create(ConfigFileName);
    try
      FConfig.ContentType := Ini.ReadString(sec, 'ContentType', '');
      FConfig.FromAddress := Ini.ReadString(sec, 'FromAddress', '');
      FConfig.FromName := Ini.ReadString(sec, 'FromName', '');
      FConfig.AuthenticationType := TAuthenticationType(Ini.ReadInteger(sec, 'AuthenticationType', 0));
      FConfig.Host := Ini.ReadString(sec, 'Host', '');
      FConfig.Password := Ini.ReadString(sec, 'Password', '');
      FConfig.Port := Ini.ReadInteger(sec, 'Port', 0);
      FConfig.Username := Ini.ReadString(sec, 'Username', '');
      FConfig.SSLMethod := Ini.ReadInteger(sec, 'SSLMethod', 0);
      FConfig.SSLMode := Ini.ReadInteger(sec, 'SSLMode', 0);
      FConfig.Debug := Ini.ReadInteger(sec, 'Debug', 1) = 1;
    finally
      FreeAndNil(Ini);
    end;
  end
  else
    raise Exception.Create('Configurações de e-mail inexistentes!');
end;

end.
