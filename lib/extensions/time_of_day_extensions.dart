import 'package:flutter/material.dart' show TimeOfDay;

/// Extensions on [TimeOfDay] for converting to a [DateTime].
extension TimeOfDayExtensions on TimeOfDay {
  /// Convert to a [DateTime].
  DateTime toDateTime() => DateTime(1, 1, 1, hour, minute);
}
