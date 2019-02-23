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
    });
    test('Non existing words', () async {
      expect(await d.translateTraditional('aaa'), equals([]));
    });
  });
}
