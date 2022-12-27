# Chinese-English Dictionary

[![pub package](https://img.shields.io/pub/v/chinese_english_dictionary.svg)](https://pub.dartlang.org/packages/chinese_english_dictionary)

A Chinese-English dictionary based on CC-CEDICT.

## Features

- Translates traditional Chinese to English.

## Usage

A simple usage example:

```dart
import 'package:chinese_english_dictionary/chinese_english_dictionary.dart';

void main() async {
  final d = ChineseEnglishDictionary();
  final translation = await d.translateTraditional('石');
  print(translation);
}
```

Prints out:

> [rock, stone, stone inscription, one of the eight categories of ancient musical instruments 八音[ba1 yin1]]

## Developer notes

To update the dictionary, download the latest version from https://www.mdbg.net/chinese/dictionary?page=cc-cedict and copy/paste the dictionary into cedict_ts.u8.dart.
