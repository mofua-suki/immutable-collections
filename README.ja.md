# Immutable Collections

[English](https://github.com/mofua-suki/immutable-collections/blob/main/README.md) · [pub.dev](https://pub.dev/packages/frozen_collections)

Dart のリスト、セット、マップを、内容で等価性を判定できる読み取り専用のスナップショットに変換します。元のコレクションが変わっても保持したいアプリの状態や設定に使えます。

## インストール

対応する Dart SDK は 3.14.0 以上 4.0.0 未満です。

```sh
dart pub add frozen_collections
```

**スナップショットを直接変更する操作はコンパイルエラーになります。**
`ImmutableList` と `ImmutableSet` には `add()`、`remove()`、`clear()` がなく、`ImmutableMap` には `remove()`、`clear()`、代入演算子 `[]=` がありません。`toMutable()` で編集用のコピーを作れます。

## スナップショットを作り、コピーを編集する

```dart
import 'package:frozen_collections/frozen_collections.dart';

void main() {
  final source = ['coffee', 'tea'];
  final drinks = source.toImmutable();
  // drinks.add('juice');  // コンパイルエラー：ImmutableList に add() はありません。
  // drinks.remove('tea'); // コンパイルエラー：ImmutableList に remove() はありません。
  source.add('water');

  print(drinks.toList()); // [coffee, tea]

  final editable = drinks.toMutable()..add('juice');
  print(editable); // [coffee, tea, juice]
  print(drinks == ImmutableList(['coffee', 'tea'])); // true
}
```

Dart の `List`、`Set`、`Map` で `toImmutable()` を使えます。コンストラクタを直接呼ぶことも、`ImmutableList<T>.empty()`、`ImmutableSet<T>.empty()`、`ImmutableMap<K, V>.empty()` で空のスナップショットを作ることもできます。内容を更新するときは `toMutable()` で得たコピーを編集し、再度 `toImmutable()` を呼びます。

## コレクションの選び方

| 型 | 主な読み取り操作 | 等しくなる条件 |
| --- | --- | --- |
| `ImmutableList<E>` | 添字アクセス、反復、順序を使う操作 | 同じ順序で各要素が等しい。 |
| `ImmutableSet<E>` | 要素の有無の確認、反復、集合演算 | 挿入順にかかわらず要素が等しい。 |
| `ImmutableMap<K, V>` | キー検索、`entries`、`keys`、`values` の反復 | 挿入順にかかわらず同じキーに等しい値が対応する。 |

```dart
final enabled = {'search', 'export'}.toImmutable();
final sameFlags = ImmutableSet({'export', 'search'});
print(enabled == sameFlags); // true

final settings = <String, String?>{'theme': null}.toImmutable();
print(settings['theme']); // null
print(settings.containsKey('theme')); // true
print(settings.containsKey('locale')); // false
```

内容による等価判定は、実行時の型が同じラッパー同士に適用されます。同じ内容の可変コレクションは別の型です。`hashCode` も内容に基づくため、ラッパーをマップのキーやセットの要素にする間は、格納したオブジェクトの等価性とハッシュ値を保ってください。

0.1.5 以降は、検索時と同じく、要素・マップのキー・値それぞれの Dart の `==` と `hashCode` を使います。以前は入れ子のコレクションを再帰的に比較する場合がありました。たとえば、別々に作った通常のリスト `[1]` は別の要素です。そのリストを1件だけ持つスナップショット同士は、同じリストを共有すれば等しくなります。公開される `props` のコレクションは従来どおりです。サブクラスの比較項目も引き継ぎます。

## コピー、ビュー、Dart コレクションとの連携

- スナップショットと編集用のコピーは**浅いコピー**です。元のコレクションで要素やエントリを追加、削除、置換してもスナップショットは変わりません。入れ子のコレクションを含め、格納したオブジェクト自体は共有されます。
- リストとセットのラッパーは `Iterable<E>` です。`List`、`Set`、`Map` を要求する API には `toMutable()` で得たコピーを渡せます。マップのエントリは `settings.entries` で反復できます。
- `cast()` は内部コレクションの型付き読み取り専用ビューを返し、ビューの変更は失敗します。編集には `toMutable()` を使います。リストやセットで型に合う要素だけを取り出すには、`whereType<T>()` で絞り込んでから結果をリストなどに変換します。
- リストの `sublist()` と `getRange()` は独立したリストを返します。セットの `union()`、`intersection()`、`difference()` は通常のセットを、マップの `map()` は変換後の通常のマップを返します。その結果に `toImmutable()` を使えば新たなスナップショットを作れます。

Map と Set のコピーでは、キーや要素を通常の `==` と `hashCode` で比較します。元のコレクションの同一性比較や独自の等価性は引き継ぎません。このため別々のキーや要素が一つにまとまる場合、コンストラクターと `toImmutable()` は `ArgumentError` を投げます。コピーできる場合は元の反復順を保ちます。

## 開発

このリポジトリのルートで次のコマンドを実行します。

```sh
dart pub get
dart analyze
dart test
```

使用例は `dart run example/main.dart` で実行できます。 API リファレンスは `dart doc` で生成できます。
