import "package:frozen_collections/frozen_collections.dart";
import "package:test/test.dart";

class _Key {
  final int value;
  _Key(this.value);

  @override
  bool operator ==(Object other) => other is _Key && value == other.value;

  @override
  int get hashCode => value.hashCode;
}

class _TaggedList extends ImmutableList<int> {
  _TaggedList(this.tag) : super([1]);

  final String tag;

  @override
  List<Object?> get props => [...super.props, tag];
}

void main() {
  group("ImmutableList", () {
    test("compares nested elements using their own equality", () {
      final item = [1];
      final left = ImmutableList<Object>([item, _Key(2)]);
      final equal = ImmutableList<Object>([item, _Key(2)]);
      expect(left == equal, isTrue);
      expect(equal == left, isTrue);
      expect(left.hashCode, equal.hashCode);
      for (final otherItem in <Object>[
        [1],
        {1},
      ]) {
        final other = ImmutableList<Object>([otherItem, _Key(2)]);
        expect(left.contains(otherItem), isFalse);
        expect(left == other, isFalse);
        expect(other == left, isFalse);
      }
    });

    test("retains runtime type and subclass equality properties", () {
      final tagged = _TaggedList("a");
      final equal = _TaggedList("a");
      expect(tagged.props.first, isA<List<int>>());
      expect(tagged == equal, isTrue);
      expect(tagged.hashCode, equal.hashCode);
      expect(tagged == _TaggedList("b"), isFalse);
      expect(tagged == ImmutableList([1]), isFalse);
      expect(ImmutableList<num>([1]) == ImmutableList<int>([1]), isFalse);
    });

    test("captures the input at conversion time", () {
      final input = [1, 2];
      final immutable = input.toImmutable();

      input[0] = 3;
      input.add(4);

      expect(immutable.toList(), [1, 2]);
    });

    test("compares and hashes contents in list order", () {
      final immutable = ImmutableList([1, 2]);
      final equal = ImmutableList([1, 2]);

      expect(immutable == equal, isTrue);
      expect(immutable.hashCode, equal.hashCode);
      expect(immutable == ImmutableList([2, 1]), isFalse);
    });

    test("provides an independent mutable copy", () {
      final immutable = ImmutableList([1, 2]);
      final copy = immutable.toMutable();

      copy[0] = 3;
      copy.add(4);

      expect(copy, [3, 2, 4]);
      expect(immutable.toList(), [1, 2]);
    });
  });

  group("ImmutableSet", () {
    test("matches nested members by lookup in both directions", () {
      final first = [1];
      final second = [1];
      final left = ImmutableSet({first, second});
      final right = ImmutableSet({
        first,
        [2],
      });
      final reordered = ImmutableSet({second, first});

      expect(right.lookup(second), isNull);
      expect(left == right, isFalse);
      expect(right == left, isFalse);
      expect(left == reordered, isTrue);
      expect(reordered == left, isTrue);
      expect(left.hashCode, reordered.hashCode);
    });

    test("rejects identity elements merged by value equality", () {
      final input = Set<_Key>.identity()..addAll([_Key(1), _Key(1)]);
      expect(input.length, 2);
      expect(() => ImmutableSet(input), throwsArgumentError);
      expect(() => input.toImmutable(), throwsArgumentError);
    });

    test("copies distinct identity elements in order with value lookup", () {
      final input = Set<_Key>.identity()..addAll([_Key(2), _Key(1)]);
      final snapshot = input.toImmutable();
      expect(snapshot.toList(), input.toList());
      expect(snapshot.contains(_Key(1)), isTrue);
    });

    test("captures the input at conversion time", () {
      final input = {1, 2};
      final immutable = input.toImmutable();

      input.remove(1);
      input.add(3);

      expect(immutable.toSet(), {1, 2});
    });

    test("compares and hashes members regardless of insertion order", () {
      final immutable = ImmutableSet({1, 2});
      final equal = ImmutableSet({2, 1});

      expect(immutable == equal, isTrue);
      expect(immutable.hashCode, equal.hashCode);
      expect(immutable == ImmutableSet({1, 3}), isFalse);
    });

    test("provides an independent mutable copy", () {
      final immutable = ImmutableSet({1, 2});
      final copy = immutable.toMutable();

      copy.remove(1);
      copy.add(3);

      expect(copy, {2, 3});
      expect(immutable.toSet(), {1, 2});
    });
  });

  group("ImmutableMap", () {
    test("compares nested keys and nullable values by lookup", () {
      final key = [1];
      final value = {2};
      final left = ImmutableMap<Object, Object?>({key: null, "v": value});
      final equal = ImmutableMap<Object, Object?>({"v": value, key: null});
      expect(left == equal, isTrue);
      expect(equal == left, isTrue);
      expect(left.hashCode, equal.hashCode);
      for (final entries in <Map<Object, Object?>>[
        {
          [1]: null,
          "v": value,
        },
        {
          key: null,
          "v": {2},
        },
        {
          key: null,
          "v": [2],
        },
      ]) {
        final other = ImmutableMap(entries);
        expect(left == other, isFalse);
        expect(other == left, isFalse);
      }
    });

    test("rejects identity keys merged by value equality", () {
      final input = Map<_Key, int>.identity()
        ..[_Key(1)] = 10
        ..[_Key(1)] = 20;
      expect(input.length, 2);
      expect(() => ImmutableMap(input), throwsArgumentError);
      expect(() => input.toImmutable(), throwsArgumentError);
    });

    test("copies distinct identity keys in order with value lookup", () {
      final input = Map<_Key, int>.identity()
        ..[_Key(2)] = 20
        ..[_Key(1)] = 10;
      final snapshot = input.toImmutable();
      expect(snapshot.keys.toList(), input.keys.toList());
      expect(snapshot[_Key(1)], 10);
    });

    test("captures the input at conversion time", () {
      final input = {"a": 1, "b": 2};
      final immutable = input.toImmutable();

      input["a"] = 3;
      input.remove("b");

      expect(immutable.length, 2);
      expect(immutable["a"], 1);
      expect(immutable["b"], 2);
    });

    test("compares and hashes entries regardless of insertion order", () {
      final immutable = ImmutableMap({"a": 1, "b": 2});
      final equal = ImmutableMap({"b": 2, "a": 1});

      expect(immutable == equal, isTrue);
      expect(immutable.hashCode, equal.hashCode);
      expect(immutable == ImmutableMap({"a": 2, "b": 1}), isFalse);
    });

    test("provides an independent mutable copy", () {
      final immutable = ImmutableMap({"a": 1, "b": 2});
      final copy = immutable.toMutable();

      copy["a"] = 3;
      copy.remove("b");

      expect(copy, {"a": 3});
      expect(immutable.length, 2);
      expect(immutable["a"], 1);
      expect(immutable["b"], 2);
    });
  });
}
