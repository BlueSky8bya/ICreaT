import 'package:flutter/services.dart';

class TextFieldInputFormatter {
  static final numberOnlyInputFormatter =
      FilteringTextInputFormatter.allow(RegExp(r'[0-9]'));

  static final decimalOnlyInputFormatter =
      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'));
}
