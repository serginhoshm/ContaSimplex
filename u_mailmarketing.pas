unit u_mailmarketing;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ADODB, DBClient, DB;

type
  TPesquisaSat = class
  private
    function ConverteNotaIndice(ANotaStr: string): Integer;
    function EhExpressaoPesquisa(AExpressao: string):Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    function ImportarDadosPlanilha: string;
  end;

implementation

uses u_bibliotecas;

{ TPesquisaSat }

function TPesquisaSat.ConverteNotaIndice(ANotaStr: string): Integer;
begin
  Result := StrToIntDef(Copy(ANotaStr,1,1), 0);
end;

constructor TPesquisaSat.Create;
begin
  inherited;
end;

destructor TPesquisaSat.Destroy;
begin
  inherited;
end;

function TPesquisaSat.EhExpressaoPesquisa(AExpressao: string): Boolean;
var
  AExp: string;
begin
  AExp := UpperCase(trim(AExpressao));

  Result := (AnsiCompareStr(AExp, UpperCase('1 ESTRELA')) = 0) or
            (AnsiCompareStr(AExp, UpperCase('2 ESTRELAS')) = 0) or
            (AnsiCompareStr(AExp, UpperCase('3 ESTRELAS')) = 0) or
            (AnsiCompareStr(AExp, UpperCase('4 ESTRELAS')) = 0) or
            (AnsiCompareStr(AExp, UpperCase('5 ESTRELAS')) = 0);
end;

function TPesquisaSat.ImportarDadosPlanilha: string;
var
  AStr: TStringList;
  AURL,
  ATemp,
  AIdentificador,
  ANomeArquivo: string;
  ACDSPesquisa: TClientDataSet;
  aux,j: Integer;
  Tokens: TStrArray;

  procedure InicializaCDSRespostas;
  begin
    ACDSPesquisa.Close;
    ACDSPesquisa.FieldDefs.Clear;
    ACDSPesquisa.FieldDefs.Add('Identificador', ftstring, 200);
    ACDSPesquisa.FieldDefs.Add('Indice', ftInteger);
    ACDSPesquisa.FieldDefs.Add('Votos', ftinteger);
    ACDSPesquisa.FieldDefs.Add('Estrelas', ftinteger);
    ACDSPesquisa.CreateDataSet;
    ACDSPesquisa.LogChanges := false;
  end;


begin
  Result := EmptyStr;
  ANomeArquivo := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + 'Pesquisa\InputPesquisa.csv';
  ForceDirectories(ExtractFilePath(ANomeArquivo));
  AURL := 'https://docs.google.com/spreadsheets/d/1vxYcVV6PBsXy4XrdANUApOB36j1fbrly6tVUdulne_k/pub?output=csv';

//  downloadFile(pAnsiChar(aUrl),pAnsiChar(ANomeArquivo));

  if FileExists(ANomeArquivo) then
  begin
    ACDSPesquisa := TClientDataSet.Create(nil);
    InicializaCDSRespostas;
    AStr := TStringList.Create;
    try
      AStr.LoadFromFile(ANomeArquivo);

      for aux := 0 to AStr.Count -1 do
      begin
        SetLength(Tokens,0);
        Explode(Tokens, ',', AStr.Strings[aux]);

        ATemp := EmptyStr;

        for j :=0 to Length(Tokens)-1 do
        begin
          //Receber o token
          ATemp := Tokens[j];

          //Se possui colchetes é um identificador
          if AnsiPos('[', ATemp) > 0 then
          begin
            AIdentificador := Copy(ATemp, AnsiPos('[', ATemp),MaxInt);
            AIdentificador := StringReplace(AIdentificador, '[', '', [rfReplaceAll, rfIgnoreCase]);
            AIdentificador := StringReplace(AIdentificador, ']', '', [rfReplaceAll, rfIgnoreCase]);
            ACDSPesquisa.AppendRecord([AIdentificador,j {índice}, 0 {contagem}]);
          end
          else
          if EhExpressaoPesquisa(ATemp) then
          begin
            if ACDSPesquisa.IndexFieldNames <> 'Indice' then
              ACDSPesquisa.IndexFieldNames := 'Indice';
            if ACDSPesquisa.FindKey([j]) then
            begin
              ACDSPesquisa.Edit;
              ACDSPesquisa.FieldByName('Votos').AsInteger := ACDSPesquisa.FieldByName('Votos').AsInteger + 1;
              ACDSPesquisa.FieldByName('Estrelas').AsInteger := ACDSPesquisa.FieldByName('Estrelas').AsInteger + ConverteNotaIndice(ATemp);
              ACDSPesquisa.Post;
            end;
          end;
        end;
      end;
      //Salva XML com resultados
      ANomeArquivo := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + 'Pesquisa\ResultadosPesquisa.xml';
      ForceDirectories(ExtractFilePath(ANomeArquivo));
      ACDSPesquisa.SaveToFile(ANomeArquivo);
      Result := ANomeArquivo;
    finally
      FreeAndNil(ACDSPesquisa);
      FreeAndNil(AStr);
    end;
  end
  else
    raise exception.Create('Arquivo inexistente');
end;

end.
 