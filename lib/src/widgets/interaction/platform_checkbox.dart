// PlatformCheckbox's two private callback fields multiplex its default and
// .tristate constructors — exactly one is non-null per instance (see the field
// comment). The default ctor binds its callback as a `this._onChanged`
// initializing formal, which Dart surfaces to callers as `onChanged` (the field
// name minus the underscore). The .tristate ctor can't reuse that: its public
// parameter must also be `onChanged`, but its field `_onChangedTristate` would
// surface as `onChangedTristate`, so it assigns in the initializer list instead
// (which prefer_initializing_formals leaves alone, since converting it would
// change the public parameter name). See APPENDIX.md#checkbox-tristate-split.

import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoCheckbox;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show Checkbox;

import '/src/models/interaction/platform_checkbox_data.dart';
import '/src/models/platform_widget_base.dart';

/// A platform-adaptive checkbox that renders Material [Checkbox] on Android
/// and [CupertinoCheckbox] on iOS.
///
/// The default constructor is the common two-state case: [value] is non-null
/// `bool` and `onChanged` hands back a non-null `bool`. For the indeterminate
/// (third) state — supported natively on both platforms — use
/// [PlatformCheckbox.tristate], whose [value] and `onChanged` are nullable so
/// taps can cycle `false → true → null`.
///
/// All functional inputs (value, callback, state-gating, behavioral tuning)
/// and shared visual defaults live as flat constructor parameters.
/// Per-platform visual tuning is opt-in via [materialCheckboxData] and
/// [cupertinoCheckboxData]. See `APPENDIX.md#field-classification` for the
/// classification rule and `APPENDIX.md#checkbox-tristate-split` for why the
/// two states share one class with two constructors.
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
  /// For the default (two-state) constructor this is always `true` (checked)
  /// or `false` (unchecked) — that constructor rejects `null`. For
  /// [PlatformCheckbox.tristate] it may also be `null` (indeterminate).
  final bool? value;

  // Exactly one of the two callbacks is non-null, selected by the constructor.
  // `_onChangedTristate != null` is the tristate discriminator (see [_isTristate]).
  // They are private because their nullability is an implementation detail of the two-vs-tristate multiplexing.
  // The public contract is the required, non-null `onChanged` parameter on each constructor.
  // See `APPENDIX.md#checkbox-tristate-split`.
  final ValueChanged<bool>? _onChanged;
  final ValueChanged<bool?>? _onChangedTristate;

  /// Whether the checkbox is enabled and responds to input.
  ///
  /// When `false`, the underlying platform widget receives `null` for its own `onChanged` parameter,
  /// producing the platform's standard disabled-checkbox rendering.
  /// The `onChanged` callback is still required and non-null at construction — the disable gate is read here.
  /// See `APPENDIX.md#callback-nullability`.
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

  /// Creates a platform-adaptive two-state checkbox.
  ///
  /// [value] and `onChanged` are required and non-null. Disable the checkbox
  /// via [isEnabled], not by passing a null callback. For the indeterminate
  /// state, use [PlatformCheckbox.tristate].
  const PlatformCheckbox({
    required bool this.value,
    required ValueChanged<bool> this._onChanged,
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
  }) : _onChangedTristate = null;

  /// Creates a platform-adaptive tristate checkbox.
  ///
  /// [value] may be `true`, `false`, or `null` (indeterminate); `onChanged`
  /// receives the same `bool?`. The callback itself is required and non-null —
  /// disable via [isEnabled], not a null callback. For the common two-state
  /// case, prefer the default [PlatformCheckbox] constructor, whose [value]
  /// and `onChanged` are non-null `bool`.
  const PlatformCheckbox.tristate({
    required this.value,
    required ValueChanged<bool?> onChanged,
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
  }) : _onChangedTristate = onChanged,
       _onChanged = null;

  /// Whether this instance was built via [PlatformCheckbox.tristate] and so
  /// drives the underlying widget in tristate mode.
  bool get _isTristate => _onChangedTristate != null;

  /// The two-state callback adapted to the `ValueChanged<bool?>?` the
  /// underlying widgets expect. Only reached in two-state mode (the
  /// `_onChangedTristate ?? …` fallback), where `_onChanged` is non-null and
  /// `tristate: false` guarantees the value is never null.
  ValueChanged<bool?> get _adaptedOnChanged =>
      (newValue) => _onChanged!(newValue!);

  @override
  Widget buildMaterial(BuildContext context) => Checkbox(
    key: widgetKey,
    value: value,
    tristate: _isTristate,
    onChanged: !isEnabled ? null : _onChangedTristate ?? _adaptedOnChanged,
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
    tristate: _isTristate,
    onChanged: !isEnabled ? null : _onChangedTristate ?? _adaptedOnChanged,
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
