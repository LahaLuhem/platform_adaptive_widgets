import 'dart:ui';

import 'package:flutter/cupertino.dart' show OverlayVisibilityMode;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' show InputCounterWidgetBuilder, InputDecoration;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Platform-shared configuration for a text field widget.
///
/// Contains common properties used by both `TextField` and `CupertinoTextField`.
final class PlatformTextFieldData {
  /// Key applied to the underlying platform widget.
  final Key? widgetKey;

  /// Group ID for undo history grouping.
  final Object groupId;

  /// Text editing controller.
  final TextEditingController? controller;

  /// Focus node for the text field.
  final FocusNode? focusNode;

  /// Undo history controller.
  final UndoHistoryController? undoController;

  /// Keyboard type for the text field.
  final TextInputType? keyboardType;

  /// Text input action button type.
  final TextInputAction? textInputAction;

  /// Text capitalization behavior.
  final TextCapitalization textCapitalization;

  /// Text style for the input text.
  final TextStyle? style;

  /// Strut style for the input text.
  final StrutStyle? strutStyle;

  /// Text alignment within the field.
  final TextAlign textAlign;

  /// Vertical text alignment within the field.
  final TextAlignVertical? textAlignVertical;

  /// Text direction for the input.
  final TextDirection? textDirection;

  /// Whether the text field is read-only.
  final bool readOnly;

  /// Whether to show the cursor.
  final bool? showCursor;

  /// Whether the text field should autofocus.
  final bool autofocus;

  /// Character used to obscure text.
  final String obscuringCharacter;

  /// Whether to obscure the text (e.g., for passwords).
  final bool obscureText;

  /// Whether to enable autocorrect.
  final bool? autocorrect;

  /// Smart dashes type.
  final SmartDashesType? smartDashesType;

  /// Smart quotes type.
  final SmartQuotesType? smartQuotesType;

  /// Whether to enable input suggestions.
  final bool enableSuggestions;

  /// Maximum number of lines.
  final int maxLines;

  /// Minimum number of lines.
  final int? minLines;

  /// Whether the text field expands to fill its parent.
  final bool expands;

  /// Maximum character length.
  final int? maxLength;

  /// How max length is enforced.
  final MaxLengthEnforcement? maxLengthEnforcement;

  /// Callback when the text changes.
  final ValueChanged<String>? onChanged;

  /// Callback when editing is complete.
  final VoidCallback? onEditingComplete;

  /// Callback when the text is submitted.
  final ValueChanged<String>? onSubmitted;

  /// Input formatters applied to the text.
  final List<TextInputFormatter>? inputFormatters;

  /// Whether the text field is enabled.
  final bool? enabled;

  /// Width of the cursor.
  final double cursorWidth;

  /// Height of the cursor.
  final double? cursorHeight;

  /// Radius of the cursor.
  final Radius? cursorRadius;

  /// Whether the cursor opacity animates.
  final bool cursorOpacityAnimates;

  /// Color of the cursor.
  final Color? cursorColor;

  /// Selection height style.
  final BoxHeightStyle? selectionHeightStyle;

  /// Selection width style.
  final BoxWidthStyle? selectionWidthStyle;

  /// Keyboard appearance (light or dark).
  final Brightness? keyboardAppearance;

  /// Drag start behavior for text selection.
  final DragStartBehavior dragStartBehavior;

  /// Whether interactive selection is enabled.
  final bool? enableInteractiveSelection;

  /// Whether to select all text on focus.
  final bool? selectAllOnFocus;

  /// Custom text selection controls.
  final TextSelectionControls? selectionControls;

  /// Callback when the text field is tapped.
  final GestureTapCallback? onTap;

  /// Callback when tapping outside the text field.
  final TapRegionCallback? onTapOutside;

  /// Callback when a tap-up occurs outside the text field.
  final TapRegionUpCallback? onTapUpOutside;

  /// Scroll controller for the text field.
  final ScrollController? scrollController;

  /// Scroll physics for the text field.
  final ScrollPhysics? scrollPhysics;

  /// Scroll padding for the text field.
  final EdgeInsets scrollPadding;

  /// Autofill hints for the text field.
  final Iterable<String>? autofillHints;

  /// Configuration for content insertion.
  final ContentInsertionConfiguration? contentInsertionConfiguration;

  /// Clip behavior for the text field.
  final Clip clipBehavior;

  /// Restoration ID for state restoration.
  final String? restorationId;

  /// Whether stylus handwriting is enabled.
  final bool stylusHandwritingEnabled;

  /// Whether to enable IME personalized learning.
  final bool enableIMEPersonalizedLearning;

  /// Context menu builder for the text field.
  final EditableTextContextMenuBuilder? contextMenuBuilder;

  /// Spell check configuration.
  final SpellCheckConfiguration? spellCheckConfiguration;

  /// Magnifier configuration.
  final TextMagnifierConfiguration? magnifierConfiguration;

  /// Default value for [groupId].
  static const kDefaultGroupId = EditableText;

  /// Default value for [textCapitalization].
  static const kDefaultTextCapitalization = TextCapitalization.none;

