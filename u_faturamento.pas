unit u_faturamento;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ADODB;

type
  TFatOpeTipo = (opeInclusao, OpeBaixa, OpeCancelamento, OpeEstorno);

  TFatObj = class
  private
    FDataFinal: TDateTime;
    FDataInicial: TDateTime;
    FLog: TStringList;
    FDataPagamento: TDateTime;
    procedure SetDataFinal(const Value: TDateTime);
    procedure SetDataInicial(const Value: TDateTime);
    procedure SetLog(const Value: TStringList);
    function InserirNovaFatura(ClienteID: Integer; DataGer: TDateTime; TotalFatura: Currency; ValorBaixado: Currency = 0; ValorCancelado: Currency = 0): integer;
    function RegLctoFatura(FaturID: integer; FaturLctoTipo: TFatOpeTipo; FaturLctoData: TDateTime; FaturLctoDescricao: string; FaturLctoValor: Currency): boolean;
    function AtualizaItensFaturados(NovaFaturID: Integer; ClienteID: Integer; ListaItens: TStringList): boolean;
    function AtualizarEmailFaturEnviado(FaturID: Integer; DataHoraEnvio: TDateTime): boolean;
    procedure SetDataPagamento(const Value: TDateTime);
  public
    constructor Create;
    destructor Destroy; override;
    property DataInicial: TDateTime read FDataInicial write SetDataInicial;
    property DataFinal: TDateTime read FDataFinal write SetDataFinal;
    property DataPagamento: TDateTime read FDataPagamento write SetDataPagamento;
    property Log: TStringList read FLog write SetLog;
    //
    procedure Exec;
    procedure EnviarEmailFaturPendentes;
  end;




implementation

uses u_dm, DateUtils, u_mailsender;

{ TFatObj }

constructor TFatObj.Create;
begin
  inherited;
  FLog := TStringList.Create;
end;

destructor TFatObj.Destroy;
begin
  inherited;
  FreeAndNil(FLog);
end;

procedure TFatObj.Exec;
var
  QTotalVenda,
  QItemVend: TADOQuery;
  ATotalFatura: Currency;
  ADataGer: TDateTime;
  ANovaFatur: integer;
  AListaItensFat: TStringList;

  procedure PrepararConsultas;
  begin
    QTotalVenda.SQL.Clear;
    QTotalVenda.SQL.Add('SELECT DISTINCTROW Departamentos.DeptoDescricao,');
    QTotalVenda.SQL.Add('Clientes.ClienteNome,ItensVendidos.ClienteID,');
    QTotalVenda.SQL.Add('Sum(ItensVendidos.ItemValorTotal) AS TotalEmAberto');
    QTotalVenda.SQL.Add('FROM Departamentos');
    QTotalVenda.SQL.Add('INNER JOIN (ItensVendidos');
    QTotalVenda.SQL.Add('INNER JOIN Clientes ON ItensVendidos.ClienteID = Clientes.ClienteID) ON Departamentos.DeptoID = Clientes.DeptoID');
    QTotalVenda.SQL.Add('WHERE (((ItensVendidos.FaturamentoID) Is Null))');
    QTotalVenda.SQL.Add('AND (ItensVendidos.DataReferencia>= :DataInicial and ItensVendidos.DataReferencia<= :DataFinal)');
    QTotalVenda.SQL.Add('GROUP BY Departamentos.DeptoDescricao, Clientes.ClienteNome, ItensVendidos.ClienteID');
    QTotalVenda.SQL.Add('ORDER BY Departamentos.DeptoDescricao, Clientes.ClienteNome');

    QItemVend.SQL.Clear;
    QItemVend.SQL.Add('SELECT * FROM ItensVendidos');
    QItemVend.SQL.Add('WHERE ItensVendidos.ClienteID = :ClienteID');
    QItemVend.SQL.Add('AND (((ItensVendidos.FaturamentoID) Is Null))');
    QItemVend.SQL.Add('AND (ItensVendidos.DataReferencia>= :DataInicial and ItensVendidos.DataReferencia<= :DataFinal)');

  end;

