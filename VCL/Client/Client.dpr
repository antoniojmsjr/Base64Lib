program Client;

{$R *.dres}

uses
  Vcl.Forms,
  Main in 'Source\Main.pas' {frmMain};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
