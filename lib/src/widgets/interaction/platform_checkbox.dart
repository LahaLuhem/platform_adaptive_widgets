import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoCheckbox;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show Checkbox;

import '/src/models/interaction/platform_checkbox_data.dart';
import '/src/models/platform_widget_base.dart';

/// Material [Checkbox] on Android, [CupertinoCheckbox] on iOS.
///
/// The default constructor covers the ordinary ticked-or-not case, with a non-null `bool` going in and
/// coming back. Both platforms also do an indeterminate third state, and that's [PlatformCheckbox.tristate],
/// where [value] and `onChanged` turn nullable so a tap cycles `false → true → null`.
///
/// Per-platform tuning lives in [materialCheckboxData] / [cupertinoCheckboxData]. See `APPENDIX.md#field-classification`,
/// and `APPENDIX.md#checkbox-tristate-split` for why one class carries both constructors.
///
/// Example:
/// {@example /example/lib/snippets/interaction/platform_checkbox.dart#platform_checkbox}
class PlatformCheckbox extends PlatformWidgetKeyedBase {
  /// Never `null` from the default constructor, which rejects it. Only [PlatformCheckbox.tristate] allows
  /// it, for the indeterminate state.
  final bool? value;

  // Exactly one is non-null, picked by the constructor, and which one is the tristate discriminator.
  // See APPENDIX.md#checkbox-tristate-split.
  final ValueChanged<bool>? _onChanged;
  final ValueChanged<bool?>? _onChangedTristate;

  /// The way to disable a checkbox. `onChanged` stays required and non-null either way, and this gate
  /// is what passes the underlying widget a `null` callback for its standard disabled look. See `APPENDIX.md#callback-nullability`.
  final bool isEnabled;

  /// Focus node for the checkbox.
  final FocusNode? focusNode;

  /// Whether the checkbox grabs focus when mounted.
  final bool autofocus;

  /// What screen readers announce. Same on both platforms.
  final String? semanticLabel;

  /// Hover cursor.
  final MouseCursor? mouseCursor;

  /// Colour while ticked.
  final Color? activeColor;

  /// Fills the box behind the tick.
  final WidgetStateProperty<Color?>? fillColor;

  /// Colours the tick itself.
  final Color? checkColor;

  /// Colour while focused.
  final Color? focusColor;

  /// Shape of the box.
  final OutlinedBorder? shape;

  /// Outlines the box.
  final BorderSide? side;

  /// Material-branch overrides, plus the knobs Cupertino has no answer for.
  final MaterialCheckboxData? materialCheckboxData;

  /// Cupertino-branch overrides, plus the knobs Material has no answer for.
  final CupertinoCheckboxData? cupertinoCheckboxData;

  /// Creates a 2-state checkbox. Disable it with [isEnabled] rather than a null callback.
  const new({
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

  /// Creates a checkbox that also does the indeterminate state, so [value] and `onChanged` both take
  /// `bool?`. Prefer the default constructor when you don't need that third state.
  const new tristate({
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

  bool get _isTristate => _onChangedTristate != null;

  /// Both `!` are safe: this is only reached in 2-state mode, where `_onChanged` is non-null and `tristate: false`
  /// keeps the value from ever arriving null.
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