begin
  QTotalVenda := TADOQuery.Create(nil);
  QItemVend := TADOQuery.Create(nil);
  AListaItensFat := TStringList.Create;
  try
    try
      QTotalVenda.Connection := DM.GetConexao;
      QItemVend.Connection := DM.GetConexao;

      Log.Clear;

      PrepararConsultas;

      //Filtramos somente aqueles clientes que possuem itens com faturamento pendente
      QTotalVenda.Close;
      QTotalVenda.Parameters.ParamByName('DataInicial').Value := StartOfTheDay(DataInicial);
      QTotalVenda.Parameters.ParamByName('DataFinal').Value := EndOfTheDay(DataFinal);
      QTotalVenda.Open;

      if QTotalVenda.Eof then
        Log.Add('Não foram encontrados registros para faturar')
      else
      begin

        ADataGer := Now;
        while not QTotalVenda.Eof do
        begin
          Log.Add(QTotalVenda.FieldByName('ClienteID').AsString + ' ' +
                  QTotalVenda.FieldByName('ClienteNome').AsString + ' R$ ' +
                  FormatCurr('#0.00', QTotalVenda.FieldByName('TotalEmAberto').AsFloat));
          QItemVend.Close;
          QItemVend.Parameters.ParamByName('ClienteID').Value := QTotalVenda.FieldByName('ClienteID').AsInteger;
          QItemVend.Parameters.ParamByName('DataInicial').Value := StartOfTheDay(DataInicial);
          QItemVend.Parameters.ParamByName('DataFinal').Value := EndOfTheDay(DataFinal);
          QItemVend.Open;
          ATotalFatura := 0;
          AListaItensFat.Clear;
          QItemVend.First;
          while not QItemVend.Eof do
          begin
            ATotalFatura := ATotalFatura + QItemVend.FieldByName('ItemValorTotal').AsCurrency;
            AListaItensFat.Add(QItemVend.FieldByName('ItemID').AsString);
            QItemVend.Next;
          end;

          if QTotalVenda.FieldByName('TotalEmAberto').AsFloat = ATotalFatura then
          begin
            //Inserir a nova fatura
            ANovaFatur := InserirNovaFatura(QTotalVenda.FieldByName('ClienteID').AsInteger, ADataGer, ATotalFatura);

            if ANovaFatur > 0 then
            begin
              Log.Add('FaturID: ' + IntToStr(ANovaFatur));
              AtualizaItensFaturados(ANovaFatur, QTotalVenda.FieldByName('ClienteID').AsInteger, AListaItensFat);
            end
            else
              raise Exception.Create('Era esperado um registro de inserção na tabela de faturas');
          end
          else
          begin
            raise Exception.Create('O valor a ser faturado retornado pelo mecanismo de consulta diverge da soma realizada dos itens pendentes' + #10#13 +
                                   'Total em aberto: ' + FormatCurr('#0.00',QTotalVenda.FieldByName('TotalEmAberto').AsFloat) + #10#13 +
                                   'SomaFat: ' + FormatCurr('#0.00', ATotalFatura))
          end;
          QTotalVenda.Next;
        end;
        Log.SaveToFile(ExtractFilePath(Application.ExeName) + 'LogFaturamento_' + FormatDateTime('yyyy-mm-dd_hhnnsszzz', Now) + '.txt');
      end;
    except
      on E:Exception do
      begin
        ShowMessage(E.Message);
        raise;
      end;
    end;
  finally
    FreeAndNil(QTotalVenda);
    FreeAndNil(QItemVend);
  end;

end;

procedure TFatObj.SetDataFinal(const Value: TDateTime);
begin
  FDataFinal := Value;
end;

procedure TFatObj.SetDataInicial(const Value: TDateTime);
begin
  FDataInicial := Value;
end;


procedure TFatObj.SetLog(const Value: TStringList);
begin
  FLog := Value;
end;

function TFatObj.InserirNovaFatura(ClienteID: Integer; DataGer: TDateTime; TotalFatura: Currency; ValorBaixado: Currency = 0; ValorCancelado: Currency = 0): integer;
var
  QInserirFat,
  QLocFat: TADOQuery;
begin
  Result := -1;
  QInserirFat := TADOQuery.Create(nil);
  QLocFat := TADOQuery.Create(nil);
  try
    QInserirFat.Connection := DM.GetConexao;
    QLocFat.Connection := DM.GetConexao;

    QInserirFat.SQL.Add('INSERT INTO Faturamentos (ClienteID, FaturDataGeracao, FaturValorTotal, FaturValorBaixado, FaturValorCancelado) VALUES ');
    QInserirFat.SQL.Add('                        (:ClienteID, :FaturDataGeracao, :FaturValorTotal, :FaturValorBaixado, :FaturValorCancelado);');

    QLocFat.SQL.Add('SELECT MAX(FaturID) AS FaturID FROM Faturamentos WHERE ClienteID = :ClienteID AND FaturDataGeracao = :FaturDataGeracao');

    QInserirFat.Close;
    QInserirFat.Parameters.ParamByName('ClienteID').Value := ClienteID;
    QInserirFat.Parameters.ParamByName('FaturDataGeracao').Value := DataGer;
    QInserirFat.Parameters.ParamByName('FaturValorTotal').Value := TotalFatura;
    QInserirFat.Parameters.ParamByName('FaturValorBaixado').Value := 0;
    QInserirFat.Parameters.ParamByName('FaturValorCancelado').Value := 0;
    try
      if QInserirFat.ExecSQL > 0 then
      begin
        QLocFat.Close;
        QLocFat.Parameters.ParamByName('ClienteID').Value := ClienteID;
        QLocFat.Parameters.ParamByName('FaturDataGeracao').Value := DataGer;
        QLocFat.Open;

        Result := QLocFat.FieldByName('FaturID').AsInteger;

        //Inserir o registro de lançamento
        RegLctoFatura(Result, opeInclusao, DataGer, 'Inclusão de fatura automática', TotalFatura);
      end;
    except
      Result := 0;
      raise;
    end;
  finally
    FreeAndNil(QInserirFat);
    FreeAndNil(QLocFat);
  end;

