{******************************************************************************}
{                                                                              }
{           Base64Lib.Decode.pas                                               }
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
unit Base64Lib.Decode;

interface

uses
  System.SysUtils, System.Classes, Base64Lib.Interfaces,
  {$IF DEFINED(HAS_FMX)} FMX.Graphics, System.Rtti {$ELSE} Vcl.Graphics {$ENDIF};

type
  TBase64LibDecodeCustom = class(TInterfacedObject)
  private
    { private declarations }
  protected
    { protected declarations }
    function Decode(const pInput: TBytes): TBytes; overload;
    function Decode(const pInput: string): TBytes; overload;
    function Decode(pInput: TStream): TBytes; overload;
    function DecodeFile(const pInput: TFileName): TBytes;
  public
    { public declarations }
  end;

  TBase64LibDecode = class(TBase64LibDecodeCustom, IBase64LibDecode)
  private
    { private declarations }
    function Bytes(const pValue: TBytes): IDecodeParse;
    function Text(const pValue: string): IDecodeParse;
    function Stream(pValue: TStream): IDecodeParse;
    function &File(const pFileName: TFileName): IDecodeParse;
  protected
    { protected declarations }
  public
    { public declarations }
  end;

implementation

uses
  System.NetEncoding, Vcl.Imaging.jpeg, Vcl.Imaging.pngimage, Vcl.Imaging.GIFImg,
  Base64Lib.Types, Base64Lib.Parse;

{$REGION 'TBase64LibDecodeCustom'}
function TBase64LibDecodeCustom.Decode(pInput: TStream): TBytes;
var
  lDecoded: TBytesStream;
  lBase64Encoding: TBase64Encoding;
begin
  SetLength(Result, 0);

  lDecoded := TBytesStream.Create;
  try
    lBase64Encoding := TBase64Encoding.Create(0);
    try
      try
        // DECODE(UTF8)
        pInput.Position := 0;
        lBase64Encoding.Decode(pInput, lDecoded);

        Result := Copy(lDecoded.Bytes, 0, lDecoded.Size);
      except
        on E: Exception do
        begin
          raise EBase64Lib.Build
            .Title('Stream decode failed.')
            .Error(E.Message)
            .Hint('Check the error message.')
            .ClassName(E.ClassName);
        end;
      end;
    finally
      lBase64Encoding.Free;
    end;
  finally
    lDecoded.Free;
  end;
end;

function TBase64LibDecodeCustom.Decode(const pInput: string): TBytes;
var
  lBase64Encoding: TBase64Encoding;
begin
  SetLength(Result, 0);

  lBase64Encoding := TBase64Encoding.Create(0);
  try
    try
      // DECODE(UTF8)
      Result := lBase64Encoding.DecodeStringToBytes(pInput);
    except
      on E: Exception do
      begin
        raise EBase64Lib.Build
          .Title('String decode failed.')
          .Error(E.Message)
          .Hint('Check the error message.')
          .ClassName(E.ClassName);
      end;
    end;
  finally
    lBase64Encoding.Free;
  end;
end;

function TBase64LibDecodeCustom.Decode(const pInput: TBytes): TBytes;
var
  lBase64Encoding: TBase64Encoding;
begin
  SetLength(Result, 0);

  lBase64Encoding := TBase64Encoding.Create(0);
  try
    try
      // DECODE(UTF8)
      Result := lBase64Encoding.Decode(pInput);
    except
      on E: Exception do
      begin
        raise EBase64Lib.Build
          .Title('Bytes decode failed.')
          .Error(E.Message)
          .Hint('Check the error message.')
          .ClassName(E.ClassName);
      end;
    end;
  finally
    lBase64Encoding.Free;
  end;
end;

function TBase64LibDecodeCustom.DecodeFile(const pInput: TFileName): TBytes;
var
  lFile: TBytesStream;
  lBase64Encoding: TBase64Encoding;
  lBytes: TBytes;
begin
  if not FileExists(pInput) then
    raise EBase64Lib.Build
      .Title('File decode failed.')
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
      // DECODE(UTF8)
      Result := lBase64Encoding.Decode(lBytes);
    except
      on E: Exception do
      begin
        raise EBase64Lib.Build
          .Title('File decode failed.')
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

{$REGION 'TBase64LibDecode'}
function TBase64LibDecode.Bytes(const pValue: TBytes): IDecodeParse;
var
  lDecoded: TBytes;
begin
  if (Length(pValue) = 0) then
    Exit;

  // DECODE
  lDecoded := Decode(pValue);
  Result := TDecodeParse.Create(lDecoded);
end;

function TBase64LibDecode.&File(const pFileName: TFileName): IDecodeParse;
var
  lDecoded: TBytes;
begin
  if not FileExists(pFileName) then
    Exit;

  // DECODE
  lDecoded := DecodeFile(pFileName);
  Result := TDecodeParse.Create(lDecoded);
end;

function TBase64LibDecode.Stream(pValue: TStream): IDecodeParse;
var
  lDecoded: TBytes;
begin
  if ((pValue = nil) or (pValue.Size = 0)) then
    Exit;

  // DECODE
  lDecoded := Decode(pValue);
  Result := TDecodeParse.Create(lDecoded);
end;

function TBase64LibDecode.Text(const pValue: string): IDecodeParse;
var
  lDecoded: TBytes;
begin
  if (Trim(pValue) = '') then
    Exit;

  // DECODE
  lDecoded := Decode(pValue);
  Result := TDecodeParse.Create(lDecoded);
end;
{$ENDREGION}

end.
