unit u_faturamento;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ADODB, StdCtrls, DBClient, DB;

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
    function AtualizarEmailRecebimentoEnviado(ReciboID: Integer; DataHoraEnvio: TDateTime):boolean;
    procedure SetDataPagamento(const Value: TDateTime);
    function RetornaCreditosPendentes(ClienteID: integer): Double;
    function RetornaDebitosPendentes(ClienteID: integer): Double;
    function GerarCredito(ClienteID: Integer; ValorCredito: Double; Observacao: string): Boolean;
    function BaixaFatura(FaturaID, ClienteID: Integer; ValorBaixado: Double):Boolean;
    function GerarAutenticacaoMecania(FaturID: integer): string;
    function CriarRecibo(Faturid: integer; recibodatageracao: TDateTime; recibovalorpago, recibovalorcredito, recibovalortroco: Double): string;
  public
    LabelProgresso: TLabel;
    constructor Create;
    destructor Destroy; override;
    property DataInicial: TDateTime read FDataInicial write SetDataInicial;
    property DataFinal: TDateTime read FDataFinal write SetDataFinal;
    property DataPagamento: TDateTime read FDataPagamento write SetDataPagamento;
    property Log: TStringList read FLog write SetLog;
    //
    function BaixarCreditos(ClienteID: Integer; ValorBaixar: Double;  CreditoRestante, CreditoUsado: Currency): Currency;
    procedure Exec;
    procedure EnviarEmailFaturPendentes;
    procedure EnviarEmailPagamentosRecebidosPendentes;
    function ReceberFatur(FaturID: Integer; ValorRecebido, ValorTroco, ValorACredito: Double): string;
    procedure EnviarHtmlMail;
  end;




implementation

uses u_dm, DateUtils, u_mailsender, MaskUtils, Math;

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
  ATotalFatura,
  ACreditoRestante,
  ACreditoUsado: Currency;
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

          if RoundTo(QTotalVenda.FieldByName('TotalEmAberto').AsFloat,-2) = RoundTo(ATotalFatura, -2) then
          begin
            ACreditoRestante := 0;
            ACreditoUsado := 0;

            ATotalFatura := BaixarCreditos(QTotalVenda.FieldByName('ClienteID').AsInteger, ATotalFatura, ACreditoRestante, ACreditoUsado);

            //Inserir a nova fatura - crédito já descontado
            ANovaFatur := InserirNovaFatura(QTotalVenda.FieldByName('ClienteID').AsInteger, ADataGer, ATotalFatura, ACreditoUsado);

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
  VDesc: Double;
  QInserirFat,
  QLocFat: TADOQuery;
begin
  Result := -1;
  QInserirFat := TADOQuery.Create(nil);
  QLocFat := TADOQuery.Create(nil);
  try
    QInserirFat.Connection := DM.GetConexao;
    QLocFat.Connection := DM.GetConexao;

    qinserirfat.sql.add('insert into faturamentos (clienteid, faturdatageracao, faturvalortotal, faturvalorbaixado, faturvalorcancelado, FaturValorDesconto, FaturValorAPagar) values ');
    qinserirfat.sql.add('                        (:clienteid, :faturdatageracao, :faturvalortotal, :faturvalorbaixado, :faturvalorcancelado, :FaturValorDesconto, :FaturValorAPagar);');

    qlocfat.sql.add('select max(faturid) as faturid from faturamentos where clienteid = :clienteid and faturdatageracao = :faturdatageracao');

    QInserirFat.Close;
    QInserirFat.Parameters.ParamByName('ClienteID').Value := ClienteID;
    QInserirFat.Parameters.ParamByName('FaturDataGeracao').Value := DataGer;
    QInserirFat.Parameters.ParamByName('FaturValorTotal').Value := TotalFatura;
    QInserirFat.Parameters.ParamByName('FaturValorBaixado').Value := ValorBaixado;
    QInserirFat.Parameters.ParamByName('FaturValorCancelado').Value := 0;
    if TotalFatura >= 20 then
      VDesc := RoundTo(TotalFatura * 0.05, -2)
    else
      VDesc := 0;
    QInserirFat.Parameters.ParamByName('FaturValorDesconto').Value := VDesc;
    QInserirFat.Parameters.ParamByName('FaturValorAPagar').Value := TotalFatura - VDesc;
    try
      QInserirFat.ExecSQL;
      if QInserirFat.RowsAffected > 0 then
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
        QAtualizaItem.Parameters.ParamByName('ClienteID').Value := ClienteID;
        QAtualizaItem.Parameters.ParamByName('ItemID').Value := AItemID;
        QAtualizaItem.Parameters.ParamByName('FaturamentoID').Value := NovaFaturID;
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
    raise Exception.Create('Era esperada uma lista de itens válida');
  end;