  /// Default value for [textAlign].
  static const kDefaultTextAlign = TextAlign.start;

  /// Default value for [readOnly].
  static const kDefaultReadOnly = false;

  /// Default value for [autofocus].
  static const kDefaultAutofocus = false;

  /// Default value for [obscuringCharacter].
  static const kDefaultObscuringCharacter = '•';

  /// Default value for [obscureText].
  static const kDefaultObscureText = false;

  /// Default value for [enableSuggestions].
  static const kDefaultEnableSuggestions = true;

  /// Default value for [maxLines].
  static const kDefaultMaxLines = 1;

  /// Default value for [expands].
  static const kDefaultExpands = false;

  /// Default value for [maxLengthEnforcement].
  static const kDefaultMaxLengthEnforcement = MaxLengthEnforcement.enforced;

  /// Default value for [cursorWidth].
  static const kDefaultCursorWidth = 2.0;

  /// Default value for [cursorRadius].
  static const kDefaultCursorRadius = Radius.circular(2);

  /// Default value for [cursorOpacityAnimates].
  static const kDefaultCursorOpacityAnimates = true;

  /// Default value for [dragStartBehavior].
  static const kDefaultDragStartBehavior = DragStartBehavior.start;

  /// Default value for [enableInteractiveSelection].
  static const kDefaultEnableInteractiveSelection = true;

  /// Default value for [selectAllOnFocus].
  static const kDefaultSelectAllOnFocus = false;

  /// Default value for [scrollPadding].
  static const kDefaultScrollPadding = EdgeInsets.all(20);

  /// Default value for [clipBehavior].
  static const kDefaultClipBehavior = Clip.hardEdge;

  /// Default value for [stylusHandwritingEnabled].
  static const kDefaultStylusHandwritingEnabled = true;

  /// Default value for [enableIMEPersonalizedLearning].
  static const kDefaultEnableIMEPersonalizedLearning = true;

  /// Creates platform text field configuration.
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

/// Material-specific configuration for a text field widget.
///
/// Extends [PlatformTextFieldData] with Material-only properties.
final class MaterialTextFieldData extends PlatformTextFieldData {
  /// Builder for a custom input counter widget.
  final InputCounterWidgetBuilder? buildCounter;

  /// Whether the text field can request focus.
  final bool canRequestFocus;

  /// Color of the cursor when the field has an error.
  final Color? cursorErrorColor;

  /// Input decoration for the text field.
  final InputDecoration decoration;

  /// Locales used for hint text.
  final List<Locale>? hintLocales;

  /// Whether to ignore pointer events.
  final bool? ignorePointers;

  /// Mouse cursor when hovering over the text field.
  final MouseCursor? mouseCursor;

  /// Callback for app-private commands.
  final AppPrivateCommandCallback? onAppPrivateCommand;

  /// Whether [onTap] is always called, even when the field already has focus.
  final bool onTapAlwaysCalled;

  /// Widget states controller for the text field.
  final WidgetStatesController? statesController;

  /// Default value for [canRequestFocus].
  static const kDefaultCanRequestFocus = true;

  /// Default value for [decoration].
  static const kDefaultDecoration = InputDecoration();

  /// Default value for [onTapAlwaysCalled].
  static const kDefaultOnTapAlwaysCalled = false;

  /// Creates Material-specific text field configuration.
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

/// Cupertino-specific configuration for a text field widget.
///
/// Maps to properties of `CupertinoTextField` on iOS.
final class CupertinoTextFieldData extends PlatformTextFieldData {
  /// Box decoration for the text field.
  final BoxDecoration? decoration;

  /// When the clear button is visible.
  final OverlayVisibilityMode clearButtonMode;

  /// Semantic label for the clear button.
  final String? clearButtonSemanticLabel;

  /// Cross-axis alignment of the text field content.
  final CrossAxisAlignment crossAxisAlignment;

  /// Padding around the text field content.
  final EdgeInsetsGeometry padding;

  /// Placeholder text displayed when the field is empty.
  final String? placeholder;

  /// Text style for the placeholder text.
  final TextStyle? placeholderStyle;

  /// Widget displayed before the text input.
  final Widget? prefix;

  /// When the prefix widget is visible.
  final OverlayVisibilityMode prefixMode;

  /// Widget displayed after the text input.
  final Widget? suffix;

  /// When the suffix widget is visible.
  final OverlayVisibilityMode suffixMode;

  /// Default value for [enabled].
  static const kDefaultEnabled = true;

  /// Default value for [clearButtonMode].
  static const kDefaultClearButtonMode = OverlayVisibilityMode.never;

  /// Default value for [crossAxisAlignment].
  static const kDefaultCrossAxisAlignment = CrossAxisAlignment.center;

  /// Default value for [padding].
  static const kDefaultPadding = EdgeInsets.all(7);

  /// Default value for [prefixMode].
  static const kDefaultPrefixMode = OverlayVisibilityMode.always;

  /// Default value for [suffixMode].
  static const kDefaultSuffixMode = OverlayVisibilityMode.always;

  /// Creates Cupertino-specific text field configuration.
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
