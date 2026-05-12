import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:icreat_dct/3_view/components/button/solid_button.dart';
import 'package:icreat_dct/3_view/components/text_field/text_field_state.dart';
import 'package:icreat_dct/theme/extenstion/text_styles_ext.dart';
import 'package:icreat_dct/theme/text_styles.dart';

class OutlineTextField extends StatefulWidget {
  const OutlineTextField({
    super.key,
    this.showCounter = false,
    this.showErrMsg = true,
    this.bottom,
    this.onTapEnter,
    this.controller,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.autofocus = false,
    this.readOnly = false,
    this.minLines,
    this.maxLines,
    this.maxLength,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.onEditingComplete,
    this.validator,
    this.inputFormatters,
    this.enabled = true,
    this.scrollPhysics,
    this.canRequestFocus = true,
    this.padding,
    this.hintText,
    this.unfocusOnTapOutside = true,
    this.readOnlyBackgroundColor,
    this.borderRadius,
    this.label,
    this.prefix,
    this.suffix,
    this.prefixSpacing,
    this.suffixSpacing,
    this.obscureText = false,
  });

  // category.MultiLineTextArea props ---
  final bool showCounter;
  final bool showErrMsg;
  final Widget? bottom;

  /// onTapEnter값이 null이 아니면 enter 버튼 show
  final VoidCallback? onTapEnter;
  // category.MultiLineTextArea props --- END

  final bool readOnly;
  final bool enabled;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool autofocus;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final void Function()? onTap;
  final void Function()? onEditingComplete;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final ScrollPhysics? scrollPhysics;
  final bool canRequestFocus;
  // custom props
  final EdgeInsetsGeometry? padding;
  final String? hintText;
  final bool unfocusOnTapOutside;
  final Color? readOnlyBackgroundColor;
  final double? borderRadius;
  final Widget? label;
  final Widget? prefix;
  final Widget? suffix;

  final double? prefixSpacing;
  final double? suffixSpacing;
  final bool obscureText;
  @override
  State<OutlineTextField> createState() => _OutlineTextFieldState();
}

