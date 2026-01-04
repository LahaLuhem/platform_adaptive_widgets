import 'package:flutter/material.dart' show TimeOfDay;

extension TimeOfDayExtensions on TimeOfDay {
  /// Convert to a [DateTime].
  DateTime toDateTime() => DateTime(1, 1, 1, hour, minute);
}
