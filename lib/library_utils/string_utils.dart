class StringUtils {
  ///
  /// Checks if the given String [s] is null or empty
  ///
  static bool isNullOrEmpty(String s) => s?.isEmpty ?? true;

  ///
  /// Checks if the given String [s] is null or empty or is only whitespace
  ///
  static bool isNullOrWhitespace(String s) => s?.trim()?.isEmpty ?? true;

  ///
  /// Concatenate the given strings as filter all null values
  ///
  static String concatenate(List<String> strings, {String separator = ''}) =>
      strings.where((item) => item != null).join(separator);

  ///Return the number of occurrences [match] has within [base]
  static int getCountOfMatches(String match, String base) =>
      base == null ? 0 : base.length - base.replaceAll(match, '').length;
}
