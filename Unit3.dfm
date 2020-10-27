object Form3: TForm3
  Left = 0
  Top = 0
  Caption = 'Form3'
  ClientHeight = 554
  ClientWidth = 1067
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    1067
    554)
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 971
    Top = 16
    Width = 75
    Height = 25
    Anchors = [akRight]
    Caption = 'get_str'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 8
    Top = 18
    Width = 57
    Height = 33
    Lines.Strings = (
      'Memo1')
    TabOrder = 1
  end
  object StringGrid1: TStringGrid
    Left = 71
    Top = 21
    Width = 882
    Height = 521
    Anchors = [akLeft, akTop, akRight, akBottom]
    ColCount = 7
    DefaultColWidth = 115
    FixedCols = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
    TabOrder = 2
  end
  object Button2: TButton
    Left = 971
    Top = 96
    Width = 75
    Height = 25
    Caption = 'saveINI'
    TabOrder = 3
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 971
    Top = 152
    Width = 75
    Height = 25
    Caption = 'LoadIni'
    TabOrder = 4
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 971
    Top = 208
    Width = 75
    Height = 25
    Caption = 'Button4'
    TabOrder = 5
  end
  object IdHTTP1: TIdHTTP
    IOHandler = IdSSLIOHandlerSocketOpenSSL1
    AllowCookies = True
    HandleRedirects = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = -1
    Request.ContentRangeStart = -1
    Request.ContentRangeInstanceLength = -1
    Request.Accept = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    Request.Ranges.Units = 'bytes'
    Request.Ranges = <>
    HTTPOptions = [hoForceEncodeParams]
    Left = 936
    Top = 56
  end
  object IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL
    MaxLineAction = maException
    Port = 0
    DefaultPort = 0
    SSLOptions.Method = sslvSSLv23
    SSLOptions.SSLVersions = [sslvSSLv2, sslvSSLv3, sslvTLSv1, sslvTLSv1_1, sslvTLSv1_2]
    SSLOptions.Mode = sslmUnassigned
    SSLOptions.VerifyMode = []
    SSLOptions.VerifyDepth = 0
    Left = 936
    Top = 120
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=db1'
      'User_Name=user1'
      'Password=user1'
      'Server=127.0.0.1'
      'DriverID=MySQL')
    LoginPrompt = False
    Left = 984
    Top = 336
  end
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    Left = 984
    Top = 384
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    Left = 992
    Top = 272
  end
  object IdReqThread: TIdThreadComponent
    Active = False
    Loop = False
    Priority = tpNormal
    StopMode = smTerminate
    OnRun = IdReqThreadRun
    Left = 984
    Top = 440
  end
  object FirstLoadTimer1: TTimer
    OnTimer = FirstLoadTimer1Timer
    Left = 984
    Top = 496
  end
end
