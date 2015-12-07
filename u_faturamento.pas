unit u_faturamento;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ADODB, Uni, UniProvider, PostgreSQLUniProvider;

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
  QItemVend: TUniQuery;
  ATotalFatura: Currency;
  ADataGer: TDateTime;
  ANovaFatur: integer;
  AListaItensFat: TStringList;

  procedure PrepararConsultas;
  begin
    qtotalvenda.sql.clear;
    qtotalvenda.sql.add('select distinct departamentos.deptodescricao,');
    qtotalvenda.sql.add('clientes.clientenome,itensvendidos.clienteid,');
    qtotalvenda.sql.add('sum(itensvendidos.itemvalortotal) as totalemaberto');
    qtotalvenda.sql.add('from departamentos');
    qtotalvenda.sql.add('inner join (itensvendidos');
    qtotalvenda.sql.add('inner join clientes on itensvendidos.clienteid = clientes.clienteid) on departamentos.deptoid = clientes.deptoid');
    qtotalvenda.sql.add('where (((itensvendidos.faturamentoid) is null))');
    qtotalvenda.sql.add('and (itensvendidos.datareferencia>= :datainicial and itensvendidos.datareferencia<= :datafinal)');
    qtotalvenda.sql.add('group by departamentos.deptodescricao, clientes.clientenome, itensvendidos.clienteid');
    qtotalvenda.sql.add('order by departamentos.deptodescricao, clientes.clientenome');

    qitemvend.sql.clear;
    qitemvend.sql.add('select * from itensvendidos');
    qitemvend.sql.add('where itensvendidos.clienteid = :clienteid');
    qitemvend.sql.add('and (((itensvendidos.faturamentoid) is null))');
    qitemvend.sql.add('and (itensvendidos.datareferencia>= :datainicial and itensvendidos.datareferencia<= :datafinal)');

  end;

begin
  QTotalVenda := TUniQuery.Create(nil);
  QItemVend := TUniQuery.Create(nil);
  AListaItensFat := TStringList.Create;
  try
    try
      QTotalVenda.Connection := DM.GetConexao;
      QItemVend.Connection := DM.GetConexao;

      Log.Clear;

      PrepararConsultas;

      //Filtramos somente aqueles clientes que possuem itens com faturamento pendente
      QTotalVenda.Close;
      QTotalVenda.ParamByName('DataInicial').Value := StartOfTheDay(DataInicial);
      QTotalVenda.ParamByName('DataFinal').Value := EndOfTheDay(DataFinal);
      QTotalVenda.Open;

      if QTotalVenda.Eof then
        Log.Add('N�o foram encontrados registros para faturar')
      else
      begin

        ADataGer := Now;
        while not QTotalVenda.Eof do
        begin
          Log.Add(QTotalVenda.FieldByName('ClienteID').AsString + ' ' +
                  QTotalVenda.FieldByName('ClienteNome').AsString + ' R$ ' +
                  FormatCurr('#0.00', QTotalVenda.FieldByName('TotalEmAberto').AsFloat));
          QItemVend.Close;
          QItemVend.ParamByName('ClienteID').Value := QTotalVenda.FieldByName('ClienteID').AsInteger;
          QItemVend.ParamByName('DataInicial').Value := StartOfTheDay(DataInicial);
          QItemVend.ParamByName('DataFinal').Value := EndOfTheDay(DataFinal);
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
              raise Exception.Create('Era esperado um registro de inser��o na tabela de faturas');
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
  QLocFat: TUniQuery;
