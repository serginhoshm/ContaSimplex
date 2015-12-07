unit u_registrovenda;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ADODB, DBClient, Uni, UniProvider, PostgreSQLUniProvider;

type
  TRegistraVenda = class
  private
  public
    constructor Create;
    destructor Destroy; override;
    function RegistroVendaExiste(DataReg: TDate): Boolean;
    function RegistrarVenda(AXMLData: string): Boolean;
  end;




implementation

uses u_dm, DateUtils, u_mailsender, DB, u_bibliotecas;

{ TRegistraVenda }

constructor TRegistraVenda.Create;
begin
  inherited;
end;

destructor TRegistraVenda.Destroy;
begin
  inherited;
end;


function TRegistraVenda.RegistrarVenda(AXMLData: string): Boolean;
var
  QIns: TUniQuery;
  ACDS: TClientDataSet;
  AFileName: string;
begin
  Result := false;
  QIns := TUniQuery.Create(nil);
  ACDS := TClientDataSet.Create(nil);
  try
    try
      ACDS.XMLData := AXMLData;

      if ACDS.RecordCount > 0then
      begin
        QIns.Connection := DM.GetConexao;
        qins.sql.add('insert into itensvendidos');
        qins.sql.add('(produtoid, clienteid, itemquantidade, itemvalorunitario, itemvalortotal, datareferencia)');
        qins.sql.add(' values ');
        qins.sql.add('(:produtoid, :clienteid, :itemquantidade, :itemvalorunitario, :itemvalortotal, :datareferencia)');

        QIns.ParamByName('ProdutoID').DataType := ftInteger;
        QIns.ParamByName('ClienteID').DataType := ftInteger;
        QIns.ParamByName('ItemQuantidade').DataType := ftFloat;
        QIns.ParamByName('ItemValorUnitario').DataType := ftFloat;
        QIns.ParamByName('ItemValorTotal').DataType := ftFloat;
        QIns.ParamByName('DataReferencia').DataType := ftDate;

        DM.GetConexao.StartTransaction;
        ACDS.First;
        while not ACDS.Eof do
        begin
          QIns.Close;
          QIns.ParamByName('ProdutoID').Value := ACDS.FieldByName('ProdutoID').AsInteger;
          QIns.ParamByName('ClienteID').Value := ACDS.FieldByName('ClienteID').AsInteger;
          QIns.ParamByName('ItemQuantidade').Value := ACDS.FieldByName('RegVenQtde').AsFloat;
          QIns.ParamByName('ItemValorUnitario').Value := ACDS.FieldByName('RegVenVlrUnit').AsFloat;
          QIns.ParamByName('ItemValorTotal').Value := ACDS.FieldByName('RegVenVlrTot').AsFloat;
          QIns.ParamByName('DataReferencia').Value := DateOf(ACDS.FieldByName('RegVenDataRef').AsDateTime);
          QIns.ExecSQL;

          ACDS.Next;
        end;

        AFileName := ExtractFilePath(Application.ExeName) + 'Log\DigitacaoItensVendidos_'+
                     FormatDateTime('yyyy-mm-dd', DateOf(ACDS.FieldByName('RegVenDataRef').AsDateTime))+'.xml';
        ForceDirectories(ExtractFilePath(AFileName));
        ACDS.SaveToFile(AFileName, dfXMLUTF8);

        DM.GetConexao.Commit;
        Result := true;
      end;
    except
      on E:Exception do
      begin
        MensagemErro('Erro ao registrar a venda: ' + E.Message);
        if DM.GetConexao.InTransaction then
          DM.GetConexao.Rollback;
        Result := false;
      end;
    end;
  finally
    FreeAndNil(QIns);
    FreeAndNil(ACDS);
  end;
end;

function TRegistraVenda.RegistroVendaExiste(DataReg: TDate): Boolean;
var
  QTemp: TUniQuery;
begin
  QTemp := TUniQuery.Create(nil);
  try
    QTemp.Connection := DM.GetConexao;
    QTemp.SQL.Add('select count(*) from itensvendidos where datareferencia = :datareferencia');
    QTemp.ParamByName('datareferencia').DataType := ftDate;
    QTemp.ParamByName('datareferencia').Value := DateOf(DataReg);
    QTemp.Open;
    Result := QTemp.Fields[0].AsInteger > 0;
  finally
    FreeAndNil(QTemp);
  end;

end;

end.
