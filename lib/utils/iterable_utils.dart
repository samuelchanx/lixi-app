extension IterableData<T> on Iterable<T> {
  List<T> toggle(T value) {
    final list = toList();
    if (list.contains(value)) {
      list.remove(value);
    } else {
      list.add(value);
    }
    return list;
  }
}
