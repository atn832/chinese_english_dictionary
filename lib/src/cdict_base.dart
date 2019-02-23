import 'package:cdict/src/dictionary_entry.dart';
import 'package:cdict/src/cedict_ts.u8.dart';

Map<String, DictionaryEntry> simplifiedDictionary;
Map<String, DictionaryEntry> traditionalDictionary;

//DNA鑒定 DNA鉴定 [D N A jian4 ding4] /DNA test/DNA testing/
final entryRegex = RegExp(r'^([^ ]+) ([^ ]+) \[([^\]]+)\] (.+)');

/// Checks if you are awesome. Spoiler: you are.
class Dictionary {
  init() {
    if (simplifiedDictionary != null) {
      return;
    }
    final string = rawDictionary;
    final lines = string.split('\n').where((line) => !line.startsWith('#')).toList();
    final dictionaryEntries = lines.map((line) {
      final matches = entryRegex.allMatches(line);
      assert(matches.length == 1);
      final match = matches.first;
      assert(match.groupCount == 4);
      final traditional = match[1];
      final simplified = match[2];
      final pinyin = match[3];
      final meanings = match[4];
      return DictionaryEntry()
        ..traditional = traditional
        ..simplified = simplified
        ..pinyin = pinyin
        ..meanings = getSplitMeanings(meanings);
    }).toList();
    simplifiedDictionary = Map.fromIterable(
      dictionaryEntries,
      key: (entry) => entry.simplified,
      value: (entry) => entry
    );
    traditionalDictionary = Map.fromIterable(
      dictionaryEntries,
      key: (entry) => entry.traditional,
      value: (entry) => entry
    );
  }

  // '/rock/stone/stone inscription/one of the eight ancient musical instruments 八音[ba1 yin1]/'
  List<String> getSplitMeanings(String slashSeparatedMeanings) {
    return slashSeparatedMeanings.split('/').where((m) => m.isNotEmpty).toList();
  }

  Future<List<String>> translateTraditional(String chinese) async {
    init();
    return Future.value(traditionalDictionary[chinese].meanings);
  }
}
