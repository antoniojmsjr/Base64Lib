unit Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Effects,
  FMX.ScrollBox, FMX.Memo, System.ImageList, FMX.ImgList;

type
  TfrmMain = class(TForm)
    vsbMain: TVertScrollBox;
    lytInputImage: TLayout;
    lytInputConvert: TLayout;
    imgInputImage: TImage;
    gbxInput: TGroupBox;
    linInputImage: TLine;
    BevelEffect2: TBevelEffect;
    lytBase64: TLayout;
    mmoBase64: TMemo;
    btnInputImageConvert: TButton;
    lytOutputConvert: TLayout;
    lytOutputImage: TLayout;
    imgOutputImage: TImage;
    linOutputImage: TLine;
    BevelEffect3: TBevelEffect;
    btnOutputConvert: TButton;
    Line1: TLine;
    BevelEffect5: TBevelEffect;
    procedure btnInputImageConvertClick(Sender: TObject);
    procedure btnOutputConvertClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  Base64Lib, Base64Lib.Utils, FMX.MultiResBitmap;

{$R *.fmx}
{$R *.XLgXhdpiTb.fmx ANDROID}
{$R *.Windows.fmx MSWINDOWS}
{$R *.LgXhdpiPh.fmx ANDROID}
{$R *.SmXhdpiPh.fmx ANDROID}
{$R *.NmXhdpiPh.fmx ANDROID}
{$R *.LgXhdpiTb.fmx ANDROID}

procedure TfrmMain.btnInputImageConvertClick(Sender: TObject);
var
  lEncode: IEncodeParse;
begin
  lEncode := TBase64Lib
    .Build
      .Encode
        .Image(imgInputImage.Bitmap);

  mmoBase64.Lines.Clear;
  mmoBase64.Lines.Add(lEncode.AsString);
end;

procedure TfrmMain.btnOutputConvertClick(Sender: TObject);
var
  lDecode: IDecodeParse;
  lBitmap: TBitmap;
  lItem: TCustomBitmapItem;
  lRect: TRect;
begin
  lDecode := TBase64Lib
    .Build
      .Decode
        .Text(mmoBase64.Text);

  if not Assigned(lDecode) then
    Exit;

  lBitmap := lDecode.AsBitmap;
  try
    lRect := TRect.Create(TPoint.Zero);
    lRect.Left := 0;
    lRect.Top := 0;
    lRect.Width := lBitmap.Bounds.Width;
    lRect.Height := lBitmap.Bounds.Height;

    imgOutputImage.MultiResBitmap.Clear;
    lItem := imgOutputImage.MultiResBitmap.ItemByScale(1, False, True);
    lItem.Bitmap.Width := lBitmap.Bounds.Width;
    lItem.Bitmap.Height  := lBitmap.Bounds.Height;
    lItem.Bitmap.CopyFromBitmap(lBitmap, lRect, 0, 0);
  finally
    lBitmap.Free;
  end;
end;

end.
