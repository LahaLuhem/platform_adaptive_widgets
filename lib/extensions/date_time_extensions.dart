import '../models/date.dart';

extension DateTimeExtensions on DateTime {
  /// Convert to a [Date].
  Date toDate() => Date(year: year, month: month, day: day);
}