end;

function TFatObj.AtualizaItensFaturados(NovaFaturID: Integer; ClienteID: Integer; ListaItens: TStringList): boolean;
var
  QAtualizaItem: TADOQuery;
  aux,
  AItemID,
  IncFatur: Integer;
begin
  if ListaItens <> nil then
  begin
    QAtualizaItem := TADOQuery.Create(nil);
    try
      QAtualizaItem.Connection := DM.GetConexao;
      QAtualizaItem.SQL.Add('UPDATE ItensVendidos');
      QAtualizaItem.SQL.Add('SET FaturamentoID = :FaturamentoID');
      QAtualizaItem.SQL.Add('WHERE ItensVendidos.ClienteID = :ClienteID');
      QAtualizaItem.SQL.Add('AND (ItensVendidos.FaturamentoID Is Null)');
      QAtualizaItem.SQL.Add('AND ItensVendidos.ItemID = :ItemID');

      IncFatur :=0;
      for aux := 0 to ListaItens.Count -1 do
      begin
        AItemID := StrToIntDef(ListaItens.Strings[aux], -1);
        QAtualizaItem.Close;
        QAtualizaItem.Parameters.ParamByName('ClienteID').Value := ClienteID;
        QAtualizaItem.Parameters.ParamByName('ItemID').Value := AItemID;
        QAtualizaItem.Parameters.ParamByName('FaturamentoID').Value := NovaFaturID;
        if QAtualizaItem.ExecSQL <= 0 then
          raise Exception.Create('Nenhum item de venda foi atualizado')
        else
        begin
          Log.Add('ItemID faturado: ' + IntToStr(AItemID));
          Inc(IncFatur);
        end;
      end;
    finally
      FreeAndNil(QAtualizaItem);
    end;
    Result := IncFatur = ListaItens.Count;
  end
  else
  begin
    raise Exception.Create('Era esperada uma lista de itens válida');
  end;
end;

function TFatObj.RegLctoFatura(FaturID: Integer; FaturLctoTipo: TFatOpeTipo;
  FaturLctoData: TDateTime; FaturLctoDescricao: string;
  FaturLctoValor: Currency): boolean;
var
  QFaturLcto: TADOQuery;
begin
  QFaturLcto :=TADOQuery.Create(nil);
  try
    QFaturLcto.Connection := DM.GetConexao;
    QFaturLcto.SQL.Add('INSERT INTO FaturamentosLancamentos');
    QFaturLcto.SQL.Add('(FaturID,FaturLctoTipo,FaturLctoData,FaturLctoDescricao,FaturLctoValor)');
    QFaturLcto.SQL.Add('VALUES');
    QFaturLcto.SQL.Add('(:FaturID,:FaturLctoTipo,:FaturLctoData,:FaturLctoDescricao,:FaturLctoValor)');
    QFaturLcto.Parameters.ParamByName('FaturID').Value := FaturID;
    QFaturLcto.Parameters.ParamByName('FaturLctoTipo').Value := Integer(FaturLctoTipo);
    QFaturLcto.Parameters.ParamByName('FaturLctoData').Value := FaturLctoData;
    QFaturLcto.Parameters.ParamByName('FaturLctoDescricao').Value := FaturLctoDescricao;
    QFaturLcto.Parameters.ParamByName('FaturLctoValor').Value := FaturLctoValor;
    try
      Result := QFaturLcto.ExecSQL > 0;
    except
      on E:Exception do
      begin
        Result := False;
        raise;
      end;
    end;
  finally
    FreeAndNil(QFaturLcto);
  end;

end;

procedure TFatObj.EnviarEmailFaturPendentes;
var
  QFatPend: TADOQuery;
  AMSend: TMailSender;
  MsgErro,
  ADt: string;
