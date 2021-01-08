extension MapIndexed<T> on List<T> {
  Iterable<U> mapIndexed<U>(U Function(int, T) map) {
    return this
        .asMap()
        .entries
        .map((MapEntry<int, T> entry) => map(entry.key, entry.value));
  }
}
