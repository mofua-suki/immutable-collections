## 0.1.5

- Compare elements, map keys, and map values using their own equality and hash codes, including nested collections.

## 0.1.4

- Throw `ArgumentError` when copying a map or set would merge distinct keys or elements under default equality.

## 0.1.3

- Add a Japanese README and document the SDK requirement and installation command.

## 0.1.2

- Document compile-time errors for in-place changes to immutable collections.

## 0.1.1

- Support Equatable 3 while keeping compatibility with Equatable 2.1.
- Clarify the package description for pub.dev.

## 0.1.0

- Add `ImmutableList`, `ImmutableSet`, and `ImmutableMap` with content-based equality.
- Add conversion from Dart collections with `toImmutable()` and back to mutable copies with `toMutable()`.
