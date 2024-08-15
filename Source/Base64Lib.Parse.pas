{******************************************************************************}
{                                                                              }
{           Base64Lib.Parse.pas                                                }
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
unit Base64Lib.Parse;

interface

uses
  System.SysUtils, System.Classes, Base64Lib.Interfaces, Base64Lib.Types,
  {$IF DEFINED(HAS_FMX)} FMX.Graphics, System.Rtti {$ELSE} Vcl.Graphics {$ENDIF};

type
  TParseCustom = class(TInterfacedObject)
  private
    { private declarations }
    FStream: TBytesStream;
    function AsString: string;
    function AsStream: TStream;
    function AsBytes: TBytes;
    function Size: Int64;
    function MD5: string;
    procedure SaveToFile(const pFileName: string);
  protected
    { protected declarations }
  public
    { public declarations }
    constructor Create(const pBytes: TBytes); reintroduce;
    destructor Destroy; override;
  end;

  TEncodeParse = class(TParseCustom, IEncodeParse);
  TDecodeParse = class(TParseCustom, IDecodeParse)
  private
    { private declarations }
    function AsBitmap: TBitmap;
  protected
    { protected declarations }
  public
    { public declarations }
  end;

implementation

uses
  System.NetEncoding, System.Hash, Vcl.Imaging.jpeg, Vcl.Imaging.pngimage,
  Vcl.Imaging.GIFImg;

{$REGION 'TParseCustom'}
constructor TParseCustom.Create(const pBytes: TBytes);
begin
  FStream := TBytesStream.Create(pBytes);
  FStream.Position := 0;
end;

destructor TParseCustom.Destroy;
begin
  FStream.Free;
  inherited Destroy;
end;

function TParseCustom.MD5: string;
var
  lHashMD5: THashMD5;
begin
  lHashMD5 := THashMD5.Create;
  lHashMD5.Reset;
  lHashMD5.Update(FStream.Bytes);
  Result := lHashMD5.HashAsString;
end;

procedure TParseCustom.SaveToFile(const pFileName: string);
begin
  try
    FStream.Position := 0;
    FStream.SaveToFile(pFileName);
  except
    on E: Exception do
    begin
      raise EBase64Lib.Build
        .Title('Failed to save the file.')
        .Error(E.Message)
        .Hint('Check the error message.')
        .ClassName(Self.ClassName);
    end;
  end;
end;

function TParseCustom.Size: Int64;
begin
  FStream.Position := 0;
  Result := FStream.Size;
end;

function TParseCustom.AsBytes: TBytes;
begin
  FStream.Position := 0;
  Result := FStream.Bytes;
end;

function TParseCustom.AsStream: TStream;
begin
  Result := TStringStream.Create('', TEncoding.UTF8);
  FStream.Position := 0;
  Result.CopyFrom(FStream, 0);
  Result.Position := 0;
end;

function TParseCustom.AsString: string;
begin
  Result := TEncoding.UTF8.GetString(FStream.Bytes);
end;
{$ENDREGION}

{$REGION 'TDecodeParse'}
function TDecodeParse.AsBitmap: TBitmap;
{$IF NOT DEFINED(HAS_FMX)} // VCL
var
  lPicture: TPicture;
{$ENDIF}
begin
  {$IF DEFINED(HAS_FMX)}
  FStream.Position := 0;
  Result := TBitmap.CreateFromStream(FStream);
  {$ELSE} // VCL
  lPicture := TPicture.Create;
  try
    FStream.Position := 0;
    lPicture.LoadFromStream(FStream);

    Result := TBitmap.Create;
    Result.Assign(lPicture.Graphic);
  finally
    lPicture.Free;
  end;
  {$ENDIF}
end;
{$ENDREGION}

end.
