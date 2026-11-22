# Immutable Collections

pub.dev でのパッケージ名は `frozen_collections` です。

Read-only snapshots of Dart lists, sets, and maps with value equality. These
types are useful for application state, configuration, and other values that
should stay stable when the source collection changes.

## Take a snapshot and edit a copy

```dart
import 'package:frozen_collections/frozen_collections.dart';

void main() {
  final source = ['coffee', 'tea'];
  final drinks = source.toImmutable();
  source.add('water');

  print(drinks.toList()); // [coffee, tea]

  final editable = drinks.toMutable()..add('juice');
  print(editable); // [coffee, tea, juice]
  print(drinks == ImmutableList(['coffee', 'tea'])); // true
}
```

`toImmutable()` works on Dart's `List`, `Set`, and `Map`. You can also call the
constructors directly or use `ImmutableList<T>.empty()`,
`ImmutableSet<T>.empty()`, and `ImmutableMap<K, V>.empty()`. To derive an
updated snapshot, call `toMutable()`, edit that copy, then freeze it with
`toImmutable()`.

## Choose a collection

| Type | Common reads | Value equality |
| --- | --- | --- |
| `ImmutableList<E>` | Indexing, iteration, and order-sensitive operations | Elements must compare equal in the same order. |
| `ImmutableSet<E>` | Membership, iteration, and set operations | Members must compare equal regardless of insertion order. |
| `ImmutableMap<K, V>` | Key lookup and iteration over `entries`, `keys`, or `values` | Keys must map to equal values regardless of insertion order. |

```dart
final enabled = {'search', 'export'}.toImmutable();
final sameFlags = ImmutableSet({'export', 'search'});
print(enabled == sameFlags); // true

final settings = <String, String?>{'theme': null}.toImmutable();
print(settings['theme']); // null
print(settings.containsKey('theme')); // true
print(settings.containsKey('locale')); // false
```

Equality applies between immutable wrappers of the same runtime type. A
mutable Dart collection with the same contents is a separate type. `hashCode`
follows content equality, so keep the equality and hashes of contained objects
stable when using an immutable wrapper as a map key or set member.

## Copies, views, and interoperability

- Snapshots and mutable copies are **shallow**. Changes to the source
  collection's slots, members, or entries do not affect a snapshot. Objects
  stored inside the collection are still shared, including nested collections.
- The list and set wrappers are `Iterable<E>`. APIs that require a Dart `List`,
  `Set`, or `Map` can receive a copy from `toMutable()`. Map entries can be
  iterated with `settings.entries`.
- `cast()` gives a typed view of the read-only backing collection. Mutating
  that view fails. Use `toMutable()` for writes or `whereType<T>()` on the list
  or set wrapper to filter by type before collecting the result.
- List `sublist()` and `getRange()` return detached lists. Set `union()`,
  `intersection()`, and `difference()` return ordinary sets. Map `map()` returns
  an ordinary transformed map. Call `toImmutable()` on these results when you
  want another immutable snapshot.

## Development

From the package root, run `dart pub get`, `dart analyze`, and `dart test`.
Run `dart run example/main.dart` for the example and `dart doc` to generate
the API reference.
