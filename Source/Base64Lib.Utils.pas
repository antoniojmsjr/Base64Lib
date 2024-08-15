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
  System.Classes, System.SysUtils, System.Hash,
  {$IF DEFINED(HAS_FMX)} FMX.Graphics, System.Rtti {$ELSE} Vcl.Graphics {$ENDIF};

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
    function AsExt: string;
    function AsMIMETypes: string;
  end;

  TUtilsBitmap = class sealed
  strict private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    class function DetectBitmap(pBitmap: TStream): TTypeBitpmap; overload;
    class function DetectBitmap(const pBase64: string): TTypeBitpmap; overload;
    class function DetectMIMETypes(pBitmap: TStream): string; overload;
    class function DetectMIMETypes(const pBase64: string): string; overload;
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
    class function GetSizeFromBitmap(const pBitmap: TBitmap): Int64;
    class function GetSizeFromFile(const pFileName: TFileName): Int64;
    class function GetMD5FromText(const pText: string): string;
    class function GetMD5FromBytes(const pBytes: TBytes): string;
    class function GetMD5FromStream(const pStream: TStream): string;
    class function GetMD5FromBitmap(const pBitmap: TBitmap): string;
    class function GetMD5FromFile(const pFileName: TFileName): string;
  end;

implementation

uses
  System.NetEncoding, Vcl.Imaging.jpeg, Vcl.Imaging.pngimage, Vcl.Imaging.GIFImg;

{$REGION 'TTypeBitpmapHelper'}
function TTypeBitpmapHelper.AsExt: string;
begin
  case Self of
    bmpJPEG: Result := '.jpeg';
    bmpPNG:  Result := '.png';
    bmpBMP:  Result := '.bmp';
    bmpGIF:  Result := '.gif';
    bmpTIFF: Result := '.tiff';
  else
    Result := EmptyStr;
  end;
end;

function TTypeBitpmapHelper.AsInteger: Integer;
begin
  Result := Ord(Self);
end;

function TTypeBitpmapHelper.AsMIMETypes: string;
begin
  case Self of
    bmpJPEG: Result := 'image/jpeg';
    bmpPNG:  Result := 'image/png';
    bmpBMP:  Result := 'image/bmp';
    bmpGIF:  Result := 'image/gif';
    bmpTIFF: Result := 'image/tiff';
  else
    Result := 'application/octet-stream';
  end;
end;

function TTypeBitpmapHelper.AsString: string;
begin
  case Self of
    bmpUnknown: Result := 'UNKNOWN';
    bmpJPEG:    Result := 'JPEG';
    bmpPNG:     Result := 'PNG';
    bmpBMP:     Result := 'BMP';
    bmpGIF:     Result := 'GIF';
    bmpTIFF:    Result := 'TIFF';
  end;
end;
{$ENDREGION}

{$REGION 'TUtilsBitmap'}
class function TUtilsBitmap.DetectBitmap(const pBase64: string): TTypeBitpmap;
var
  lBase64: string;
begin
  Result := TTypeBitpmap.bmpUnknown;
  if (Trim(pBase64) = EmptyStr) then
    Exit;

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

class function TUtilsBitmap.DetectBitmap(pBitmap: TStream): TTypeBitpmap;
var
  lSignature: TBytes;
  lBase64: string;
begin
  Result := TTypeBitpmap.bmpUnknown;
  if ((pBitmap = nil) or (pBitmap.Size = 0)) then
    Exit;

  SetLength(lSignature, 15);

  pBitmap.Position := 0;
  pBitmap.ReadBuffer(lSignature[0], Length(lSignature));

  lBase64 := TNetEncoding.Base64.EncodeBytesToString(lSignature);
  Result := DetectBitmap(lBase64);
end;

class function TUtilsBitmap.DetectMIMETypes(const pBase64: string): string;
begin
  Result := DetectBitmap(pBase64).AsMIMETypes;
end;

class function TUtilsBitmap.DetectMIMETypes(pBitmap: TStream): string;
begin
  Result := DetectBitmap(pBitmap).AsMIMETypes;
end;
{$ENDREGION}

{$REGION 'TUtilsBitmap'}
class function TUtilsString.GetMD5FromBitmap(const pBitmap: TBitmap): string;
var
  lBitmap: TStream;
begin
  Result := EmptyStr;
  if not Assigned(pBitmap) then
    Exit;

  lBitmap := TMemoryStream.Create;
  try
    pBitmap.SaveToStream(lBitmap);

    lBitmap.Position := 0;
    Result := GetMD5FromStream(lBitmap);
  finally
    lBitmap.Free;
  end;
end;

class function TUtilsString.GetMD5FromBytes(const pBytes: TBytes): string;
var
  lHashMD5: THashMD5;
begin
  lHashMD5 := THashMD5.Create;
  lHashMD5.Reset;
  lHashMD5.Update(pBytes);

  Result := lHashMD5.HashAsString;
end;

class function TUtilsString.GetMD5FromFile(const pFileName: TFileName): string;
begin
  Result := THashMD5.GetHashStringFromFile(pFileName);
end;

class function TUtilsString.GetMD5FromStream(const pStream: TStream): string;
begin
  Result := EmptyStr;
  if not Assigned(pStream) then
    Exit;

  Result := THashMD5.GetHashString(pStream);
end;

class function TUtilsString.GetMD5FromText(const pText: string): string;
begin
  Result := THashMD5.GetHashString(pText);
end;

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

class function TUtilsString.GetSizeFromBitmap(const pBitmap: TBitmap): Int64;
var
  lBitmap: TStream;
begin
  Result := 0;

  if not Assigned(pBitmap) then
    Exit;

  lBitmap := TBytesStream.Create;
  try
    pBitmap.SaveToStream(lBitmap);

    lBitmap.Position := 0;
    Result := lBitmap.Size;
  finally
    lBitmap.Free;
  end;
end;
{$ENDREGION}

end.
