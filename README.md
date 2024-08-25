![Maintained YES](https://img.shields.io/badge/Maintained%3F-yes-green.svg?style=flat-square&color=important)
![Memory Leak Verified YES](https://img.shields.io/badge/Memory%20Leak%20Verified%3F-yes-green.svg?style=flat-square&color=important)
![Stars](https://img.shields.io/github/stars/antoniojmsjr/Base64Lib.svg?style=flat-square)
![Forks](https://img.shields.io/github/forks/antoniojmsjr/Base64Lib.svg?style=flat-square)
![Issues](https://img.shields.io/github/issues/antoniojmsjr/Base64Lib.svg?style=flat-square&color=blue)</br>
![Compatibility](https://img.shields.io/badge/Compatibility-VCL,%20Firemonkey,%20DataSnap,%20Horse,%20RDW,%20RADServer-3db36a?style=flat-square)
![Delphi Supported Versions](https://img.shields.io/badge/Delphi%20Supported%20Versions-XE7%20and%20higher-3db36a?style=flat-square)

</br>
<p align="center">
  <a href="https://github.com/antoniojmsjr/Base64Lib/blob/main/Image/Logo.png">
    <img alt="IPGeolocation" height="200" width="400" src="https://github.com/antoniojmsjr/Base64Lib/blob/main/Image/Logo.png">
  </a>
</p>
</br>

# Base64Lib

**Base64Lib** é uma biblioteca de **codificação** e **decodificação** de dados em **Base64**.

Implementado na linguagem Delphi, utiliza o conceito de [fluent interface](https://en.wikipedia.org/wiki/Fluent_interface) para guiar no uso da biblioteca, oferece uma interface simples e intuitiva, facilitando a codificação e decodificação em Base64, desde a manipulação de strings até a conversão de **tipos complexos**.

Para mais informações, consultar **[Wiki](https://github.com/antoniojmsjr/Base64Lib/wiki)**.

#### Recursos

* Facilidade de Integração: Com uma interface amigável e documentação detalhada, a Base64Lib é fácil de integrar em qualquer projeto.
* Flexibilidade: Base64Lib suporta diferentes tipos de dados, desde `string` até tipos complexos(`TBitmap`, `TPicture`, `TStream`, `TBytes` e etc.), permitindo uma ampla gama de aplicações, desde comunicação entre sistemas até armazenamento.
* Exemplos de uso: Repositório com diversos exemplos de uso da biblioteca, por exemplo, VCL, FMX e um servidor de aplicação em [Horse](https://github.com/HashLoad/horse).
</br>

> [!WARNING]\
Para os projetos em **Firemonkey** definir a diretiva de compilação `HAS_FMX` em *conditional defines*:

<a href="https://github.com/user-attachments/assets/db3d20a6-8ee0-4b16-a03c-832bc14561e3">
    <img alt="IPGeolocation" height="500" width="700" src="https://github.com/user-attachments/assets/db3d20a6-8ee0-4b16-a03c-832bc14561e3">
  </a>

## ⚙️ Instalação Automatizada

Utilizando o [**Boss**](https://github.com/HashLoad/boss/releases/latest) (Dependency manager for Delphi) é possível instalar a biblioteca de forma automatizada.

```
boss install https://github.com/antoniojmsjr/Base64Lib
```

## ⚙️ Instalação Manual

Se você optar por instalar manualmente, basta adicionar as seguintes pastas ao seu projeto, em *Project > Options > Delphi Compiler > Target > All Configurations > Search path*

```
..\Base64Lib\Source
```

## ⚡️ Uso da biblioteca

Os exemplos estão disponíveis na pasta do projeto:

```
..\Base64Lib\Samples
```

### [Codificação](https://github.com/antoniojmsjr/Base64Lib/wiki/Encode)

```delphi
Uses
  Base64Lib;
```
#### Texto >> Base64

```delphi
var
  lEncode: IEncodeParse;
  lBase64: string;
  lBase64Size: Int64;
  lBase64MD5: string;
begin
  lEncode := TBase64Lib
    .Build
      .Encode
        .Text('Base64Lib');

  lBase64 := lEncode.AsString;
  lBase64Size := lEncode.Size;
  lBase64MD5 := lEncode.MD5;
end;
```

#### Image >> Base64
```delphi
var
  lEncode: IEncodeParse;
  lBase64: string;
  lBase64Size: Int64;
  lBase64MD5: string;
begin
  lEncode := TBase64Lib
    .Build
      .Encode
        .Bitmap(Timage.Picture); // VCL

  lEncode := TBase64Lib
    .Build
      .Encode
        .Bitmap(Timage.Bitmap); // FMX

  lBase64 := lEncode.AsString;
  lBase64Size := lEncode.Size;
  lBase64MD5 := lEncode.MD5;
```

### [Decodificação](https://github.com/antoniojmsjr/Base64Lib/wiki/Decode)

#### Base64 >> Texto
```delphi
var
  lDecode: IDecodeParse;
  lText: string;
  lSize: Int64;
  lMD5: string;
begin
  lDecode := TBase64Lib
    .Build
      .Decode
        .Text('QmFzZTY0TGli');

  if not Assigned(lDecode) then
    Exit;

  lText := lDecode.AsString;
  lSize := lDecode.Size;
  lMD5 := lDecode.MD5;
end;
```

#### Base64 >> Image
```delphi
var
  lDecode: IDecodeParse;
  lBitmapStream: TStream;
  lBitmap: TBitmap;
  lPicture: TPicture;
  lItem: TCustomBitmapItem; // FMX - Unit FMX.MultiResBitmap
  lRect: TRect; // FMX
  lSize: Int64;
  lMD5: string;
begin
  lDecode := TBase64Lib
    .Build
      .Decode
        .Text('QmFzZTY0TGli');

  if not Assigned(lDecode) then
    Exit;
  
  // VCL
  lPicture := nil;
  try
    lPicture := lDecode.AsPicture;
    
    TImage.Picture.Assign(nil);
    TImage.Picture.Assign(lPicture);
  finally
    lPicture.Free;
  end;

  // FMX
  lBitmap := nil;
  try
    lBitmap := lDecode.AsBitmap;

    lRect := TRect.Create(TPoint.Zero);
    lRect.Left := 0;
    lRect.Top := 0;
    lRect.Width := lBitmap.Bounds.Width;
    lRect.Height := lBitmap.Bounds.Height;

    imgFileBase64ToBitmap.MultiResBitmap.Clear;
    lItem := imgFileBase64ToBitmap.MultiResBitmap.ItemByScale(1, False, True);
    lItem.Bitmap.Width := lBitmap.Bounds.Width;
    lItem.Bitmap.Height  := lBitmap.Bounds.Height;
    lItem.Bitmap.CopyFromBitmap(lBitmap, lRect, 0, 0);
  finally
    lBitmap.Free;
  end;

  OU

  // FMX
  lBitmapStream := nil;
  try
    lBitmapStream := lDecode.AsStream;

    imgFileBase64ToBitmap.MultiResBitmap.Clear;
    lItem := imgFileBase64ToBitmap.MultiResBitmap.ItemByScale(1, False, True);
    lItem.Bitmap.LoadFromStream(lBitmapStream);
  finally
    lBitmapStream.Free;
  end;

  lSize := lDecode.Size;
  lMD5 := lDecode.MD5;
end;
```

#### Exemplo compilado

* [Base64LibApp](https://github.com/user-attachments/files/16621611/Base64LibApp.zip)
* [FMX](https://github.com/user-attachments/files/16621577/FMX.zip)
* [Client](https://github.com/user-attachments/files/16621589/Client.zip)
* [Server](https://github.com/user-attachments/files/16621609/Server.zip)

#### Exemplo Base64LibApp
```
..\Base64Lib\Samples\Base64LibApp\
```
https://github.com/user-attachments/assets/b9fa6dd4-aff4-4ad4-bbde-1332c4b5d6ed
#### Exemplo FMX
```
..\Base64Lib\Samples\Bitmap\FMX\
```
https://github.com/user-attachments/assets/222719ca-8b65-4297-b3b4-c654ca0b2114
#### Servidor REST(VCL)
```
..\Base64Lib\Samples\Bitmap\VCL\
```
https://github.com/user-attachments/assets/2a2b3cd5-5720-456e-a900-5b8c1117dc06

## Licença
`Base64Lib` is free and open-source software licensed under the [![License](https://img.shields.io/badge/license-MIT%202-blue.svg)](https://github.com/antoniojmsjr/Base64Lib/blob/master/LICENSE)

[:arrow_up: Ir para o Topo](https://github.com/antoniojmsjr/Base64Lib/tree/main#base64lib)
