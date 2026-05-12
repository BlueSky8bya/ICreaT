import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:icreat_dct/3_view/components/text_field/outline_text_field.dart';
import 'package:icreat_dct/8_extension/string_ext.dart';


enum TextAreaType {
  normal,
  number,
  decimal,
  multiline,
}

class FormSelectTextAreaWidget extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? suffix;
  final TextAreaType textAreaType;
  final Function(String)? onChangeAnswer;
  final int? maxLength;
  final bool isReadOnly;
  
  const FormSelectTextAreaWidget({
    super.key,
    required this.controller,
    this.hintText,
    this.suffix,
    this.onChangeAnswer,
    this.textAreaType = TextAreaType.normal,
    this.maxLength = 5000,
    this.isReadOnly = false,
  });

  TextInputFormatter? get textAreaTypeFormatter {
    switch (textAreaType) {
      case TextAreaType.number:
        return FilteringTextInputFormatter.digitsOnly;
      case TextAreaType.decimal:
        return FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'));
      default:
        return null;
    }
  }

  TextInputType? get textInputType {
    switch (textAreaType) {
      case TextAreaType.number:
        return TextInputType.number;
      case TextAreaType.decimal:
        return TextInputType.numberWithOptions(decimal: true);
      case TextAreaType.multiline:
        return TextInputType.multiline;
      default:
        return null;
    }
  }

  int? get _minLines {
    switch (textAreaType) {
      case TextAreaType.multiline:
        return 3;
      default:
        return null;
    }
  }

  int? get _maxLines {
    switch (textAreaType) {
      case TextAreaType.multiline:
        return 10;
      default:
        return null;
    }
  }

  bool get _showCounter {
    switch (textAreaType) {
      case TextAreaType.multiline:
        return true;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return OutlineTextField(
      controller: controller,
      readOnly: isReadOnly,
      hintText: hintText,
      onChanged: onChangeAnswer,
      minLines: _minLines,
      maxLines: _maxLines,
      keyboardType: textInputType,
      inputFormatters: [
        if (textAreaTypeFormatter != null) textAreaTypeFormatter!,
      ],
      showCounter: _showCounter,
      maxLength: maxLength,
      suffix: suffix.isNullOrEmpty ? null : Text(suffix!),
    );
  }
}
