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
    function InserirNovaFatura(ClienteID: Integer; DataGer: TDateTime; TotalFatura: Currency): integer;
    function AtualizaItensFaturados(NovaFaturID: Integer; ClienteID: Integer; ListaItens: TStringList): boolean;
    function AtualizarEmailFaturEnviado(FaturID: Integer; DataHoraEnvio: TDateTime): boolean;
    function AtualizarEmailRecebimentoEnviado(ReciboID: Integer; DataHoraEnvio: TDateTime):boolean;
    procedure SetDataPagamento(const Value: TDateTime);
    function RetornaCreditosPendentes(ClienteID: integer): Double;
    function GerarCredito(ClienteID: Integer; ValorCredito: Double; FaturID: integer): Boolean;
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
    procedure BaixarCreditos(ClienteID: Integer);
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

function TFatObj.InserirNovaFatura(ClienteID: Integer; DataGer: TDateTime; TotalFatura: Currency): integer;
var
  VDesc,
  VCanc,
  VFat,
  VNovoCred: Double;
  QInserirFat,
  QLocFat: TADOQuery;
begin
  Result := -1;
  VNovoCred := 0;
  QInserirFat := TADOQuery.Create(nil);
  QLocFat := TADOQuery.Create(nil);
  try
    QInserirFat.Connection := DM.GetConexao;
    QLocFat.Connection := DM.GetConexao;

    qinserirfat.sql.add('insert into faturamentos (clienteid, faturdatageracao, faturvalortotal, faturvalorbaixado, faturvalorcancelado, FaturValorDesconto, FaturValorAPagar) values ');
    qinserirfat.sql.add('                        (:clienteid, :faturdatageracao, :faturvalortotal, :faturvalorbaixado, :faturvalorcancelado, :FaturValorDesconto, :FaturValorAPagar);');

    qlocfat.sql.add('select max(faturid) as faturid from faturamentos where clienteid = :clienteid and faturdatageracao = :faturdatageracao');

    VFat := TotalFatura;

    //Descontos por consumo (maior ou igual a 20 reais)
    if TotalFatura >= 20 then
      VDesc := RoundTo(TotalFatura * 0.05, -2)
    else
      VDesc := 0;
    QInserirFat.Parameters.ParamByName('FaturValorDesconto').Value := VDesc;
    VFat := VFat - VDesc;

    //Valores cancelados por cr�dito
    VCanc := RetornaCreditosPendentes(ClienteID);
    if VCanc > 0 then
    begin
      //O valor do cr�dito � maior que o consumo
      //Devemos descontar o total da fatura (zerar a mesma) e creditar o saldo residual
      if VCanc >= VFat then
      begin
        VCanc := RoundTo(VCanc - VFat, -2);
        VNovoCred := VCanc;
        VFat := 0;
      end
      else
      begin
        VFat := RoundTo(VFat - VCanc, -2);
        VNovoCred := 0;
      end;
      BaixarCreditos(ClienteID);
    end;


    QInserirFat.Close;
    QInserirFat.Parameters.ParamByName('ClienteID').Value := ClienteID;
    QInserirFat.Parameters.ParamByName('FaturDataGeracao').Value := DataGer;
    QInserirFat.Parameters.ParamByName('FaturValorTotal').Value := TotalFatura;
    QInserirFat.Parameters.ParamByName('FaturValorBaixado').Value := 0;
    QInserirFat.Parameters.ParamByName('FaturValorCancelado').Value := VCanc;
    QInserirFat.Parameters.ParamByName('FaturValorAPagar').Value := VFat;
    try
      QInserirFat.ExecSQL;
      if QInserirFat.RowsAffected > 0 then
      begin
        QLocFat.Close;
        QLocFat.Parameters.ParamByName('ClienteID').Value := ClienteID;
        QLocFat.Parameters.ParamByName('FaturDataGeracao').Value := DataGer;
        QLocFat.Open;

        Result := QLocFat.FieldByName('FaturID').AsInteger;

        //Inserir o novo cr�dito se for o caso
        if VNovoCred > 0 then
          GerarCredito(ClienteID, VNovoCred, Result);
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
    raise Exception.Create('Era esperada uma lista de itens v�lida');
  end;
