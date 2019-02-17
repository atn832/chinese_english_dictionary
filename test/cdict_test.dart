import 'package:cdict/cdict.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    Dictionary d;

    setUp(() {
      d = Dictionary();
    });

    test('First Test', () async {
      expect(await d.translateTraditional('石'), '/rock/stone/stone inscription/one of the eight ancient musical instruments 八音[ba1 yin1]/');
    });
  });
}
