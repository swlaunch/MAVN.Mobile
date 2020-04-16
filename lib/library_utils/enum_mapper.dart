class EnumMapper {
  /// Map the given [enumTypeAsString] to an item from [enumValues]
  static EnumType mapFromString<EnumType>(String enumTypeAsString,
          {List<EnumType> enumValues, EnumType defaultValue}) =>
      enumValues.firstWhere(
          (enumValue) =>
              enumValue.toString().split('.')[1]?.toLowerCase() ==
              enumTypeAsString?.toLowerCase(),
          orElse: () => defaultValue);
}
