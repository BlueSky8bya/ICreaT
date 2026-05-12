import 'dart:math';
import 'package:flutter/material.dart';

import 'package:icreat_dct/8_extension/date_time_ext.dart';
import 'package:icreat_dct/theme/extenstion/build_context_ext.dart';
import 'package:icreat_dct/theme/extenstion/text_styles_ext.dart';
import 'package:icreat_dct/theme/text_styles.dart';

class LinearCalendar extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;

  /// 1줄에 표시할 컬럼 수
  final int columnCount;
  final double itemHeight;

  /// 컬럼 사이의 간격
  final double spacing;
  final double horizontalPadding;

  /// columnCount 바깥의 날짜를 표시할지 여부
  /// 표시한다면 horizontalPadding 만큼 더 표시
  final bool showPreviewEdge;

  final DateTime? selectedDate;
  final void Function(DateTime)? onDateSelected;
  final void Function(DateTime)? onDateFocused;

  const LinearCalendar({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.columnCount,
    this.itemHeight = 60,
    this.spacing = 16.0,
    this.horizontalPadding = 16.0,
    this.showPreviewEdge = false,
    this.selectedDate,
    this.onDateSelected,
    this.onDateFocused,
  });

  @override
  State<LinearCalendar> createState() => LinearCalendarState();
}

class LinearCalendarState extends State<LinearCalendar> {
  final ScrollController _sc = ScrollController();

  final Map<int, double> _itemOffsets = {};
  double entireWidth = 0;
  double itemWidth = 0;

  int get itemCount {
    if (widget.endDate.isBefore(widget.startDate)) {
      return 0;
    }

    return widget.endDate.difference(widget.startDate).inDays + 1;
  }

  DateTime getItemDate(int index) {
    return widget.startDate.add(Duration(days: index));
  }

  @override
  void initState() {
    super.initState();

    _sc.addListener(_handleScroll);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _moveDayTile(widget.selectedDate ?? widget.startDate);
    });
  }

  @override
  void didUpdateWidget(LinearCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.selectedDate != oldWidget.selectedDate) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _moveDayTile(widget.selectedDate ?? widget.startDate);
      });
    }
  }

  @override
  void dispose() {
    _sc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        entireWidth = constraints.maxWidth;

        final sumOfPadding = widget.horizontalPadding * 2;
        final sumOfRemainingWidth = entireWidth -
            _sumOfSpacing(widget.columnCount) -
            sumOfPadding -
            _sumOfPreviewEdge;
        itemWidth = sumOfRemainingWidth / widget.columnCount;

        _initItemOffsets();

        return SizedBox(
          height: widget.itemHeight,
          child: ListView.builder(
            controller: _sc,
            physics: const BouncingScrollPhysics(),
            itemCount: itemCount,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
            itemBuilder: (context, index) {
              final date = getItemDate(index);
              final isSelected = widget.selectedDate != null
                  ? date.isSameDate(widget.selectedDate!)
                  : false;

              final item = SizedBox(
                width: itemWidth,
                child: DayTile(
                  type: isSelected ? DayTileType.selected : DayTileType.normal,
                  date: date,
                  onTap: _handleDateSelected,
                ),
              );

              if (index == itemCount - 1) {
                return item;
              }

              return Padding(
                padding: EdgeInsets.only(right: widget.spacing),
                child: item,
              );
            },
          ),
        );
      },
    );
  }

  // ----------- getters -----------

  double get _sumOfDayTileWidth {
    return itemCount * itemWidth;
  }

  double _sumOfSpacing(int itemCount) {
    if (itemCount < 0) return 0;
    return widget.spacing * (itemCount - 1);
  }

  double get _sumOfPreviewEdge {
    return widget.showPreviewEdge ? widget.horizontalPadding * 2 : 0;
  }

  double get _getMaxOffset {
    return _sumOfDayTileWidth +
        _sumOfSpacing(itemCount) -
        entireWidth +
        _sumOfPreviewEdge;
  }

  double _getItemsSize(int itemCount) {
    return itemCount * itemWidth + (widget.spacing * (itemCount - 1));
  }

  // ----------- initializers -----------

  /// 컬럼 수가 홀수일 때 가운데 기준으로 오프셋을 줘야 하기 때문에
  /// 컬럼 수의 절반만큼 빼준다.
  void _initItemOffsets() {
    final halfOfColumnCount = widget.columnCount ~/ 2;
    for (var i = 0; i < itemCount; i++) {
      final sizeOfPrevItems = _getItemsSize(i - halfOfColumnCount);

      // 소수점 때문에 가운데 기준이 반올림으로 틀어지는걸 방지하기 위해 1픽셀 추가
      _itemOffsets[i] = sizeOfPrevItems + 1;
    }
  }

  // ----------- actions -----------

  void _handleDateSelected(DateTime date) {
    _moveDayTile(date);
    widget.onDateSelected?.call(date);
  }

  void _moveDayTile(DateTime date) {
    final halfOfItemWidth = itemWidth / 2;
    final halfOfEntireWidth = entireWidth / 2;

    final isInRange = date.isSameOrAfter(widget.startDate) &&
        date.isSameOrBefore(widget.endDate);

    if (!isInRange) {
      return;
    }

    final dayDiff = date.difference(widget.startDate).inDays;

    double moveOffset = 0;
    final sumOfDayTileWidth = dayDiff * itemWidth;
    final sumOfSpacing = widget.spacing * dayDiff;

    if (dayDiff > 0) {
      moveOffset = min(
        max(
            widget.horizontalPadding +
                sumOfDayTileWidth +
                sumOfSpacing -
                halfOfEntireWidth +
                halfOfItemWidth,
            0),
        _getMaxOffset,
      );
    }

    _sc.animateTo(
      moveOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _handleScroll() {
    final offset = _sc.offset;

    // offset이 너무 크면 firstWhere에서 못찾기 때문에 마지막 값을 반환
    final itemOffset = _itemOffsets.entries
        .firstWhere(
          (element) => element.value >= offset,
          orElse: () => _itemOffsets.entries.last,
        )
        .key;

    widget.onDateFocused?.call(getItemDate(itemOffset));
  }
}

enum DayTileType {
  normal,
  disabled,
  selected;

  Color getBackgroundColor(BuildContext context) {
    switch (this) {
      case normal:
        return context.bgPrimary;
      case disabled:
        return context.bgPrimary;
      case selected:
        return context.bgBrand;
    }
  }

  Color getTextColor(BuildContext context) {
    switch (this) {
      case normal:
        return context.textPrimary;
      case disabled:
        return context.textTertiary;
      case selected:
        return context.textInverse;
    }
  }
}

class DayTile extends StatelessWidget {
  final DateTime date;
  final void Function(DateTime) onTap;
  final DayTileType type;

  const DayTile({
    super.key,
    required this.date,
    required this.onTap,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = type.getBackgroundColor(context);
    final textColor = type.getTextColor(context);
    final borderRadius = BorderRadius.circular(16);

    return Material(
      color: bgColor,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: () => onTap(date),
        borderRadius: borderRadius,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            children: [
              Text(
                date.toDayOfWeekKorean(),
                style: TextStyles.body1.semiBold.copyWith(color: textColor),
              ),
              Spacer(),
              Text(
                '${date.day}',
                style: TextStyles.body1.semiBold.copyWith(color: textColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
