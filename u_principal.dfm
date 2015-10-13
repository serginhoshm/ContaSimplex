object FormPrincipal: TFormPrincipal
  Left = 251
  Top = 129
  Width = 928
  Height = 480
  Caption = 'ContaSimplex'
  Color = clAppWorkSpace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  WindowState = wsMaximized
  PixelsPerInch = 96
  TextHeight = 13
  object MainMenu1: TMainMenu
    Left = 64
    Top = 24
    object Cadastros1: TMenuItem
      Caption = 'Cadastros'
    end
    object Faturamento1: TMenuItem
      Caption = 'Faturamento'
    end
    object Marketing1: TMenuItem
      Caption = 'Marketing'
      object Pesquisas1: TMenuItem
        Caption = 'Pesquisas'
        object Lerresultadosenquete1: TMenuItem
          Caption = 'Importar resultados enquete'
          OnClick = Lerresultadosenquete1Click
        end
      end
    end
  end
end
