import "package:collection/collection.dart";
import "package:equatable/equatable.dart";

/// Keeps Equatable from recursively comparing elements of the snapshot.
final class _SnapshotProperty<C> {
  const _SnapshotProperty(this.contents, this.equality);

  final C contents;
  final Equality<C> equality;

  @override
  bool operator ==(Object other) =>
      other is _SnapshotProperty<C> &&
      identical(equality, other.equality) &&
      equality.equals(contents, other.contents);

  @override
  int get hashCode => equality.hash(contents);

}

// Preserve the public props list and any extra properties added by a subclass.
Equatable snapshotComparison<C>(
  C contents,
  Equality<C> equality,
  List<Object?> props,
) => _ComparisonParts([
  for (final part in props)
    if (identical(part, contents)) _SnapshotProperty(contents, equality) else part,
]);

final class _ComparisonParts extends Equatable {
  const _ComparisonParts(this.props);

  @override
  final List<Object?> props;
}
