import 'package:flutter/material.dart';

import 'package:icreat_dct/3_view/components/button/radio_button.dart';

import '../form_view_type.dart';

class FormSelectRadioWidget extends StatelessWidget {
  final bool isReadOnly;
  final List<FormOption> options;
  final String? selectedOptionKey;
  final Function(String) onChangeAnswer;

  const FormSelectRadioWidget({
    super.key,
    required this.isReadOnly,
    required this.options,
    this.selectedOptionKey,
    required this.onChangeAnswer,
  });

  bool isSelectedAnswer(String optionKey) {
    return selectedOptionKey == optionKey;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: options.length,
      itemBuilder: (context, index) {
        final option = options[index];
        final isSelected = isSelectedAnswer(option.key);

        return InkWell(
          onTap: () => _onTapOption(option),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                RadioButton(
                  isSelected: isSelected,
                  onTap: () => _onTapOption(option),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    option.text,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox.shrink();
      },
    );
  }

  void _onTapOption(FormOption option) {
    if (isReadOnly) {
      return;
    }
    onChangeAnswer(option.key);
  }
}
