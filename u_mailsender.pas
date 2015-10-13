unit u_mailsender;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ComCtrls,  Psock, NMsmtp, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdMessageClient, IdSMTP, IdIOHandler,
  IdIOHandlerSocket, IdSSLOpenSSL, IdMessage;


type
  TMailSender = class
  private
    FDestinatarioEmail: string;
    FDestinatarioNome: string;
    FTextoEmail: TStringList;
    FMailClient: TIdSMTP;
    FIOHandler: TIdSSLIOHandlerSocket;
    FMessage: TIdMessage;
    FAssuntoEmail: string;
    function ConfigComponente: Boolean;
    procedure SetDestinatarioNome(const Value: string);
    procedure SetDestinatarioEmail(const Value: string);
    procedure SetTextoEmail(const Value: TStringList);
    procedure SetAssuntoEmail(const Value: string);
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
    FMailClient.AuthenticationType := atLogin;
    FMailClient.Host := 'smtp.gmail.com';
    FMailClient.IOHandler := FIOHandler;
    FMailClient.Password := '1unix()*';
    FMailClient.Port := 465;
    FMailClient.Username := 'serginhoshm@gmail.com'; //não esqueça o @gmail.com!!

    FIOHandler.SSLOptions.Method := sslvTLSv1;
    FIOHandler.SSLOptions.Mode := sslmClient;
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
begin
  try
    FMessage.Body := TextoEmail;
    FMessage.From.Address := 'serginhoshm@gmail.com'; //opcional
    FMessage.From.Name := 'Sérgio Henrique Marchiori'; //opcional
    FMessage.Recipients.Add;
    FMessage.Recipients.Items[0].Address := DestinatarioEmail;
    FMessage.Recipients.Items[0].Name := DestinatarioNome; //opcional
    FMessage.Subject := AssuntoEmail;

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

end.
