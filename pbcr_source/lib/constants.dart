// ignore_for_file: constant_identifier_names, non_constant_identifier_names

class Constants {
  static final DateTime FIRST_DATETIME = DateTime(1970, 1, 1);
  static final DateTime LAST_DATETIME = DateTime(2100, 12, 31);

  static const int MAX_INT = 9007199254740991;
  static const int MIN_INT = -0x8000000000000000;

  static const double MAX_FLOAT = double.maxFinite;
  static const double MIN_FLOAT = double.minPositive;
}

isNumeric(string) => num.tryParse(string) != null;
