unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  System.Net.URLClient, System.Net.HttpClient, System.Net.HttpClientComponent,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.DBCGrids, Vcl.DBCtrls,
  Vcl.ExtDlgs;

type
  TfrmMain = class(TForm)
    pnlHeader: TPanel;
    lblHeader: TLabel;
    gbServer: TGroupBox;
    lblServerHost: TLabel;
    edtServerHost: TEdit;
    lblServerPort: TLabel;
    edtServerPort: TEdit;
    gbRequestBitmap: TGroupBox;
    imgRequestBitmap: TImage;
    lblRequestBitmapURL: TLabel;
    edtRequestBitmapID: TEdit;
    btnGetBitmap: TButton;
    httpClient: TNetHTTPClient;
    httpRequest: TNetHTTPRequest;
    GroupBox1: TGroupBox;
    pnlMenuBitmap: TPanel;
    mtBitmap: TFDMemTable;
    dsBitmap: TDataSource;
    dbgBitmap: TDBCtrlGrid;
    dbimgBitmap: TDBImage;
    dbedtIDBitmap: TDBText;
    Bevel1: TBevel;
    opdBitmap: TOpenPictureDialog;
    btnLoadBitmap: TButton;
    mtBitmapID: TIntegerField;
    mtBitmapBITMAP: TGraphicField;
    mtBitmapBASE64: TBlobField;
    dbmmoBase64: TDBMemo;
    Bevel2: TBevel;
    btnGetBase64: TPanel;
    procedure edtServerHostChange(Sender: TObject);
    procedure edtServerPortChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btnGetBitmapClick(Sender: TObject);
    procedure btnLoadBitmapClick(Sender: TObject);
    procedure btnGetBase64Click(Sender: TObject);
    procedure mtBitmapIDGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
  private
    { Private declarations }
    function GetURL(const pHost: string; const pPort: Integer): string;
    function GetResourceStream(const pResourceName: string): TStream;
    procedure DownloadImagesFromResource;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  System.Types, System.Net.Mime, Vcl.Imaging.jpeg, Vcl.Imaging.pngimage,
  Vcl.Imaging.GIFImg, Base64Lib;

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
var
  lRect: TRectF;
begin
  opdBitmap.InitialDir := GetCurrentDir;

  lRect := TRectF.Create(Screen.WorkAreaRect.TopLeft, Screen.WorkAreaRect.Width,
                         Screen.WorkAreaRect.Height);
  SetBounds(Round(lRect.Left + (lRect.Width - Width) / 2),
            0,
            Width,
            Screen.WorkAreaRect.Height);

  mtBitmap.CreateDataSet;
  DownloadImagesFromResource;
end;

procedure TfrmMain.FormResize(Sender: TObject);
begin
  if (Self.Width < 650) then
  begin
    Self.Width := 650;
    Abort;
  end;
end;

procedure TfrmMain.btnGetBitmapClick(Sender: TObject);
var
  lHTTPResponse: IHTTPResponse;
  lURL: string;
  lPicture: TPicture;
begin
  lURL := GetURL(edtServerHost.Text, StrToIntDef(edtServerPort.Text, 9000));
  lURL := lURL + '/base64/' + edtRequestBitmapID.Text;

  lHTTPResponse := httpRequest.Client.Get(lURL);

  if (lHTTPResponse.StatusCode <> 200) then
    raise Exception.CreateFmt('%d - %s', [lHTTPResponse.StatusCode, lHTTPResponse.StatusText]);

  lHTTPResponse.ContentStream.Position := 0;
  if not Assigned(lHTTPResponse.ContentStream) then
    raise Exception.Create('Content response empty.');

  lPicture := nil;
  try
    // DECODE
    lPicture := TBase64Lib
      .Build
        .Decode
          .Stream(lHTTPResponse.ContentStream).AsPicture;

    imgRequestBitmap.Picture.Assign(nil);
    imgRequestBitmap.Picture.Assign(lPicture);
  finally
    lPicture.Free;
  end;
end;

procedure TfrmMain.btnLoadBitmapClick(Sender: TObject);
var
  lHTTPResponse: IHTTPResponse;
  lURL: string;
  lContentType: string;
  lKind: TMimeTypes.TKind;
