/// The activity-intensity preference shown by the Showcase screen's segmented
/// button. A plain example enum — the point is the adaptive
/// `PlatformSegmentButton`, not the domain.
enum ActivityLevel {
  /// Light activity.
  casual(label: 'Casual'),

  /// Moderate activity.
  regular(label: 'Regular'),

  /// Heavy activity.
  intense(label: 'Intense');

  /// Segment label.
  final String label;

  const ActivityLevel({required this.label});
}
