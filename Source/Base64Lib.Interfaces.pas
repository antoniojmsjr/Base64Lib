{******************************************************************************}
{                                                                              }
{           Base64Lib.Interfaces.pas                                           }
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
unit Base64Lib.Interfaces;

interface

uses
  System.SysUtils, System.Classes, System.IOUtils, System.Rtti,
  {$IF DEFINED(HAS_FMX)}FMX.Graphics{$ELSE}Vcl.Graphics{$ENDIF};

type
  IBase64LibEncode = interface;
  IBase64LibDecode = interface;

  IBase64Lib = interface
    ['{79FC8FEE-3B58-4135-9063-764CA80EDBE6}']
    function GetEncode: IBase64LibEncode;
    function GetDecode: IBase64LibDecode;
    function GetVersion: string;

    property Encode: IBase64LibEncode read GetEncode;
    property Decode: IBase64LibDecode read GetDecode;
    property Version: string read GetVersion;
  end;

  IParse = interface
    ['{C5BC9D75-1291-416C-A906-E9E6CBF3A24B}']
    function AsString: string;
    function AsStream: TStream;
    function AsBytes: TBytes;
    function Size: Int64;
    function MD5: string;
    procedure SaveToFile(const FileName: string);
  end;

  IEncodeParse = interface(IParse)
    ['{E6E013E7-0187-4592-AA1B-558655E4323A}']
  end;

  IDecodeParse = interface(IParse)
    ['{59D33757-E67D-443B-87A8-9576A359DBF1}']
    function AsBitmap: TBitmap;
  end;

  IBase64LibEncode = interface
    ['{CA3C82F8-AFA2-4B26-9B35-EB5B048A4F2F}']
    function Bytes(const Value: TBytes): IEncodeParse;
    function Text(const Value: string): IEncodeParse;
    function Stream(Value: TStream; const OwnsObject: Boolean = True): IEncodeParse;
    function &File(const FileName: TFileName): IEncodeParse;
    function Bitmap(Value: TBitmap): IEncodeParse; overload;
    {$IF NOT DEFINED(HAS_FMX)}function Bitmap(Value: TGraphic): IEncodeParse; overload;{$ENDIF}
  end;

  IBase64LibDecode = interface
    ['{59DAEE92-DE47-4471-994A-935E985822C1}']
    function Bytes(const Value: TBytes): IDecodeParse;
    function Text(const Value: string): IDecodeParse;
    function Stream(Value: TStream): IDecodeParse;
    function &File(const FileName: TFileName): IDecodeParse;
  end;

implementation

end.
