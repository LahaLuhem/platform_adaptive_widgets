import '/src/models/date.dart';

/// Extensions on [DateTime] for converting to a [Date].
extension DateTimeExtensions on DateTime {
  /// Convert to a [Date].
  Date toDate() => Date(year: year, month: month, day: day);
}
