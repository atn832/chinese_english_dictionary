import 'cedict_ts.u8.dart';
import 'dictionary_entry.dart';
import 'util.dart';

Map<String, DictionaryEntry> _traditionalDictionary;

// DNA鑒定 DNA鉴定 [D N A jian4 ding4] /DNA test/DNA testing/
final _entryRegex = RegExp(r'^([^ ]+) ([^ ]+) \[([^\]]+)\] (.+)');

/// Chinese-English Dictionary.
class ChineseEnglishDictionary {
  Future<void> _init() async {
    if (_traditionalDictionary != null) {
      return;
    }
    final string = rawDictionary;
    final lines =
        string.split('\n').where((line) => !line.startsWith('#')).toList();
    final dictionaryEntries = lines.map((line) {
      final matches = _entryRegex.allMatches(line);
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
        ..meanings = _getSplitMeanings(meanings);
    }).toList();

    _traditionalDictionary = {};
    dictionaryEntries.forEach((entry) {
      final key = entry.traditional;
      if (_traditionalDictionary.containsKey(key) &&
          _traditionalDictionary[key].meanings.length > entry.meanings.length) {
        return;
      }
      _traditionalDictionary[key] = entry;
    });
  }

  // '/rock/stone/stone inscription/one of the eight ancient musical instruments 八音[ba1 yin1]/'
  static List<String> _getSplitMeanings(String slashSeparatedMeanings) {
    return slashSeparatedMeanings
        .split('/')
        .where((m) => m.isNotEmpty)
        .toList();
  }

  Future<Iterable<String>> getEntries() async {
    await _init();
    return _traditionalDictionary.keys;
  }

  /// Translate traditional Chinese. Automatically replaces references to other
  /// words such as `variant of 概[gai4]` to that reference's meanings.
  Future<List<String>> translateTraditional(String chinese) async {
    await _init();
    final entry = _traditionalDictionary[chinese];
    if (entry == null) return Future.value(<String>[]);

    final completeMeanings = _followVariants(entry.meanings);
    return completeMeanings;
  }

  /// Translate traditional Chinese. Leaves references to other words such as
  /// `variant of 概[gai4]` as is.
  List<String> translateTraditionalDirect(String chinese) {
    final entry = _traditionalDictionary[chinese];
    if (entry == null) return [];
    return entry.meanings;
  }

  List<String> _followVariants(List<String> meanings) {
    final variantsFollowed = <String>{};
    var result = _followVariantsR(meanings, variantsFollowed);
    while (result.followedSome) {
      result = _followVariantsR(result.meanings, variantsFollowed);
    }
    return result.meanings;
  }

  _FollowVariantResult _followVariantsR(
      List<String> meanings, Set<String> variantsFollowed) {
    var newMeanings = <String>[];
    var followedSome = false;
    for (final m in meanings) {
      final sources = getVariantSource(m);
      if (sources.isEmpty) {
        // Pass-through
        newMeanings.add(m);
      } else {
        // Fetch new meanings
        for (final s in sources) {
          if (variantsFollowed.contains(s)) continue;

          final otherMeanings = translateTraditionalDirect(s);
          newMeanings.addAll(otherMeanings);
          variantsFollowed.add(s);
          followedSome = true;
        }
        ;
      }
    }
    return _FollowVariantResult()
      ..followedSome = followedSome
      ..meanings = newMeanings;
  }
}

class _FollowVariantResult {
  List<String> meanings;
  bool followedSome;
}
