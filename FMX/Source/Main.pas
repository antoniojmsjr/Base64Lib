unit Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.ScrollBox, FMX.Memo, FMX.Objects,
  FMX.Layouts, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.FMXUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, System.Rtti, FMX.Grid.Style, FMX.Grid,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.Components, Data.Bind.Grid, Data.Bind.Controls,
  Fmx.Bind.Navigator, Data.Bind.DBScope;

type
  TfrmMain = class(TForm)
    gbBitmapToBase64: TGroupBox;
    imgBitmapToBase64: TImage;
    mmoBitmapToBase64: TMemo;
    btnBitmapToBase64: TButton;
    gbFileBitmapToBase64: TGroupBox;
    btnFileBitmapToBase64: TButton;
    mmoFileBitmapToBase64: TMemo;
    OpenDialogImage: TOpenDialog;
    btnFileBitmapToBase64Convert: TButton;
    gbFileBase64ToBitmap: TGroupBox;
    imgFileBase64ToBitmap: TImage;
    mmoFileBase64ToBitmap: TMemo;
    btnFileBase64ToBitmap: TButton;
    OpenDialogBase64: TOpenDialog;
    btnBase64ToBitmap: TButton;
    imgFileBitmapToBase64: TImage;
    crcBase64ToBitmap: TCircle;
    crcFileBitmapToBase64Convert: TCircle;
    lytHeader: TLayout;
    rtgHeader: TRectangle;
    lblHeader: TLabel;
    gbDatabase: TGroupBox;
    FDConnection: TFDConnection;
    FDQuery: TFDQuery;
    imgDatabaseBitmapToBase64: TImage;
    btnDatabaseBitmapToBase64: TButton;
    grdDatabase: TGrid;
    BindingsList1: TBindingsList;
    BindSourceDB: TBindSourceDB;
    BindNavigator: TBindNavigator;
    LinkGridToDataSourceBindSourceDB: TLinkGridToDataSource;
    imgDatabaseBase64ToBitmap: TImage;
    FDQueryID: TIntegerField;
    FDQueryBASE64: TBlobField;
    FDQueryMENSAGEM: TStringField;
    procedure btnBitmapToBase64Click(Sender: TObject);
    procedure btnFileBitmapToBase64Click(Sender: TObject);
    procedure btnFileBitmapToBase64ConvertClick(Sender: TObject);
    procedure btnFileBase64ToBitmapClick(Sender: TObject);
    procedure btnBase64ToBitmapClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FDConnectionBeforeConnect(Sender: TObject);
    procedure btnDatabaseBitmapToBase64Click(Sender: TObject);
    procedure FDQueryCalcFields(DataSet: TDataSet);
    procedure grdDatabaseCellDblClick(const Column: TColumn;
      const Row: Integer);
  private
    { Private declarations }
    function GetResourceStream(const pResourceName: string): TStream;
    procedure DownloadImagesFromResource;
    procedure DatabaseSaveBase64(const pBase64: string);
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  FMX.MultiResBitmap, Utils.Image;

{$R *.fmx}

procedure TfrmMain.FormCreate(Sender: TObject);
var
  lRect: TRectF;
  lFileStream: TFileStream;
  lResStream: TStream;
begin
  lRect := TRectF.Create(Screen.WorkAreaRect.TopLeft, Screen.WorkAreaRect.Width,
                         Screen.WorkAreaRect.Height);
  SetBounds(Round(lRect.Left + (lRect.Width - Width) / 2),
            0,
            Width,
            Screen.WorkAreaRect.Height);

  OpenDialogImage.InitialDir := GetCurrentDir;
  OpenDialogBase64.InitialDir := GetCurrentDir;

  // ARQUIVO Base64.txt
  if not FileExists(IncludeTrailingPathDelimiter(GetCurrentDir) + 'Base64.txt') then
  begin
    lFileStream := TFileStream.Create(IncludeTrailingPathDelimiter(GetCurrentDir) + 'Base64.txt', fmCreate);
    try
      lResStream := GetResourceStream('RES_TXT_1');
      lFileStream.CopyFrom(lResStream, 0);
    finally
      FreeAndNil(lResStream);
      FreeAndNil(lFileStream);
    end;
  end;

  // ARQUIVO Database.db
  if not FileExists(IncludeTrailingPathDelimiter(GetCurrentDir) + 'Database.db') then
  begin
    lFileStream := TFileStream.Create(IncludeTrailingPathDelimiter(GetCurrentDir) + 'Database.db', fmCreate);
    try
      lResStream := GetResourceStream('RES_DB_1');
      lFileStream.CopyFrom(lResStream, 0);
    finally
      FreeAndNil(lResStream);
      FreeAndNil(lFileStream);
    end;
  end;

  // DOWNLOAD DAS IMAGENS
  DownloadImagesFromResource;

  FDConnection.Connected := True;
  FDQuery.Open();
