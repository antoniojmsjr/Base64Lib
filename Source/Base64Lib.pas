{******************************************************************************}
{                                                                              }
{           Base64Lib.pas                                                      }
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
unit Base64Lib;

interface

uses
  Base64Lib.Interfaces, Base64Lib.Types;

type

  IBase64Lib = Base64Lib.Interfaces.IBase64Lib;
  IEncodeParse = Base64Lib.Interfaces.IEncodeParse;
  IDecodeParse = Base64Lib.Interfaces.IDecodeParse;
  EBase64Lib = Base64Lib.Types.EBase64Lib;

  TBase64Lib = class sealed(TInterfacedObject, IBase64Lib)
  strict private
    { private declarations }
    FEncode: IBase64LibEncode;
    FDecode: IBase64LibDecode;
    function GetEncode: IBase64LibEncode;
    function GetDecode: IBase64LibDecode;
    function GetVersion: string;
  protected
    { protected declarations }
  public
    { public declarations }
    class function Build: IBase64Lib;
  end;

implementation

uses
  Base64Lib.Encode, Base64Lib.Decode;

{$I Base64Lib.inc}

{$REGION 'TBase64Lib'}
class function TBase64Lib.Build: IBase64Lib;
begin
  Result := Self.Create;
end;

function TBase64Lib.GetDecode: IBase64LibDecode;
begin
  if not Assigned(FDecode) then
    FDecode := TBase64LibDecode.Create;
  Result := FDecode;
end;

function TBase64Lib.GetEncode: IBase64LibEncode;
begin
  if not Assigned(FEncode) then
    FEncode := TBase64LibEncode.Create;
  Result := FEncode;
end;

function TBase64Lib.GetVersion: string;
begin
  Result := Base64LibVersion;
end;
{$ENDREGION}

end.
