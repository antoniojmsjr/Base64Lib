{******************************************************************************}
{                                                                              }
{           Base64Lib.Types.pas                                                }
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
unit Base64Lib.Types;

interface

uses
  System.SysUtils, System.Classes,
  {$IF DEFINED(HAS_FMX)} FMX.Graphics {$ELSE} Vcl.Graphics {$ENDIF};

type
  EBase64Lib = class(Exception)
  private
    { private declarations }
    FTitle: string;
    FHint: string;
    FClassName: string;
  protected
    { protected declarations }
  public
    { public declarations }
    function Title: string; overload;
    function Title(const Value: string): EBase64Lib; overload;
    function Title(const Format: string; const Values: array of const): EBase64Lib; overload;
    function Error: string; overload;
    function Error(const Value: string): EBase64Lib; overload;
    function Error(const Format: string; const Values: array of const): EBase64Lib; overload;
    function Hint: string; overload;
    function Hint(const Value: string): EBase64Lib; overload;
    function Hint(const Format: string; const Values: array of const): EBase64Lib; overload;
    function ClassName: string; overload;
    function ClassName(const Value: string): EBase64Lib; overload;
    function ToString: string; override;
    class function Build: EBase64Lib;
  end;

implementation

{$REGION 'EBase64Lib'}
class function EBase64Lib.Build: EBase64Lib;
begin
  Result := inherited Create(EmptyStr);
end;

function EBase64Lib.ClassName(const Value: string): EBase64Lib;
begin
  Result := Self;
  FClassName := Trim(Value);
end;

function EBase64Lib.ClassName: string;
begin
  Result := FClassName;
end;

function EBase64Lib.Error: string;
begin
  Result := Self.Message;
end;

function EBase64Lib.Error(const Value: string): EBase64Lib;
begin
  Result := Self;
  Self.Message := Trim(Value);
end;

function EBase64Lib.Error(const Format: string; const Values: array of const): EBase64Lib;
begin
  Result := Self;
  Self.Message := System.SysUtils.Format(Format, Values, FormatSettings);
end;

function EBase64Lib.Hint: string;
begin
  Result := FHint;
end;

function EBase64Lib.Hint(const Value: string): EBase64Lib;
begin
  Result := Self;
  FHint := Trim(Value);
end;

function EBase64Lib.Hint(const Format: string; const Values: array of const): EBase64Lib;
begin
  Result := Self;
  FHint := System.SysUtils.Format(Format, Values, FormatSettings);
end;

function EBase64Lib.Title(const Format: string; const Values: array of const): EBase64Lib;
begin
  Result := Self;
  FTitle := System.SysUtils.Format(Format, Values, FormatSettings);
end;

function EBase64Lib.Title(const Value: string): EBase64Lib;
begin
  Result := Self;
  FTitle := Trim(Value);
end;

function EBase64Lib.Title: string;
begin
  Result := FTitle;
end;

function EBase64Lib.ToString: string;
var
  lResult: TStringBuilder;
begin
  Result := EmptyStr;

  lResult := TStringBuilder.Create;
  try
    lResult.AppendFormat('Title: %s%s', [Self.Title, sLineBreak]);
    lResult.AppendFormat('Error: %s%s', [Self.Error, sLineBreak]);
    lResult.AppendFormat('Hint: %s%s', [Self.Hint, sLineBreak]);
    lResult.AppendFormat('Class Name: %s%s', [Self.ClassName, sLineBreak]);

    Result := lResult.ToString;
  finally
    lResult.Free;
  end;
end;
{$ENDREGION}

end.
