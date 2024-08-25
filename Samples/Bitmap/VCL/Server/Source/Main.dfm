object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Server :: Base64 to Bitmap / Bitmap to Base64'
  ClientHeight = 461
  ClientWidth = 629
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
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
      Caption = 'Server :: Base64 to Bitmap / Bitmap to Base64'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitWidth = 382
      ExplicitHeight = 19
    end
  end
  object pnlServerTools: TPanel
    Left = 0
    Top = 41
    Width = 629
    Height = 40
    Align = alTop
    BevelOuter = bvNone
    Caption = 'pnlServerTools'
    ShowCaption = False
    TabOrder = 1
    DesignSize = (
      629
      40)
    object lblServerPort: TLabel
      Left = 10
      Top = 12
      Width = 24
      Height = 13
      Caption = 'Port:'
    end
    object edtServerPort: TEdit
      Left = 50
      Top = 9
      Width = 50
      Height = 21
      TabOrder = 0
      Text = '9000'
    end
    object btnServerStart: TButton
      Left = 461
      Top = 9
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Start'
      TabOrder = 1
      OnClick = btnServerStartClick
    end
    object btnServerStop: TButton
      Left = 542
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Stop'
      TabOrder = 2
      OnClick = btnServerStopClick
    end
    object lblTestePingPong: TLinkLabel
      Left = 350
      Top = 16
      Width = 89
      Height = 19
      Cursor = crHandPoint
      Caption = 'lblTestPingPong'
      TabOrder = 3
      UseVisualStyle = True
      Visible = False
      OnLinkClick = lblTestePingPongLinkClick
    end
  end
  object gbRequest: TGroupBox
    Left = 0
    Top = 81
    Width = 629
    Height = 380
    Align = alClient
    Caption = ' Request '
    TabOrder = 2
    object dbgRequest: TDBGrid
      Left = 2
      Top = 15
      Width = 625
      Height = 170
      Align = alClient
      DataSource = dsRequest
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnDblClick = dbgRequestDblClick
      Columns = <
        item
          Expanded = False
          FieldName = 'ID'
          Width = 70
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'TYPE_BITMAP'
          Width = 100
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CONTENT_TYPE'
          Width = 100
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'MESSAGE'
          Width = 320
          Visible = True
        end>
    end
    object pnlBottom: TPanel
      Left = 2
      Top = 185
      Width = 625
      Height = 193
      Align = alBottom
      BevelOuter = bvNone
      Caption = 'pnlBottom'
      ShowCaption = False
      TabOrder = 1
      object imgBitmap: TImage
        Left = 20
        Top = 24
        Width = 165
        Height = 160
        Stretch = True
        Transparent = True
      end
      object mmoBase64: TMemo
        Left = 210
        Top = 24
        Width = 405
        Height = 145
        Lines.Strings = (
          '')
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
      end
      object lblSiteBase64Guru: TLinkLabel
        Left = 520
        Top = 171
        Width = 95
        Height = 17
        Cursor = crHandPoint
        AutoSize = False
        Caption = 'www.base64.guru'
        TabOrder = 1
        UseVisualStyle = True
        OnLinkClick = lblSiteBase64GuruLinkClick
      end
      object lblViewBase64Browser: TLinkLabel
        Left = 210
        Top = 4
        Width = 120
        Height = 19
        Cursor = crHandPoint
        Caption = 'lblViewBase64Browser'
        TabOrder = 2
        UseVisualStyle = True
        Visible = False
        OnLinkClick = lblViewBase64BrowserLinkClick
      end
      object lblViewBitmapBrowser: TLinkLabel
        Left = 20
        Top = 4
        Width = 122
        Height = 19
        Cursor = crHandPoint
        Caption = 'lblViewBitmapBrowser'
        TabOrder = 3
        UseVisualStyle = True
        Visible = False
        OnLinkClick = lblViewBase64BrowserLinkClick
      end
    end
  end
  object mtRequest: TFDMemTable
    OnCalcFields = mtRequestCalcFields
    IndexFieldNames = 'ID'
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired]
    UpdateOptions.CheckRequired = False
    Left = 128
    Top = 41
    object mtRequestID: TIntegerField
      FieldName = 'ID'
    end
    object mtRequestTYPE_BITMAP: TStringField
      DisplayLabel = 'TYPE BITMAP'
      FieldName = 'TYPE_BITMAP'
      Size = 50
    end
    object mtRequestCONTENT_TYPE: TStringField
      DisplayLabel = 'CONTENT TYPE'
      FieldName = 'CONTENT_TYPE'
      Size = 100
    end
    object mtRequestBASE64: TBlobField
      FieldName = 'BASE64'
    end
    object mtRequestMESSAGE: TStringField
      FieldKind = fkInternalCalc
      FieldName = 'MESSAGE'
      Size = 100
    end
  end
  object dsRequest: TDataSource
    DataSet = mtRequest
    Left = 176
    Top = 41
  end
end
