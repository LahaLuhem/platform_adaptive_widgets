import 'dart:ui';

import 'package:flutter/cupertino.dart' show OverlayVisibilityMode;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' show InputCounterWidgetBuilder, InputDecoration;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

final class PlatformTextFieldData {
  final Key? widgetKey;
  final Object groupId;

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final UndoHistoryController? undoController;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final TextDirection? textDirection;
  final bool readOnly;
  final bool? showCursor;
  final bool autofocus;
  final String obscuringCharacter;
  final bool obscureText;
  final bool? autocorrect;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final bool enableSuggestions;
  final int maxLines;
  final int? minLines;
  final bool expands;
  final int? maxLength;
  final MaxLengthEnforcement? maxLengthEnforcement;

  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;

  final double cursorWidth;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final bool cursorOpacityAnimates;
  final Color? cursorColor;

  final BoxHeightStyle? selectionHeightStyle;
  final BoxWidthStyle? selectionWidthStyle;
  final Brightness? keyboardAppearance;
  final DragStartBehavior dragStartBehavior;
  final bool? enableInteractiveSelection;
  final bool? selectAllOnFocus;
  final TextSelectionControls? selectionControls;

  final GestureTapCallback? onTap;
  final TapRegionCallback? onTapOutside;
  final TapRegionUpCallback? onTapUpOutside;

  final ScrollController? scrollController;
  final ScrollPhysics? scrollPhysics;
  final EdgeInsets scrollPadding;

  final Iterable<String>? autofillHints;
  final ContentInsertionConfiguration? contentInsertionConfiguration;
  final Clip clipBehavior;
  final String? restorationId;
  final bool stylusHandwritingEnabled;
  final bool enableIMEPersonalizedLearning;
  final EditableTextContextMenuBuilder? contextMenuBuilder;
  final SpellCheckConfiguration? spellCheckConfiguration;
  final TextMagnifierConfiguration? magnifierConfiguration;

  static const kDefaultGroupId = EditableText;
  static const kDefaultTextCapitalization = TextCapitalization.none;
  static const kDefaultTextAlign = TextAlign.start;
  static const kDefaultReadOnly = false;
  static const kDefaultAutofocus = false;
  static const kDefaultObscuringCharacter = '•';
  static const kDefaultObscureText = false;
  static const kDefaultEnableSuggestions = true;
  static const kDefaultMaxLines = 1;
  static const kDefaultExpands = false;
  static const kDefaultMaxLengthEnforcement = MaxLengthEnforcement.enforced;
  static const kDefaultCursorWidth = 2.0;
  static const kDefaultCursorRadius = Radius.circular(2);
  static const kDefaultCursorOpacityAnimates = true;
  static const kDefaultDragStartBehavior = DragStartBehavior.start;
  static const kDefaultEnableInteractiveSelection = true;
  static const kDefaultSelectAllOnFocus = false;
  static const kDefaultScrollPadding = EdgeInsets.all(20);
  static const kDefaultClipBehavior = Clip.hardEdge;
  static const kDefaultStylusHandwritingEnabled = true;
  static const kDefaultEnableIMEPersonalizedLearning = true;

  const PlatformTextFieldData({
    this.widgetKey,
    this.groupId = kDefaultGroupId,
    this.controller,
    this.focusNode,
    this.undoController,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = kDefaultTextCapitalization,
    this.style,
    this.strutStyle,
    this.textAlign = kDefaultTextAlign,
    this.textAlignVertical,
    this.textDirection,
    this.readOnly = kDefaultReadOnly,
    this.showCursor,
    this.autofocus = kDefaultAutofocus,
    this.obscuringCharacter = kDefaultObscuringCharacter,
    this.obscureText = kDefaultObscureText,
    this.autocorrect,
    this.smartDashesType,
    this.smartQuotesType,
    this.enableSuggestions = kDefaultEnableSuggestions,
    this.maxLines = kDefaultMaxLines,
    this.minLines,
    this.expands = kDefaultExpands,
    this.maxLength,
    this.maxLengthEnforcement = kDefaultMaxLengthEnforcement,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.inputFormatters,
    this.enabled,
    this.cursorWidth = kDefaultCursorWidth,
    this.cursorHeight,
    this.cursorRadius = kDefaultCursorRadius,
    this.cursorOpacityAnimates = kDefaultCursorOpacityAnimates,
    this.cursorColor,
    this.selectionHeightStyle,
    this.selectionWidthStyle,
    this.keyboardAppearance,
    this.dragStartBehavior = kDefaultDragStartBehavior,
    this.enableInteractiveSelection = kDefaultEnableInteractiveSelection,
    this.selectAllOnFocus = kDefaultSelectAllOnFocus,
    this.selectionControls,
    this.onTap,
    this.onTapOutside,
    this.onTapUpOutside,
    this.scrollController,
    this.scrollPhysics,
    this.scrollPadding = kDefaultScrollPadding,
    this.autofillHints,
    this.contentInsertionConfiguration,
    this.clipBehavior = kDefaultClipBehavior,
    this.restorationId,
    this.stylusHandwritingEnabled = kDefaultStylusHandwritingEnabled,
    this.enableIMEPersonalizedLearning = kDefaultEnableIMEPersonalizedLearning,
    this.contextMenuBuilder,
    this.spellCheckConfiguration,
    this.magnifierConfiguration,
  });
}

