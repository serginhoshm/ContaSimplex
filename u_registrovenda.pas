unit u_registrovenda;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ADODB, DBClient;

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
  QIns: TADOQuery;
  ACDS: TClientDataSet;
  AFileName: string;
begin
  Result := false;
  QIns := TADOQuery.Create(nil);
  ACDS := TClientDataSet.Create(nil);
  try
    try
      ACDS.XMLData := AXMLData;

      if ACDS.RecordCount > 0then
      begin
        QIns.Connection := DM.GetConexao;
        QIns.SQL.Add('INSERT INTO ItensVendidos');
        QIns.SQL.Add('(ProdutoID, ClienteID, ItemQuantidade, ItemValorUnitario, ItemValorTotal, DataReferencia)');
        QIns.SQL.Add(' VALUES ');
        QIns.SQL.Add('(:ProdutoID, :ClienteID, :ItemQuantidade, :ItemValorUnitario, :ItemValorTotal, :DataReferencia)');

        QIns.Parameters.ParamByName('ProdutoID').DataType := ftInteger;
        QIns.Parameters.ParamByName('ClienteID').DataType := ftInteger;
        QIns.Parameters.ParamByName('ItemQuantidade').DataType := ftFloat;
        QIns.Parameters.ParamByName('ItemValorUnitario').DataType := ftFloat;
        QIns.Parameters.ParamByName('ItemValorTotal').DataType := ftFloat;
        QIns.Parameters.ParamByName('DataReferencia').DataType := ftDate;

        DM.GetConexao.BeginTrans;
        ACDS.First;
        while not ACDS.Eof do
        begin
          QIns.Close;
          QIns.Parameters.ParamByName('ProdutoID').Value := ACDS.FieldByName('ProdutoID').AsInteger;
          QIns.Parameters.ParamByName('ClienteID').Value := ACDS.FieldByName('ClienteID').AsInteger;
          QIns.Parameters.ParamByName('ItemQuantidade').Value := ACDS.FieldByName('RegVenQtde').AsFloat;
          QIns.Parameters.ParamByName('ItemValorUnitario').Value := ACDS.FieldByName('RegVenVlrUnit').AsFloat;
          QIns.Parameters.ParamByName('ItemValorTotal').Value := ACDS.FieldByName('RegVenVlrTot').AsFloat;
          QIns.Parameters.ParamByName('DataReferencia').Value := DateOf(ACDS.FieldByName('RegVenDataRef').AsDateTime);
          QIns.ExecSQL;

          ACDS.Next;
        end;

        AFileName := ExtractFilePath(Application.ExeName) + 'Log\DigitacaoItensVendidos_'+
                     FormatDateTime('yyyy-mm-dd', DateOf(ACDS.FieldByName('RegVenDataRef').AsDateTime))+'.xml';
        ForceDirectories(ExtractFilePath(AFileName));
        ACDS.SaveToFile(AFileName, dfXMLUTF8);

        DM.GetConexao.CommitTrans;
        Result := true;
      end;
    except
      on E:Exception do
      begin
        MensagemErro('Erro ao registrar a venda: ' + E.Message);
        if DM.GetConexao.InTransaction then
          DM.GetConexao.RollbackTrans;
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
  QTemp: TADOQuery;
begin
  QTemp := TADOQuery.Create(nil);
  try
    QTemp.Connection := DM.GetConexao;
    QTemp.SQL.Add('select count(*) from ItensVendidos where DataReferencia = :DataReferencia');
    QTemp.Parameters.ParamByName('DataReferencia').DataType := ftDate;
    QTemp.Parameters.ParamByName('DataReferencia').Value := DateOf(DataReg);
    QTemp.Open;
    Result := QTemp.Fields[0].AsInteger > 0;
  finally
    FreeAndNil(QTemp);
  end;

end;

end.
