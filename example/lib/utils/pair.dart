final class Pair<A, B> {
  const Pair(this.a, this.b);

  /// Iterable 1
  final A a;

  /// Iterable 2
  final B b;
}

Iterable<Pair<A, B>> zip<A, B>(List<A> listA, List<B> listB) sync* {
  assert(listA.length == listB.length, 'For zipping, lengths of the lists must match');
  for (var i = 0; i < listA.length; i++) {
    yield Pair(listA[i], listB[i]);
  }
}
