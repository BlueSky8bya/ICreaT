List<T> removeElementsAtIndices<T>(List<T> originalList, Set<int> indicesToRemove) {
  List<T> list = List.from(originalList);
  List<int> sortedIndices = indicesToRemove.toList()
    ..sort((a, b) => b.compareTo(a)); // Descending 정렬

  for (int index in sortedIndices) {
    if (index >= 0 && index < list.length) {
      list.removeAt(index);
    }
  }

  return list;
}