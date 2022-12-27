// [old] variant of 概[gai4]
final _singleVariantRegex = RegExp(r'(?:see also|see|variant of) ([^\[]+)');

/// Internal function to extract original character from references like
/// `variant of 概[gai4]`. Do not use directly.
List<String> getVariantSource(String meaning) {
  final matches = _singleVariantRegex.allMatches(meaning);
  if (matches.isEmpty) return [];

  final match = matches.first;
  final variants = match[match.groupCount];
  return variants.split('|');
}
