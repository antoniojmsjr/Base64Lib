program FMX;

{$R *.dres}

uses
  System.StartUpCopy,
  FMX.Forms,
  Main in 'Source\Main.pas' {frmMain};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
