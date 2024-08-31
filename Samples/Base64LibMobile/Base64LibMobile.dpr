program Base64LibMobile;

uses
  System.StartUpCopy,
  FMX.Forms,
  Main in 'Main.pas' {frmMain},
  Launcher in 'Launcher.pas' {frmLauncher};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.CreateForm(TfrmLauncher, frmLauncher);
  Application.Run;
end.
