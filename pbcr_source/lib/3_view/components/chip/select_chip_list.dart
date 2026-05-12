import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icreat_dct/3_view/components/chip/solid_chip.dart';

typedef OnSelectedCallback<T> = void Function(Set<T>);

class SelectChipList<T> extends StatefulWidget {
  const SelectChipList({
    super.key,
    this.debounceTime,
    this.selectedData,
    required this.data,
    this.onSelected,
    this.padding,
    this.isMultiSelect = false,
    this.isMultiLine = false,
    this.isUnselectable = false,
    this.spacing = 4,
    this.color = SolidChipColor.outlineGrey,
    this.size = SolidChipSize.size13,
    this.shape = SolidChipShape.round,
    this.chipWidth,
    this.chipHeight,
    this.chipPadding,
    this.isExpanded = false,
  })  : assert(
          !isExpanded || (chipWidth != null || chipHeight != null),
          'isExpanded가 true일 때는 chipWidth 또는 chipHeight가 필수입니다.',
        ),
        assert(
          isMultiSelect || selectedData == null || selectedData.length <= 1,
          'isMultiSelect가 false(단일 선택)일 때는 selectedData의 길이가 1 이하여야 합니다.',
        );

  final int? debounceTime;
  final Set<T>? selectedData;
  final List<(T, dynamic)> data;
  final OnSelectedCallback<T>? onSelected;

  /// [isMultiLine]이 false일 때 SingleChildScrollView의 padding
  final EdgeInsetsGeometry? padding;
  final bool isMultiSelect;
  final bool isMultiLine;

  /// isMultiSelect가 false일 때 작동
  final bool isUnselectable;
  final double spacing;
  final SolidChipColor color;
  final SolidChipSize size;
  final SolidChipShape shape;
  final double? chipWidth;
  final double? chipHeight;
  final EdgeInsetsGeometry? chipPadding;
  final bool isExpanded;

  static double calcChipWidth({
    required double maxWidth,
    required int count,
    double spacing = 4,
    double paddingHorizontal = 0,
  }) {
    final chipWidth =
        (maxWidth - paddingHorizontal - (spacing * (count - 1))) / count;
    return chipWidth;
  }

  @override
  State<SelectChipList<T>> createState() => _SelectChipListState<T>();
}

class _SelectChipListState<T> extends State<SelectChipList<T>> {
  @override
  void initState() {
    super.initState();
    _selectedSet.clear();
    _selectedSet.addAll(widget.selectedData ?? {});
  }

  void _onTap(dynamic e) {
    /// 여러개 선택 가능할 때
    if (widget.isMultiSelect) {
      if (_selectedSet.contains(e)) {
        _selectedSet.remove(e);
      } else {
        _selectedSet.add(e);
      }
      widget.onSelected?.call(_selectedSet);

      /// 단일 선택 일 때
    } else {
      /// 선택된 것을 다시 누르면 선택 해제
      if (widget.isUnselectable && _selectedSet.contains(e)) {
        _selectedSet.clear();
        widget.onSelected?.call(_selectedSet);
        return;
      }

      _selectedSet.clear();
      _selectedSet.add(e);
      widget.onSelected?.call(_selectedSet);
    }
  }

  final RxSet<T> _selectedSet = RxSet<T>({});

  @override
  void didUpdateWidget(covariant SelectChipList<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.selectedData != oldWidget.selectedData) {
      _selectedSet.clear();
      _selectedSet.addAll(widget.selectedData ?? {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isMultiLine) {
      return Wrap(
        crossAxisAlignment: WrapCrossAlignment.start,
        spacing: widget.spacing,
        runSpacing: widget.spacing,
        children: widget.data
            .mapIndexed(
              (idx, e) => SizedBox(
                width: widget.chipWidth,
                height: widget.chipHeight,
                child: Obx(
                  () => SolidChip(
                    debounceTime: widget.debounceTime,
                    text: e.$2,
                    data: e.$1,
                    onTap: _onTap,
                    isSelected: _selectedSet.contains(e.$1),
                    shape: widget.shape,
                    size: widget.size,
                    color: widget.color,
                    isExpanded: widget.isExpanded,
                    padding: widget.chipPadding,
                  ),
                ),
              ),
            )
            .toList(),
      );
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: widget.padding,
      child: Row(
        spacing: widget.spacing,
        children: <Widget>[
          for (int i = 0; i < widget.data.length; i++)
            SizedBox(
              width: widget.chipWidth,
              height: widget.chipHeight,
              child: Obx(
                () => SolidChip(
                  debounceTime: widget.debounceTime,
                  text: widget.data[i].$2,
                  data: widget.data[i].$1,
                  onTap: _onTap,
                  isSelected: _selectedSet.contains(widget.data[i].$1),
                  shape: widget.shape,
                  size: widget.size,
                  color: widget.color,
                  isExpanded: widget.isExpanded,
                  padding: widget.chipPadding,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
