import "package:equatable/equatable.dart";
import "package:meta/meta.dart";

/// イミュータブルなMapの振る舞いを提供するmixin
/// 読み取り専用のメソッドのみを公開する([Map]は実装しない)
mixin _ImmutableMapMixin<K, V> {
  @protected
  Map<K, V> get internal;

  /// Returns the value for [key], or `null` when the key is absent.
  ///
  /// Use [containsKey] to distinguish an absent key from a stored `null`.
  V? operator [](Object? key) => internal[key];

  /// The keys in the backing map's iteration order.
  Iterable<K> get keys => internal.keys;

  /// The values in the corresponding key order.
  Iterable<V> get values => internal.values;

  /// The key-value entries of this snapshot.
  Iterable<MapEntry<K, V>> get entries => internal.entries;

  /// The number of entries in the snapshot.
  int get length => internal.length;

  /// Whether the snapshot has no entries.
  bool get isEmpty => internal.isEmpty;

  /// Whether the snapshot has at least one entry.
  bool get isNotEmpty => internal.isNotEmpty;

  /// Whether [key] is present, even when its stored value is `null`.
  bool containsKey(Object? key) => internal.containsKey(key);

  /// Whether any entry has a value equal to [value].
  bool containsValue(Object? value) => internal.containsValue(value);

  /// Calls [action] once for each key-value entry.
  void forEach(void Function(K, V) action) => internal.forEach(action);

  /// Returns a new Dart map by applying [transform] to each entry.
  Map<K2, V2> map<K2, V2>(MapEntry<K2, V2> Function(K, V) transform) =>
      internal.map(transform);

  /// Returns a typed view of the unmodifiable backing map.
  ///
  /// Accessing an entry with an incompatible key or value raises a type error.
  Map<RK, RV> cast<RK, RV>() => internal.cast();
}

/// A read-only snapshot of a [Map] with order-independent entry equality.
///
/// Construction copies the key-value associations. Key and value objects are
/// still shared with the source, so keep keys' equality and hashes stable.
/// Iterate through [entries], or call [toMutable] for a detached writable map.
@immutable
class ImmutableMap<K, V> with Equatable, _ImmutableMapMixin<K, V> {
  final Map<K, V> _internal;

  /// Copies [map], throwing [ArgumentError] if source keys collapse under
  /// the snapshot’s value equality.
  ImmutableMap(Map<K, V> map) : _internal = Map<K, V>.unmodifiable(map) {
    if (_internal.length != map.length) {
      throw ArgumentError("Distinct source keys compare equal in the snapshot.");
    }
  }

  /// Creates an empty snapshot with keys of type [K] and values of type [V].
  factory ImmutableMap.empty() => ImmutableMap(<K, V>{});

  @override
  @protected
  Map<K, V> get internal => _internal;

  /// Returns a detached writable map with the same key and value references.
  Map<K, V> toMutable() => Map.from(_internal);

  @override
  List<Object?> get props => [_internal];

  @override
  bool? get stringify => true;
}

/// Adds read-only snapshot conversion to Dart maps.
extension ForImmutableMapExtension<K, V> on Map<K, V> {
  /// Copies the current entries into an [ImmutableMap].
  ImmutableMap<K, V> toImmutable() => ImmutableMap(this);
}
