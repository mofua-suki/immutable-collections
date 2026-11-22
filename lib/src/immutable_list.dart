import "package:equatable/equatable.dart";
import "package:meta/meta.dart";

/// イミュータブルなListの振る舞いを提供するmixin
/// 読み取り専用のメソッドのみを公開する([List]は実装しない)
mixin _ImmutableListMixin<E> implements Iterable<E> {
  List<E> get internal;

  /// Returns the element at [index]. The index must be in `0 .. length - 1`.
  E operator [](int index) => internal[index];

  /// [List.length]
  @override
  int get length => internal.length;

  /// [List.isEmpty]
  @override
  bool get isEmpty => internal.isEmpty;

  /// [List.isNotEmpty]
  @override
  bool get isNotEmpty => internal.isNotEmpty;

  /// [List.first]
  @override
  E get first => internal.first;

  /// [List.last]
  @override
  E get last => internal.last;

  /// [List.single]
  @override
  E get single => internal.single;

  /// [List.elementAt]
  @override
  E elementAt(int index) => internal.elementAt(index);

  /// [List.contains]
  @override
  bool contains(Object? element) => internal.contains(element);

  /// [List.indexOf]
  int indexOf(E element, [int start = 0]) => internal.indexOf(element, start);

  /// [List.lastIndexOf]
  int lastIndexOf(E element, [int? start]) =>
      internal.lastIndexOf(element, start);

  /// [List.indexWhere]
  int indexWhere(bool Function(E element) test, [int start = 0]) =>
      internal.indexWhere(test, start);

  /// [List.lastIndexWhere]
  int lastIndexWhere(bool Function(E element) test, [int? start]) =>
      internal.lastIndexWhere(test, start);

  /// Returns a detached list from [start] through the element before [end].
  ///
  /// When [end] is omitted, the result includes the rest of the list.
  List<E> sublist(int start, [int? end]) => internal.sublist(start, end);

  /// Copies the elements from [start] up to, but excluding, [end].
  List<E> getRange(int start, int end) =>
      internal.getRange(start, end).toList();

  /// Provides a read-only map view from indices to elements.
  Map<int, E> asMap() => internal.asMap();

  /// [List.reversed]
  Iterable<E> get reversed => internal.reversed;

  /// [List.every]
  @override
  bool every(bool Function(E) test) => internal.every(test);

  /// [List.any]
  @override
  bool any(bool Function(E) test) => internal.any(test);

  /// [List.where]
  @override
  Iterable<E> where(bool Function(E) test) => internal.where(test);

  /// [List.firstWhere]
  @override
  E firstWhere(bool Function(E) test, {E Function()? orElse}) =>
      internal.firstWhere(test, orElse: orElse);

  /// [List.lastWhere]
  @override
  E lastWhere(bool Function(E) test, {E Function()? orElse}) =>
      internal.lastWhere(test, orElse: orElse);

  /// [List.singleWhere]
  @override
  E singleWhere(bool Function(E) test, {E Function()? orElse}) =>
      internal.singleWhere(test, orElse: orElse);

  /// [List.map]
  @override
  Iterable<T> map<T>(T Function(E e) f) => internal.map(f);

  /// [List.expand]
  @override
  Iterable<T> expand<T>(Iterable<T> Function(E) f) => internal.expand(f);

  /// [List.fold]
  @override
  T fold<T>(T initialValue, T Function(T previousValue, E element) combine) =>
      internal.fold(initialValue, combine);

  /// [List.reduce]
  @override
  E reduce(E Function(E value, E element) combine) => internal.reduce(combine);

  /// [List.skip]
  @override
  Iterable<E> skip(int count) => internal.skip(count);

  /// [List.skipWhile]
  @override
  Iterable<E> skipWhile(bool Function(E value) test) =>
      internal.skipWhile(test);

  /// [List.take]
  @override
  Iterable<E> take(int count) => internal.take(count);

  /// [List.takeWhile]
  @override
  Iterable<E> takeWhile(bool Function(E value) test) =>
      internal.takeWhile(test);

  /// [List.followedBy]
  @override
  Iterable<E> followedBy(Iterable<E> other) => internal.followedBy(other);

  /// [List.forEach]
  @override
  void forEach(void Function(E) action) => internal.forEach(action);

  /// [List.join]
  @override
  String join([String separator = ""]) => internal.join(separator);

  /// [List.whereType]
  @override
  Iterable<T> whereType<T>() => internal.whereType<T>();

  /// [List.toList]
  @override
  List<E> toList({bool growable = true}) =>
      List<E>.from(internal, growable: growable);

  /// [List.toSet]
  @override
  Set<E> toSet() => internal.toSet();

  /// Returns a typed view of the unmodifiable backing list.
  ///
  /// Reading an element that is not an [R] throws a type error. Use
  /// [ImmutableList.toMutable] when you need a writable list.
  @override
  List<R> cast<R>() => internal.cast<R>();

  /// [List.iterator]
  @override
  Iterator<E> get iterator => internal.iterator;
}

/// A read-only snapshot of a [List] with order-sensitive value equality.
///
/// Construction copies the input's element references in order. Adding,
/// removing, or replacing elements in the source does not change the snapshot.
/// Mutating an element itself can still affect the value seen in both lists.
///
/// The wrapper is an [Iterable]. Use [toMutable] when an API requires a
/// writable [List]. Equality compares immutable lists of the same runtime type.
@immutable
class ImmutableList<E>(List<E> list) with Equatable, _ImmutableListMixin<E> {
  final _internal = List<E>.unmodifiable(list);

  this;

  /// Creates an empty snapshot of elements of type [E].
  factory ImmutableList.empty() => ImmutableList(<E>[]);

  /// The unmodifiable list backing this snapshot.
  @override
  List<E> get internal => _internal;

  /// Returns a detached growable list containing the same element references.
  List<E> toMutable() => List.from(_internal);

  @override
  List<Object?> get props => [_internal];

  @override
  bool? get stringify => true;
}

/// Adds read-only snapshot conversion to Dart lists.
extension ImmutableListExtension<E> on List<E> {
  /// Copies this list into an [ImmutableList] in its current order.
  ImmutableList<E> toImmutable() => ImmutableList(this);
}
