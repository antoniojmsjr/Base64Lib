unit Launcher;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, Main;

type
  TfrmLauncher = class(TForm)
    lytTop: TLayout;
    lytBottom: TLayout;
    lytClient: TLayout;
    imgLogo: TImage;
    lytBase64LibVersion: TLayout;
    lblBase64LibVersionTitle: TLabel;
    lblBase64LibVersion: TLabel;
    lytBase64LibGit: TLayout;
    lblBase64LibGitTitle: TLabel;
    lblBase64LibGit: TLabel;
    tmrShowMain: TTimer;
    procedure tmrShowMainTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lblBase64LibGitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    {$IFDEF ANDROID}procedure OpenURLAndroid(const pURL: string);{$ENDIF}
    {$IFDEF MSWINDOWS}procedure OpenURLWindows(const pURL: string);{$ENDIF}
    procedure OpenURL(const pURL: string);
  public
    { Public declarations }
  end;

var
  frmLauncher: TfrmLauncher;

implementation

uses
  {$IFDEF ANDROID}
  FMX.Helpers.Android, Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.Net, Androidapi.JNI.JavaTypes, Androidapi.Helpers,
  FMX.Platform.Android, Androidapi.JNI.App,
  {$ENDIF ANDROID}
  {$IFDEF MSWINDOWS}
  Winapi.ShellAPI, Winapi.Windows,
  {$ENDIF MSWINDOWS}
  IdURI, FMX.Platform, Base64Lib;

{$R *.fmx}
{$R *.Windows.fmx MSWINDOWS}
{$R *.SmXhdpiPh.fmx ANDROID}
{$R *.LgXhdpiPh.fmx ANDROID}
{$R *.NmXhdpiPh.fmx ANDROID}
{$R *.LgXhdpiTb.fmx ANDROID}
{$R *.XLgXhdpiTb.fmx ANDROID}

procedure TfrmLauncher.FormCreate(Sender: TObject);
begin
  lblBase64LibVersion.Text := Format('v%s', [TBase64Lib.Build.Version]);
end;

procedure TfrmLauncher.FormShow(Sender: TObject);
begin
  tmrShowMain.Enabled := True;
end;

procedure TfrmLauncher.lblBase64LibGitClick(Sender: TObject);
begin
  OpenURL('https://github.com/antoniojmsjr/Base64Lib');
end;

procedure TfrmLauncher.OpenURL(const pURL: string);
begin
  {$IFDEF ANDROID}
  OpenURLAndroid(pURL);
  {$ENDIF ANDROID}

  {$IFDEF MSWINDOWS}
  OpenURLWindows(pURL);
  {$ENDIF MSWINDOWS}
end;

{$IFDEF ANDROID}
procedure TfrmLauncher.OpenURLAndroid(const pURL: string);
var
  lIntent: JIntent;
begin
  lIntent := TJIntent.Create;
  lIntent.setType(StringToJString('text/pas'));
  lIntent.setAction(TJIntent.JavaClass.ACTION_VIEW);
  lIntent.setData(TJnet_Uri.JavaClass.parse(StringToJString(TIdURI.URLEncode(pURL))));
  SharedActivity.startActivity(lIntent);
end;
{$ENDIF ANDROID}

{$IFDEF MSWINDOWS}
procedure TfrmLauncher.OpenURLWindows(const pURL: string);
begin
  ShellExecute(0, 'OPEN', PChar(pURL), '', '', SW_SHOWNORMAL);
end;
{$ENDIF MSWINDOWS}

procedure TfrmLauncher.tmrShowMainTimer(Sender: TObject);
begin
  tmrShowMain.Enabled := False;
  try
    Application.CreateForm(TfrmMain, frmMain);
    Application.MainForm := frmMain;
    frmMain.Show;
    frmMain.BringToFront;
  finally
    Self.Hide;
  end;
end;

end.
