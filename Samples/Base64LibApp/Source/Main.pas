unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Imaging.pngimage,
  Vcl.ComCtrls, Vcl.StdCtrls, Vcl.AppEvnts, Vcl.ExtDlgs, Vcl.Imaging.jpeg,
  Vcl.Imaging.GIFImg;

type
  TfrmBase64LibApp = class(TForm)
    pnlHeader: TPanel;
    pnlHeaderApp: TPanel;
    lblHeaderAppGithub: TLinkLabel;
    lblHeaderAppName: TLinkLabel;
    bvlHeader: TBevel;
    PageControl: TPageControl;
    tbsTextBase64: TTabSheet;
    pnlTextBase64Left: TPanel;
    bvlTextBase64: TBevel;
    pnlTextBase64Right: TPanel;
    lblTextBase64InputText: TLabel;
    mmoTextBase64InputText: TMemo;
    btnTextBase64Encode: TButton;
    lblTextBase64OutputBase64: TLabel;
    mmoTextBase64OutputBase64: TMemo;
    lblHeaderBase64Online: TLinkLabel;
    lblHeaderBase64OnlineLink: TLinkLabel;
    lblTextBase64InputBase64: TLabel;
    mmoTextBase64InputBase64: TMemo;
    btnTextBase64Decode: TButton;
    lblTextBase64OutputText: TLabel;
    mmoTextBase64OutputText: TMemo;
    ApplicationEvents: TApplicationEvents;
    stbTextBase64OutputBase64: TStatusBar;
    stbTextBase64OutputText: TStatusBar;
    stbTextBase64InputText: TStatusBar;
    stbTextBase64InputBase64: TStatusBar;
    tbsBitmapBase64: TTabSheet;
    pnlBitmapBase64Left: TPanel;
    lblBitmapBase64InputBitmap: TLabel;
    lblBitmapBase64OutputBase64: TLabel;
    btnBitmapBase64Encode: TButton;
    mmoBitmapBase64OutputBase64: TMemo;
    stbBitmapBase64OutputBase64: TStatusBar;
    stbBitmapBase64InputBitmap: TStatusBar;
    imgBitmapBase64InputBitmap: TImage;
    pnlBitmapBase64Right: TPanel;
    lblBitmapBase64InputBase64: TLabel;
    lblBitmapBase64OutputBitmap: TLabel;
    mmoBitmapBase64InputBase64: TMemo;
    btnBitmapBase64Decode: TButton;
    stbBitmapBase64OutputBitmap: TStatusBar;
    stbBitmapBase64InputBase64: TStatusBar;
    imgBitmapBase64OutputBitmap: TImage;
    imgLogo: TImage;
    bvlBitmapBase64: TBevel;
    tbsFileBase64: TTabSheet;
    pnlFileBase64Left: TPanel;
    lblFileBase64InputFileTitle: TLabel;
    lblFileBase64OutputBase64: TLabel;
    btnFileBase64Encode: TButton;
    mmoFileBase64OutputBase64: TMemo;
    stbFileBase64OutputBase64: TStatusBar;
    stbFileBase64InputFile: TStatusBar;
    gbxFileBase64InputFile: TGroupBox;
    btnFileBase64InputFile: TButton;
    lblFileBase64InputFile: TLabel;
    OpenDialog: TOpenDialog;
    bvlFileBase64: TBevel;
    pnlFileBase64LeftRight: TPanel;
    lblFileBase64InputBase64: TLabel;
    mmoFileBase64InputBase64: TMemo;
    stbFileBase64InputBase64: TStatusBar;
    btnFileBase64Decode: TButton;
    gbxFileBase64OutputFile: TGroupBox;
    stbFileBase64OutputFile: TStatusBar;
    lblFileBase64OutputFile: TLabel;
    SaveDialog: TSaveDialog;
    Label1: TLabel;
    tbsDetectImage: TTabSheet;
    pnlDetectImage: TPanel;
    pnlDetectImageHeader: TPanel;
    pnlDetectImageClient: TPanel;
    Label2: TLabel;
    lblDetectImageType: TLabel;
    bvlDetectImageHeader: TBevel;
    btnDetectImageLoadFile: TButton;
    imgDetectImage: TImage;
    OpenPictureDialog: TOpenPictureDialog;
    pnlDetectImageBase64: TPanel;
    lblDetectImageBase64Input: TLabel;
    lblDetectImageBase64Output: TLabel;
    imgDetectImageBase64Output: TImage;
    mmoDetectImageBase64Input: TMemo;
    btnDetectImageBase64Decode: TButton;
    lblDetectImageBase64OutputType: TLabel;
    lblBitmapBase64InputBitmapType: TLabel;
    lblBitmapBase64OutputBitmapType: TLabel;
    stbDetectImage: TStatusBar;
    procedure lblHeaderAppGithubLinkClick(Sender: TObject; const Link: string;
      LinkType: TSysLinkType);
    procedure FormCreate(Sender: TObject);
    procedure btnTextBase64EncodeClick(Sender: TObject);
    procedure lblHeaderBase64OnlineLinkLinkClick(Sender: TObject;
      const Link: string; LinkType: TSysLinkType);
    procedure btnTextBase64DecodeClick(Sender: TObject);
    procedure ApplicationEventsException(Sender: TObject; E: Exception);
    procedure mmoTextBase64InputTextChange(Sender: TObject);
    procedure btnBitmapBase64EncodeClick(Sender: TObject);
    procedure btnBitmapBase64DecodeClick(Sender: TObject);
    procedure btnFileBase64InputFileClick(Sender: TObject);
    procedure btnFileBase64EncodeClick(Sender: TObject);
    procedure btnFileBase64DecodeClick(Sender: TObject);
    procedure btnDetectImageLoadFileClick(Sender: TObject);
    procedure btnDetectImageBase64DecodeClick(Sender: TObject);
  private
    { Private declarations }
    procedure GetStatus;
  public
    { Public declarations }
  end;

