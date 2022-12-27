import 'package:chinese_english_dictionary/chinese_english_dictionary.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    ChineseEnglishDictionary d;

    setUp(() {
      d = ChineseEnglishDictionary();
    });

    test('Results', () async {
      expect(
          await d.translateTraditional('石'),
          equals([
            'rock',
            'stone',
            'stone inscription',
            'one of the eight categories of ancient musical instruments 八音[ba1 yin1]'
          ]));
      expect(
          await d.translateTraditional('子'),
          equals([
            'son',
            'child',
            'seed',
            'egg',
            'small thing',
            '1st earthly branch: 11 p.m.-1 a.m., midnight, 11th solar month (7th December to 5th January), year of the Rat',
            'Viscount, fourth of five orders of nobility 五等爵位[wu3 deng3 jue2 wei4]',
            'ancient Chinese compass point: 0° (north)'
          ]));
    });
    test('Non existing words', () async {
      expect(await d.translateTraditional('aaa'), equals([]));
    });

    test('getVariantSource', () {
      // No source.
      expect(d.getVariantSource('child'), equals([]));
      // Single source.
      expect(d.getVariantSource('variant of 概[gai4]'), equals(['概']));
      // Multiple source.
      expect(d.getVariantSource('variant of 獎|奖[jiang3]'), equals(['獎', '奖']));
      // old variant of...
      expect(d.getVariantSource('old variant of 姊[zi3]'), equals(['姊']));
      // japanese variant of...
      expect(d.getVariantSource('Japanese variant of 產|产'), equals(['產', '产']));
      // see...
      expect(d.getVariantSource('see 犯不著|犯不着[fan4 bu5 zhao2]'),
          equals(['犯不著', '犯不着']));
      // see also...
      expect(
          d.getVariantSource('see also 新儒家[Xin1 Ru2 jia1]'), equals(['新儒家']));
    });

    test('Find variant meanings', () async {
      // variant of 概[gai4]
      expect(await d.translateTraditional('槪'),
          equals(await d.translateTraditional('概')));
      // variant of 據|据[ju4]
      expect(await d.translateTraditional('㨿'),
          equals(await d.translateTraditional('據')));
    });

    test('Look for infinite loops', () async {
      final words = await d.getEntries();
      for (final word in words) {
        await d.translateTraditional(word);
      }
    });
  });
}
