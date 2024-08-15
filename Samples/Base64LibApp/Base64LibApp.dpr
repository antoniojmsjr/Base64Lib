program Base64LibApp;

uses
  Vcl.Forms,
  Main in 'Source\Main.pas' {frmBase64LibApp};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmBase64LibApp, frmBase64LibApp);
  Application.Run;
end.