begin
  QFatPend := TADOQuery.Create(nil);
  QFatPend.Connection := DM.GetConexao;
  try
    try
      if DataPagamento = 0 then
        raise Exception.Create('A data de pagamento dos faturamentos não foi informada');

      QFatPend.SQL.Add('SELECT * FROM MalaDiretaFaturPendente');
      QFatPend.Open;
      if not QFatPend.Eof then
      begin
        while not QFatPend.Eof do
        begin
          if QFatPend.FieldByName('ClienteEmail').AsString = EmptyStr then
          begin
            QFatPend.Next;
            Continue;
          end;

          AMSend := TMailSender.Create;
          try
            AMSend.DestinatarioNome := QFatPend.FieldByName('ClienteNome').AsString;
            AMSend.DestinatarioEmail := LowerCase(trim(QFatPend.FieldByName('ClienteEmail').AsString));
            AMSend.AssuntoEmail := 'Resumo conta consumo bolos e doces';
            AMSend.TextoEmail.Add('Olá ' + AMSend.DestinatarioNome + '!');
            AMSend.TextoEmail.Add(' ');
            AMSend.TextoEmail.Add(' ');
            AMSend.TextoEmail.Add('Sua conta do consumo de bolos e doces foi de: R$ ' + FormatCurr('#0.00', QFatPend.FieldByName('FaturValorTotal').AsCurrency));
            AMSend.TextoEmail.Add('O pagamento poderá ser realizado até ' + FormatDateTime('dd/mm/yyyy', DataPagamento) + ', pessoalmente.');
            AMSend.TextoEmail.Add('Se você preferir pode efetuar um depósito no Santander através dos dados abaixo.');
            AMSend.TextoEmail.Add(' ');
            AMSend.TextoEmail.Add('BANCO SANTANDER ');
            AMSend.TextoEmail.Add('AG 4509 ');
            AMSend.TextoEmail.Add('C/C 01064448-3');
            AMSend.TextoEmail.Add('TITULAR: SERGIO HENRIQUE MARCHIORI');
            AMSend.TextoEmail.Add(' ');
            AMSend.TextoEmail.Add(' ');
            AMSend.TextoEmail.Add('Por favor responda este e-mail caso efetuar depósito, para facilitar o controle.');
            AMSend.TextoEmail.Add('Em caso de alguma divergência possuo os registros para sua verificação.');
            AMSend.TextoEmail.Add(' ');
            AMSend.TextoEmail.Add('Obrigado por consumir nossos produtos e utilize este canal de comunicação para efetuar sugestões ou críticas');
            AMSend.TextoEmail.Add(' ');
            AMSend.TextoEmail.Add('Att. Sérgio Henrique Marchiori');
            ADt := '[' + FormatDateTime('dd/mm/yyyy hh:nn:ss zzz', Now) + '] ';
            if not AMSend.Enviar(MsgErro) then
            begin
              Log.Add(ADt + 'Erro: ' + QFatPend.FieldByName('ClienteNome').AsString + MsgErro)
            end
            else
            begin
              Log.Add(ADt + 'Enviado: ' + QFatPend.FieldByName('ClienteNome').AsString);
              AtualizarEmailFaturEnviado(QFatPend.FieldByName('FaturID').AsInteger, Now);
            end;
          finally
            FreeAndNil(AMSend);
          end;
          QFatPend.Next;
        end;
        Log.SaveToFile(ExtractFilePath(Application.ExeName) + 'LogEnviaEmail_' + FormatDateTime('yyyy-mm-dd_hhnnsszzz', Now) + '.txt');
      end;
      Log.Add('Não há e-mails pendentes para enviar');
    except
      on E:Exception do
      begin
        ShowMessage(E.Message);
        raise;
      end;
    end;
  finally
    FreeAndNil(QFatPend);
  end;

end;

procedure TFatObj.SetDataPagamento(const Value: TDateTime);
begin
  FDataPagamento := Value;
end;

function TFatObj.AtualizarEmailFaturEnviado(FaturID: Integer;
  DataHoraEnvio: TDateTime):boolean;
var
  QUpdEmailFat: TADOQuery;
begin
  QUpdEmailFat := TADOQuery.Create(nil);
  try
    QUpdEmailFat.Connection := DM.GetConexao;
    QUpdEmailFat.SQL.Add('UPDATE Faturamentos set FaturDataEnvioEmail = :FaturDataEnvioEmail where FaturID = :FaturID');
    QUpdEmailFat.Parameters.ParamByName('FaturDataEnvioEmail').Value := DataHoraEnvio;
    QUpdEmailFat.Parameters.ParamByName('FaturID').Value := FaturID;
    Result := QUpdEmailFat.ExecSQL > 0;
  finally
    FreeAndNil(QUpdEmailFat);
  end;
end;

end.