end;

procedure TfrmMain.FormResize(Sender: TObject);
begin
  if (Self.Width < 975) then
  begin
    Self.Width := 975;
    Abort;
  end;
end;

procedure TfrmMain.btnBase64ToBitmapClick(Sender: TObject);
var
  lBitmap: TBitmap;
  lBase64: string;
begin
  lBase64 := Trim(mmoBitmapToBase64.Text);

  if (lBase64 = '') then
    Exit;

  lBitmap := nil;
  try
    // DECODE BASE64
    lBitmap := TImageUtils.Base64ToBitmap(lBase64);

    crcBase64ToBitmap.Fill.Bitmap.Bitmap := lBitmap;
  finally
    lBitmap.Free;
  end;

  // VERIFICAR
  // https://base64.guru/converter/encode/image
end;

procedure TfrmMain.btnBitmapToBase64Click(Sender: TObject);
var
  lBase64: string;
begin
  // ENCODE BITMAP
  lBase64 := TImageUtils.BitmapToBase64(imgBitmapToBase64.Bitmap);

  mmoBitmapToBase64.Lines.Clear;
  mmoBitmapToBase64.Lines.Add(lBase64);

  crcBase64ToBitmap.Fill.Bitmap.Bitmap := nil;

  // VERIFICAR
  // https://base64.guru/converter/decode/image
end;

procedure TfrmMain.btnDatabaseBitmapToBase64Click(Sender: TObject);
var
  lFileBitmap: TFileName;
  lBase64: string;
  lBitmapStream: TFileStream;
  lItem: TCustomBitmapItem;
begin
  if not OpenDialogImage.Execute then
    Exit;

  lFileBitmap := OpenDialogImage.FileName;

  //CARREGA BITMAP
  lBitmapStream := nil;
  try
    lBitmapStream := TFileStream.Create(lFileBitmap, fmOpenRead or fmShareDenyNone);

    imgDatabaseBitmapToBase64.MultiResBitmap.Clear;
    lItem := imgDatabaseBitmapToBase64.MultiResBitmap.ItemByScale(1, False, True);
    lItem.Bitmap.LoadFromStream(lBitmapStream);
  finally
    lBitmapStream.Free;
  end;

  // ENCODE BITMAP
  lBase64 := TImageUtils.BitmapToBase64(lFileBitmap);
  DatabaseSaveBase64(lBase64);

  // VERIFICAR
  // https://base64.guru/converter/decode/image
end;

procedure TfrmMain.btnFileBase64ToBitmapClick(Sender: TObject);
var
  lBitmapStream: TStream;
  lItem: TCustomBitmapItem;
  lBase64File: TStringStream;
  lBase64: string;
  lFileBase64: string;
begin
  lBitmapStream := nil;
  try
    lBase64File := TStringStream.Create();
    try
      if OpenDialogBase64.Execute then
        lFileBase64 := OpenDialogBase64.FileName;

      lBase64File.LoadFromFile(lFileBase64);
      lBase64 := lBase64File.DataString;

      mmoFileBase64ToBitmap.Lines.Clear;
      mmoFileBase64ToBitmap.Text := lBase64;
    finally
      lBase64File.Free;
    end;

    // DECODE
    lBitmapStream := TImageUtils.Base64ToBitmapStream(mmoFileBase64ToBitmap.Text);

    imgFileBase64ToBitmap.MultiResBitmap.Clear;
    lItem := imgFileBase64ToBitmap.MultiResBitmap.ItemByScale(1, False, True);
    lItem.Bitmap.LoadFromStream(lBitmapStream);
  finally
    lBitmapStream.Free;
  end;

  // VERIFICAR
  // https://base64.guru/converter/encode/image
