import 'package:flutter/material.dart' show MaterialTapTargetSize, VisualDensity;
import 'package:flutter/widgets.dart';

final class PlatformCheckboxData {
  final Key? widgetKey;
  final bool? value;
  final bool tristate;
  final bool isEnabled;
  final ValueChanged<bool?> onChanged;
  final MouseCursor? mouseCursor;
  final Color? activeColor;
  final WidgetStateProperty<Color?>? fillColor;
  final Color? checkColor;
  final Color? focusColor;
  final FocusNode? focusNode;
  final bool autofocus;
  final OutlinedBorder? shape;
  final BorderSide? side;
  final String? semanticLabel;

  static const kDefaultAutofocus = false;

  const PlatformCheckboxData({
    required this.onChanged,
    required this.value,
    this.tristate = false,
    this.isEnabled = true,
    this.widgetKey,
    this.mouseCursor,
    this.activeColor,
    this.fillColor,
    this.checkColor,
    this.focusColor,
    this.focusNode,
    this.autofocus = kDefaultAutofocus,
    this.shape,
    this.side,
    this.semanticLabel,
  });
}

final class MaterialCheckboxData extends PlatformCheckboxData {
  final Color? hoverColor;
  final WidgetStateProperty<Color?>? overlayColor;
  final double? splashRadius;
  final MaterialTapTargetSize? materialTapTargetSize;
  final VisualDensity? visualDensity;
  final bool isError;

  static const kDefaultIsError = false;

  const MaterialCheckboxData({
    required super.onChanged,
    required super.value,
    super.tristate,
    super.isEnabled,
    super.widgetKey,
    super.mouseCursor,
    super.activeColor,
    super.fillColor,
    super.checkColor,
    super.focusColor,
    super.focusNode,
    super.autofocus,
    super.shape,
    super.side,
    super.semanticLabel,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.materialTapTargetSize,
    this.visualDensity,
    this.isError = kDefaultIsError,
  });
}

final class CupertinoCheckboxData extends PlatformCheckboxData {
  final Size? tapTargetSize;

  const CupertinoCheckboxData({
    required super.onChanged,
    required super.value,
    super.tristate,
    super.isEnabled,
    super.widgetKey,
    super.mouseCursor,
    super.activeColor,
    super.fillColor,
    super.checkColor,
    super.focusColor,
    super.focusNode,
    super.autofocus,
    super.shape,
    super.side,
    super.semanticLabel,
    this.tapTargetSize,
  });
}
