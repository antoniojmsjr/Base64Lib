![Maintained YES](https://img.shields.io/badge/Maintained%3F-yes-green.svg?style=flat-square&color=important)
![Memory Leak Verified YES](https://img.shields.io/badge/Memory%20Leak%20Verified%3F-yes-green.svg?style=flat-square&color=important)
![Stars](https://img.shields.io/github/stars/antoniojmsjr/Base64Bitmap.svg?style=flat-square)
![Forks](https://img.shields.io/github/forks/antoniojmsjr/Base64Bitmap.svg?style=flat-square)
![Issues](https://img.shields.io/github/issues/antoniojmsjr/Base64Bitmap.svg?style=flat-square&color=blue)</br>
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

Implementado na linguagem Delphi, utiliza o conceito de [fluent interface](https://en.wikipedia.org/wiki/Fluent_interface) para guiar no uso da biblioteca, desenvolvida para oferecer praticidade e eficiência na codificação e decodificação de dados em Base64.

Desenvolvida especificamente para ambientes Delphi, esta biblioteca oferece uma interface simples e intuitiva, facilitando a codificação e decodificação em Base64, desde a manipulação de strings até a conversão de **tipos complexos**.

#### Tipos complexos:

* `Base64`: É uma forma de codificação que permite representar dados binários usando um conjunto de caracteres seguros, tornando-os adequados para transmissão. É amplamente utilizado em aplicações que lidam com transferência de dados, como em e-mails ou em URLs, para garantir que os dados permaneçam intactos e sem erros durante a transmissão.

* `Bitmap`: É a classe que representa e gerência imagens no Delphi, permitindo manipulações e exibições dentro da interface gráfica de um aplicativo.
A classe TBitmap é usada para criar, carregar, manipular e exibir imagens bitmap na interface do aplicativo. Ela oferece recursos para carregar imagens de arquivos, desenhar na imagem, ajustar suas dimensões, aplicar operações de pintura, entre outros. Essa classe é particularmente útil para trabalhar com gráficos e imagens em aplicações que necessitam de recursos visuais.
As imagens armazenadas em um objeto TBitmap podem ser exibidas em componentes visuais como TImage, TPaintBox, TPicture, TCanvas, entre outros.

* `Stream`: É uma classe que representa um fluxo genérico de dados, permitindo a leitura e escrita de bytes sequenciais. É uma parte central do sistema de I/O do Delphi, oferecendo uma base flexível para manipulação de fluxos de dados em várias formas.
  
* `Bytes`: É um tipo de dado dinâmico que representa um array de bytes. Ele é frequentemente utilizado para armazenar e manipular sequências de dados binários, como arquivos, fluxos de dados, ou buffers em operações de I/O. Sua natureza de array dinâmico permite que ele seja dimensionado conforme necessário, tornando-o uma escolha comum para operações de buffer e manipulação de dados em uma variedade de contextos, desde I/O até processamento de dados em memória.

#### Recursos:

> [!WARNING]\
Para os projetos em **Firemonkey** definir a diretiva de compilação `HAS_FMX`:

![image](https://github.com/antoniojmsjr/Base64Bitmap/assets/20980984/439c248f-7873-4eb8-a86f-f70fb88f25c6)

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

## Uso da biblioteca:

```delphi
uses Utils.Image.pas;
```
### Bitmap para Base64:

```delphi
var
  lBase64: string;
  lItem: TCustomBitmapItem; // FMX.MultiResBitmap
begin
  // ENCODE BITMAP

  //VCL
  lBase64 := TImageUtils.BitmapToBase64(TImage.Picture.Bitmap);

  //FMX
  lItem := TImage.MultiResBitmap.ItemByScale(1, False, True);
  lBase64 := TImageUtils.BitmapToBase64(lItem.Bitmap);
```

### Base64 para Bitmap:

```delphi
var
  lBase64: string;
  lBitmap: TBitmap;
  lItem: TCustomBitmapItem; // FMX.MultiResBitmap
begin
  lBitmap := nil;
  try
    // DECODE BASE64
    lBitmap := TImageUtils.Base64ToBitmap(lBase64);

    //VCL
    TImage.Picture.Assign(nil);
    TImage.Picture.Assign(lBitmap);

    //FMX
    TImage.MultiResBitmap.Clear;
    lItem := TImage.MultiResBitmap.ItemByScale(1, False, True);
    lItem.Bitmap.Assign(lBitmap);
  finally
    lBitmap.Free;
  end;
```

## Exemplos:

### Exemplo compilado

* [FMX](https://github.com/antoniojmsjr/Base64Bitmap/files/12165582/FMX.zip)
* [Client](https://github.com/antoniojmsjr/Base64Bitmap/files/12165588/Client.zip)
* [Server](https://github.com/antoniojmsjr/Base64Bitmap/files/12165595/Server.zip)
  
### Exemplo FMX
```
..\Base64Bitmap\FMX\
```
https://github.com/antoniojmsjr/Base64Bitmap/assets/20980984/d10661f3-0845-41c3-8275-88693117d4df
### Servidor REST(VCL)
```
..\Base64Bitmap\VCL\
```
https://github.com/antoniojmsjr/Base64Bitmap/assets/20980984/f9dab252-22fb-43a5-9ca1-cc7b6c36d75c

## Licença
`Base64Bitmap` is free and open-source software licensed under the [![License](https://img.shields.io/badge/license-MIT%202-blue.svg)](https://github.com/antoniojmsjr/Base64Bitmap/blob/master/LICENSE)
