import "package:equatable/equatable.dart";
import "package:meta/meta.dart";

/// イミュータブルなSetの振る舞いを提供するmixin
/// 読み取り専用のメソッドのみを公開する([Set]は実装しない)
mixin _ImmutableSetMixin<E> implements Iterable<E> {
  Set<E> get internal;

  // Iterable<E> の未実装メソッドをすべて internal に委譲
  @override
  Iterator<E> get iterator => internal.iterator;

  @override
  int get length => internal.length;

  @override
  bool get isEmpty => internal.isEmpty;

  @override
  bool get isNotEmpty => internal.isNotEmpty;

  @override
  E elementAt(int index) => internal.elementAt(index);

  @override
  Iterable<T> expand<T>(Iterable<T> Function(E element) f) =>
      internal.expand(f);

  @override
  E firstWhere(bool Function(E element) test, {E Function()? orElse}) =>
      internal.firstWhere(test, orElse: orElse);

  @override
  T fold<T>(T initialValue, T Function(T previousValue, E element) combine) =>
      internal.fold(initialValue, combine);

  @override
  E get last => internal.last;

  @override
  E lastWhere(bool Function(E element) test, {E Function()? orElse}) =>
      internal.lastWhere(test, orElse: orElse);

  @override
  E reduce(E Function(E value, E element) combine) => internal.reduce(combine);

  @override
  E get single => internal.single;

  @override
  E singleWhere(bool Function(E element) test, {E Function()? orElse}) =>
      internal.singleWhere(test, orElse: orElse);

  @override
  Iterable<E> skip(int count) => internal.skip(count);

  @override
  Iterable<E> skipWhile(bool Function(E value) test) =>
      internal.skipWhile(test);

  @override
  Iterable<E> take(int count) => internal.take(count);

  @override
  Iterable<E> takeWhile(bool Function(E value) test) =>
      internal.takeWhile(test);

  @override
  Iterable<E> followedBy(Iterable<E> other) => internal.followedBy(other);

  @override
  String join([String separator = ""]) => internal.join(separator);

  @override
  Iterable<T> whereType<T>() => internal.whereType<T>();

  @override
  String toString() => internal.toString();

  @override
  Iterable<E> where(bool Function(E element) test) => internal.where(test);

  @override
  Iterable<T> map<T>(T Function(E e) f) => internal.map(f);

  @override
  bool any(bool Function(E element) test) => internal.any(test);

  @override
  bool every(bool Function(E element) test) => internal.every(test);

  @override
  void forEach(void Function(E element) action) => internal.forEach(action);

  @override
  bool contains(Object? element) => internal.contains(element);

  @override
  List<E> toList({bool growable = true}) =>
      List<E>.from(internal, growable: growable);

  @override
  Set<E> toSet() => Set<E>.from(internal);

  /// Returns a typed view of the unmodifiable backing set.
  ///
  /// Reading an incompatible member raises a type error. Use
  /// [ImmutableSet.toMutable] when you need a writable set.
  @override
  Set<R> cast<R>() => internal.cast<R>();

  /// [Set.lookup]
  E? lookup(Object? element) => internal.lookup(element);

  /// [Set.union]
  Set<E> union(Set<E> other) => internal.union(other);

  /// [Set.intersection]
  Set<E> intersection(Set<Object?> other) => internal.intersection(other);

  /// [Set.difference]
  Set<E> difference(Set<Object?> other) => internal.difference(other);

  @override
  E get first => internal.first;
}

/// A read-only snapshot of a [Set] with order-independent value equality.
///
/// Construction copies the set membership. Objects in the snapshot are still
/// shared with the input. Keep their equality and hashes stable while they
/// are members of the set.
///
/// The wrapper is an [Iterable]. Set operations such as [union] return Dart
/// sets. Use [toMutable] for a detached, writable copy of this snapshot.
@immutable
class ImmutableSet<E>(Set<E> set) with Equatable, _ImmutableSetMixin<E> {
  final _internal = Set<E>.unmodifiable(set);

  this;

  /// Creates an empty snapshot of members of type [E].
  factory ImmutableSet.empty() => ImmutableSet(<E>{});

  /// The unmodifiable set backing this snapshot.
  @override
  Set<E> get internal => _internal;

  /// Returns a detached writable set containing the same member references.
  Set<E> toMutable() => Set.from(_internal);

  @override
  List<Object?> get props => [_internal];

  @override
  bool? get stringify => true;
}

/// Adds read-only snapshot conversion to Dart sets.
extension ImmutableSetExtension<E> on Set<E> {
  /// Copies the current membership into an [ImmutableSet].
  ImmutableSet<E> toImmutable() => ImmutableSet(this);
}
