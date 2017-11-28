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
    function GetXMLRegistroVenda(DataRef: TDate): string;
  end;




implementation

uses u_dm, DateUtils, u_mailsender, DB, u_bibliotecas, u_dmregvenda;

{ TRegistraVenda }

constructor TRegistraVenda.Create;
begin
  inherited;
end;

destructor TRegistraVenda.Destroy;
begin
  inherited;
end;


function TRegistraVenda.GetXMLRegistroVenda(DataRef: TDate): string;
var
  QItens: TADOQuery;
  AFileName: string;
  DMReg: TDMRegVenda;
begin
  Result := EmptyStr;
  QItens := TADOQuery.Create(nil);
  DMReg := TDMRegVenda.Create(nil);
  try
    try
      DMReg.CDSItens.Close;
      DMReg.CDSItens.CreateDataSet;

      QItens.Connection := DM.GetConexao;
      QItens.sql.add('select ');
      QItens.sql.add('itemid, produtoid, clienteid, itemquantidade, itemvalorunitario, itemvalortotal, datareferencia, faturamentoid');
      QItens.sql.add('from itensvendidos');
      QItens.sql.add('where datareferencia = :datareferencia');
      QItens.Parameters.ParamByName('DataReferencia').DataType := ftDate;
      QItens.Parameters.ParamByName('DataReferencia').Value := DataRef;
      QItens.Open;

      QItens.First;
      while not QItens.Eof do
      begin
        if QItens.FieldByName('faturamentoid').AsInteger > 0 then
          raise Exception.Create('Não é possível editar, pois este dia possui um ou mais itens já faturados');

        QItens.Next;
      end;

      QItens.First;
      while not QItens.Eof do
      begin
        DMReg.CDSItens.Append;
        DMReg.CDSItensProdutoID.AsInteger := QItens.FieldByName('ProdutoID').AsInteger;
        DMReg.CDSItensClienteID.AsInteger := QItens.FieldByName('ClienteID').AsInteger;
        DMReg.CDSItensRegVenQtde.Value := QItens.FieldByName('itemquantidade').AsFloat;
        DMReg.CDSItensRegVenVlrUnit.Value := QItens.FieldByName('itemvalorunitario').AsFloat;
        DMReg.CDSItensRegVenVlrTot.Value := QItens.FieldByName('itemvalortotal').AsFloat;
        DMReg.CDSItensRegVenDataRef.Value := DateOf(QItens.FieldByName('datareferencia').AsDateTime);
        DMReg.CDSItensItemNro.AsInteger := QItens.RecNo;
        DMReg.CDSItens.Post;
        QItens.Next;
      end;
      Result := DMReg.CDSItens.XMLData;
    except
      on E:Exception do
      begin
  //      if DM.GetConexao.InTransaction then
//          DM.GetConexao.;
        Result := EmptyStr;
        raise;
      end;
    end;
  finally
    FreeAndNil(QItens);
    FreeAndNil(DMReg);
  end;


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
        qins.sql.add('insert into itensvendidos');
        qins.sql.add('(produtoid, clienteid, itemquantidade, itemvalorunitario, itemvalortotal, datareferencia)');
        qins.sql.add(' values ');
        qins.sql.add('(:produtoid, :clienteid, :itemquantidade, :itemvalorunitario, :itemvalortotal, :datareferencia)');

        QIns.Parameters.ParamByName('ProdutoID').DataType := ftInteger;
        QIns.Parameters.ParamByName('ClienteID').DataType := ftInteger;
        QIns.Parameters.ParamByName('ItemQuantidade').DataType := ftFloat;
        QIns.Parameters.ParamByName('ItemValorUnitario').DataType := ftFloat;
        QIns.Parameters.ParamByName('ItemValorTotal').DataType := ftFloat;
        QIns.Parameters.ParamByName('DataReferencia').DataType := ftDate;

        //DM.GetConexao.StartTransaction;
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

        //DM.GetConexao.Commit;
        Result := true;
      end;
    except
      on E:Exception do
      begin
        MensagemErro('Erro ao registrar a venda: ' + E.Message);
        //if DM.GetConexao.InTransaction then
          //DM.GetConexao.Rollback;
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
    QTemp.SQL.Add('select count(*) from itensvendidos where datareferencia = :datareferencia');
    QTemp.Parameters.ParamByName('datareferencia').DataType := ftDate;
    QTemp.Parameters.ParamByName('datareferencia').Value := DateOf(DataReg);
    QTemp.Open;
    Result := QTemp.Fields[0].AsInteger > 0;
  finally
    FreeAndNil(QTemp);
  end;

end;

end.
