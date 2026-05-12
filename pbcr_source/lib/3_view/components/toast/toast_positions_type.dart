enum ToastPositionType { top, bottom }

extension ToastPositionTypeExt on ToastPositionType {
  bool get isTop => this == ToastPositionType.top;
  bool get isBottom => this == ToastPositionType.bottom;
}
