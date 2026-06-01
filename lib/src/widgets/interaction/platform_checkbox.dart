import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoCheckbox;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show Checkbox;

import '/src/models/interaction/platform_checkbox_data.dart';
import '/src/models/platform_widget_base.dart';

/// A platform-adaptive checkbox that renders Material [Checkbox] on Android
/// and [CupertinoCheckbox] on iOS.
///
/// All functional inputs (value, callbacks, state-gating, behavioral tuning)
/// and shared visual defaults live as flat constructor parameters.
/// Per-platform visual tuning is opt-in via [materialCheckboxData] and
/// [cupertinoCheckboxData]. See `APPENDIX.md#field-classification` for the
/// classification rule.
///
/// Example:
/// ```dart
/// PlatformCheckbox(
///   value: _isChecked,
///   onChanged: (v) => setState(() => _isChecked = v),
/// )
/// ```
class PlatformCheckbox extends PlatformWidgetKeyedBase {
  /// Current value of the checkbox.
  ///
  /// Nullable to support [tristate]'s indeterminate state — `null` renders
  /// the indeterminate visual when `tristate: true`. With `tristate: false`,
  /// pass `true` or `false`.
  final bool? value;

  /// Callback fired when the user changes the checkbox value.
  ///
  /// Required and non-null. To disable the checkbox, set [isEnabled] to
  /// `false` — do **not** pass `null` here. See
  /// `APPENDIX.md#callback-nullability`.
  ///
  /// Receives `bool?` because [tristate] can cycle through `null`.
  final ValueChanged<bool?> onChanged;

  /// Whether the checkbox supports three states (true, false, null).
  final bool tristate;

  /// Whether the checkbox is enabled and responds to input.
  ///
  /// When `false`, the underlying platform widget receives `null` for its
  /// own `onChanged` parameter, producing the platform's standard
  /// disabled-checkbox rendering. [onChanged] is still required and
  /// non-null at construction — the disable gate is read here.
  final bool isEnabled;

  /// Focus node for the checkbox.
  final FocusNode? focusNode;

  /// Whether the checkbox should autofocus.
  final bool autofocus;

  /// Semantic label for accessibility. Read by screen readers; same value
  /// is used on both platforms.
  final String? semanticLabel;

  /// Mouse cursor when hovering over the checkbox.
  final MouseCursor? mouseCursor;

  /// Color of the checkbox when active.
  final Color? activeColor;

  /// Fill color as a [WidgetStateProperty].
  final WidgetStateProperty<Color?>? fillColor;

  /// Color of the check mark.
  final Color? checkColor;

  /// Color of the checkbox when focused.
  final Color? focusColor;

  /// Shape of the checkbox border.
  final OutlinedBorder? shape;

  /// Border side of the checkbox.
  final BorderSide? side;

  /// Material-only visual overrides. Optional.
  ///
  /// Fields set on this record override the widget's flat shared-visual
  /// defaults on the Material branch; Material-only fields (e.g.
  /// `hoverColor`, `splashRadius`, `isError`) are read only from here.
  final MaterialCheckboxData? materialCheckboxData;

  /// Cupertino-only visual overrides. Optional.
  ///
  /// Fields set on this record override the widget's flat shared-visual
  /// defaults on the Cupertino branch; Cupertino-only fields (e.g.
  /// `tapTargetSize`) are read only from here.
  final CupertinoCheckboxData? cupertinoCheckboxData;

  /// Creates a platform-adaptive checkbox.
  ///
  /// [value] and [onChanged] are required. [value] is nullable to allow
  /// [tristate]'s indeterminate state. Disable the checkbox via [isEnabled],
  /// not by passing a null callback.
  const PlatformCheckbox({
    required this.value,
    required this.onChanged,
    this.tristate = false,
    this.isEnabled = true,
    this.focusNode,
    this.autofocus = false,
    this.semanticLabel,
    this.mouseCursor,
    this.activeColor,
    this.fillColor,
    this.checkColor,
    this.focusColor,
    this.shape,
    this.side,
    this.materialCheckboxData,
    this.cupertinoCheckboxData,
    super.widgetKey,
    super.key,
  });

  @override
  Widget buildMaterial(BuildContext context) => Checkbox(
    key: widgetKey,
    value: value,
    tristate: tristate,
    onChanged: !isEnabled ? null : onChanged,
    mouseCursor: materialCheckboxData?.mouseCursor ?? mouseCursor,
    activeColor: materialCheckboxData?.activeColor ?? activeColor,
    fillColor: materialCheckboxData?.fillColor ?? fillColor,
    checkColor: materialCheckboxData?.checkColor ?? checkColor,
    focusColor: materialCheckboxData?.focusColor ?? focusColor,
    shape: materialCheckboxData?.shape ?? shape,
    side: materialCheckboxData?.side ?? side,
    focusNode: focusNode,
    autofocus: autofocus,
    semanticLabel: semanticLabel,
    hoverColor: materialCheckboxData?.hoverColor,
    overlayColor: materialCheckboxData?.overlayColor,
    splashRadius: materialCheckboxData?.splashRadius,
    materialTapTargetSize: materialCheckboxData?.materialTapTargetSize,
    visualDensity: materialCheckboxData?.visualDensity,
    isError: materialCheckboxData?.isError ?? kDefaultCheckboxIsError,
  );

  @override
  Widget buildCupertino(BuildContext context) => CupertinoCheckbox(
    key: widgetKey,
    value: value,
    tristate: tristate,
    onChanged: !isEnabled ? null : onChanged,
    mouseCursor: cupertinoCheckboxData?.mouseCursor ?? mouseCursor,
    activeColor: cupertinoCheckboxData?.activeColor ?? activeColor,
    fillColor: cupertinoCheckboxData?.fillColor ?? fillColor,
    checkColor: cupertinoCheckboxData?.checkColor ?? checkColor,
    focusColor: cupertinoCheckboxData?.focusColor ?? focusColor,
    shape: cupertinoCheckboxData?.shape ?? shape,
    side: cupertinoCheckboxData?.side ?? side,
    focusNode: focusNode,
    autofocus: autofocus,
    semanticLabel: semanticLabel,
    tapTargetSize: cupertinoCheckboxData?.tapTargetSize,
  );
}
