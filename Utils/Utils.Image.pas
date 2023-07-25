{*********************************************************************************}
{                                                                                 }
{           Utils.Image.pas                                                       }
{                                                                                 }
{           Copyright (C) Antônio José Medeiros Schneider Júnior                  }
{                                                                                 }
{           https://github.com/antoniojmsjr/Base64Bitmap                          }
{                                                                                 }
{                                                                                 }
{*********************************************************************************}
{  MIT License                                                                    }
{                                                                                 }
{  Permission is hereby granted, free of charge, to any person obtaining a copy   }
{  of this software and associated documentation files (the "Software"), to deal  }
{  in the Software without restriction, including without limitation the rights   }
{  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell      }
{  copies of the Software, and to permit persons to whom the Software is          }
{  furnished to do so, subject to the following conditions:                       }
{                                                                                 }
{  The above copyright notice and this permission notice shall be included in all }
{  copies or substantial portions of the Software.                                }
{                                                                                 }
{  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR     }
{  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,       }
{  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE    }
{  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER         }
{  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,  }
{  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE  }
{  SOFTWARE.                                                                      }
{*********************************************************************************}
unit Utils.Image;

interface

uses
  System.SysUtils, System.Classes,
  {$IFDEF HAS_FMX} FMX.Graphics {$ELSE} Vcl.Graphics {$ENDIF};

type
  TTypeBitpmap = (bmpUnknown, bmpJPEG, bmpPNG, bmpBMP, bmpGIF, bmpTIFF);

  TTypeBitpmapHelper = record helper for TTypeBitpmap
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    function AsString: string;
    function AsInteger: Integer;
  end;

  // VCL
  {$IFNDEF HAS_FMX}
  TBitmapHelpers = class helper for Vcl.Graphics.TBitmap
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    function IsEmpty: Boolean;
  end;
  {$ENDIF}

  TImageUtils = class sealed
  strict private
    { private declarations }
    class function EncodeBase64(pInput: TStream): TBytes; overload;
    class function DecodeBase64(const pBase64: string): TBytes; overload;
    class function DecodeBase64(pBase64: TStream): TBytes; overload;
  protected
    { protected declarations }
  public
    { public declarations }
    class function Base64ToBitmapStream(const pBase64: string): TStream; overload;
    class function Base64ToBitmapStream(pBase64: TStream): TStream; overload;
    class function Base64ToBitmapStream(const pBase64: TFileName): TStream; overload;
    class function Base64ToBitmap(const pBase64: string): TBitmap; overload;
    class function Base64ToBitmap(pBase64: TStream): TBitmap; overload;
    class function Base64ToBitmap(const pBase64: TFileName): TBitmap; overload;

    class function BitmapToBase64Stream(pBitmap: TBitmap): TStream; overload;
    class function BitmapToBase64Stream(pBitmap: TStream): TStream; overload;
    class function BitmapToBase64Stream(const pBitmap: TFileName): TStream; overload;
    class function BitmapToBase64(pBitmap: TBitmap): string; overload;
    class function BitmapToBase64(pBitmap: TStream): string; overload;
    class function BitmapToBase64(const pBitmap: TFileName): string; overload;

    class function DetectBitmap(pBitmap: TStream): TTypeBitpmap; overload;
    class function DetectBitmap(const pBase64: string): TTypeBitpmap; overload;
    class function DetectMIMETypes(const pTypeBitpmap: TTypeBitpmap): string; overload;
    class function DetectMIMETypes(pBitmap: TStream): string; overload;
    class function DetectMIMETypes(const pBase64: string): string; overload;
  end;

implementation

uses
  System.NetEncoding, Vcl.Imaging.jpeg, Vcl.Imaging.pngimage;

{ TBitmapHelpers }

{$IFNDEF HAS_FMX}
function TBitmapHelpers.IsEmpty: Boolean;
begin
  Result := (Self.Width = 0) or (Self.Height = 0) or (Self.Canvas.Pixels[0, 0] = clNone);
end;
{$ENDIF}

{ TImageUtils }

class function TImageUtils.DetectBitmap(const pBase64: string): TTypeBitpmap;
var
  lBase64: string;
begin
  Result := TTypeBitpmap.bmpUnknown;

  lBase64 := Copy(pBase64, 1, 15);

  if (Pos('/9j/4AAQSkZJRg', lBase64) > 0)  then
    Result := TTypeBitpmap.bmpJPEG
  else
    if (Pos('iVBORw0KGgo', lBase64) > 0)  then
      Result := TTypeBitpmap.bmpPNG
    else
      if (Pos('R0lGODdh', lBase64) > 0)
      or (Pos('R0lGODlh', lBase64) > 0) then
        Result := TTypeBitpmap.bmpGIF
      else
        if (Pos('Qk0', lBase64) > 0)
        or (Pos('Qk2', lBase64) > 0) then
          Result := TTypeBitpmap.bmpBMP
        else
          if (Pos('SUkq', lBase64) > 0)  then
            Result := TTypeBitpmap.bmpTIFF;
end;

class function TImageUtils.DetectMIMETypes(const pBase64: string): string;
begin
  REsult := DetectMIMETypes(DetectBitmap(pBase64));
end;

class function TImageUtils.DetectMIMETypes(pBitmap: TStream): string;
begin
  REsult := DetectMIMETypes(DetectBitmap(pBitmap));
end;

class function TImageUtils.DetectMIMETypes(
  const pTypeBitpmap: TTypeBitpmap): string;
begin
  case pTypeBitpmap of
    bmpJPEG: Result := 'image/jpeg';
    bmpPNG: Result := 'image/png';
    bmpBMP: Result := 'image/bmp';
    bmpGIF: Result := 'image/gif';
    bmpTIFF: Result := 'image/tiff';
  else
    Result := 'application/octet-stream';
  end;
end;

class function TImageUtils.DetectBitmap(pBitmap: TStream): TTypeBitpmap;
var
  lSignature: TBytes;
  lBase64: string;
begin
  SetLength(lSignature, 15);

  pBitmap.Seek(0, soFromBeginning);
  pBitmap.ReadBuffer(lSignature[0], Length(lSignature));

  lBase64 := TNetEncoding.Base64.EncodeBytesToString(lSignature);

  Result := DetectBitmap(lBase64);
end;

class function TImageUtils.DecodeBase64(pBase64: TStream): TBytes;
var
  lOutputStream: TBytesStream;
  lBase64Encoding: TBase64Encoding;
begin
  SetLength(Result, 0);

  lOutputStream := TBytesStream.Create;
  try
    pBase64.Seek(0, TSeekOrigin.soBeginning);

    lBase64Encoding := TBase64Encoding.Create(0);
    try
      // DECODE
      lBase64Encoding.Decode(pBase64, lOutputStream);
    finally
      lBase64Encoding.Free;
    end;

    Result := lOutputStream.Bytes;
  finally
    lOutputStream.Free;
  end;
end;

class function TImageUtils.DecodeBase64(const pBase64: string): TBytes;
var
  lBase64Encoding: TBase64Encoding;
begin
  SetLength(Result, 0);

  lBase64Encoding := TBase64Encoding.Create(0);
  try
    // DECODE
    Result := lBase64Encoding.DecodeStringToBytes(pBase64);
  finally
    lBase64Encoding.Free;
  end;
end;

class function TImageUtils.EncodeBase64(pInput: TStream): TBytes;
var
  lBase64Stream: TBytesStream;
  lBase64Encoding: TBase64Encoding;
begin
  SetLength(Result, 0);

  lBase64Stream := TBytesStream.Create;
  try

    lBase64Encoding := TBase64Encoding.Create(0);
    try
      pInput.Seek(0, TSeekOrigin.soBeginning);

      // ENCODE
      lBase64Encoding.Encode(pInput, lBase64Stream);
    finally
      lBase64Encoding.Free;
    end;

    Result := lBase64Stream.Bytes;
  finally
    lBase64Stream.Free;
  end;
end;

class function TImageUtils.Base64ToBitmapStream(const pBase64: string): TStream;
var
  lBitmapBytes: TBytes;
begin
  Result := nil;

  if (pBase64 = EmptyStr) then
    Exit;

  // DECODE
  lBitmapBytes := DecodeBase64(pBase64);

  Result := TBytesStream.Create(lBitmapBytes);
end;

class function TImageUtils.Base64ToBitmapStream(pBase64: TStream): TStream;
var
  lBitmapBytes: TBytes;
begin
  Result := nil;

  if (not Assigned(pBase64) or (pBase64.Size = 0)) then
    Exit;

  // DECODE
  lBitmapBytes := DecodeBase64(pBase64);

  Result := TBytesStream.Create(lBitmapBytes);
end;

class function TImageUtils.Base64ToBitmap(const pBase64: string): TBitmap;
var
  lBitmapStream: TStream;
  {$IFNDEF HAS_FMX} //VCL
  lPicture: TPicture;
  {$ENDIF}
begin
  lBitmapStream := nil;
  try
    // DECODE
    lBitmapStream := Base64ToBitmapStream(pBase64);
    lBitmapStream.Position := 0;

    {$IFDEF HAS_FMX}
    Result := TBitmap.CreateFromStream(lBitmapStream);
    {$ELSE}
    lPicture := TPicture.Create;
    try
      lPicture.LoadFromStream(lBitmapStream);

      Result := TBitmap.Create;
      Result.Assign(lPicture.Graphic);
    finally
      lPicture.Free;
    end;
    {$ENDIF}
  finally
    lBitmapStream.Free;
  end;
end;

class function TImageUtils.Base64ToBitmap(pBase64: TStream): TBitmap;
var
  lBitmapStream: TStream;
  {$IFNDEF HAS_FMX} //VCL
  lPicture: TPicture;
  {$ENDIF}
begin
  lBitmapStream := nil;
  try
    // DECODE
    lBitmapStream := Base64ToBitmapStream(pBase64);
    lBitmapStream.Position := 0;

    {$IFDEF HAS_FMX}
    Result := TBitmap.CreateFromStream(lBitmapStream);
    {$ELSE}
    lPicture := TPicture.Create;
    try
      lPicture.LoadFromStream(lBitmapStream);

      Result := TBitmap.Create;
      Result.Assign(lPicture.Graphic);
    finally
      lPicture.Free;
    end;
    {$ENDIF}
  finally
    lBitmapStream.Free;
  end;
end;

class function TImageUtils.Base64ToBitmap(const pBase64: TFileName): TBitmap;
var
  lBase64Stream: TFileStream;
begin
  Result := nil;

  if not FileExists(pBase64) then
    Exit;

  lBase64Stream := TFileStream.Create(pBase64, fmOpenRead or fmShareDenyNone);
  try
    // DECODE
    Result := Base64ToBitmap(lBase64Stream);
  finally
    lBase64Stream.Free;
  end;
end;

class function TImageUtils.Base64ToBitmapStream(
  const pBase64: TFileName): TStream;
var
  lBase64Stream: TFileStream;
begin
  Result := nil;

  if not FileExists(pBase64) then
    Exit;

  lBase64Stream := TFileStream.Create(pBase64, fmOpenRead or fmShareDenyNone);
  try
    // DECODE
    Result := Base64ToBitmapStream(lBase64Stream);
  finally
    lBase64Stream.Free;
  end;
end;

class function TImageUtils.BitmapToBase64Stream(pBitmap: TStream): TStream;
var
  lBitmapBytes: TBytes;
begin
  Result := nil;

  if ((not Assigned(pBitmap)) or (pBitmap.Size = 0)) then
    Exit;

  // ENCODE
  lBitmapBytes := EncodeBase64(pBitmap);

  Result := TBytesStream.Create(lBitmapBytes);
end;

class function TImageUtils.BitmapToBase64Stream(pBitmap: TBitmap): TStream;
var
  lBitmapStream: TStream;
begin
  Result := nil;

  if (not Assigned(pBitmap) or pBitmap.IsEmpty) then
    Exit;

  lBitmapStream := TStream.Create;
  try
    pBitmap.SaveToStream(lBitmapStream);

    // ENCODE
    Result := BitmapToBase64Stream(lBitmapStream);
  finally
    lBitmapStream.Free;
  end;
end;

class function TImageUtils.BitmapToBase64Stream(const pBitmap: TFileName): TStream;
var
  lBitmapStream: TFileStream;
begin
  Result := nil;

  if not FileExists(pBitmap) then
    Exit;

  lBitmapStream := TFileStream.Create(pBitmap, fmOpenRead or fmShareDenyNone);
  try
    // ENCODE
    Result := BitmapToBase64Stream(lBitmapStream);
  finally
    lBitmapStream.Free;
  end;
end;

class function TImageUtils.BitmapToBase64(pBitmap: TStream): string;
var
  lBase64Bytes: TBytes;
  lBase64Stream: TStringStream;
begin
  Result := EmptyStr;

  if ((not Assigned(pBitmap)) or (pBitmap.Size = 0)) then
    Exit;

  // ENCODE
  lBase64Bytes := EncodeBase64(pBitmap);

  lBase64Stream := TStringStream.Create(lBase64Bytes);
  try
    Result := lBase64Stream.DataString;
  finally
    lBase64Stream.Free;
  end;
end;

class function TImageUtils.BitmapToBase64(pBitmap: TBitmap): string;
var
  lBitmapStream: TMemoryStream;
begin
  Result := EmptyStr;

  if (not Assigned(pBitmap) or pBitmap.IsEmpty) then
    Exit;

  lBitmapStream := TMemoryStream.Create;
  try
    pBitmap.SaveToStream(lBitmapStream);

    // ENCODE
    Result := BitmapToBase64(lBitmapStream);
  finally
    lBitmapStream.Free;
  end;
end;

class function TImageUtils.BitmapToBase64(const pBitmap: TFileName): string;
var
  lBitmapStream: TFileStream;
begin
  if not FileExists(pBitmap) then
    Exit;

  lBitmapStream := TFileStream.Create(pBitmap, fmOpenRead or fmShareDenyNone);
  try
    // ENCODE
    Result := BitmapToBase64(lBitmapStream);
  finally
    lBitmapStream.Free;
  end;
end;

{ TTypeBitpmapHelper }

function TTypeBitpmapHelper.AsInteger: Integer;
begin
  Result := Ord(Self);
end;

function TTypeBitpmapHelper.AsString: string;
begin
  case Self of
    bmpUnknown: Result := 'UNKNOWN';
    bmpJPEG: Result := 'JPEG';
    bmpPNG: Result := 'PNG';
    bmpBMP: Result := 'BMP';
    bmpGIF: Result := 'GIF';
    bmpTIFF: Result := 'TIFF';
  end;
end;

end.
