import 'package:cdict/src/dictionary_entry.dart';
import 'package:resource/resource.dart' show Resource;
import 'dart:convert' show utf8;

Map<String, DictionaryEntry> simplifiedDictionary;
Map<String, DictionaryEntry> traditionalDictionary;

//DNA鑒定 DNA鉴定 [D N A jian4 ding4] /DNA test/DNA testing/
final entryRegex = RegExp(r'^([^ ]+) ([^ ]+) \[([^\]]+)\] (.+)');

/// Checks if you are awesome. Spoiler: you are.
class Dictionary {
  init() async {
    if (simplifiedDictionary != null) {
      return;
    }
    final resource = new Resource("package:cdict/src/cedict_ts.u8");
    final string = await resource.readAsString(encoding: utf8);
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
        ..meanings = [meanings];
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

  Future<List<String>> translateTraditional(String chinese) async {
    await init();
    return traditionalDictionary[chinese].meanings;
  }
}
