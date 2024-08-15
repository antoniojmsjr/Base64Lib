{******************************************************************************}
{                                                                              }
{           Base64Lib.Encode.pas                                               }
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
unit Base64Lib.Encode;

interface

uses
  System.SysUtils, System.Classes, Base64Lib.Interfaces,
  {$IF DEFINED(HAS_FMX)} FMX.Graphics, System.Rtti {$ELSE} Vcl.Graphics {$ENDIF};

type
  TBase64LibEncodeCustom = class(TInterfacedObject)
  private
    { private declarations }
  protected
    { protected declarations }
    function Encode(const pInput: TBytes): TBytes; overload;
    function Encode(const pInput: string): TBytes; overload;
    function Encode(pInput: TStream): TBytes; overload;
    function EncodeFile(const pInput: TFileName): TBytes;
  public
    { public declarations }
  end;

  TBase64LibEncode = class(TBase64LibEncodeCustom, IBase64LibEncode)
  private
    { private declarations }
    function Bytes(const pValue: TBytes): IEncodeParse;
    function Text(const pValue: string): IEncodeParse; overload;
    function Stream(pValue: TStream; const pOwnsObject: Boolean = True): IEncodeParse;
    function &File(const pFileName: TFileName): IEncodeParse;
    function Bitmap(pValue: TBitmap): IEncodeParse; overload;
    {$IF NOT DEFINED(HAS_FMX)}function Bitmap(pValue: TGraphic): IEncodeParse; overload;{$ENDIF}
  protected
    { protected declarations }
  public
    { public declarations }
  end;

implementation

uses
  System.NetEncoding, Vcl.Imaging.jpeg, Vcl.Imaging.pngimage, Vcl.Imaging.GIFImg,
  Base64Lib.Types, Base64Lib.Parse;

{$REGION 'TBase64LibEncodeCustom'}
function TBase64LibEncodeCustom.Encode(pInput: TStream): TBytes;
var
  lEncoded: TBytesStream;
  lBase64Encoding: TBase64Encoding;
begin
  SetLength(Result, 0);

  lEncoded := TBytesStream.Create;
  try
    lBase64Encoding := TBase64Encoding.Create(0);
    try
      try
        // ENCODE(UTF8)
        pInput.Position := 0;
        lBase64Encoding.Encode(pInput, lEncoded);

        Result := Copy(lEncoded.Bytes, 0, lEncoded.Size);
      except
        on E: Exception do
        begin
          raise EBase64Lib.Build
            .Title('Stream encoding failed.')
            .Error(E.Message)
            .Hint('Check the error message.')
            .ClassName(E.ClassName);
        end;
      end;
    finally
      lBase64Encoding.Free;
    end;
  finally
    lEncoded.Free;
  end;
end;

function TBase64LibEncodeCustom.Encode(const pInput: string): TBytes;
var
  lEncoded: string;
  lBase64Encoding: TBase64Encoding;
begin
  SetLength(Result, 0);

  lBase64Encoding := TBase64Encoding.Create(0);
  try
    try
      // ENCODE(UTF8)
      lEncoded := lBase64Encoding.Encode(pInput);
      Result := TEncoding.UTF8.GetBytes(lEncoded);
    except
      on E: Exception do
      begin
        raise EBase64Lib.Build
          .Title('String encoding failed.')
          .Error(E.Message)
          .Hint('Check the error message.')
          .ClassName(E.ClassName);
      end;
    end;
  finally
    lBase64Encoding.Free;
  end;
end;

function TBase64LibEncodeCustom.Encode(const pInput: TBytes): TBytes;
var
  lBase64Encoding: TBase64Encoding;
begin
  SetLength(Result, 0);

  lBase64Encoding := TBase64Encoding.Create(0);
  try
    try
      // ENCODE(UTF8)
      Result := lBase64Encoding.Encode(pInput);
    except
      on E: Exception do
      begin
        raise EBase64Lib.Build
          .Title('Bytes encoding failed.')
          .Error(E.Message)
          .Hint('Check the error message.')
          .ClassName(E.ClassName);
      end;
    end;
  finally
    lBase64Encoding.Free;
  end;
end;

function TBase64LibEncodeCustom.EncodeFile(const pInput: TFileName): TBytes;
var
  lFile: TBytesStream;
  lBase64Encoding: TBase64Encoding;
  lBytes: TBytes;
begin
  if not FileExists(pInput) then
    raise EBase64Lib.Build
      .Title('File encoding failed.')
      .Error('File not found.')
      .Hint('Check if the file exists.')
      .ClassName(Self.ClassName);

  lFile := TBytesStream.Create;
  try
    lFile.LoadFromFile(pInput);
    lBytes := Copy(lFile.Bytes, 0, lFile.Size);
  finally
    lFile.Free;
  end;

  lBase64Encoding := TBase64Encoding.Create(0);
  try
    try
      // ENCODE(UTF8)
      Result := lBase64Encoding.Encode(lBytes);
    except
      on E: Exception do
      begin
        raise EBase64Lib.Build
          .Title('File encoding failed.')
          .Error(E.Message)
          .Hint('Check the error message.')
          .ClassName(E.ClassName);
      end;
    end;
  finally
    lBase64Encoding.Free;
  end;
end;
{$ENDREGION}

{$REGION 'TBase64LibEncode'}
function TBase64LibEncode.Bitmap(pValue: TBitmap): IEncodeParse;
var
  lBitmapStream: TMemoryStream;
  lEncoded: TBytes;
begin
  if (pValue = nil) then
    Exit;

  lBitmapStream := TMemoryStream.Create;
  try
    pValue.SaveToStream(lBitmapStream);

    // ENCODE
    lEncoded := Encode(lBitmapStream);
    Result := TEncodeParse.Create(lEncoded);
  finally
    lBitmapStream.Free;
  end;
end;

{$IF NOT DEFINED(HAS_FMX)}
function TBase64LibEncode.Bitmap(pValue: TGraphic): IEncodeParse;
var
  lBitmap: TBitmap;
begin
  if (pValue = nil) then
    Exit;

  lBitmap := TBitmap(pValue);

  // ENCODE
  Result := Bitmap(lBitmap);
end;
{$ENDIF}

function TBase64LibEncode.Bytes(const pValue: TBytes): IEncodeParse;
var
  lEncoded: TBytes;
begin
  if (Length(pValue) = 0) then
    Exit;

  // ENCODE
  lEncoded := Encode(pValue);
  Result := TEncodeParse.Create(lEncoded);
end;

function TBase64LibEncode.&File(const pFileName: TFileName): IEncodeParse;
var
  lEncoded: TBytes;
begin
  if not FileExists(pFileName) then
    Exit;

  // ENCODE
  lEncoded := EncodeFile(pFileName);
  Result := TEncodeParse.Create(lEncoded);
end;

function TBase64LibEncode.Stream(pValue: TStream; const pOwnsObject: Boolean): IEncodeParse;
var
  lEncoded: TBytes;
begin
  if ((pValue = nil) or (pValue.Size = 0)) then
    Exit;

  // ENCODE
  lEncoded := Encode(pValue);
  Result := TEncodeParse.Create(lEncoded);

  if pOwnsObject then
    pValue.Free;
end;

function TBase64LibEncode.Text(const pValue: string): IEncodeParse;
var
  lEncoded: TBytes;
begin
  if (Trim(pValue) = '') then
    Exit;

  // ENCODE
  lEncoded := Encode(pValue);
  Result := TEncodeParse.Create(lEncoded);
end;
{$ENDREGION}

end.
