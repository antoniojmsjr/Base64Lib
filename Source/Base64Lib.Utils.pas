{******************************************************************************}
{                                                                              }
{           Base64Lib.Utils.pas                                                }
{                                                                              }
{           Copyright (C) Antônio José Medeiros Schneider Júnior               }
{                                                                              }
{           https://github.com/antoniojmsjr/Base64Lib                          }
{                                                                              }
{                                                                              }
{******************************************************************************}
{                                                                              }
{  Licensed under the Apache License, Version 2.0 (the "License");             }
{  you may not use this file except in compliance with the License.            }
{  You may obtain a copy of the License at                                     }
{                                                                              }
{      http://www.apache.org/licenses/LICENSE-2.0                              }
{                                                                              }
{  Unless required by applicable law or agreed to in writing, software         }
{  distributed under the License is distributed on an "AS IS" BASIS,           }
{  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    }
{  See the License for the specific language governing permissions and         }
{  limitations under the License.                                              }
{                                                                              }
{******************************************************************************}
unit Base64Lib.Utils;

interface

uses
  System.SysUtils, System.Classes, System.Rtti,
  {$IF DEFINED(HAS_FMX)}FMX.Graphics{$ELSE}Vcl.Graphics{$ENDIF};

type
  TTypeImage = (imgUnknown, imgJPEG, imgPNG, imgBMP, imgGIF, imgTIFF, imgSVG, imgWMF, imgEMF, imgICON, imgWEBP, imgAPNG);

  TTypeImageHelper = record helper for TTypeImage
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    function AsString: string;
    function AsInteger: Integer;
    function AsExt: string;
    function AsText: string;
    function AsMIMETypes: string;
  end;

  TUtilsImage = class sealed
  strict private
    { private declarations }
    class function DetectImageCustom(const pStream: TStream; out pBuffer: TBytes): Boolean;
    class function DetectImageSVG(const pBuffer: TBytes): Boolean;
    class function DetectImageBMP(const pBuffer: TBytes): Boolean;
    class function DetectImageJPEG(const pBuffer: TBytes): Boolean;
    class function DetectImagePNG(const pBuffer: TBytes): Boolean;
    class function DetectImageGIF(const pBuffer: TBytes): Boolean;
    class function DetectImageTIFF(const pBuffer: TBytes): Boolean;
    class function DetectImageWMF(const pBuffer: TBytes): Boolean;
    class function DetectImageEMF(const pBuffer: TBytes): Boolean;
    class function DetectImageICON(const pBuffer: TBytes): Boolean;
    class function DetectImageWEBP(const pBuffer: TBytes): Boolean;
    class function DetectImageAPNG(const pBuffer: TBytes): Boolean;
  protected
    { protected declarations }
  public
    { public declarations }
    {$IF DEFINED(HAS_FMX)}class function DetectImage(const pBitmap: TBitmap): TTypeImage; overload;{$ENDIF}
    {$IF NOT DEFINED(HAS_FMX)}class function DetectImage(const pPicture: TPicture): TTypeImage; overload;{$ENDIF}
    class function DetectImage(const pStream: TStream): TTypeImage; overload;
    class function DetectImage(const pBase64: string): TTypeImage; overload;
    class function DetectImage(const pFileName: TFileName): TTypeImage; overload;
    {$IF DEFINED(HAS_FMX)}class function DetectMIMETypes(const pBitmap: TBitmap): string; overload;{$ENDIF}
    {$IF NOT DEFINED(HAS_FMX)}class function DetectMIMETypes(const pPicture: TPicture): string; overload;{$ENDIF}
    class function DetectMIMETypes(const pStream: TStream): string; overload;
    class function DetectMIMETypes(const pBase64: string): string; overload;
    class function DetectMIMETypes(const pFileName: TFileName): string; overload;
  end;

  TUtilsString = class sealed
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    class function GetSizeFromText(const pText: string): Int64;
    class function GetSizeFromBytes(const pBytes: TBytes): Int64;
    class function GetSizeFromStream(const pStream: TStream): Int64;
    {$IF DEFINED(HAS_FMX)}class function GetSizeFromImage(const pBitmap: TBitmap): Int64;{$ENDIF}
    {$IF NOT DEFINED(HAS_FMX)}class function GetSizeFromImage(const pPicture: TPicture): Int64;{$ENDIF}
    class function GetSizeFromFile(const pFileName: TFileName): Int64;

    class function GetMD5FromText(const pText: string): string;
    class function GetMD5FromBytes(const pBytes: TBytes): string;
    class function GetMD5FromStream(const pStream: TStream): string;
    {$IF DEFINED(HAS_FMX)}class function GetMD5FromImage(const pBitmap: TBitmap): string;{$ENDIF}
    {$IF NOT DEFINED(HAS_FMX)}class function GetMD5FromImage(const pPicture: TPicture): string;{$ENDIF}
    class function GetMD5FromFile(const pFileName: TFileName): string;
  end;

implementation

uses
  {$IF CompilerVersion >= 30}System.Hash,{$ELSE}IdHashMessageDigest,{$ENDIF}
  {$IF NOT DEFINED(HAS_FMX)}Vcl.Imaging.jpeg, Vcl.Imaging.pngimage, Vcl.Imaging.GIFImg,{$ENDIF}
  IdGlobal, System.NetEncoding;

{$REGION 'TTypeImageHelper'}
function TTypeImageHelper.AsExt: string;
begin
  case Self of
    imgJPEG: Result := '.jpeg';
    imgPNG:  Result := '.png';
    imgBMP:  Result := '.bmp';
    imgGIF:  Result := '.gif';
    imgTIFF: Result := '.tiff';
    imgSVG: Result := '.svg';
    imgWMF: Result := '.wmf';
    imgEMF: Result := '.emf';
    imgICON: Result := '.ico';
    imgWEBP: Result := '.webp';
    imgAPNG: Result := '.apng';
  else
    Result := '.unknown';
  end;
end;

function TTypeImageHelper.AsInteger: Integer;
begin
  Result := Ord(Self);
end;

function TTypeImageHelper.AsMIMETypes: string;
begin
  case Self of
    imgJPEG: Result := 'image/jpeg';
    imgPNG:  Result := 'image/png';
    imgBMP:  Result := 'image/bmp';
    imgGIF:  Result := 'image/gif';
    imgTIFF: Result := 'image/tiff';
    imgSVG: Result := 'image/svg+xml';
    imgWMF: Result := 'image/x-wmf';
    imgEMF: Result := 'image/emf';
    imgICON: Result := 'image/x-icon';
    imgWEBP: Result := 'image/webp';
    imgAPNG: Result := 'image/apng';
  else
    Result := 'application/octet-stream';
  end;
end;

function TTypeImageHelper.AsString: string;
begin
  case Self of
    imgUnknown: Result := 'UNKNOWN';
    imgJPEG:    Result := 'JPEG';
    imgPNG:     Result := 'PNG';
    imgBMP:     Result := 'BMP';
    imgGIF:     Result := 'GIF';
    imgTIFF:    Result := 'TIFF';
    imgSVG:     Result := 'SVG';
    imgWMF:     Result := 'WMF';
    imgEMF:     Result := 'EMF';
    imgICON:    Result := 'ICON';
    imgWEBP:    Result := 'WEBP';
    imgAPNG:    Result := 'APNG';
  end;
end;

function TTypeImageHelper.AsText: string;
begin
  case Self of
    imgUnknown: Result := 'Unknown';
    imgJPEG:    Result := 'JPEG (Joint Photographic Experts Group)';
    imgPNG:     Result := 'PNG (Portable Network Graphics)';
    imgBMP:     Result := 'BMP (Bitmap Image File)';
    imgGIF:     Result := 'GIF (Graphics Interchange Format)';
    imgTIFF:    Result := 'TIFF (Tagged Image File Format)';
    imgSVG:     Result := 'SVG (Scalable Vector Graphics)';
    imgWMF:     Result := 'WMF (Windows Metafile)';
    imgEMF:     Result := 'EMF (Enhanced Metafile)';
    imgICON:    Result := 'ICON';
    imgWEBP:    Result := 'WEBP';
    imgAPNG:    Result := 'APNG (Animated PNG)';
  end;
end;
{$ENDREGION}

{$REGION 'TUtilsBitmap'}
class function TUtilsImage.DetectImageCustom(const pStream: TStream; out pBuffer: TBytes): Boolean;
begin
  if not Assigned(pStream) then
    Exit(False);

  pStream.Position := 0;
  if (pStream.Size = 0) then
    Exit(False);

  SetLength(pBuffer, 256);
  pStream.Read(pBuffer, Length(pBuffer));
  Result := True;
end;

class function TUtilsImage.DetectImage(const pFileName: TFileName): TTypeImage;
var
  lFile: TBytesStream;
begin
  lFile := TBytesStream.Create;
  try
    Result := DetectImage(lFile);
  finally
    lFile.Free;
  end;
end;

class function TUtilsImage.DetectImageAPNG(const pBuffer: TBytes): Boolean;
begin
  if not DetectImagePNG(pBuffer) then
    Exit(False);

  Result := ((pBuffer[12] = $61) and (pBuffer[13] = $63) and (pBuffer[14] = $54) and (pBuffer[15] = $4C));
end;

class function TUtilsImage.DetectImageBMP(const pBuffer: TBytes): Boolean;
begin
  Result := ((pBuffer[0] = $42) and (pBuffer[1] = $4D));
end;

class function TUtilsImage.DetectImageEMF(const pBuffer: TBytes): Boolean;
begin
  Result := ((pBuffer[0] = $01) and (pBuffer[1] = $00) and (pBuffer[2] = $00) and (pBuffer[3] = $00));
end;

class function TUtilsImage.DetectImageGIF(const pBuffer: TBytes): Boolean;
begin
  Result := ((pBuffer[0] = $47) and (pBuffer[1] = $49) and (pBuffer[2] = $46) and (pBuffer[3] = $38));
end;

class function TUtilsImage.DetectImageICON(const pBuffer: TBytes): Boolean;
begin
  Result := ((pBuffer[0] = $00) and (pBuffer[1] = $00) and (pBuffer[2] = $01) and (pBuffer[3] = $00));
end;

class function TUtilsImage.DetectImageJPEG(const pBuffer: TBytes): Boolean;
begin
  Result := ((pBuffer[0] = $FF) and (pBuffer[1] = $D8) and (pBuffer[2] = $FF));
end;

class function TUtilsImage.DetectImagePNG(const pBuffer: TBytes): Boolean;
begin
  Result := ((pBuffer[0] = $89) and (pBuffer[1] = $50) and (pBuffer[2] = $4E)
        and  (pBuffer[3] = $47) and (pBuffer[4] = $0D) and (pBuffer[5] = $0A)
        and  (pBuffer[6] = $1A) and (pBuffer[7] = $0A));
end;

class function TUtilsImage.DetectImageSVG(const pBuffer: TBytes): Boolean;
var
  lBufferStr: string;
begin
  lBufferStr := LowerCase(TEncoding.ASCII.GetString(pBuffer, 0, Length(pBuffer)));
  Result := ((Pos('<svg', lBufferStr) > 0) or (Pos('http://www.w3.org/2000/svg', lBufferStr) > 0));
end;

class function TUtilsImage.DetectImageTIFF(const pBuffer: TBytes): Boolean;
begin
  Result := (((pBuffer[0] = $49) and (pBuffer[1] = $49) and (pBuffer[2] = $2A) and (pBuffer[3] = $00)) or
            ((pBuffer[0] = $4D) and (pBuffer[1] = $4D) and (pBuffer[2] = $00) and (pBuffer[3] = $2A)));
end;

class function TUtilsImage.DetectImageWEBP(const pBuffer: TBytes): Boolean;
begin
  Result := ((pBuffer[0] = $52) and (pBuffer[1] = $49) and
            (pBuffer[2] = $46) and (pBuffer[3] = $46) and
            (pBuffer[8] = $57) and (pBuffer[9] = $45) and
            (pBuffer[10] = $42) and (pBuffer[11] = $50));
end;

class function TUtilsImage.DetectImageWMF(const pBuffer: TBytes): Boolean;
begin
  Result := ((pBuffer[0] = $D7) and (pBuffer[1] = $CD) and (pBuffer[2] = $C6) and (pBuffer[3] = $9A));
end;

class function TUtilsImage.DetectMIMETypes(const pFileName: TFileName): string;
var
  lFile: TBytesStream;
begin
  lFile := TBytesStream.Create;
  try
    Result := DetectMIMETypes(lFile);
  finally
    lFile.Free;
  end;
end;

{$IF DEFINED(HAS_FMX)}
class function TUtilsImage.DetectImage(const pBitmap: TBitmap): TTypeImage;
var
  lImageStream: TStream;
begin
  Result := TTypeImage.imgUnknown;
  if not Assigned(pBitmap) then
    Exit;

  lImageStream := TMemoryStream.Create;
  try
    pBitmap.SaveToStream(lImageStream);
    Result := DetectImage(lImageStream);
  finally
    lImageStream.Free;
  end;
end;

class function TUtilsImage.DetectMIMETypes(const pBitmap: TBitmap): string;
var
  lImageStream: TStream;
begin
  Result := EmptyStr;
  if not Assigned(pBitmap) then
    Exit;

  lImageStream := TMemoryStream.Create;
  try
    pBitmap.SaveToStream(lImageStream);
    Result := DetectMIMETypes(lImageStream);
  finally
    lImageStream.Free;
  end;
end;
{$ENDIF}

{$IF NOT DEFINED(HAS_FMX)}
class function TUtilsImage.DetectImage(const pPicture: TPicture): TTypeImage;
var
  lImageStream: TStream;
begin
  Result := TTypeImage.imgUnknown;
  if not Assigned(pPicture) then
    Exit;

  lImageStream := TMemoryStream.Create;
  try
    pPicture.Graphic.SaveToStream(lImageStream);
    Result := DetectImage(lImageStream);
  finally
    lImageStream.Free;
  end;
end;

class function TUtilsImage.DetectMIMETypes(const pPicture: TPicture): string;
var
  lImageStream: TStream;
begin
  Result := EmptyStr;
  if not Assigned(pPicture) then
    Exit;

  lImageStream := TMemoryStream.Create;
  try
    pPicture.Graphic.SaveToStream(lImageStream);
    Result := DetectMIMETypes(lImageStream);
  finally
    lImageStream.Free;
  end;
end;
{$ENDIF}

class function TUtilsImage.DetectImage(const pBase64: string): TTypeImage;
var
  lImageStream: TStream;
  lBytes: TBytes;
begin
  Result := TTypeImage.imgUnknown;
  if (Trim(pBase64) = EmptyStr) then
    Exit;

  lBytes := TNetEncoding.Base64.DecodeStringToBytes(pBase64);
  lImageStream := TBytesStream.Create(lBytes);
  try
    Result := DetectImage(lImageStream);
  finally
    lImageStream.Free;
  end;
end;

class function TUtilsImage.DetectImage(const pStream: TStream): TTypeImage;
var
  lBuffer: TBytes;
begin
  Result := TTypeImage.imgUnknown;

  if not DetectImageCustom(pStream, lBuffer) then
    Exit;

  if (Length(lBuffer) = 0) then
    Exit;

  if DetectImageSVG(lBuffer) then
    Result := TTypeImage.imgSVG
  else if DetectImageBMP(lBuffer) then
    Result := TTypeImage.imgBMP
  else if DetectImageJPEG(lBuffer) then
    Result := TTypeImage.imgJPEG
  else if DetectImageAPNG(lBuffer) then
    Result := TTypeImage.imgAPNG
  else if DetectImagePNG(lBuffer) then
    Result := TTypeImage.imgPNG
  else if DetectImageGIF(lBuffer) then
    Result := TTypeImage.imgGIF
  else if DetectImageTIFF(lBuffer) then
    Result := TTypeImage.imgTIFF
  else if DetectImageWMF(lBuffer) then
    Result := TTypeImage.imgWMF
  else if DetectImageEMF(lBuffer) then
    Result := TTypeImage.imgEMF
  else if DetectImageICON(lBuffer) then
    Result := TTypeImage.imgICON
  else if DetectImageWEBP(lBuffer) then
    Result := TTypeImage.imgWEBP;
end;

class function TUtilsImage.DetectMIMETypes(const pBase64: string): string;
begin
  Result := DetectImage(pBase64).AsMIMETypes;
end;

class function TUtilsImage.DetectMIMETypes(const pStream: TStream): string;
begin
  Result := DetectImage(pStream).AsMIMETypes;
end;
{$ENDREGION}

{$REGION 'TUtilsString'}
procedure TBytesToTIdBytes(const pInput: TBytes; var pOutput: TIdBytes);
var
  lLengthBytes: Integer;
begin
  lLengthBytes := Length(pInput);
  if (lLengthBytes = 0) then
  begin
    SetLength(pOutput, 0);
    Exit;
  end;
  SetLength(pOutput, lLengthBytes);
  Move(Pointer(pInput)^, Pointer(pOutput)^, lLengthBytes);
end;

{$IF DEFINED(HAS_FMX)}
class function TUtilsString.GetMD5FromImage(const pBitmap: TBitmap): string;
var
  lImageStream: TStream;
begin
  Result := EmptyStr;
  if not Assigned(pBitmap) then
    Exit;

  lImageStream := TMemoryStream.Create;
  try
    pBitmap.SaveToStream(lImageStream);

    lImageStream.Position := 0;
    Result := GetMD5FromStream(lImageStream);
  finally
    lImageStream.Free;
  end;
end;
{$ENDIF}

{$IF NOT DEFINED(HAS_FMX)}
class function TUtilsString.GetMD5FromImage(const pPicture: TPicture): string;
var
  lImageStream: TStream;
begin
  Result := EmptyStr;
  if not Assigned(pPicture) then
    Exit;

  lImageStream := TMemoryStream.Create;
  try
    pPicture.Graphic.SaveToStream(lImageStream);

    lImageStream.Position := 0;
    Result := GetMD5FromStream(lImageStream);
  finally
    lImageStream.Free;
  end;
end;
{$ENDIF}

class function TUtilsString.GetMD5FromBytes(const pBytes: TBytes): string;
var
{$IF CompilerVersion >= 30}
  lHashMD5: THashMD5;
{$ELSE}
  lIdHashMessageDigest5: TIdHashMessageDigest5;
  lIdBytes: TIdBytes;
{$ENDIF}
begin
{$IF CompilerVersion >= 30}
  lHashMD5 := THashMD5.Create;
  lHashMD5.Reset;
  lHashMD5.Update(pBytes);
  Result := lHashMD5.HashAsString;
{$ELSE}
  lIdHashMessageDigest5 := TIdHashMessageDigest5.Create;
  try
    TBytesToTIdBytes(pBytes, lIdBytes);
    Result := lIdHashMessageDigest5.HashBytesAsHex(lIdBytes);
  finally
    lIdHashMessageDigest5.Free;
  end;
{$ENDIF}
  Result := LowerCase(Result);
end;

class function TUtilsString.GetMD5FromFile(const pFileName: TFileName): string;
{$IF CompilerVersion < 30}
var
  lIdHashMessageDigest5: TIdHashMessageDigest5;
  lFileStream: TFileStream;
{$ENDIF}
begin
{$IF CompilerVersion >= 30}
  Result := THashMD5.GetHashStringFromFile(pFileName);
{$ELSE}
  lFileStream := TFileStream.Create(pFileName, fmOpenRead OR fmShareDenyWrite);
  try
    lIdHashMessageDigest5 := TIdHashMessageDigest5.Create;
    try
      lFileStream.Position := 0;
      Result := lIdHashMessageDigest5.HashStreamAsHex(lFileStream);
    finally
      lIdHashMessageDigest5.Free;
    end;
  finally
    lFileStream.Free;
  end;
{$ENDIF}
  Result := LowerCase(Result);
end;

class function TUtilsString.GetMD5FromStream(const pStream: TStream): string;
{$IF CompilerVersion < 30}
var
  lIdHashMessageDigest5: TIdHashMessageDigest5;
{$ENDIF}
begin
  Result := EmptyStr;
  if not Assigned(pStream) then
    Exit;
{$IF CompilerVersion >= 30}
  pStream.Position := 0;
  Result := THashMD5.GetHashString(pStream);
{$ELSE}
  lIdHashMessageDigest5 := TIdHashMessageDigest5.Create;
  try
    pStream.Position := 0;
    Result := lIdHashMessageDigest5.HashStreamAsHex(pStream);
  finally
    lIdHashMessageDigest5.Free;
  end;
{$ENDIF}
  Result := LowerCase(Result);
end;

class function TUtilsString.GetMD5FromText(const pText: string): string;
{$IF CompilerVersion < 30}
var
  lIdHashMessageDigest5: TIdHashMessageDigest5;
{$ENDIF}
begin
{$IF CompilerVersion >= 30}
  Result := THashMD5.GetHashString(pText);
{$ELSE}
  lIdHashMessageDigest5 := TIdHashMessageDigest5.Create;
  try
    Result := lIdHashMessageDigest5.HashStringAsHex(pText);
  finally
    lIdHashMessageDigest5.Free;
  end;
{$ENDIF}
  Result := LowerCase(Result);
end;

{$IF DEFINED(HAS_FMX)}
class function TUtilsString.GetSizeFromImage(const pBitmap: TBitmap): Int64;
var
  lImageStream: TStream;
begin
  Result := 0;
  if not Assigned(pBitmap) then
    Exit;

  lImageStream := TMemoryStream.Create;
  try
    pBitmap.SaveToStream(lImageStream);

    lImageStream.Position := 0;
    Result := lImageStream.Size;
  finally
    lImageStream.Free;
  end;
end;
{$ENDIF}

{$IF NOT DEFINED(HAS_FMX)}
class function TUtilsString.GetSizeFromImage(const pPicture: TPicture): Int64;
var
  lImageStream: TStream;
begin
  Result := 0;
  if not Assigned(pPicture) then
    Exit;

  lImageStream := TMemoryStream.Create;
  try
    pPicture.Graphic.SaveToStream(lImageStream);

    lImageStream.Position := 0;
    Result := lImageStream.Size;
  finally
    lImageStream.Free;
  end;
end;
{$ENDIF}

class function TUtilsString.GetSizeFromBytes(const pBytes: TBytes): Int64;
begin
  Result := Length(pBytes);
end;

class function TUtilsString.GetSizeFromFile(const pFileName: TFileName): Int64;
var
  lFile: TFileStream;
begin
  lFile := TFileStream.Create(pFileName, fmOpenRead or fmShareDenyNone);
  try
    lFile.Position := 0;
    Result := lFile.Size;
  finally
    lFile.Free;
  end;
end;

class function TUtilsString.GetSizeFromStream(const pStream: TStream): Int64;
begin
  Result := 0;
  if not Assigned(pStream) then
    Exit;

  pStream.Position := 0;
  Result := pStream.Size;
end;

class function TUtilsString.GetSizeFromText(const pText: string): Int64;
begin
  Result := Length(pText);
end;
{$ENDREGION}

end.