var
  frmBase64LibApp: TfrmBase64LibApp;

implementation

uses
  Winapi.ShellAPI, Base64Lib, Base64Lib.Types, Base64Lib.Utils;

{$R *.dfm}
{$I Base64Lib.inc}

procedure TfrmBase64LibApp.FormCreate(Sender: TObject);
begin
  Self.Caption := Format('Base64Lib v%s', [Base64LibVersion]);
  lblHeaderAppName.Caption := Format('Base64Lib v%s', [Base64LibVersion]);
  lblHeaderAppGithub.Caption :=
    '<a href="https://github.com/antoniojmsjr/Base64Lib">https://github.com/antoniojmsjr/Base64Lib</a>';
  lblHeaderBase64OnlineLink.Caption :=
    '<a href="https://base64.guru/">https://base64.guru/</a>';
  PageControl.ActivePage := tbsTextBase64;

  GetStatus;
end;

procedure TfrmBase64LibApp.GetStatus;
var
  lText: string;
begin
  lText := mmoTextBase64InputText.Text;
  Delete(lText, (Length(lText)+1) - (Length(sLineBreak)), (Length(sLineBreak)));
  stbTextBase64InputText.Panels[1].Text := TUtilsString.GetMD5FromText(lText);
  stbTextBase64InputText.Panels[3].Text := TUtilsString.GetSizeFromText(lText).ToString;
  mmoTextBase64InputText.Clear;
  mmoTextBase64InputText.Text := lText;

  stbBitmapBase64InputBitmap.Panels[1].Text := TUtilsString.GetMD5FromImage(imgBitmapBase64InputBitmap.Picture);
  stbBitmapBase64InputBitmap.Panels[3].Text := TUtilsString.GetSizeFromImage(imgBitmapBase64InputBitmap.Picture).ToString;
  lblBitmapBase64InputBitmapType.Caption := TUtilsImage.DetectImage(imgBitmapBase64InputBitmap.Picture).AsText;
end;

procedure TfrmBase64LibApp.ApplicationEventsException(Sender: TObject; E: Exception);
begin
  if (E is EBase64Lib) then
    Application.MessageBox(PWideChar(EBase64Lib(E).ToString), 'E R R O R',
      MB_OK + MB_ICONERROR)
  else
    Application.MessageBox(PWideChar(E.Message), 'E R R O R',
      MB_OK + MB_ICONERROR);
end;

procedure TfrmBase64LibApp.btnBitmapBase64DecodeClick(Sender: TObject);
var
  lDecode: IDecodeParse;
  lPicture: TPicture;
