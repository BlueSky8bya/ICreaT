import 'package:flutter/material.dart';

extension TextEditingControllerExt on TextEditingController {
  setInitText(String text) {
    this.text = text;
    selection = TextSelection.fromPosition(TextPosition(offset: text.length));
  }
}
