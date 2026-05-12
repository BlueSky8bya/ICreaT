enum RangeMarkerType {
  start,
  end,
  middle,

  /// 기간 선택이 단일 날짜일 때
  single,
}

extension RangeMarkerTypeExtension on RangeMarkerType {
  bool get isStart => this == RangeMarkerType.start;
  bool get isEnd => this == RangeMarkerType.end;
  bool get isMiddle => this == RangeMarkerType.middle;
  bool get isSingle => this == RangeMarkerType.single;
}
