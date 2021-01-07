extension NthKey<K, V> on Map {
  K nthKey<K, V>(int index) => entries.toList()[index].key;
}
