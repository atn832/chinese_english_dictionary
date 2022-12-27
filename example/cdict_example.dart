import 'package:cdict/cdict.dart';

void main() async {
  final d = ChineseEnglishDictionary();
  final translation = await d.translateTraditional('石');
  print(translation);
}