begin
  lDecode := TBase64Lib
               .Build
                 .Decode
                   .Text(mmoBitmapBase64InputBase64.Text);

  if not Assigned(lDecode) then
    Exit;

  lPicture := lDecode.AsPicture;
  try
    imgBitmapBase64OutputBitmap.Picture.Assign(nil);
    imgBitmapBase64OutputBitmap.Picture.Assign(lPicture);
    stbBitmapBase64OutputBitmap.Panels[1].Text := lDecode.MD5;
    stbBitmapBase64OutputBitmap.Panels[3].Text := lDecode.Size.ToString;
    lblBitmapBase64OutputBitmapType.Caption := TUtilsImage.DetectImage(lPicture).AsText;
  finally
    lPicture.Free;
  end;
end;

procedure TfrmBase64LibApp.btnBitmapBase64EncodeClick(Sender: TObject);
var
  lEncode: IEncodeParse;
begin
  lEncode := TBase64Lib
               .Build
                 .Encode
                   .Image(imgBitmapBase64InputBitmap.Picture);

  if not Assigned(lEncode) then
    Exit;

  mmoBitmapBase64OutputBase64.Clear;
  mmoBitmapBase64OutputBase64.Text := lEncode.AsString;
  stbBitmapBase64OutputBase64.Panels[1].Text := lEncode.MD5;
  stbBitmapBase64OutputBase64.Panels[3].Text := lEncode.Size.ToString;

  mmoBitmapBase64InputBase64.Clear;
  mmoBitmapBase64InputBase64.Text := lEncode.AsString;
  stbBitmapBase64InputBase64.Panels[1].Text := TUtilsString.GetMD5FromText(lEncode.AsString);
  stbBitmapBase64InputBase64.Panels[3].Text := TUtilsString.GetSizeFromText(lEncode.AsString).ToString;
end;

procedure TfrmBase64LibApp.btnDetectImageBase64DecodeClick(Sender: TObject);
var
  lDecode: IDecodeParse;
  lPicture: TPicture;
begin
  lDecode := TBase64Lib
               .Build
                 .Decode
                   .Text(mmoDetectImageBase64Input.Text);

  if not Assigned(lDecode) then
    Exit;

  lPicture := lDecode.AsPicture;
  lblDetectImageBase64OutputType.Caption := TUtilsImage.DetectImage(lPicture).AsText;
  try
    imgDetectImageBase64Output.Picture.Assign(nil);
    imgDetectImageBase64Output.Picture.Assign(lPicture);
  finally
    lPicture.Free;
  end;
end;

procedure TfrmBase64LibApp.btnDetectImageLoadFileClick(Sender: TObject);
var
  lFileStream: TBytesStream;
  lTypeImage: TTypeImage;
begin
  if not OpenPictureDialog.Execute then
    Exit;

  lFileStream := TBytesStream.Create;
  try
    lFileStream.LoadFromFile(OpenPictureDialog.FileName);

    lTypeImage := TUtilsImage.DetectImage(lFileStream);
    lblDetectImageType.Caption := lTypeImage.AsText;
  finally
    lFileStream.Free;
  end;

  imgDetectImage.Picture.Assign(nil);
  imgDetectImage.Picture.LoadFromFile(OpenPictureDialog.FileName);

  stbDetectImage.Panels[1].Text := TUtilsString.GetMD5FromFile(OpenPictureDialog.FileName);
  stbDetectImage.Panels[3].Text := TUtilsString.GetSizeFromFile(OpenPictureDialog.FileName).ToString;
end;

procedure TfrmBase64LibApp.btnFileBase64DecodeClick(Sender: TObject);
var
  lDecode: IDecodeParse;
begin
  SaveDialog.InitialDir := IncludeTrailingPathDelimiter(GetCurrentDir);
  if not SaveDialog.Execute then
    Exit;

  lblFileBase64OutputFile.Caption := SaveDialog.FileName;

  lDecode := TBase64Lib.Build.Decode.Text(mmoFileBase64InputBase64.Text);

  if not Assigned(lDecode) then
    Exit;

  stbFileBase64OutputFile.Panels[1].Text := lDecode.MD5;
  stbFileBase64OutputFile.Panels[3].Text := lDecode.Size.ToString;

  lDecode.SaveToFile(SaveDialog.FileName);
  if FileExists(SaveDialog.FileName) then
    ShowMessage('Save!');
