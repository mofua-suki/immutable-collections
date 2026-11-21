import 'package:immutable_collections/immutable_collections.dart';

void main() {
  final source = ['coffee', 'tea'];
  final drinks = source.toImmutable();
  source.add('water');

  print(drinks.toList()); // [coffee, tea]

  final editable = drinks.toMutable()..add('juice');
  print(editable); // [coffee, tea, juice]
  print(drinks == ImmutableList(['coffee', 'tea'])); // true
}
