import 'package:cdict/src/dictionary_entry.dart';
import 'package:cdict/src/cedict_ts.u8.dart';

Map<String, DictionaryEntry> traditionalDictionary;

// DNA鑒定 DNA鉴定 [D N A jian4 ding4] /DNA test/DNA testing/
final entryRegex = RegExp(r'^([^ ]+) ([^ ]+) \[([^\]]+)\] (.+)');

// [old] variant of 概[gai4]
final singleVariantRegex = RegExp(r'variant of (.+)\[.+$');

/// Checks if you are awesome. Spoiler: you are.
class Dictionary {
  init() async {
    if (traditionalDictionary != null) {
      return;
    }
    final string = rawDictionary;
    final lines =
        string.split('\n').where((line) => !line.startsWith('#')).toList();
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

    traditionalDictionary = Map();
    dictionaryEntries.forEach((entry) {
      final key = entry.traditional;
      if (traditionalDictionary.containsKey(key) &&
          traditionalDictionary[key].meanings.length > entry.meanings.length) {
        return;
      }
      traditionalDictionary[key] = entry;
    });
  }

  // '/rock/stone/stone inscription/one of the eight ancient musical instruments 八音[ba1 yin1]/'
  List<String> getSplitMeanings(String slashSeparatedMeanings) {
    return slashSeparatedMeanings
        .split('/')
        .where((m) => m.isNotEmpty)
        .toList();
  }

  Future<Iterable<String>> getEntries() async {
    await init();
    return traditionalDictionary.keys;
  }

  Future<List<String>> translateTraditional(String chinese) async {
    await init();
    final entry = traditionalDictionary[chinese];
    if (entry == null) return Future.value(<String>[]);

    final completeMeanings = followVariants(entry.meanings);
    return completeMeanings;
  }

  translateTraditionalDirect(String chinese) {
    final entry = traditionalDictionary[chinese];
    if (entry == null) return Future.value(<String>[]);
    return entry.meanings;
  }

  Future<List<String>> followVariants(List<String> meanings) async {
    final variantsFollowed = Set<String>();
    var result = await followVariantsR(meanings, variantsFollowed);
    while (result.followedSome) {
      result = await followVariantsR(result.meanings, variantsFollowed);
    }
    return result.meanings;
  }

  Future<FollowVariantResult> followVariantsR(
      List<String> meanings, Set<String> variantsFollowed) async {
    List<String> newMeanings = List();
    bool followedSome = false;
    for (final m in meanings) {
      final sources = getVariantSource(m);
      if (sources.isEmpty) {
        // Pass-through
        newMeanings.add(m);
      } else {
        // Fetch new meanings
        for (final s in sources) {
          if (variantsFollowed.contains(s)) continue;

          final otherMeanings = await translateTraditionalDirect(s);
          newMeanings.addAll(otherMeanings);
          variantsFollowed.add(s);
          followedSome = true;
        }
        ;
      }
    }
    return FollowVariantResult()
      ..followedSome = followedSome
      ..meanings = newMeanings;
  }

  List<String> getVariantSource(String meaning) {
    final matches = singleVariantRegex.allMatches(meaning);
    if (matches.isEmpty) return [];

    final match = matches.first;
    final variants = match[match.groupCount];
    return variants.split('|');
  }
}

class FollowVariantResult {
  List<String> meanings;
  bool followedSome;
}