end;

procedure TfrmMain.btnFileBitmapToBase64Click(Sender: TObject);
var
  lFileBitmap: TFileName;
  lBase64: string;
  lBitmapStream: TFileStream;
  lItem: TCustomBitmapItem;
begin
  if not OpenDialogImage.Execute then
    Exit;

  lFileBitmap := OpenDialogImage.FileName;

  //CARREGA BITMAP
  lBitmapStream := nil;
  try
    lBitmapStream := TFileStream.Create(lFileBitmap, fmOpenRead or fmShareDenyNone);

    imgFileBitmapToBase64.MultiResBitmap.Clear;
    lItem := imgFileBitmapToBase64.MultiResBitmap.ItemByScale(1, False, True);
    lItem.Bitmap.LoadFromStream(lBitmapStream);
  finally
    lBitmapStream.Free;
  end;

  // ENCODE BITMAP
  lBase64 := TImageUtils.BitmapToBase64(lFileBitmap);

  mmoFileBitmapToBase64.Lines.Clear;
  mmoFileBitmapToBase64.Lines.Add(lBase64);

  crcFileBitmapToBase64Convert.Fill.Bitmap.Bitmap := nil;

  // VERIFICAR
  // https://base64.guru/converter/decode/image
end;

procedure TfrmMain.btnFileBitmapToBase64ConvertClick(Sender: TObject);
var
  lBitmap: TBitmap;
  lBase64: string;
begin
  lBase64 := Trim(mmoFileBitmapToBase64.Text);

  if (lBase64 = '') then
    Exit;

  lBitmap := nil;
  try
    // DECODE
    lBitmap := TImageUtils.Base64ToBitmap(lBase64);
    crcFileBitmapToBase64Convert.Fill.Bitmap.Bitmap := lBitmap;
  finally
    lBitmap.Free;
  end;

  // VERIFICAR
  // https://base64.guru/converter/encode/image
end;

procedure TfrmMain.DatabaseSaveBase64(const pBase64: string);
var
  lID: Integer;
begin
  Randomize;
  lID := Random(99999);

  FDQuery.Append;
  FDQuery.FieldByName('ID').AsInteger := lID;
  TBlobField(FDQuery.FieldByName('BASE64')).AsString := pBase64;
  FDQuery.Post;
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
  for I := 1 to 5 do
  begin
    lImageName := Format('IMG%d.png', [I]);
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

procedure TfrmMain.FDConnectionBeforeConnect(Sender: TObject);
begin
  FDConnection.Params.Values['Database'] := IncludeTrailingPathDelimiter(GetCurrentDir) + 'Database.db';
end;

procedure TfrmMain.FDQueryCalcFields(DataSet: TDataSet);
begin
  DataSet.FieldByName('MENSAGEM').AsString := 'Duplo clique para fazer a decodificação Base64 para Bitmap.';
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

procedure TfrmMain.grdDatabaseCellDblClick(const Column: TColumn;
  const Row: Integer);
var
  lBitmapStream: TStream;
  lItem: TCustomBitmapItem;
  lBase64: string;
begin
  lBase64 := FDQuery.FieldByName('BASE64').AsString;

  if (lBase64 = '') then
    Exit;

  lBitmapStream := nil;
  try
    // DECODE
    lBitmapStream := TImageUtils.Base64ToBitmapStream(lBase64);

    imgDatabaseBase64ToBitmap.MultiResBitmap.Clear;
    lItem := imgDatabaseBase64ToBitmap.MultiResBitmap.ItemByScale(1, False, True);
    lItem.Bitmap.LoadFromStream(lBitmapStream);
  finally
    lBitmapStream.Free;
  end;

  // VERIFICAR
  // https://base64.guru/converter/encode/image
end;

end.
