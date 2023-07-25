object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Cliente Base64 para Bitmap / Bitmap para Base64'
  ClientHeight = 644
  ClientWidth = 629
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object pnlHeader: TPanel
    Left = 0
    Top = 0
    Width = 629
    Height = 41
    Align = alTop
    Caption = 'pnlHeader'
    Color = clHighlight
    ParentBackground = False
    ShowCaption = False
    TabOrder = 0
    object lblHeader: TLabel
      AlignWithMargins = True
      Left = 1
      Top = 11
      Width = 627
      Height = 29
      Margins.Left = 0
      Margins.Top = 10
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alClient
      Alignment = taCenter
      Caption = 'Cliente Base64 para Bitmap / Bitmap para Base64'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitWidth = 410
      ExplicitHeight = 19
    end
  end
  object gbServer: TGroupBox
    Left = 0
    Top = 41
    Width = 629
    Height = 50
    Align = alTop
    Caption = ' Servidor '
    TabOrder = 1
    object lblServerHost: TLabel
      Left = 11
      Top = 24
      Width = 26
      Height = 13
      Caption = 'Host:'
    end
    object lblServerPort: TLabel
      Left = 211
      Top = 24
      Width = 24
      Height = 13
      Caption = 'Port:'
    end
    object edtServerHost: TEdit
      Left = 45
      Top = 21
      Width = 150
      Height = 21
      TabOrder = 0
      Text = 'http://localhost'
      OnChange = edtServerHostChange
    end
    object edtServerPort: TEdit
      Left = 240
      Top = 21
      Width = 50
      Height = 21
      TabOrder = 1
      Text = '9000'
      OnChange = edtServerPortChange
    end
  end
  object gbRequestBitmap: TGroupBox
    Left = 0
    Top = 91
    Width = 629
    Height = 150
    Align = alTop
    Caption = ' Request Bitmap'
    TabOrder = 2
    object imgRequestBitmap: TImage
      AlignWithMargins = True
      Left = 12
      Top = 18
      Width = 150
      Height = 127
      Margins.Left = 10
      Align = alLeft
      Stretch = True
      ExplicitLeft = 10
      ExplicitTop = 17
    end
    object lblRequestBitmapURL: TLabel
      Left = 175
      Top = 18
      Width = 209
      Height = 14
      Caption = 'http://localhost:9000/base64/ID'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object edtRequestBitmapID: TEdit
      Left = 400
      Top = 16
      Width = 70
      Height = 21
      TabOrder = 0
      TextHint = 'ID Bitmap'
    end
    object btnGetBitmap: TButton
      Left = 510
      Top = 14
      Width = 100
      Height = 25
      Caption = 'GetBitmap'
      TabOrder = 1
      OnClick = btnGetBitmapClick
    end
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 241
    Width = 629
    Height = 403
    Align = alClient
    Caption = ' Cadastro Bitmap '
    TabOrder = 3
    object pnlMenuBitmap: TPanel
      Left = 2
      Top = 15
      Width = 625
      Height = 45
      Align = alTop
      BevelOuter = bvNone
      Caption = 'pnlMenuBitmap'
      ShowCaption = False
      TabOrder = 0
      object Bevel1: TBevel
        Left = 0
        Top = 40
        Width = 625
        Height = 5
        Align = alBottom
        Shape = bsBottomLine
        ExplicitTop = 27
      end
      object btnLoadBitmap: TButton
        Left = 10
        Top = 9
        Width = 150
        Height = 25
        Caption = 'Enviar Bitmap'
        TabOrder = 0
        OnClick = btnLoadBitmapClick
      end
    end
    object dbgBitmap: TDBCtrlGrid
      Left = 2
      Top = 60
      Width = 625
      Height = 341
      Align = alClient
      AllowDelete = False
      DataSource = dsBitmap
      PanelBorder = gbNone
      PanelHeight = 113
      PanelWidth = 608
      TabOrder = 1
      object dbedtIDBitmap: TDBText
        Left = 10
        Top = 10
        Width = 80
        Height = 17
        DataField = 'ID'
        DataSource = dsBitmap
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Bevel2: TBevel
        Left = 0
        Top = 108
        Width = 608
        Height = 5
        Align = alBottom
        Shape = bsBottomLine
        ExplicitTop = 320
      end
      object dbimgBitmap: TDBImage
        Left = 10
        Top = 30
        Width = 150
        Height = 150
        DataField = 'BITMAP'
        DataSource = dsBitmap
        ReadOnly = True
        Stretch = True
        TabOrder = 0
      end
      object dbmmoBase64: TDBMemo
        Left = 320
        Top = 30
        Width = 281
        Height = 150
        Anchors = [akTop, akRight]
        DataField = 'BASE64'
        DataSource = dsBitmap
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 1
      end
      object btnGetBase64: TPanel
        Left = 180
        Top = 30
        Width = 120
        Height = 41
        Caption = 'GetBase64'
        TabOrder = 2
        OnClick = btnGetBase64Click
      end
    end
  end
  object httpClient: TNetHTTPClient
    Asynchronous = False
    ConnectionTimeout = 60000
    ResponseTimeout = 60000
    HandleRedirects = True
    AllowCookies = True
    UserAgent = 'Embarcadero URI Client/1.0'
    Left = 524
    Top = 8
  end
  object httpRequest: TNetHTTPRequest
    Asynchronous = False
    ConnectionTimeout = 60000
    ResponseTimeout = 60000
    Client = httpClient
    Left = 584
    Top = 8
  end
  object mtBitmap: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 456
    Top = 8
    object mtBitmapID: TIntegerField
      FieldName = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      OnGetText = mtBitmapIDGetText
    end
    object mtBitmapBITMAP: TGraphicField
      FieldName = 'BITMAP'
      BlobType = ftGraphic
    end
    object mtBitmapBASE64: TBlobField
      FieldName = 'BASE64'
    end
  end
  object dsBitmap: TDataSource
    DataSet = mtBitmap
    Left = 408
    Top = 8
  end
  object opdBitmap: TOpenPictureDialog
    Title = 'Selecionar arquivo de imagem'
    Left = 336
    Top = 8
  end
end
