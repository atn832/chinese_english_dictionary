A Chinese-English dictionary based on CC-CEDICT.

## Features

- Translates traditional Chinese to English.

## Usage

A simple usage example:

```dart
import 'package:cdict/cdict.dart';

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
