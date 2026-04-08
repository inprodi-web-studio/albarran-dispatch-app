import 'package:collection/collection.dart';

enum ColorSchemes {
  light,
  dark,
}

enum ValidateContexts {
  register,
  reset,
}

enum Genders {
  male,
  female,
  undefined,
}

extension FFEnumExtensions<T extends Enum> on T {
  String serialize() => name;
}

extension FFEnumListExtensions<T extends Enum> on Iterable<T> {
  T? deserialize(String? value) =>
      firstWhereOrNull((e) => e.serialize() == value);
}

T? deserializeEnum<T>(String? value) {
  switch (T) {
    case (ColorSchemes):
      return ColorSchemes.values.deserialize(value) as T?;
    case (ValidateContexts):
      return ValidateContexts.values.deserialize(value) as T?;
    case (Genders):
      return Genders.values.deserialize(value) as T?;
    default:
      return null;
  }
}