end;

function TFatObj.RegLctoFatura(FaturID: Integer; FaturLctoTipo: TFatOpeTipo;
  FaturLctoData: TDateTime; FaturLctoDescricao: string;
  FaturLctoValor: Currency): boolean;
var
  QFaturLcto: TADOQuery;
begin
  //esta parte do procedimento está sendo ignorada
  {

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
  }
end;

procedure TFatObj.EnviarEmailFaturPendentes;
var
  QRecP: TADOQuery;
  AMSend: TMailSender;
  MsgErro,
  ADt: string;
  clienteid: Integer;
  ACDS: TClientDataSet;
  TabelaFaturas: TStringList;
  ASoma: Currency;

  procedure CriarCursorCliente;
  begin
    QRecP.First;
    while not QRecP.Eof do
    begin
      if trim(QRecP.FieldByName('clienteemail').AsString) = EmptyStr then
      begin
        QRecP.Next;
        Continue;
      end;
      if not ACDS.Locate('clienteid', QRecP.FieldByName('clienteid').AsInteger, [loCaseInsensitive]) then
      begin
        ACDS.Append;
        ACDS.FieldByName('clienteid').AsInteger := QRecP.FieldByName('clienteid').AsInteger;
        ACDS.Post;
      end;
      QRecP.Next;
    end;
    ACDS.IndexFieldNames := 'clienteid';
    QRecP.First;
  end;