class _OutlineTextFieldState extends State<OutlineTextField>
    with TickerProviderStateMixin {
  final RxString _text = ''.obs;
  late final int? _maxLength;
  TextFieldState _origTextState = TextFieldState.default$;
  final Rx<TextFieldState> _textState = TextFieldState.default$.obs;
  final RxBool _hasFocus = false.obs;
  final RxString _errMsg = ''.obs;

  Worker? _textStateWorker;
  Worker? _validateWorker;
  Worker? _focusWorker;

  int get _currentLength => _text.value.length;
  bool get _isFilled => _currentLength != 0;
  bool get _showEnterButton => widget.onTapEnter != null;
  bool get _hasErrMsg => _errMsg.value.isNotEmpty;

  bool get _showBottom {
    if (widget.showErrMsg && _hasErrMsg) {
      return true;
    }
    if (widget.showCounter) {
      return true;
    }
    return false;
  }

  TextEditingController? get _controller => widget.controller;
  FocusNode? get _focusNode => widget.focusNode;

  String get _hintText => widget.hintText ?? '';

  TextStyle _hintTextStyle(BuildContext context) =>
      TextStyles.body2.tertiaryColor(context);

  // TextState에 따른 스타일

  double _errorOpacity(BuildContext context) =>
      _textState.value.errorOpacity(context);

  Border _boxBorder(BuildContext context) {
    if (widget.readOnly) {
      return TextFieldState.filled.border(context);
    }

    return _textState.value.border(context);
  }

  Color _boxBackgroundColor(BuildContext context) {
    if (widget.readOnly) {
      return widget.readOnlyBackgroundColor ??
          TextFieldState.filled.backgroundColor(context);
    }

    return _textState.value.backgroundColor(context);
  }

  Color _cursorColor(BuildContext context) {
    if (widget.readOnly) {
      return TextFieldState.filled.cursorColor(context);
    }

    return _textState.value.cursorColor(context);
  }

  TextStyle _textStyle(BuildContext context) {
    if (widget.readOnly) {
      return TextFieldState.filled.textStyle(context);
    }

    return _textState.value.textStyle(context);
  }

  TextStyle _counterTextStyle(BuildContext context) {
    if (widget.readOnly) {
      return TextFieldState.filled.counterTextStyle(context);
    }

    return _textState.value.counterTextStyle(context);
  }

  @override
  void initState() {
    super.initState();
    _initVariables();

    _initTextState();
    _initWorker();
  }

  void _initVariables() {
    _maxLength = widget.maxLength;
    _hasFocus.value = _focusNode?.hasFocus ?? false;
    _text.value = _controller?.text ?? '';
  }

  @override
  void dispose() {
    super.dispose();
    _textStateWorker?.dispose();
    _validateWorker?.dispose();
    _focusWorker?.dispose();
  }

  void _initTextState() {
    if (!widget.enabled) {
      _textState.value = TextFieldState.disabled;
    } else if (_hasErrMsg) {
      _textState.value = TextFieldState.error;
    } else if (_hasFocus.value) {
      _textState.value = TextFieldState.focused;
    } else if (_isFilled) {
      _textState.value = TextFieldState.filled;
    } else {
      _textState.value = TextFieldState.default$;
    }
  }

  void _initWorker() {
    _textStateWorker = debounce(_textState, (_) {
      _updateStyle(_origTextState, _textState.value);
      _origTextState = _textState.value;
    }, time: const Duration(milliseconds: 300));

    _validateWorker = ever(_errMsg, (_) {
      _updateTextState();
    });

    _focusWorker = ever(_hasFocus, (_) {
      _updateTextState();
    });
  }

  void _onTextChanged(String value) {
    _text.value = value;
    widget.onChanged?.call(value);
  }

  void _onFocusChanged(bool hasFocus) {
    _text.value = _controller?.text ?? '';
    _hasFocus.value = hasFocus;
  }

  void _updateTextState() {
    if (_hasErrMsg) {
      _textState.value = TextFieldState.error;
    } else if (_hasFocus.value) {
      _textState.value = TextFieldState.focused;
    } else if (_isFilled) {
      _textState.value = TextFieldState.filled;
    } else {
      _textState.value = TextFieldState.default$;
    }
  }

  void _updateStyle(TextFieldState? origState, TextFieldState newState) {
    if (origState == newState) return;

    // 이거 안하면 실제로 포커스나 타이핑으로 상태가 바뀌어도
    // UI 업데이트가 안되서스타일 변경이 안됨
    if (mounted) setState(() {});
  }

  Widget? _buildFakeCounter(
    BuildContext context, {
    required int currentLength,
    required bool isFocused,
    required int? maxLength,
  }) {
    return null;
  }

  Widget _buildBottom() {
    if (widget.bottom == null) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: AnimatedOpacity(
              opacity: _errorOpacity(context),
              duration: const Duration(milliseconds: 300),
              child: _buildErrorMsg(),
            ),
          ),
          const SizedBox(width: 8),
          if (widget.showCounter)
            Obx(
              () => Text(
                _counter,
                style: _counterTextStyle(context),
              ),
            ),
          if (_showEnterButton) ...[
            const SizedBox(width: 8),
            SolidButton(
              text: 'Enter',
              onTap: _isFilled ? widget.onTapEnter : null,
            ).primary(context).textAreaEnter,
          ],
        ],
      );
    }
    return Column(
      children: [
        Opacity(
          opacity: _errorOpacity(context),
          child: Align(
            heightFactor: _errorOpacity(context),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildErrorMsg(),
            ),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: widget.bottom ?? const SizedBox.shrink(),
              ),
            ),
            Obx(
              () => Text(
                _counter,
                style: _counterTextStyle(context),
              ),
            ),
            if (_showEnterButton) ...[
              const SizedBox(width: 8),
              Obx(
                () => SolidButton(
                  text: 'Enter',
                  onTap: _isFilled ? widget.onTapEnter : null,
                ).primary(context).textAreaEnter,
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildErrorIcon() {
    return Icon(
      Icons.error_outline,
      size: 16,
    );
    // return GraphicSvgIcons.error.iconBuilder(size: 16);
  }

  Widget _buildErrorMsg() {
    if (_errMsg.value.isEmpty) return const SizedBox.shrink();
    return Row(
      children: [
        _buildErrorIcon(),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            _errMsg.value,
            style: TextStyles.caption1.dangerColor(context),
          ),
        ),
      ],
    );
  }

  String get _counter {
    if (_maxLength == null) {
      return '$_currentLength';
    }
    return '$_currentLength/$_maxLength';
  }

  String? checkValidate(String? value) {
    var result = widget.validator?.call(value);
    _errMsg.value = result ?? '';
    // return result;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap?.call();
        widget.focusNode?.requestFocus();
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: _boxBorder(context),
          color: _boxBackgroundColor(context),
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 16),
        ),
        child: Padding(
          padding: widget.padding ?? const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              if (widget.label != null) widget.label!,
              Row(
                children: [
                  if (widget.prefix != null) ...[
                    widget.prefix!,
                    SizedBox(width: widget.prefixSpacing ?? 8),
                  ],
                  Expanded(
                    child: Focus(
                      onFocusChange: _onFocusChanged,
                      child: TextFormField(
                        style: _textStyle(context),
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.start,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: InputDecoration(
                          hintMaxLines: 3,
                          errorMaxLines: 3,
                          helperMaxLines: 3,
                          hintText: _hintText,
                          hintStyle: _hintTextStyle(context),
                          contentPadding: EdgeInsets.zero,
                          isDense: true, // content padding 동작하게 하기 위함
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                        ),
                        key: widget.key,
                        controller: widget.controller,
                        focusNode: widget.focusNode,
                        keyboardType: widget.keyboardType,
                        textCapitalization: TextCapitalization.none,
                        textInputAction: widget.textInputAction,
                        autofocus: widget.autofocus,
                        readOnly: widget.readOnly,
                        autocorrect: true,
                        enableSuggestions: true,
                        minLines: widget.minLines,
                        maxLines: widget.maxLines,
                        maxLength: widget.maxLength,
                        onChanged: _onTextChanged,
                        onFieldSubmitted: widget.onSubmitted,
                        onTap: widget.onTap,
                        onTapOutside: widget.unfocusOnTapOutside
                            ? (_) => FocusScope.of(context).unfocus()
                            : null,
                        onEditingComplete: widget.onEditingComplete,
                        validator: checkValidate,
                        inputFormatters: widget.inputFormatters,
                        enabled: widget.enabled,
                        cursorWidth: 1,
                        cursorColor: _cursorColor(context),
                        buildCounter: _buildFakeCounter,
                        scrollPhysics: widget.scrollPhysics,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        dragStartBehavior: DragStartBehavior.start,
                        canRequestFocus: widget.canRequestFocus,
                        obscureText: widget.obscureText,
                      ),
                    ),
                  ),
                  if (widget.suffix != null) ...[
                    SizedBox(width: widget.suffixSpacing ?? 8),
                    widget.suffix!,
                  ],
                ],
              ),
              Visibility(
                visible: _showBottom,
                child: _buildBottom(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
