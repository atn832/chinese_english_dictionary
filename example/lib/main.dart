import 'package:chinese_english_dictionary/chinese_english_dictionary.dart';

void main() async {
  final d = ChineseEnglishDictionary();
  final translation = await d.translateTraditional('石');
  print(translation);
}