begin
  Result := -1;
  QInserirFat := TUniQuery.Create(nil);
  QLocFat := TUniQuery.Create(nil);
  try
    QInserirFat.Connection := DM.GetConexao;
    QLocFat.Connection := DM.GetConexao;

    qinserirfat.sql.add('insert into faturamentos (clienteid, faturdatageracao, faturvalortotal, faturvalorbaixado, faturvalorcancelado) values ');
    qinserirfat.sql.add('                        (:clienteid, :faturdatageracao, :faturvalortotal, :faturvalorbaixado, :faturvalorcancelado);');

    qlocfat.sql.add('select max(faturid) as faturid from faturamentos where clienteid = :clienteid and faturdatageracao = :faturdatageracao');

    QInserirFat.Close;
    QInserirFat.ParamByName('ClienteID').Value := ClienteID;
    QInserirFat.ParamByName('FaturDataGeracao').Value := DataGer;
    QInserirFat.ParamByName('FaturValorTotal').Value := TotalFatura;
    QInserirFat.ParamByName('FaturValorBaixado').Value := 0;
    QInserirFat.ParamByName('FaturValorCancelado').Value := 0;
    try
      QInserirFat.ExecSQL;
      if QInserirFat.RowsAffected > 0 then
      begin
        QLocFat.Close;
        QLocFat.ParamByName('ClienteID').Value := ClienteID;
        QLocFat.ParamByName('FaturDataGeracao').Value := DataGer;
        QLocFat.Open;

        Result := QLocFat.FieldByName('FaturID').AsInteger;

        //Inserir o registro de lan�amento
        RegLctoFatura(Result, opeInclusao, DataGer, 'Inclus�o de fatura autom�tica', TotalFatura);
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
  QAtualizaItem: TUniQuery;
  aux,
  AItemID,
  IncFatur: Integer;
begin
  if ListaItens <> nil then
  begin
    QAtualizaItem := TUniQuery.Create(nil);
    try
      qatualizaitem.connection := dm.getconexao;
      qatualizaitem.sql.add('update itensvendidos');
      qatualizaitem.sql.add('set faturamentoid = :faturamentoid');
      qatualizaitem.sql.add('where itensvendidos.clienteid = :clienteid');
      qatualizaitem.sql.add('and (itensvendidos.faturamentoid is null)');
      qatualizaitem.sql.add('and itensvendidos.itemid = :itemid');

      IncFatur :=0;
      for aux := 0 to ListaItens.Count -1 do
      begin
        AItemID := StrToIntDef(ListaItens.Strings[aux], -1);
        QAtualizaItem.Close;
        QAtualizaItem.ParamByName('ClienteID').Value := ClienteID;
        QAtualizaItem.ParamByName('ItemID').Value := AItemID;
        QAtualizaItem.ParamByName('FaturamentoID').Value := NovaFaturID;
        QAtualizaItem.ExecSQL;
        if QAtualizaItem.RowsAffected <= 0 then
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
    raise Exception.Create('Era esperada uma lista de itens v�lida');
  end;
end;

function TFatObj.RegLctoFatura(FaturID: Integer; FaturLctoTipo: TFatOpeTipo;
  FaturLctoData: TDateTime; FaturLctoDescricao: string;
  FaturLctoValor: Currency): boolean;
var
  QFaturLcto: TUniQuery;
begin
  //esta parte do procedimento est� sendo ignorada
  {

  QFaturLcto :=TUniQuery.Create(nil);
  try
    QFaturLcto.Connection := DM.GetConexao;
    QFaturLcto.SQL.Add('INSERT INTO FaturamentosLancamentos');
    QFaturLcto.SQL.Add('(FaturID,FaturLctoTipo,FaturLctoData,FaturLctoDescricao,FaturLctoValor)');
    QFaturLcto.SQL.Add('VALUES');
    QFaturLcto.SQL.Add('(:FaturID,:FaturLctoTipo,:FaturLctoData,:FaturLctoDescricao,:FaturLctoValor)');
    QFaturLcto.ParamByName('FaturID').Value := FaturID;
    QFaturLcto.ParamByName('FaturLctoTipo').Value := Integer(FaturLctoTipo);
    QFaturLcto.ParamByName('FaturLctoData').Value := FaturLctoData;
    QFaturLcto.ParamByName('FaturLctoDescricao').Value := FaturLctoDescricao;
    QFaturLcto.ParamByName('FaturLctoValor').Value := FaturLctoValor;
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
  }
end;

