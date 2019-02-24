import 'package:cdict/cdict.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    Dictionary d;

    setUp(() {
      d = Dictionary();
    });

    test('Results', () async {
      expect(await d.translateTraditional('石'), 
        equals(['rock', 'stone', 'stone inscription', 'one of the eight ancient musical instruments 八音[ba1 yin1]']));
      expect(await d.translateTraditional('子'), 
        equals(['son', 'child', 'seed', 'egg', 'small thing', '1st earthly branch: 11 p.m.-1 a.m., midnight, 11th solar month (7th December to 5th January), year of the Rat', 'Viscount, fourth of five orders of nobility 五等爵位[wu3 deng3 jue2 wei4]', 'ancient Chinese compass point: 0° (north)']));
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
    });

    test('Find variant meanings', () async {
      expect(await d.translateTraditional('槪'), equals(['general', 'approximate']));
    });
  });
}
