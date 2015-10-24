unit u_bibliotecas;

interface

uses
 windows,sysUtils,idHttp, classes, IdIOHandler, IdIOHandlerSocket, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdSSLOpenSSL;

type
  TArray = array of string;
  TStrArray = array of string;

  function Explode(var a: TStrArray; Border, S: string): Integer;
  function explode2(cDelimiter,  sValue : string; iCount : integer) : TArray;
  function forceDeleteFile(pFileName:pAnsiChar):boolean;
  function downloadFile(pUrl,pFileName:pChar):boolean;
  function boolToStr(bl:boolean):ansiString;

const
 NONE              = $00; //Blank number
 INET_USERAGENT    = 'Mozilla/4.0, Indy Library (Windows; en-US)';
 INET_REDIRECT_MAX = 10;

implementation

function Explode(var a: TStrArray; Border, S: string): Integer;
var
  S2: string;
begin
  Result  := 0;
  S2 := S + Border;
  repeat
    SetLength(A, Length(A) + 1);
    a[Result] := Copy(S2, 0,Pos(Border, S2) - 1);
    Delete(S2, 1,Length(a[Result] + Border));
    Inc(Result);
  until S2 = '';
end;

function explode2(cDelimiter,  sValue : string; iCount : integer) : TArray;
var
  s : string; i,p : integer;
begin
  s := sValue; i := 0;
  while length(s) > 0 do
  begin
    inc(i);
    SetLength(result, i);
    p := pos(cDelimiter,s);
    if ( p > 0 ) and ( ( i < iCount ) OR ( iCount = 0) ) then
    begin
      result[i - 1] := copy(s,0,p-1);
      s := copy(s,p + length(cDelimiter),length(s));
    end else
    begin
      result[i - 1] := s;
      s :=  '';
    end;
  end;
end;

function forceDeleteFile(pFileName:pAnsiChar):boolean;
begin
 windows.setFileAttributes(pFileName,NONE);//clear file attributes
 result:=windows.deleteFile(pFileName);    //then delete the file
end;

function downloadFile(pUrl,pFileName:pChar):boolean;
var
  fs:TFileStream;
  IOHandler: TIdSSLIOHandlerSocket;
  Http: TIdHTTP;
begin
  result:=false;
  if (pUrl=nil) or (pFileName=nil) then
    exit;                     //Check arguments
  if fileAge(pFileName)>-1 then
    forceDeleteFile(pFileName);       //Delete existing file

  try
    fs:=TFileStream.Create(pFileName,fmCreate)
  except
    exit;
  end; //Create file stream

  Http := TIdHTTP.Create(nil);
  IOHandler := TIdSSLIOHandlerSocket.Create(nil);
  try
    IOHandler := TIdSSLIOHandlerSocket.Create(nil);
    IOHandler.SSLOptions.Method := sslvSSLv3;
    Http.IOHandler := IOHandler;
    Http.request.userAgent:=INET_USERAGENT;                             //Define user agent
    Http.redirectMaximum:=INET_REDIRECT_MAX;                            //Redirect maxumum
    Http.handleRedirects:=INET_REDIRECT_MAX<>NONE;                      //Handle redirects
    try
      http.get(pUrl,fs);result:=fs.size>NONE
    except
    end;              //Do the request
  finally
    FreeAndNil(http);
    FreeAndNil(IOHandler);
    FreeAndNil(fs);
  end;

end;


function boolToStr(bl:boolean):ansiString;
begin
 if bl then result:='yes' else result:='no';
end;

end.