end;

procedure TfrmBase64LibApp.btnFileBase64EncodeClick(Sender: TObject);
var
  lEncode: IEncodeParse;
begin
  lEncode := TBase64Lib.Build.Encode.&File(lblFileBase64InputFile.Caption);

  if not Assigned(lEncode) then
    Exit;

  mmoFileBase64OutputBase64.Clear;
  mmoFileBase64OutputBase64.Text := lEncode.AsString;
  stbFileBase64OutputBase64.Panels[1].Text := lEncode.MD5;
  stbFileBase64OutputBase64.Panels[3].Text := lEncode.Size.ToString;

  mmoFileBase64InputBase64.Clear;
  mmoFileBase64InputBase64.Text := lEncode.AsString;
  stbFileBase64InputBase64.Panels[1].Text := TUtilsString.GetMD5FromText(lEncode.AsString);
  stbFileBase64InputBase64.Panels[3].Text := TUtilsString.GetSizeFromText(lEncode.AsString).ToString;
end;

procedure TfrmBase64LibApp.btnFileBase64InputFileClick(Sender: TObject);
begin
  OpenDialog.InitialDir := IncludeTrailingPathDelimiter(GetCurrentDir);
  if not OpenDialog.Execute then
    Exit;

  lblFileBase64InputFile.Caption := OpenDialog.FileName;

  stbFileBase64InputFile.Panels[1].Text := TUtilsString.GetMD5FromFile(lblFileBase64InputFile.Caption);
  stbFileBase64InputFile.Panels[3].Text := TUtilsString.GetSizeFromFile(lblFileBase64InputFile.Caption).ToString;

  btnFileBase64Encode.Enabled := True;
end;

procedure TfrmBase64LibApp.btnTextBase64DecodeClick(Sender: TObject);
var
  lDecode: IDecodeParse;
begin
  lDecode := TBase64Lib.Build.Decode.Text(mmoTextBase64InputBase64.Text);

  if not Assigned(lDecode) then
    Exit;

  mmoTextBase64OutputText.Clear;
  mmoTextBase64OutputText.Text := lDecode.AsString;

  stbTextBase64OutputText.Panels[1].Text := lDecode.MD5;
  stbTextBase64OutputText.Panels[3].Text := lDecode.Size.ToString;
end;

procedure TfrmBase64LibApp.btnTextBase64EncodeClick(Sender: TObject);
var
  lEncode: IEncodeParse;
begin
  lEncode := TBase64Lib.Build.Encode.Text(mmoTextBase64InputText.Text);

  if not Assigned(lEncode) then
    Exit;

  mmoTextBase64OutputBase64.Clear;
  mmoTextBase64OutputBase64.Text := lEncode.AsString;
  stbTextBase64OutputBase64.Panels[1].Text := lEncode.MD5;
  stbTextBase64OutputBase64.Panels[3].Text := lEncode.Size.ToString;

  mmoTextBase64InputBase64.Clear;
  mmoTextBase64InputBase64.Text := lEncode.AsString;
  stbTextBase64InputBase64.Panels[1].Text := TUtilsString.GetMD5FromText(lEncode.AsString);
  stbTextBase64InputBase64.Panels[3].Text := TUtilsString.GetSizeFromText(lEncode.AsString).ToString;
end;

procedure TfrmBase64LibApp.lblHeaderAppGithubLinkClick(Sender: TObject;
  const Link: string; LinkType: TSysLinkType);
begin
  ShellExecute(0, nil, PChar(Link), nil, nil, 1);
end;

procedure TfrmBase64LibApp.lblHeaderBase64OnlineLinkLinkClick(Sender: TObject;
  const Link: string; LinkType: TSysLinkType);
begin
  ShellExecute(0, nil, PChar(Link), nil, nil, 1);
end;

procedure TfrmBase64LibApp.mmoTextBase64InputTextChange(Sender: TObject);
var
  lText: string;
begin
  lText := StringReplace(mmoTextBase64InputText.Text, sLineBreak, '', []);
  stbTextBase64InputText.Panels[1].Text := TUtilsString.GetMD5FromText(lText);
  stbTextBase64InputText.Panels[3].Text := TUtilsString.GetSizeFromText
    (lText).ToString;
end;

end.