begin
  QRecP := TADOQuery.Create(nil);
  QRecP.Connection := DM.GetConexao;
  ACDS := TClientDataSet.Create(nil);
  TabelaFaturas := TStringList.Create;
  try
    ACDS.FieldDefs.Add('clienteid', ftinteger);
    ACDS.CreateDataSet;
    ACDS.LogChanges := false;
    try
      QRecP.sql.add('SELECT * ');
      QRecP.sql.add('  FROM faturamentospendentes order by clientenome, faturdatageracao');
      QRecP.Open;

      if not QRecP.Eof then
      begin
        CriarCursorCliente;
        TabelaFaturas.Clear;

        ACDS.First;
        while not ACDS.Eof do
        begin
          QRecP.Filter := 'clienteid=' + ACDS.FieldByName('clienteid').AsString;
          QRecP.Filtered := True;
          //QRecP.IndexFieldNames := 'faturid';

          TabelaFaturas.Add('<TABLE BORDER=1>');
          TabelaFaturas.Add('<TR>');
          TabelaFaturas.Add('   <TD>Referência</TD>');
          TabelaFaturas.Add('   <TD>Consumo</TD>');
          TabelaFaturas.Add('   <TD>Desconto</TD>');
          TabelaFaturas.Add('   <TD>A pagar</TD>');
          TabelaFaturas.Add('</TR>');

          ASoma := 0;
          QRecP.First;
          while not QRecP.Eof do
          begin
            TabelaFaturas.Add('<TR>');
            TabelaFaturas.Add('   <TD>' + FormatDateTime('dd/mm/yyyy', QRecP.FieldByName('faturdatageracao').AsDateTime) + '</TD>');
            TabelaFaturas.Add('   <TD>' + FormatCurr('#0.00', QRecP.FieldByName('FaturValorTotal').AsCurrency) + '</TD>');
            TabelaFaturas.Add('   <TD>' + FormatCurr('#0.00', QRecP.FieldByName('FaturValorDesconto').AsCurrency) + '</TD>');
            TabelaFaturas.Add('   <TD>' + FormatCurr('#0.00', QRecP.FieldByName('valorpendente').AsCurrency) + '</TD>');
            TabelaFaturas.Add('</TR>');
            ASoma := ASoma + QRecP.FieldByName('valorpendente').AsCurrency;
            QRecP.Next;
          end;

          TabelaFaturas.Add('<TR>');
          TabelaFaturas.Add('   <TD><b>TOTAL</b></TD>');
          TabelaFaturas.Add('   <TD></TD>');
          TabelaFaturas.Add('   <TD></TD>');
          TabelaFaturas.Add('   <TD><b>' + FormatCurr('#0.00', ASoma) + '</b></TD>');
          TabelaFaturas.Add('</TR>');
          TabelaFaturas.Add('</TABLE>');

          //Mandar o e-mail
          AMSend := TMailSender.Create;
          try
            AMSend.DestinatarioNome := QRecP.FieldByName('clientenome').AsString;
            AMSend.DestinatarioEmail := LowerCase(trim(QRecP.FieldByName('clienteemail').AsString));
            //AMSend.DestinatarioEmail := 'serginhoshm@gmail.com'; //para testes
            AMSend.AssuntoEmail := 'Conta Bolos e Doces';
            AMSend.TextoEmail.Add('Olá ' + AMSend.DestinatarioNome + '!');
            AMSend.TextoEmail.Add('');
            AMSend.TextoEmail.Add('');
            AMSend.TextoEmail.Add('<h2><mark><font color="red">ATENÇÃO: MUDAMOS NOSSOS MEIOS DE PAGAMENTO</font></mark></h2>');
            AMSend.TextoEmail.Add('');
            AMSend.TextoEmail.Add('');
            AMSend.TextoEmail.Add('Segue abaixo faturamento do consumo de bolos e doces: ');
            AMSend.TextoEmail.Add('');
            AMSend.TextoEmail.Add(TabelaFaturas.Text);
            AMSend.TextoEmail.Add('<h2>Métodos de pagamento</h2>');
            AMSend.TextoEmail.Add('<TABLE border=1>');
            AMSend.TextoEmail.Add('<TR>');
            AMSend.TextoEmail.Add('  <TD><b>PicPay</b></TD>');
            AMSend.TextoEmail.Add('  <TD><img src="https://image.ibb.co/eY1snJ/picpay.jpg" alt="picpay" border="0"></TD>');
            AMSend.TextoEmail.Add('</TR>  ');
            AMSend.TextoEmail.Add('<TR>');
            AMSend.TextoEmail.Add('	<TD colspan="2">');
            AMSend.TextoEmail.Add('    	<ul>');
            AMSend.TextoEmail.Add('    	<li>Adicione @paulocesar75 e efetue seu pagamento</li>');
            AMSend.TextoEmail.Add('  		<li>Nome da conta: Paulo César Pereira</li>');
            AMSend.TextoEmail.Add('  		<li>Conheça PicPay https://goo.gl/QkGxdk</li>');
            AMSend.TextoEmail.Add('  		</ul>');
            AMSend.TextoEmail.Add('    </TD>');
            AMSend.TextoEmail.Add('</TR>  ');
            AMSend.TextoEmail.Add('<TR>');
            AMSend.TextoEmail.Add('<TD><b>Santander</b></TD>');
            AMSend.TextoEmail.Add('  <TD><img src="https://image.ibb.co/mj9Ouy/santander.jpg" alt="santander" border="0"></TD>');
            AMSend.TextoEmail.Add('</TR>  ');
            AMSend.TextoEmail.Add('<TR>');
            AMSend.TextoEmail.Add('	<TD colspan="2">');
            AMSend.TextoEmail.Add('    	<ul>');
            AMSend.TextoEmail.Add('          <li>Banco Santander Banespa - Código 033</li>');
            AMSend.TextoEmail.Add('          <li>Ag. 1539</li>');
            AMSend.TextoEmail.Add('          <li>C/C 770014243</li>');
            AMSend.TextoEmail.Add('          <li>Titular: PAULO CESAR PEREIRA</li>');
            AMSend.TextoEmail.Add('          <li>CPF: 924.598.629-20</li>');
            AMSend.TextoEmail.Add('  		</ul>');
            AMSend.TextoEmail.Add('    </TD>');
            AMSend.TextoEmail.Add('</TR>  ');
            AMSend.TextoEmail.Add('<TR>');
            AMSend.TextoEmail.Add('  <TD><b>Viacredi</b></TD>');
            AMSend.TextoEmail.Add('  <TD><img src="https://image.ibb.co/dfaJSJ/viacredi.jpg" alt="viacredi" border="0"></TD>');
            AMSend.TextoEmail.Add('</TR>  ');
            AMSend.TextoEmail.Add('<TR>');
            AMSend.TextoEmail.Add('	<TD colspan="2">');
            AMSend.TextoEmail.Add('    	<ul>');
            AMSend.TextoEmail.Add('          <li>Banco Cecred (Viacredi) - Código 085</li>');
            AMSend.TextoEmail.Add('          <li>Ag. 0101</li>');
            AMSend.TextoEmail.Add('          <li>C/C 933739-3</li>');
            AMSend.TextoEmail.Add('          <li>Titular: PAULO CESAR PEREIRA</li>');
            AMSend.TextoEmail.Add('          <li>CPF: 924.598.629-20</li>');
            AMSend.TextoEmail.Add('  		</ul>');
            AMSend.TextoEmail.Add('    </TD>');
            AMSend.TextoEmail.Add('</TR>  ');
            AMSend.TextoEmail.Add('<TR>');
            AMSend.TextoEmail.Add('  <TD><b>Caixinha</b></TD>');
            AMSend.TextoEmail.Add('  <TD><img src="https://image.ibb.co/jvaJSJ/cofrinho.jpg" alt="cofrinho" border="0"></TD>  ');
            AMSend.TextoEmail.Add('</TR>  ');
            AMSend.TextoEmail.Add('<TR>');
            AMSend.TextoEmail.Add('	<TD colspan="2">');
            AMSend.TextoEmail.Add('    	<ul>');
            AMSend.TextoEmail.Add('            <li>Situada no "Primeiro andar", mesmo local de venda, URNA azul</li>');
            AMSend.TextoEmail.Add('            <li>Deposite o valor na URNA, utilizando envelope plástico</li>');
            AMSend.TextoEmail.Add('            <li>Com post-it existente no local, informe se deseja troco ou crédito</li>');
            AMSend.TextoEmail.Add('            <li>No dia seguinte o troco será devolvido pessoalmente</li>');
            AMSend.TextoEmail.Add('            <li>Não será devolvido TROCO no momento do pagamento</li>');
            AMSend.TextoEmail.Add('  		</ul>');
            AMSend.TextoEmail.Add('    </TD>');
            AMSend.TextoEmail.Add('</TR> ');
            AMSend.TextoEmail.Add('<TR>');
            AMSend.TextoEmail.Add('  <TD><b>Pessoalmente</b></TD>');
            AMSend.TextoEmail.Add('  <TD><img src="https://image.ibb.co/e1bQ7J/mao.png" alt="mao" border="0">   	</TD>    ');
            AMSend.TextoEmail.Add('</TR>  ');
            AMSend.TextoEmail.Add('<TR>');
            AMSend.TextoEmail.Add('	<TD colspan="2">');
            AMSend.TextoEmail.Add('    	<ul>');
            AMSend.TextoEmail.Add('            <li>SOMENTE após as 18h (não posso receber durante o expediente)</li>');
            AMSend.TextoEmail.Add('            <li>Preferencialmente trazer o valor já trocado</li>');
            AMSend.TextoEmail.Add('  		</ul>');
            AMSend.TextoEmail.Add('    </TD>');
            AMSend.TextoEmail.Add('</TR> ');
            AMSend.TextoEmail.Add('  ');
            AMSend.TextoEmail.Add('</TABLE>');
            AMSend.TextoEmail.Add('');
            AMSend.TextoEmail.Text := StringReplace(AMSend.TextoEmail.Text, #13#10, '', [rfReplaceAll, rfIgnoreCase]);
            AMSend.TextoEmail.Add(' ');
            AMSend.TextoEmail.Add('Em caso de alguma divergência possuo os registros para sua verificação.');
            AMSend.TextoEmail.Add(' ');
            AMSend.TextoEmail.Add('Obrigado por consumir nossos produtos e utilize este canal de comunicação para efetuar sugestões ou críticas');
            AMSend.TextoEmail.Add(' ');
            AMSend.TextoEmail.Add('Att. Sérgio e Paulo');

            ADt := '[' + FormatDateTime('dd/mm/yyyy hh:nn:ss zzz', Now) + '] ';
            if not AMSend.Enviar(MsgErro) then
            begin
              Log.Add(ADt + 'Erro: ' + QRecP.FieldByName('ClienteNome').AsString + MsgErro)
            end
            else
            begin
              Log.Add(ADt + 'Enviado: ' + QRecP.FieldByName('ClienteNome').AsString);
              AtualizarEmailFaturEnviado(QRecP.FieldByName('faturid').AsInteger, Now);
            end;
          finally
            FreeAndNil(AMSend);
          end;
          TabelaFaturas.Clear;

          ACDS.Next;
        end;
        Log.SaveToFile(ExtractFilePath(Application.ExeName) + 'LogFatur_' + FormatDateTime('yyyy-mm-dd_hhnnsszzz', Now) + '.txt');
      end
      else
        Log.Add('Não há e-mails pendentes para enviar');
    except
      on E:Exception do
      begin
        ShowMessage(E.Message);
        raise;
      end;
    end;
  finally
    FreeAndNil(QRecP);
    FreeAndNil(ACDS);
    FreeAndNil(TabelaFaturas);
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
    qupdemailfat.sql.add('update faturamentos set faturdataenvioemail = :faturdataenvioemail where faturid = :faturid');
    QUpdEmailFat.Parameters.ParamByName('FaturDataEnvioEmail').Value := DataHoraEnvio;
    QUpdEmailFat.Parameters.ParamByName('FaturID').Value := FaturID;
    QUpdEmailFat.ExecSQL;
    Result := QUpdEmailFat.RowsAffected > 0;
  finally
    FreeAndNil(QUpdEmailFat);
  end;
end;

function TFatObj.AtualizarEmailRecebimentoEnviado(ReciboID: Integer;
  DataHoraEnvio: TDateTime):boolean;
var
  QUpdEmailRec: TADOQuery;
begin
  QUpdEmailRec := TADOQuery.Create(nil);
  try
    QUpdEmailRec.Connection := DM.GetConexao;
    QUpdEmailRec.sql.add('update recibos set recibodataenviocomprov = :recibodataenviocomprov where reciboid = :reciboid');
    QUpdEmailRec.Parameters.ParamByName('recibodataenviocomprov').Value := DataHoraEnvio;
    QUpdEmailRec.Parameters.ParamByName('reciboid').Value := ReciboID;
    QUpdEmailRec.ExecSQL;
    Result := QUpdEmailRec.RowsAffected > 0;
  finally
    FreeAndNil(QUpdEmailRec);
  end;
end;


function TFatObj.ReceberFatur(FaturID: Integer; ValorRecebido, ValorTroco, ValorACredito: Double): string;
var
  QFaturOrig: TADOQuery;
  ARecibo: string;
begin
  QFaturOrig := TADOQuery.Create(nil);
  try
    QFaturOrig.Connection := DM.GetConexao;
    QFaturOrig.SQL.Text := 'select * from faturamentos where faturid=' + IntToStr(FaturID);
    QFaturOrig.Open;

    if not QFaturOrig.IsEmpty then
    begin
      if (RoundTo(ValorRecebido, -2) - RoundTo((QFaturOrig.FieldByName('faturvalortotal').AsFloat + ValorTroco + ValorACredito), -2)) <> 0 then
        raise Exception.Create('ATENÇÃO: Fatura + Crédito + Troco = Valor Recebido')
      else
      begin

        if BaixaFatura(QFaturOrig.FieldByName('faturid').AsInteger,
                    QFaturOrig.FieldByName('clienteid').AsInteger,
                    QFaturOrig.FieldByName('faturvalortotal').AsFloat) then
        begin
          //Criar o recibo
          ARecibo := CriarRecibo(QFaturOrig.FieldByName('faturid').AsInteger, Now, ValorRecebido, ValorACredito, ValorTroco);
        end;

        Result := 'Recibo: ' + ARecibo;
      end;

    end
    else
      raise Exception.Create('Contagem de registros de fatura é diferente do esperado ' + IntToStr(QFaturOrig.RecordCount));

  finally
    FreeAndNil(QFaturOrig);
  end;
end;

function TFatObj.RetornaDebitosPendentes(ClienteID: integer): Double;
var
  QCred: TADOQuery;
begin
  QCred := TADOQuery.Create(nil);
  try
    QCred.Connection := DM.GetConexao;
    QCred.SQL.Add('select coalesce(sum(clicredvalor), 0) debitos, cred.clienteid from clientescreditos cred');
    QCred.SQL.Add('join clientes cli on cli.clienteid = cred.clienteid');
    QCred.SQL.Add(' where (coalesce(cred.clicredvalor,0) < coalesce(cred.clicredvalorbaixado, 0))');
    QCred.SQL.Add(' and coalesce(cred.clicredvalor,0) < 0');   //somente débitos
    QCred.SQL.Add(' and cred.clienteid = :clienteid');
    QCred.SQL.Add(' group by cred.clienteid ');
    QCred.Parameters.ParamByName('clienteid').Value := ClienteID;
    QCred.Open;
    if QCred.RecordCount > 0 then
      Result := QCred.FieldByName('debitos').AsFloat
    else
      Result := 0;
  finally
    FreeAndNil(QCred);
  end;
end;


function TFatObj.RetornaCreditosPendentes(ClienteID: integer): Double;
var
  QCred: TADOQuery;
begin
  QCred := TADOQuery.Create(nil);
  try
    QCred.Connection := DM.GetConexao;
    QCred.SQL.Add('select coalesce(sum(cred.clicredvalor), 0) as creditos, cli.clienteid');
    QCred.SQL.Add('from clientescreditos cred');
    QCred.SQL.Add('join clientes cli on cli.clienteid = cred.clienteid');
    QCred.SQL.Add(' where (coalesce(cred.clicredvalor,0) > coalesce(cred.clicredvalorbaixado, 0))');
    QCred.SQL.Add(' and coalesce(cred.clicredvalor,0) > 0');
    QCred.SQL.Add(' and cred.clienteid = :clienteid');
    QCred.SQL.Add('group by cli.clienteid');
    QCred.Parameters.ParamByName('clienteid').Value := ClienteID;
    QCred.Open;
    if QCred.RecordCount > 0 then
      Result := QCred.FieldByName('creditos').AsFloat
    else
      Result := 0;
  finally
    FreeAndNil(QCred);
  end;
end;

function TFatObj.BaixarCreditos(ClienteID: Integer;
  ValorBaixar: Double; CreditoRestante, CreditoUsado: Currency): Currency;
var
  TotalCredito: Currency;
  QBaixa: TADOQuery;
begin
  CreditoRestante := 0;
  Result := ValorBaixar;

  QBaixa := TADOQuery.Create(nil);
  try
    QBaixa.Connection := DM.GetConexao;
    QBaixa.SQL.Add('select * from clientescreditos where clicredvalor > 0 and clicreddatabaixa is null and clienteid = :clienteid');
    QBaixa.Parameters.ParamByName('clienteid').Value := ClienteID;
    QBaixa.Open;
    //Calcula o total de creditos do cliente
    TotalCredito := 0;
    while not QBaixa.Eof do
    begin
      TotalCredito := TotalCredito + QBaixa.FieldByName('clicredvalor').AsFloat;
      QBaixa.Next;
    end;

    if TotalCredito > 0 then
    begin
      //Baixar todos os créditos existentes
      QBaixa.SQL.Clear;
      QBaixa.SQL.Text := 'update clientescreditos set clicreddatabaixa = :data where clicredvalor > 0 and clicreddatabaixa is null and clienteid = :clienteid';
      QBaixa.Parameters.ParamByName('data').Value := Now;
      QBaixa.Parameters.ParamByName('clienteid').Value := ClienteID;
      QBaixa.ExecSQL;
      if QBaixa.RowsAffected > 0 then
      begin
        if TotalCredito >= ValorBaixar  then
        begin
          Result := 0;
          CreditoRestante := TotalCredito - ValorBaixar;
          CreditoUsado := ValorBaixar;
        end
        else
        begin
          Result := ValorBaixar - TotalCredito;
          CreditoRestante := 0;
          CreditoUsado := TotalCredito;
        end;

        if CreditoRestante > 0 then
        begin
          if GerarCredito(ClienteID, CreditoRestante, 'Sobra de crédito gerada de forma automática') then
            ShowMessage('Crédito restante: ' + FloatToStr(CreditoRestante))
          else
            raise Exception.Create('Erro ao gerar crédito para: ' + IntToStr(ClienteID));
        end;

      end;
    end;
  finally
    FreeAndNil(QBaixa);
  end;
end;

function TFatObj.GerarCredito(ClienteID: Integer;
  ValorCredito: Double; Observacao: string): Boolean;
var
  QCred: TADOQuery;
begin
  QCred := TADOQuery.Create(nil);
  try
    QCred.Connection := Dm.GetConexao;
    QCred.SQL.Clear;
    QCred.SQL.Add('insert into clientescreditos ');
    QCred.SQL.Add('(clienteid, clicreddataconcedido, clicredvalor, clicredobs)');
    QCred.SQL.Add(' values ');
    QCred.SQL.Add('(:clienteid, :clicreddataconcedido, :clicredvalor, :clicredobs)');
    QCred.Parameters.ParamByName('clienteid').Value := ClienteID;
    QCred.Parameters.ParamByName('clicreddataconcedido').Value := Now;
    QCred.Parameters.ParamByName('clicredvalor').Value := ValorCredito;
    QCred.Parameters.ParamByName('clicredobs').Value := Observacao;
    QCred.ExecSQL;
    Result := QCred.RowsAffected > 0;
  finally
    FreeAndNil(QCred);
  end;

end;

function TFatObj.BaixaFatura(FaturaID, ClienteID: Integer; ValorBaixado: Double): Boolean;
var
  QUpd: TADOQuery;
begin
  QUpd := TADOQuery.Create(nil);
  try
    QUpd.Connection := DM.GetConexao;
    QUpd.SQL.Add('update faturamentos ');
    QUpd.SQL.Add('set faturvalorbaixado = :faturvalorbaixado,');
    QUpd.SQL.Add('    faturvalorcancelado = :faturvalorcancelado');
    QUpd.SQL.Add('where');
    QUpd.SQL.Add('  faturid = :faturid');
    QUpd.SQL.Add('  and clienteid = :clienteid');

    QUpd.Parameters.ParamByName('clienteid').Value := ClienteID;
    QUpd.Parameters.ParamByName('faturid').Value := FaturaID;
    QUpd.Parameters.ParamByName('faturvalorbaixado').Value := ValorBaixado;
    QUpd.Parameters.ParamByName('faturvalorcancelado').Value := 0;
    QUpd.ExecSQL;
    Result := QUpd.RowsAffected > 0;
  finally
    FreeAndNil(QUpd);
  end;
end;

function TFatObj.GerarAutenticacaoMecania(FaturID: integer): string;
var
  AStrFatur: string;
  Res: array[1..10] of string;
  aux: integer;
begin
  AStrFatur := IntToStr(FaturID);
  (*
  1-ALFA aleat
  2-NUM aleat
  3-ALFA aleat
  4-9 - FaturIDReverse
  10-Alfa aleat
  *)
  Randomize;
  Res[1] := Chr(RandomRange(65, 90));
  Res[2] := IntToStr(RandomRange(0, 9));
  Res[3] := Chr(RandomRange(65, 90));

  Res[4] := '0';
  Res[5] := '0';
  Res[6] := '0';
  Res[7] := '0';
  Res[8] := '0';
  Res[9] := '0';
  aux := 4;
  repeat
    if aux < 10 then
      Res[aux] := Copy(AStrFatur, 1, 1);
    Delete(AStrFatur, 1, 1);
    Inc(aux);
  until AStrFatur = EmptyStr;

  Res[10] := Chr(RandomRange(65, 90));
  Result := Concat(Res[1], Res[2], Res[3], Res[4], Res[5], Res[6], Res[7], Res[8], Res[9], Res[10]);
end;

function TFatObj.CriarRecibo(Faturid: integer;
  recibodatageracao: TDateTime; recibovalorpago, recibovalorcredito,
  recibovalortroco: Double): string;
var
  ARec: TADOQuery;
  Autenticacao: string;
begin
  ARec := TADOQuery.Create(nil);
  ARec.Connection := DM.GetConexao;
  try
    Autenticacao := GerarAutenticacaoMecania(Faturid);
    ARec.SQL.Add('insert into recibos (faturid, recibodatageracao, recibovalorpago, recibovalorcredito, recibovalortroco, reciboautentic) ');
    ARec.SQL.Add('values(:faturid, :recibodatageracao, :recibovalorpago, :recibovalorcredito, :recibovalortroco, :reciboautentic) ');
    ARec.Parameters.ParamByName('faturid').Value := Faturid;
    ARec.Parameters.ParamByName('recibodatageracao').Value := recibodatageracao;
    ARec.Parameters.ParamByName('recibovalorpago').Value := recibovalorpago;
    ARec.Parameters.ParamByName('recibovalorcredito').Value := recibovalorcredito;
    ARec.Parameters.ParamByName('recibovalortroco').Value := recibovalortroco;
    ARec.Parameters.ParamByName('reciboautentic').Value := Autenticacao;
    ARec.ExecSQL;
    if ARec.RowsAffected <= 0 then
      raise Exception.Create('Erro ao criar recibo')
    else
      Result := Autenticacao;
  finally
    FreeAndNil(ARec);
  end;
end;

procedure TFatObj.EnviarEmailPagamentosRecebidosPendentes;
var
  QRecP: TADOQuery;
  AMSend: TMailSender;
  MsgErro,
  ADt: string;
begin
  QRecP := TADOQuery.Create(nil);
  QRecP.Connection := DM.GetConexao;
  try
    try
      QRecP.sql.add('SELECT reciboid, clienteid, clientenome, clienteemail, recibovalorpago,');
      QRecP.sql.add('       recibovalortroco, reciboautentic, recibodatageracao, faturid');
      QRecP.sql.add('  FROM maladiretaemailrecebimentos;');


      QRecP.Open;
      if not QRecP.Eof then
      begin
        while not QRecP.Eof do
        begin
          if QRecP.FieldByName('clienteemail').AsString = EmptyStr then
          begin
            QRecP.Next;
            Continue;
          end;

          AMSend := TMailSender.Create;
          try
            AMSend.DestinatarioNome := QRecP.FieldByName('clientenome').AsString;
            AMSend.DestinatarioEmail := LowerCase(trim(QRecP.FieldByName('clienteemail').AsString));
            AMSend.AssuntoEmail := 'Obrigado - recebido';
            AMSend.TextoEmail.Add('<b>Obrigado ' + AMSend.DestinatarioNome + '! </b>');
            AMSend.TextoEmail.Add(' ');
            AMSend.TextoEmail.Add('Recebemos sua conta do consumo de bolos e doces no valor de: R$ ' + FormatCurr('#0.00', QRecP.FieldByName('recibovalorpago').AsCurrency));
            if (QRecP.FieldByName('recibovalortroco').AsFloat > 0) then
              AMSend.TextoEmail.Add('O troco no valor de : R$ ' + FormatCurr('#0.00', QRecP.FieldByName('recibovalortroco').AsCurrency) + ' será entregue em mãos');
            AMSend.TextoEmail.Add(' ');
            AMSend.TextoEmail.Add('<i>Obrigado por consumir nossos produtos e utilize este canal para efetuar sugestões ou críticas</i>');
            AMSend.TextoEmail.Add(' ');
            AMSend.TextoEmail.Add('Autenticação: [' + QRecP.FieldByName('reciboautentic').AsString + ']');
            AMSend.TextoEmail.Add(' ');
            AMSend.TextoEmail.Add('Att. Sérgio e Paulo');
            ADt := '[' + FormatDateTime('dd/mm/yyyy hh:nn:ss zzz', Now) + '] ';
            if not AMSend.Enviar(MsgErro) then
            begin
              Log.Add(ADt + 'Erro: ' + QRecP.FieldByName('ClienteNome').AsString + MsgErro)
            end
            else
            begin
              Log.Add(ADt + 'Enviado: ' + QRecP.FieldByName('ClienteNome').AsString);
              AtualizarEmailRecebimentoEnviado(QRecP.FieldByName('reciboid').AsInteger, Now);
            end;
          finally
            FreeAndNil(AMSend);
          end;
          QRecP.Next;
        end;
        Log.SaveToFile(ExtractFilePath(Application.ExeName) + 'LogEnviaRecibo_' + FormatDateTime('yyyy-mm-dd_hhnnsszzz', Now) + '.txt');
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
    FreeAndNil(QRecP);
  end;
end;

procedure TFatObj.EnviarHtmlMail;
var
  AMSend: TMailSender;
  ADt,
  MsgErro: string;
begin
  AMSend := TMailSender.Create;
  try
    AMSend.DestinatarioNome := 'Sérgio Henrique Marchiori';
    AMSend.DestinatarioEmail := 'serginhoshm@gmail.com';
    AMSend.AssuntoEmail := 'Teste HTML';
    AMSend.TextoEmail.Add('<b>Olá ' + AMSend.DestinatarioNome + '!</b>');
    AMSend.TextoEmail.Add('<i>zazazaza</i>');
    AMSend.TextoEmail.Add(' ');


    ADt := '[' + FormatDateTime('dd/mm/yyyy hh:nn:ss zzz', Now) + '] ';
    if not AMSend.Enviar(MsgErro) then
    begin
      Log.Add(ADt + 'Erro: ' + MsgErro)
    end
    else
    begin
      Log.Add(ADt + 'Enviado.');
    end;
  finally
    FreeAndNil(AMSend);
  end;

end;

end.
