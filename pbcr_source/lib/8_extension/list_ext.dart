extension ListExt<T> on List<T> {

  List<T> insertBetween(T element) {
    if (isEmpty) return this;
    var newList = List<T>.generate(
      length * 2 - 1,
      (index) => index % 2 == 0 ? this[index ~/ 2] : element,
    );

    return newList;
  }

  /// 현재 리스트의 전체 요소를 space 개수만큼만 고르게 가져와서 반환
  List<T> spaceBetween(int space) {
    final result = <T>[];
    for (var i = 0; i < space; i++) {
      final index = (i * (length - 1) / (space - 1)).round();
      result.add(this[index]);
    }
    return result;
  }

  /// 현재 리스트를 targetCount 개수만큼 고르게 나누어 반환
  List<(int, int)> splitIntoEqualRanges(int targetCount) {
    if (targetCount <= 0) throw ArgumentError("targetCount는 0보다 커야 합니다.");

    final indexRanges = <(int, int)>[];
    int totalCount = length;

    int startIndex = 0;
    for (var i = 0; i < targetCount; i++) {
      int endIndex = ((i + 1) * totalCount ~/ targetCount) - 1;
      if (i == targetCount - 1) endIndex = totalCount - 1;
      indexRanges.add((startIndex, endIndex));
      startIndex = endIndex + 1;
    }

    return indexRanges;
  }
}
