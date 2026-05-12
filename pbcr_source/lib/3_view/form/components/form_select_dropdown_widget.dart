import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'package:icreat_dct/3_view/components/button/common_dropdown_button.dart';
import 'package:icreat_dct/9_contants/box_decorations.dart';
import 'package:icreat_dct/theme/extenstion/build_context_ext.dart';
import 'package:icreat_dct/theme/extenstion/text_styles_ext.dart';
import 'package:icreat_dct/theme/text_styles.dart';

import '../form_view_type.dart';

class FormSelectDropdownWidget extends StatelessWidget {
  final bool isReadOnly;
  final List<FormOption> options;
  final String? selectedOptionKey;
  final Function(String) onChangeAnswer;

  const FormSelectDropdownWidget({
    super.key,
    required this.isReadOnly,
    required this.options,
    this.selectedOptionKey,
    required this.onChangeAnswer,
  });

  bool isSelectedAnswer(String optionKey) {
    return selectedOptionKey == optionKey;
  }

  /// answer로부터 현재 선택된 값 파싱해서 반환
  /// 특히 options에서 일치하는 value가 없을경우 에러발생함
  /// 그러므로 없는 경우는 null 반환해야함

  String? get _selectedOptionKey {
    return selectedOptionKey;
  }

  String? get _selectedOptionText {
    if (_selectedOptionKey == null) return null;

    final option = options.firstWhereOrNull((option) => option.key == _selectedOptionKey);
    if (option == null) return null;

    return option.text;
  }

  TextStyle _textStyle(BuildContext context) => TextStyles.body1.primaryColor(context);

  @override
  Widget build(BuildContext context) {
    if (isReadOnly) {
      return _buildReadOnly(context);
    }

    // maxLine이 3이라고 하더라도 선택창에서만 5줄이고 선택된 값은 1줄로 표시됨
    return CommonDropdownButton<String?>(
      value: _selectedOptionKey,
      items: [
        for (final option in options)
          DropdownMenuItem(
            value: option.key,
            child: Text(
              option.text,
              style: _textStyle(context),
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
          ),
      ],
      onChanged: (key) => _handleAnswer(
        options.firstWhere((option) => option.key == key),
      ),
    );
  }

  Widget _buildReadOnly(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecorations.borderBox(context),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _selectedOptionText ?? '',
              style: _textStyle(context),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          Icon(
            Icons.arrow_drop_down,
            color: context.iconDisabled,
          ),
        ],
      ),
    );
  }

  void _handleAnswer(FormOption option) {
    if (isReadOnly) return;
    onChangeAnswer(option.key);
  }
}
