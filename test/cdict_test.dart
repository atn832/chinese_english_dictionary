import 'package:cdict/cdict.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    Dictionary d;

    setUp(() {
      d = Dictionary();
    });

    test('First Test', () {
      expect(d.translate('石'), '?');
    });
  });
}
