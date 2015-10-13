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
  object IdHTTP1: TIdHTTP
    MaxLineAction = maException
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = 0
    Request.ContentRangeStart = 0
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    HTTPOptions = [hoForceEncodeParams]
    Left = 448
    Top = 224
  end
  object IdSSLIOHandlerSocket1: TIdSSLIOHandlerSocket
    SSLOptions.Method = sslvSSLv2
    SSLOptions.Mode = sslmUnassigned
    SSLOptions.VerifyMode = []
    SSLOptions.VerifyDepth = 0
    Left = 456
    Top = 232
  end
end
