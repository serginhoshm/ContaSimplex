unit u_BibliotecaSQL;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, RzEdit, Buttons, ExtCtrls, DB, MemDS, DBAccess, Uni,
  RzButton;

type
  TBibliotecaSQL = class(TForm)
    class function faturamentospendentes: string;


  end;


implementation




{ TBibliotecaSQL }

class function TBibliotecaSQL.faturamentospendentes: string;
var
  linhas: TStringList;
begin
  linhas := TStringList.Create;
  try
    linhas.Add('  SELECT faturamentos.faturid,');
    linhas.Add('    clientes.clientenome,     ');
    linhas.Add('    clientes.clienteemail,      ');
    linhas.Add('    faturamentos.faturdatageracao,');
    linhas.Add('    faturamentos.faturvalortotal, ');
    linhas.Add('    faturamentos.faturvalorbaixado,');
    linhas.Add('    faturamentos.faturdataenvioemail2,');
    linhas.Add('    (faturamentos.faturvalortotal - (faturamentos.faturvalorbaixado + faturamentos.faturvalorcancelado)) AS valorpendente,');
    linhas.Add('    faturamentos.faturvalorcancelado,');
    linhas.Add('    clientes.clienteid');
    linhas.Add('   FROM (clientes');
    linhas.Add('     JOIN faturamentos ON ((clientes.clienteid = faturamentos.clienteid)))');
    linhas.Add('  WHERE ((faturamentos.faturvalortotal - (faturamentos.faturvalorbaixado + faturamentos.faturvalorcancelado)) > (0))');
    linhas.Add('  ORDER BY clientes.clientenome');
    Result := linhas.Text;
  finally
    FreeAndNil(linhas);
  end;
end;

end.