procedure TFatObj.EnviarEmailFaturPendentes;
var
  QFatPend: TUniQuery;
  AMSend: TMailSender;
  MsgErro,
  ADt: string;
begin
  QFatPend := TUniQuery.Create(nil);
  QFatPend.Connection := DM.GetConexao;
  try
    try
      if DataPagamento = 0 then
        raise Exception.Create('A data de pagamento dos faturamentos n�o foi informada');

      qfatpend.sql.add('select * from maladiretafaturpendente');
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
            AMSend.TextoEmail.Add('Ol� ' + AMSend.DestinatarioNome + '!');
            AMSend.TextoEmail.Add(' ');
            AMSend.TextoEmail.Add(' ');
            AMSend.TextoEmail.Add('Sua conta do consumo de bolos e doces foi de: R$ ' + FormatCurr('#0.00', QFatPend.FieldByName('FaturValorTotal').AsCurrency));
            AMSend.TextoEmail.Add('O pagamento poder� ser realizado at� ' + FormatDateTime('dd/mm/yyyy', DataPagamento) + '.');
            AMSend.TextoEmail.Add(' ');
            AMSend.TextoEmail.Add('ATEN��O: Estamos inovando os m�todos de pagamento para este m�s, conto com sua colabora��o:');
            AMSend.TextoEmail.Add('M�TODO 1 - CAIXINHA (auto-atendimento)');
            AMSend.TextoEmail.Add(' ');
            AMSend.TextoEmail.Add(' - Atr�s de minha esta��o de trabalho (baia vazia), existe uma caixinha trancada com envelopes ao lado');
            AMSend.TextoEmail.Add(' - Escreva seu nome no envelope, coloque os valores nele e deposite na caixa');
            AMSend.TextoEmail.Add(' - Confirmo o recebimentos destes valores at� o final do dia');
            AMSend.TextoEmail.Add(' - Se o seu pagamento tiver troco, devolvo o mesmo no dia seguinte (tamb�m pode ficar a cr�dito)');
            AMSend.TextoEmail.Add('M�TODO 2 - Dep�sito banc�rio (somente Santander)');
            AMSend.TextoEmail.Add(' ');
            AMSend.TextoEmail.Add(' - BANCO SANTANDER ');
            AMSend.TextoEmail.Add(' - AG 4509 ');
            AMSend.TextoEmail.Add(' - C/C 01064448-3');
            AMSend.TextoEmail.Add(' - TITULAR: SERGIO HENRIQUE MARCHIORI');
            AMSend.TextoEmail.Add('M�TODO 3 - Pessoalmente');
            AMSend.TextoEmail.Add(' - Prefira os hor�rios ap�s as 12:00h e ap�s as 18h, assim evitamos interrup��es durante o expediente.');
            AMSend.TextoEmail.Add(' ');
            AMSend.TextoEmail.Add(' ');
            AMSend.TextoEmail.Add('Em caso de alguma diverg�ncia possuo os registros para sua verifica��o.');
            AMSend.TextoEmail.Add(' ');
            AMSend.TextoEmail.Add('Obrigado por consumir nossos produtos e utilize este canal de comunica��o para efetuar sugest�es ou cr�ticas');
            AMSend.TextoEmail.Add(' ');
            AMSend.TextoEmail.Add('Att. S�rgio e Paulo');
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
      Log.Add('N�o h� e-mails pendentes para enviar');
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
  QUpdEmailFat: TUniQuery;
begin
  QUpdEmailFat := TUniQuery.Create(nil);
  try
    QUpdEmailFat.Connection := DM.GetConexao;
    qupdemailfat.sql.add('update faturamentos set faturdataenvioemail = :faturdataenvioemail where faturid = :faturid');
    QUpdEmailFat.ParamByName('FaturDataEnvioEmail').Value := DataHoraEnvio;
    QUpdEmailFat.ParamByName('FaturID').Value := FaturID;
    QUpdEmailFat.ExecSQL;
    Result := QUpdEmailFat.RowsAffected > 0;
  finally
    FreeAndNil(QUpdEmailFat);
  end;
end;

end.
