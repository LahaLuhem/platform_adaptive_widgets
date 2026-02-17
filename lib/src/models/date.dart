import 'package:flutter/foundation.dart';

import '/src/extensions/date_time_extensions.dart';

/// A gregorian calendar date
@immutable
final class Date implements Comparable<Date> {
  /// The year of this date.
  final int year;

  /// The month of this date. January is 1.
  final int month;

  /// The day of this date. First day is 1.
  final int day;

  /// Creates a [Date] with the given [year], [month], and [day].
  const Date({required this.year, this.month = 1, this.day = 1});

  /// The current date
  static Date now({bool utc = false}) {
    final now = DateTime.now();
    if (utc) return now.toUtc().toDate();

    return now.toDate();
  }

  /// Convert to a [DateTime].
  DateTime toDateTime({bool utc = false}) =>
      utc ? .utc(year, month, day) : DateTime(year, month, day);

  @override
  int compareTo(Date other) {
    var d = year.compareTo(other.year);
    if (d != 0) return d;

    d = month.compareTo(other.month);
    if (d != 0) return d;

    return day.compareTo(other.day);
  }

  /// Returns a new [Date] with the given [duration] added.
  Date add(Duration duration) => toDateTime().add(duration).toDate();

  /// Returns a new [Date] with the given [duration] subtracted.
  Date subtract(Duration duration) => toDateTime().subtract(duration).toDate();

  /// Returns the [Duration] between this date and [other].
  Duration difference(Date other) => toDateTime().difference(other.toDateTime());

  /// Whether this date is before [other].
  bool isBefore(Date other) => toDateTime().isBefore(other.toDateTime());

  /// Whether this date is after [other].
  bool isAfter(Date other) => toDateTime().isAfter(other.toDateTime());

  /// Whether this date is at the same moment as [other].
  bool isAtSameMomentAs(Date other) => toDateTime().isAtSameMomentAs(other.toDateTime());

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Date &&
          runtimeType == other.runtimeType &&
          year == other.year &&
          month == other.month &&
          day == other.day;

  @override
  int get hashCode => year.hashCode ^ month.hashCode ^ day.hashCode;

  @override
  String toString() {
    final yyyy = year.toString();
    final mm = month.toString().padLeft(2, '0');
    final dd = day.toString().padLeft(2, '0');

    return '$yyyy-$mm-$dd';
  }
}