begin
  if not opdBitmap.Execute() then
    Exit;

  lURL := GetURL(edtServerHost.Text, StrToIntDef(edtServerPort.Text, 9000));
  lURL := lURL + '/bitmap/';

  TMimeTypes.Default.GetFileInfo(ExtractFileName(opdBitmap.FileName), lContentType, lKind);
  httpRequest.Client.ContentType := lContentType;
  lHTTPResponse := httpRequest.Client.Post(lURL, opdBitmap.FileName);

  if (lHTTPResponse.StatusCode <> 201) then
    raise Exception.CreateFmt('%d - %s', [lHTTPResponse.StatusCode, lHTTPResponse.StatusText]);

  lHTTPResponse.ContentStream.Position := 0;
  if not Assigned(lHTTPResponse.ContentStream) then
    raise Exception.Create('Content response empty.');

  mtBitmap.Append;
  mtBitmap.FieldByName('ID').Value := Trim(lHTTPResponse.ContentAsString());
  TBlobField(mtBitmap.FieldByName('BITMAP')).LoadFromFile(opdBitmap.FileName);
  mtBitmap.Post;
end;

procedure TfrmMain.DownloadImagesFromResource;
var
  I: Integer;
  lResourceName: string;
  lImageName: string;
  lImagePath: string;
  lResourceStream: TStream;
  lFileStream: TFileStream;
begin
  for I := 1 to 4 do
  begin
    case I of
      1: lImageName := Format('IMG%d.bmp', [I]);
      2: lImageName := Format('IMG%d.png', [I]);
      3: lImageName := Format('IMG%d.gif', [I]);
      4: lImageName := Format('IMG%d.jpg', [I]);
    end;
    lResourceName := Format('RES_IMG_%d', [I]);

    lImagePath := IncludeTrailingPathDelimiter(GetCurrentDir) + lImageName;
    if FileExists(lImagePath) then
      Continue;

    lFileStream := TFileStream.Create(lImagePath, fmCreate);
    try
      lResourceStream := GetResourceStream(lResourceName);
      lFileStream.CopyFrom(lResourceStream, 0);
    finally
      FreeAndNil(lResourceStream);
      FreeAndNil(lFileStream);
    end;
  end;
end;

procedure TfrmMain.edtServerHostChange(Sender: TObject);
begin
  lblRequestBitmapURL.Caption := EmptyStr;
  lblRequestBitmapURL.Caption := Format('%s/bitmap/ID', [GetURL(edtServerHost.Text, StrToIntDef(edtServerPort.Text, 9000))]);
end;

procedure TfrmMain.edtServerPortChange(Sender: TObject);
begin
  lblRequestBitmapURL.Caption := EmptyStr;
  lblRequestBitmapURL.Caption := Format('%s/bitmap/ID', [GetURL(edtServerHost.Text, StrToIntDef(edtServerPort.Text, 9000))]);
end;

function TfrmMain.GetResourceStream(const pResourceName: string): TStream;
var
  lResStream: TResourceStream;
begin
  lResStream := TResourceStream.Create(HInstance, pResourceName, RT_RCDATA);
  try
    lResStream.Position := 0;
    Result := lResStream;
  except
    lResStream.Free;
    raise;
  end;
end;

function TfrmMain.GetURL(const pHost: string; const pPort: Integer): string;
begin
  Result := Format('%s:%d', [pHost, pPort]);
end;

procedure TfrmMain.mtBitmapIDGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  Text := Format('ID: %d', [Sender.AsInteger]);
end;

procedure TfrmMain.btnGetBase64Click(Sender: TObject);
var
  lHTTPResponse: IHTTPResponse;
  lURL: string;
begin
  mtBitmap.DisableControls;
  try
    lURL := GetURL(edtServerHost.Text, StrToIntDef(edtServerPort.Text, 9000));
    lURL := lURL + '/base64/' + mtBitmapID.AsString;

    lHTTPResponse := httpRequest.Client.Get(lURL);

    if (lHTTPResponse.StatusCode <> 200) then
      raise Exception.CreateFmt('%d - %s', [lHTTPResponse.StatusCode, lHTTPResponse.StatusText]);

    lHTTPResponse.ContentStream.Position := 0;
    if not Assigned(lHTTPResponse.ContentStream) then
      raise Exception.Create('Content response empty.');

    mtBitmap.Edit;
    TBlobField(mtBitmap.FieldByName('BASE64')).LoadFromStream(lHTTPResponse.ContentStream);
    mtBitmap.Post;
  finally
    mtBitmap.EnableControls;
  end;
end;

end.
