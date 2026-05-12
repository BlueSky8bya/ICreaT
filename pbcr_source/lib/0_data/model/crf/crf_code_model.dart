class CRFCodeModel {
  final String code;
  final String name;

  const CRFCodeModel({
    required this.code,
    required this.name,
  });

  /// "1=Not done|2=Done", "a=A|b=B"
  static List<CRFCodeModel> fromString(String codeList) {
    List<CRFCodeModel> list = [];
    for (var cv in codeList.split('|')) {
      if (cv.isEmpty) {
        continue;
      }

      final keyValue = cv.split('=');
      if (keyValue.length < 2) {
        continue;
      }

      list.add(CRFCodeModel(code: keyValue[0], name: keyValue[1]));
    }
    return list;
  }
}