end;

procedure TFatObj.EnviarEmailFaturPendentes;
var
  QRecP: TADOQuery;
  AMSend: TMailSender;
  MsgErro,
  ADt: string;
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
          TabelaFaturas.Add('   <TD>Refer�ncia</TD>');
          TabelaFaturas.Add('   <TD>Consumo(+)</TD>');
          TabelaFaturas.Add('   <TD>Desconto(-)</TD>');
          TabelaFaturas.Add('   <TD>Cr�dito(-)</TD>');
          TabelaFaturas.Add('   <TD>A pagar(=)</TD>');
          TabelaFaturas.Add('</TR>');

          ASoma := 0;
          QRecP.First;
          while not QRecP.Eof do
          begin
            TabelaFaturas.Add('<TR>');
            TabelaFaturas.Add('   <TD>' + FormatDateTime('dd/mm/yyyy', QRecP.FieldByName('faturdatageracao').AsDateTime) + '</TD>');
            TabelaFaturas.Add('   <TD>' + FormatCurr('#0.00', QRecP.FieldByName('FaturValorTotal').AsCurrency) + '</TD>');
            TabelaFaturas.Add('   <TD>' + FormatCurr('#0.00', QRecP.FieldByName('FaturValorDesconto').AsCurrency) + '</TD>');
            TabelaFaturas.Add('   <TD>' + FormatCurr('#0.00', QRecP.FieldByName('FaturValorCancelado').AsCurrency) + '</TD>');
            TabelaFaturas.Add('   <TD>' + FormatCurr('#0.00', QRecP.FieldByName('valorpendente').AsCurrency) + '</TD>');
            TabelaFaturas.Add('</TR>');
            ASoma := ASoma + QRecP.FieldByName('valorpendente').AsCurrency;
            QRecP.Next;
          end;

          TabelaFaturas.Add('<TR>');
          TabelaFaturas.Add('   <TD><b>TOTAL</b></TD>');
          TabelaFaturas.Add('   <TD></TD>');
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
            AMSend.TextoEmail.Add('Ol� ' + AMSend.DestinatarioNome + '!');
            AMSend.TextoEmail.Add('');
            AMSend.TextoEmail.Add('');
            AMSend.TextoEmail.Add('<h2><mark><font color="red">ATEN��O: MUDAMOS NOSSOS MEIOS DE PAGAMENTO</font></mark></h2>');
            AMSend.TextoEmail.Add('');
            AMSend.TextoEmail.Add('');
            AMSend.TextoEmail.Add('Segue abaixo faturamento do consumo de bolos e doces: ');
            AMSend.TextoEmail.Add('');
            AMSend.TextoEmail.Add(TabelaFaturas.Text);
            AMSend.TextoEmail.Add('<h2>M�todos de pagamento</h2>');
            AMSend.TextoEmail.Add('<TABLE border=1>');
            AMSend.TextoEmail.Add('<TR>');
            AMSend.TextoEmail.Add('  <TD><b>PicPay</b></TD>');
            AMSend.TextoEmail.Add('  <TD><img src="https://image.ibb.co/eY1snJ/picpay.jpg" alt="picpay" border="0"></TD>');
            AMSend.TextoEmail.Add('</TR>  ');
            AMSend.TextoEmail.Add('<TR>');
            AMSend.TextoEmail.Add('	<TD colspan="2">');
            AMSend.TextoEmail.Add('    	<ul>');
            AMSend.TextoEmail.Add('    	<li>Adicione @paulocesar75 e efetue seu pagamento</li>');
            AMSend.TextoEmail.Add('  		<li>Nome da conta: Paulo C�sar Pereira</li>');
            AMSend.TextoEmail.Add('  		<li>Conhe�a PicPay https://goo.gl/QkGxdk</li>');
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
            AMSend.TextoEmail.Add('          <li>Banco Santander Banespa - C�digo 033</li>');
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
            AMSend.TextoEmail.Add('          <li>Banco Cecred (Viacredi) - C�digo 085</li>');
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
            AMSend.TextoEmail.Add('            <li>Deposite o valor na URNA, utilizando envelope pl�stico</li>');
            AMSend.TextoEmail.Add('            <li>Com post-it existente no local, informe se deseja troco ou cr�dito</li>');
            AMSend.TextoEmail.Add('            <li>No dia seguinte o troco ser� devolvido pessoalmente</li>');
            AMSend.TextoEmail.Add('            <li>N�o ser� devolvido TROCO no momento do pagamento</li>');
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
            AMSend.TextoEmail.Add('            <li>SOMENTE ap�s as 18h (n�o posso receber durante o expediente)</li>');
            AMSend.TextoEmail.Add('            <li>Preferencialmente trazer o valor j� trocado</li>');
            AMSend.TextoEmail.Add('  		</ul>');
            AMSend.TextoEmail.Add('    </TD>');
            AMSend.TextoEmail.Add('</TR> ');
            AMSend.TextoEmail.Add('  ');
            AMSend.TextoEmail.Add('</TABLE>');
            AMSend.TextoEmail.Add('');
            AMSend.TextoEmail.Text := StringReplace(AMSend.TextoEmail.Text, #13#10, '', [rfReplaceAll, rfIgnoreCase]);
            AMSend.TextoEmail.Add(' ');
            AMSend.TextoEmail.Add('Em caso de alguma diverg�ncia possuo os registros para sua verifica��o.');
            AMSend.TextoEmail.Add(' ');
            AMSend.TextoEmail.Add('Obrigado por consumir nossos produtos e utilize este canal de comunica��o para efetuar sugest�es ou cr�ticas');
            AMSend.TextoEmail.Add(' ');
            AMSend.TextoEmail.Add('Att. S�rgio e Paulo');

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
        Log.Add('N�o h� e-mails pendentes para enviar');
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
      if (RoundTo(ValorRecebido, -2) - RoundTo((QFaturOrig.FieldByName('FaturValorAPagar').AsFloat + ValorTroco + ValorACredito), -2)) <> 0 then
        raise Exception.Create('ATEN��O: Fatura + Cr�dito + Troco = Valor Recebido')
      else
      begin

        if BaixaFatura(QFaturOrig.FieldByName('faturid').AsInteger,
                    QFaturOrig.FieldByName('clienteid').AsInteger,
                    QFaturOrig.FieldByName('FaturValorAPagar').AsFloat) then
        begin
          //Criar o recibo
          ARecibo := CriarRecibo(QFaturOrig.FieldByName('faturid').AsInteger, Now, ValorRecebido, ValorACredito, ValorTroco);

          if RoundTo(ValorACredito,-2) > 0 then
          begin
            GerarCredito(QFaturOrig.FieldByName('clienteid').AsInteger, ValorACredito, QFaturOrig.FieldByName('faturid').AsInteger);
          end;
        end;

        Result := 'Recibo: ' + ARecibo;
      end;

    end
    else
      raise Exception.Create('Contagem de registros de fatura � diferente do esperado ' + IntToStr(QFaturOrig.RecordCount));

  finally
    FreeAndNil(QFaturOrig);
  end;
end;

function TFatObj.RetornaCreditosPendentes(ClienteID: integer): Double;
var
  QCred: TADOQuery;
begin
  QCred := TADOQuery.Create(nil);
  try
    QCred.Connection := DM.GetConexao;
    QCred.SQL.Add('select COALESCE(Saldo,0) creditos from ClientesCreditosPendentes where clienteid = :clienteid');
    QCred.Parameters.ParamByName('clienteid').Value := ClienteID;
    QCred.Open;
    if not QCred.IsEmpty then
      Result := QCred.FieldByName('creditos').AsFloat
    else
      Result := 0;
  finally
    FreeAndNil(QCred);
  end;
end;

procedure TFatObj.BaixarCreditos(ClienteID: Integer);
var
  QBaixa: TADOQuery;
begin
  QBaixa := TADOQuery.Create(nil);
  QBaixa.Connection := DM.GetConexao;
  try
    //Baixar todos os cr�ditos existentes
    QBaixa.SQL.Add('update ClientesCreditos');
    QBaixa.SQL.Add('set CredDataBaixa = GetDate(),');
    QBaixa.SQL.Add('CredValorBaixado = CredValorInclusao');
    QBaixa.SQL.Add('where (clienteid = ' + IntToStr(ClienteID) + ')');
    QBaixa.SQL.Add('and (CredValorBaixado <> CredValorInclusao)');
    QBaixa.ExecSQL;
  finally
    FreeAndNil(QBaixa);
  end;
end;

function TFatObj.GerarCredito(ClienteID: Integer;
  ValorCredito: Double; FaturID: integer): Boolean;
var
  QCred: TADOQuery;
begin
  QCred := TADOQuery.Create(nil);
  try
    QCred.Connection := Dm.GetConexao;
    QCred.SQL.Clear;
    QCred.SQL.Add('insert into ClientesCreditos ');
    QCred.SQL.Add('(clienteid, CredFaturOrigem, CredDataInclusao, CredValorInclusao)');
    QCred.SQL.Add(' values ');
    QCred.SQL.Add('(:clienteid, :CredFaturOrigem, GetDate(), :CredValorInclusao)');
    QCred.Parameters.ParamByName('clienteid').Value := ClienteID;
    QCred.Parameters.ParamByName('CredFaturOrigem').Value := FaturID;
    QCred.Parameters.ParamByName('CredValorInclusao').Value := ValorCredito;
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
      QRecP.sql.add('SELECT *');
      QRecP.sql.add('  FROM maladiretaemailrecebimentos');

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
            AMSend.TextoEmail.Add('Recebemos sua conta do consumo de bolos e doces no valor de: R$ ' + FormatCurr('#0.00', QRecP.FieldByName('FaturValorAPagar').AsCurrency));

            AMSend.TextoEmail.Add('<ul>');
            AMSend.TextoEmail.Add('Valor recebido: R$ ' + FormatCurr('#0.00', QRecP.FieldByName('recibovalorpago').AsCurrency));
              AMSend.TextoEmail.Add('<li>O troco no valor de: R$ ' + FormatCurr('#0.00', QRecP.FieldByName('recibovalortroco').AsCurrency) + ' ser� entregue em m�os</li>');
            if (QRecP.FieldByName('recibovalortroco').AsFloat > 0) then
            if (QRecP.FieldByName('recibovalorcredito').AsFloat > 0) then
              AMSend.TextoEmail.Add('<li>Cr�dito para pr�ximo ciclo: R$ ' + FormatCurr('#0.00', QRecP.FieldByName('recibovalorcredito').AsCurrency) + '</li>');
            AMSend.TextoEmail.Add('</ul>');
            AMSend.TextoEmail.Add(' ');
            AMSend.TextoEmail.Add('<i>Obrigado por consumir nossos produtos e utilize este canal para efetuar sugest�es ou cr�ticas</i>');
            AMSend.TextoEmail.Add(' ');
            AMSend.TextoEmail.Add('Autentica��o: [' + QRecP.FieldByName('reciboautentic').AsString + ']');
            AMSend.TextoEmail.Add(' ');
            AMSend.TextoEmail.Add('Att. S�rgio e Paulo');
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
      Log.Add('N�o h� e-mails pendentes para enviar');
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
    AMSend.DestinatarioNome := 'S�rgio Henrique Marchiori';
    AMSend.DestinatarioEmail := 'serginhoshm@gmail.com';
    AMSend.AssuntoEmail := 'Teste HTML';
    AMSend.TextoEmail.Add('<b>Ol� ' + AMSend.DestinatarioNome + '!</b>');
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