final class MaterialTextFieldData extends PlatformTextFieldData {
  final InputCounterWidgetBuilder? buildCounter;
  final bool canRequestFocus;
  final Color? cursorErrorColor;
  final InputDecoration decoration;
  final List<Locale>? hintLocales;
  final bool? ignorePointers;
  final MouseCursor? mouseCursor;
  final AppPrivateCommandCallback? onAppPrivateCommand;
  final bool onTapAlwaysCalled;
  final WidgetStatesController? statesController;

  static const kDefaultCanRequestFocus = true;
  static const kDefaultDecoration = InputDecoration();
  static const kDefaultOnTapAlwaysCalled = false;

  const MaterialTextFieldData({
    super.widgetKey,
    super.groupId,
    super.controller,
    super.focusNode,
    super.undoController,
    super.keyboardType,
    super.textInputAction,
    super.textCapitalization,
    super.style,
    super.strutStyle,
    super.textAlign,
    super.textAlignVertical,
    super.textDirection,
    super.readOnly,
    super.showCursor,
    super.autofocus,
    super.obscuringCharacter,
    super.obscureText,
    super.autocorrect,
    super.smartDashesType,
    super.smartQuotesType,
    super.enableSuggestions,
    super.maxLines,
    super.minLines,
    super.expands,
    super.maxLength,
    super.maxLengthEnforcement,
    super.onChanged,
    super.onEditingComplete,
    super.onSubmitted,
    super.inputFormatters,
    super.enabled,
    super.cursorWidth,
    super.cursorHeight,
    super.cursorRadius,
    super.cursorOpacityAnimates,
    super.cursorColor,
    super.selectionHeightStyle,
    super.selectionWidthStyle,
    super.keyboardAppearance,
    super.dragStartBehavior,
    super.enableInteractiveSelection,
    super.selectAllOnFocus,
    super.selectionControls,
    super.onTap,
    super.onTapOutside,
    super.onTapUpOutside,
    super.scrollController,
    super.scrollPhysics,
    super.scrollPadding,
    super.autofillHints,
    super.contentInsertionConfiguration,
    super.clipBehavior,
    super.restorationId,
    super.stylusHandwritingEnabled,
    super.enableIMEPersonalizedLearning,
    super.contextMenuBuilder,
    super.spellCheckConfiguration,
    super.magnifierConfiguration,
    this.buildCounter,
    this.canRequestFocus = kDefaultCanRequestFocus,
    this.cursorErrorColor,
    this.decoration = kDefaultDecoration,
    this.hintLocales,
    this.ignorePointers,
    this.mouseCursor,
    this.onAppPrivateCommand,
    this.onTapAlwaysCalled = kDefaultOnTapAlwaysCalled,
    this.statesController,
  });
}

final class CupertinoTextFieldData extends PlatformTextFieldData {
  final BoxDecoration? decoration;
  final OverlayVisibilityMode clearButtonMode;
  final String? clearButtonSemanticLabel;
  final CrossAxisAlignment crossAxisAlignment;
  final EdgeInsetsGeometry padding;

  final String? placeholder;
  final TextStyle? placeholderStyle;
  final Widget? prefix;
  final OverlayVisibilityMode prefixMode;
  final Widget? suffix;
  final OverlayVisibilityMode suffixMode;

  static const kDefaultEnabled = true;
  static const kDefaultClearButtonMode = OverlayVisibilityMode.never;
  static const kDefaultCrossAxisAlignment = CrossAxisAlignment.center;
  static const kDefaultPadding = EdgeInsets.all(7);
  static const kDefaultPrefixMode = OverlayVisibilityMode.always;
  static const kDefaultSuffixMode = OverlayVisibilityMode.always;

  const CupertinoTextFieldData({
    super.widgetKey,
    super.groupId,
    super.controller,
    super.focusNode,
    super.undoController,
    super.keyboardType,
    super.textInputAction,
    super.textCapitalization,
    super.style,
    super.strutStyle,
    super.textAlign,
    super.textAlignVertical,
    super.textDirection,
    super.readOnly,
    super.showCursor,
    super.autofocus,
    super.obscuringCharacter,
    super.obscureText,
    super.autocorrect,
    super.smartDashesType,
    super.smartQuotesType,
    super.enableSuggestions,
    super.maxLines,
    super.minLines,
    super.expands,
    super.maxLength,
    super.maxLengthEnforcement,
    super.onChanged,
    super.onEditingComplete,
    super.onSubmitted,
    super.inputFormatters,
    super.enabled,
    super.cursorWidth,
    super.cursorHeight,
    super.cursorRadius,
    super.cursorOpacityAnimates,
    super.cursorColor,
    super.selectionHeightStyle,
    super.selectionWidthStyle,
    super.keyboardAppearance,
    super.dragStartBehavior,
    super.enableInteractiveSelection,
    super.selectAllOnFocus,
    super.selectionControls,
    super.onTap,
    super.onTapOutside,
    super.onTapUpOutside,
    super.scrollController,
    super.scrollPhysics,
    super.scrollPadding,
    super.autofillHints,
    super.contentInsertionConfiguration,
    super.clipBehavior,
    super.restorationId,
    super.stylusHandwritingEnabled,
    super.enableIMEPersonalizedLearning,
    super.contextMenuBuilder,
    super.spellCheckConfiguration,
    super.magnifierConfiguration,
    this.decoration,
    this.clearButtonMode = kDefaultClearButtonMode,
    this.clearButtonSemanticLabel,
    this.crossAxisAlignment = kDefaultCrossAxisAlignment,
    this.padding = kDefaultPadding,
    this.placeholder,
    this.placeholderStyle,
    this.prefix,
    this.prefixMode = kDefaultPrefixMode,
    this.suffix,
    this.suffixMode = kDefaultSuffixMode,
  });
}
