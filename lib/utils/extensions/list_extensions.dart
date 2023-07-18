extension ListUtil on List {
  bool containsAll<T>(List<T> other) {
    for (final data in other) {
      if (!contains(data)) {
        return false;
      }
    }

    return true;
  }
}
