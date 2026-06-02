import 'dart:ui' show BoxHeightStyle, BoxWidthStyle;

import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoTextField;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '/src/models/interaction/platform_text_field_data.dart';
import '/src/models/platform_widget_base.dart';

/// A platform-adaptive text field that renders Material [TextField] on Android
/// and [CupertinoTextField] on iOS.
///
/// All shared functional inputs (controller, focus, keyboard, text-behavior,
/// cursor, scrolling, autofill, IME, selection, context menu, …) live as flat
/// constructor parameters. The three most-common content slots — [hintText],
/// [prefix], and [suffix] — are also flat on the widget, since forcing every
/// caller through a per-platform data record for these is exactly the kind of
/// boilerplate this package exists to remove.
///
/// **Slot mapping.**
/// - [hintText] → Material `decoration.hintText` + Cupertino `placeholder`.
/// - [prefix]   → Material `decoration.prefixIcon` + Cupertino `prefix`
///   (always visible by default; matches Cupertino's `prefixMode = always`).
/// - [suffix]   → Material `decoration.suffixIcon` + Cupertino `suffix`
///   (always visible by default).
///
/// **Override precedence.** If you also pass [MaterialTextFieldData.decoration]
/// with `hintText` / `prefixIcon` / `suffixIcon` set, those win for the
/// Material branch. If you pass [CupertinoTextFieldData.placeholder] /
/// `prefix` / `suffix`, those win for the Cupertino branch. The flat
/// widget-level values are the cross-platform default; data-class values are
/// per-platform overrides. See `APPENDIX.md#cross-platform-field-mappings`.
///
/// Per-platform tuning beyond the common slots is opt-in via
/// [materialTextFieldData] and [cupertinoTextFieldData]. See
/// `APPENDIX.md#field-classification` for the classification rule.
///
/// Example:
/// ```dart
/// PlatformTextField(
///   controller: _controller,
///   hintText: 'Search',
///   prefix: const Icon(Icons.search),
///   onSubmitted: _runSearch,
/// )
/// ```
class PlatformTextField extends PlatformWidgetKeyedBase {
  // ---- Common content slots (flat shared) ----------------------------------

  /// Placeholder / hint text shown when the field is empty. Maps to
  /// Material `decoration.hintText` and Cupertino `placeholder`. Overridden
  /// per-platform when [MaterialTextFieldData.decoration]'s `hintText` or
  /// [CupertinoTextFieldData.placeholder] are set.
  final String? hintText;

  /// Widget rendered before the text input (typically an icon). Maps to
  /// Material `decoration.prefixIcon` and Cupertino `prefix`. Overridden
  /// per-platform when [MaterialTextFieldData.decoration]'s `prefixIcon` or
  /// [CupertinoTextFieldData.prefix] are set.
  final Widget? prefix;

  /// Widget rendered after the text input (typically an icon). Maps to
  /// Material `decoration.suffixIcon` and Cupertino `suffix`. Overridden
  /// per-platform when [MaterialTextFieldData.decoration]'s `suffixIcon` or
  /// [CupertinoTextFieldData.suffix] are set.
  final Widget? suffix;

  // ---- Controllers / focus / state -----------------------------------------

  /// Group ID for undo-history grouping with other editors.
  final Object groupId;

  /// Text-editing controller.
  final TextEditingController? controller;

  /// Focus node.
  final FocusNode? focusNode;

  /// Undo-history controller.
  final UndoHistoryController? undoController;

  /// Whether the field is enabled and responds to input. Defaults to `true`.
  /// Maps to Material `enabled: bool?` and Cupertino `enabled: bool` directly
  /// — see `APPENDIX.md#cross-platform-field-mappings`.
  final bool isEnabled;

  /// Whether the field is read-only.
  final bool readOnly;

  /// Whether the field should autofocus on mount. Defaults to `false`.
  final bool autofocus;

  // ---- Keyboard / IME -------------------------------------------------------

  /// Keyboard type.
  final TextInputType? keyboardType;

  /// Action button on the keyboard's bottom-right.
  final TextInputAction? textInputAction;

  /// Capitalisation behaviour applied as the user types.
  final TextCapitalization textCapitalization;

  /// Smart-dashes input feature.
  final SmartDashesType? smartDashesType;

  /// Smart-quotes input feature.
  final SmartQuotesType? smartQuotesType;

  /// Whether to enable input suggestions.
  final bool enableSuggestions;

  /// Whether to enable autocorrect. Defaults to `true` (matches Cupertino's
  /// upstream default; Material treats `true` and `null` identically).
  final bool autocorrect;

  /// Whether to enable IME personalised learning.
  final bool enableIMEPersonalizedLearning;

  /// Whether stylus handwriting is enabled.
  final bool stylusHandwritingEnabled;

  /// Keyboard appearance (light or dark).
  final Brightness? keyboardAppearance;

  // ---- Text rendering -------------------------------------------------------

  /// Text style for the input text.
  final TextStyle? style;

  /// Strut style for the input text.
  final StrutStyle? strutStyle;

  /// Text alignment within the field.
  final TextAlign textAlign;

  /// Vertical text alignment within the field.
  final TextAlignVertical? textAlignVertical;

  /// Text direction.
  final TextDirection? textDirection;

  /// Character used to obscure text (e.g. for passwords).
  final String obscuringCharacter;

  /// Whether to obscure the text.
  final bool obscureText;

  /// Maximum number of lines.
  final int? maxLines;

  /// Minimum number of lines.
  final int? minLines;

  /// Whether the field expands to fill its parent.
  final bool expands;

  /// Maximum character length.
  final int? maxLength;

  /// How [maxLength] is enforced.
  final MaxLengthEnforcement? maxLengthEnforcement;

  /// Input formatters applied to the text.
  final List<TextInputFormatter>? inputFormatters;

  // ---- Cursor ---------------------------------------------------------------

  /// Whether to show the cursor. When `null`, derived from focus state.
  final bool? showCursor;

  /// Width of the cursor.
  final double cursorWidth;

  /// Height of the cursor. When `null`, derived from text metrics.
  final double? cursorHeight;

  /// Radius of the cursor.
  final Radius? cursorRadius;

  /// Whether the cursor opacity animates.
  final bool cursorOpacityAnimates;

  /// Colour of the cursor.
  final Color? cursorColor;

  // ---- Selection ------------------------------------------------------------

  /// Selection-region height style.
  final BoxHeightStyle? selectionHeightStyle;

  /// Selection-region width style.
  final BoxWidthStyle? selectionWidthStyle;

  /// Whether interactive selection is enabled.
  final bool? enableInteractiveSelection;

  /// Whether to select all text on focus.
  final bool? selectAllOnFocus;

  /// Custom text-selection controls.
  final TextSelectionControls? selectionControls;

  // ---- Callbacks ------------------------------------------------------------

  /// Callback fired when the text changes. Optional — text fields are
  /// frequently controller-driven (read `controller.text` on submit), so
  /// nullable per Flutter's own [TextField.onChanged] shape.
  final ValueChanged<String>? onChanged;

  /// Callback fired when editing is complete (e.g. on submit).
  final VoidCallback? onEditingComplete;

  /// Callback fired when the text is submitted.
  final ValueChanged<String>? onSubmitted;

  /// Callback fired when the field is tapped.
  final GestureTapCallback? onTap;

  /// Callback fired when tapping outside the field.
  final TapRegionCallback? onTapOutside;

  /// Callback fired on tap-up outside the field.
  ///
  /// **Cupertino-bug workaround.** Upstream Cupertino's `onTapUpOutside`
  /// callback is typed as if it received a [PointerDownEvent] (the package
  /// expects [PointerUpEvent] per [TapRegionUpCallback]). The build site
  /// synthesises a [PointerUpEvent] from the Cupertino-provided
  /// [PointerDownEvent] so callers can write a single
  /// [TapRegionUpCallback] that works on both platforms.
  final TapRegionUpCallback? onTapUpOutside;

  // ---- Scrolling / layout ---------------------------------------------------

  /// Scroll controller for the field's internal scroll view.
  final ScrollController? scrollController;

  /// Scroll physics for the field's internal scroll view.
  final ScrollPhysics? scrollPhysics;

  /// Scroll padding applied while bringing the cursor into view.
  final EdgeInsets scrollPadding;

  /// Drag-start behaviour for text-selection gestures.
  final DragStartBehavior dragStartBehavior;

  /// Clip behaviour applied to the field's render box.
  final Clip clipBehavior;

  // ---- Autofill / context ---------------------------------------------------

  /// Autofill hints for the OS-level autofill service.
  final Iterable<String>? autofillHints;

  /// Configuration for content insertion (paste, drag-drop).
  final ContentInsertionConfiguration? contentInsertionConfiguration;

  /// Restoration ID for state restoration.
  final String? restorationId;

  /// Custom context-menu builder.
  final EditableTextContextMenuBuilder? contextMenuBuilder;

  /// Spell-check configuration.
  final SpellCheckConfiguration? spellCheckConfiguration;

  /// Magnifier configuration.
  final TextMagnifierConfiguration? magnifierConfiguration;

  // ---- Per-platform records -------------------------------------------------

  /// Material-only visual + functional overrides. Optional.
  ///
  /// Fields set on this record drive the Material branch only. Setting
  /// `decoration.hintText` / `decoration.prefixIcon` / `decoration.suffixIcon`
  /// here overrides the corresponding widget-level flat slots ([hintText], [prefix], [suffix]) on Material.
  final MaterialTextFieldData? materialTextFieldData;

  /// Cupertino-only visual + functional overrides. Optional.
  ///
  /// Fields set on this record drive the Cupertino branch only. Setting
  /// [CupertinoTextFieldData.placeholder] / `prefix` / `suffix` here
  /// overrides the corresponding widget-level flat slots ([hintText], [prefix], [suffix]) on Cupertino.
  final CupertinoTextFieldData? cupertinoTextFieldData;

  /// Creates a platform-adaptive text field.
  const PlatformTextField({
    this.hintText,
    this.prefix,
    this.suffix,
    this.groupId = EditableText,
    this.controller,
    this.focusNode,
    this.undoController,
    this.isEnabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = .none,
    this.smartDashesType,
    this.smartQuotesType,
    this.enableSuggestions = true,
    this.autocorrect = true,
    this.enableIMEPersonalizedLearning = true,
    this.stylusHandwritingEnabled = true,
    this.keyboardAppearance,
    this.style,
    this.strutStyle,
    this.textAlign = .start,
    this.textAlignVertical,
    this.textDirection,
    this.obscuringCharacter = '•',
    this.obscureText = false,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.maxLength,
    this.maxLengthEnforcement = MaxLengthEnforcement.enforced,
    this.inputFormatters,
    this.showCursor,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius = const Radius.circular(2),
    this.cursorOpacityAnimates = true,
    this.cursorColor,
    this.selectionHeightStyle,
    this.selectionWidthStyle,
    this.enableInteractiveSelection = true,
    this.selectAllOnFocus,
    this.selectionControls,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.onTap,
    this.onTapOutside,
    this.onTapUpOutside,
    this.scrollController,
    this.scrollPhysics,
    this.scrollPadding = const EdgeInsets.all(20),
    this.dragStartBehavior = .start,
    this.clipBehavior = .hardEdge,
    this.autofillHints,
    this.contentInsertionConfiguration,
    this.restorationId,
    this.contextMenuBuilder,
    this.spellCheckConfiguration,
    this.magnifierConfiguration,
    this.materialTextFieldData,
    this.cupertinoTextFieldData,
    super.widgetKey,
    super.key,
  });

  @override
  Widget buildMaterial(BuildContext context) {
    // Merge widget-level flat slots into the Material decoration. Data-class values win
    // when explicitly set; flat widget values fill the gaps.
    final baseDecoration = materialTextFieldData?.decoration ?? kDefaultMaterialTextFieldDecoration;
    final mergedDecoration = baseDecoration.copyWith(
      hintText: baseDecoration.hintText ?? hintText,
      prefixIcon: baseDecoration.prefixIcon ?? prefix,
      suffixIcon: baseDecoration.suffixIcon ?? suffix,
    );

    return TextField(
      key: widgetKey,
      groupId: groupId,
      controller: controller,
      focusNode: focusNode,
      undoController: undoController,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      style: style,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textAlignVertical: textAlignVertical,
      textDirection: textDirection,
      readOnly: readOnly,
      showCursor: showCursor,
      autofocus: autofocus,
      obscuringCharacter: obscuringCharacter,
      obscureText: obscureText,
      autocorrect: autocorrect,
      smartDashesType: smartDashesType,
      smartQuotesType: smartQuotesType,
      enableSuggestions: enableSuggestions,
      maxLines: maxLines,
      minLines: minLines,
      expands: expands,
      maxLength: maxLength,
      maxLengthEnforcement: maxLengthEnforcement,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      onSubmitted: onSubmitted,
      inputFormatters: inputFormatters,
      enabled: isEnabled,
      cursorWidth: cursorWidth,
      cursorHeight: cursorHeight,
      cursorRadius: cursorRadius,
      cursorOpacityAnimates: cursorOpacityAnimates,
      cursorColor: cursorColor,
      selectionHeightStyle: selectionHeightStyle,
      selectionWidthStyle: selectionWidthStyle,
      keyboardAppearance: keyboardAppearance,
      scrollPadding: scrollPadding,
      dragStartBehavior: dragStartBehavior,
      enableInteractiveSelection: enableInteractiveSelection,
      selectAllOnFocus: selectAllOnFocus,
      selectionControls: selectionControls,
      onTap: onTap,
      onTapOutside: onTapOutside,
      onTapUpOutside: onTapUpOutside,
      scrollController: scrollController,
      scrollPhysics: scrollPhysics,
      autofillHints: autofillHints,
      contentInsertionConfiguration: contentInsertionConfiguration,
      clipBehavior: clipBehavior,
      restorationId: restorationId,
      stylusHandwritingEnabled: stylusHandwritingEnabled,
      enableIMEPersonalizedLearning: enableIMEPersonalizedLearning,
      contextMenuBuilder: contextMenuBuilder,
      spellCheckConfiguration: spellCheckConfiguration,
      magnifierConfiguration: magnifierConfiguration,
      buildCounter: materialTextFieldData?.buildCounter,
      canRequestFocus:
          materialTextFieldData?.canRequestFocus ?? kDefaultMaterialTextFieldCanRequestFocus,
      cursorErrorColor: materialTextFieldData?.cursorErrorColor,
      decoration: mergedDecoration,
      hintLocales: materialTextFieldData?.hintLocales,
      ignorePointers: materialTextFieldData?.ignorePointers,
      mouseCursor: materialTextFieldData?.mouseCursor,
      onAppPrivateCommand: materialTextFieldData?.onAppPrivateCommand,
      onTapAlwaysCalled:
          materialTextFieldData?.onTapAlwaysCalled ?? kDefaultMaterialTextFieldOnTapAlwaysCalled,
      statesController: materialTextFieldData?.statesController,
    );
  }

  @override
  Widget buildCupertino(BuildContext context) => CupertinoTextField(
    key: widgetKey,
    groupId: groupId,
    controller: controller,
    focusNode: focusNode,
    undoController: undoController,
    keyboardType: keyboardType,
    textInputAction: textInputAction,
    textCapitalization: textCapitalization,
    style: style,
    strutStyle: strutStyle,
    textAlign: textAlign,
    textAlignVertical: textAlignVertical,
    textDirection: textDirection,
    readOnly: readOnly,
    showCursor: showCursor,
    autofocus: autofocus,
    obscuringCharacter: obscuringCharacter,
    obscureText: obscureText,
    autocorrect: autocorrect,
    smartDashesType: smartDashesType,
    smartQuotesType: smartQuotesType,
    enableSuggestions: enableSuggestions,
    maxLines: maxLines,
    minLines: minLines,
    expands: expands,
    maxLength: maxLength,
    maxLengthEnforcement: maxLengthEnforcement,
    onChanged: onChanged,
    onEditingComplete: onEditingComplete,
    onSubmitted: onSubmitted,
    inputFormatters: inputFormatters,
    enabled: isEnabled,
    cursorWidth: cursorWidth,
    cursorHeight: cursorHeight,
    // Cupertino's cursorRadius is non-null with an inline default; substitute
    // when the package's nullable flat field is null. Material's stays nullable.
    cursorRadius: cursorRadius ?? const Radius.circular(2),
    cursorOpacityAnimates: cursorOpacityAnimates,
    cursorColor: cursorColor,
    selectionHeightStyle: selectionHeightStyle,
    selectionWidthStyle: selectionWidthStyle,
    keyboardAppearance: keyboardAppearance,
    scrollPadding: scrollPadding,
    dragStartBehavior: dragStartBehavior,
    enableInteractiveSelection: enableInteractiveSelection,
    selectAllOnFocus: selectAllOnFocus,
    selectionControls: selectionControls,
    onTap: onTap,
    onTapOutside: onTapOutside,
    // Pattern match binds the non-null callback in the match arm — that
    // local IS promoted across the closure boundary (an instance field would not be).
    // See [onTapUpOutside] dartdoc for the upstream Cupertino-typing bug this conversion compensates for.
    onTapUpOutside: switch (onTapUpOutside) {
      null => null,
      final onTapUpOutsideCallback => (event) => onTapUpOutsideCallback(event.toPointerUpEvent()),
    },
    scrollController: scrollController,
    scrollPhysics: scrollPhysics,
    autofillHints: autofillHints,
    contentInsertionConfiguration: contentInsertionConfiguration,
    clipBehavior: clipBehavior,
    restorationId: restorationId,
    stylusHandwritingEnabled: stylusHandwritingEnabled,
    enableIMEPersonalizedLearning: enableIMEPersonalizedLearning,
    contextMenuBuilder: contextMenuBuilder,
    spellCheckConfiguration: spellCheckConfiguration,
    magnifierConfiguration: magnifierConfiguration,
    decoration: cupertinoTextFieldData?.decoration,
    clearButtonMode:
        cupertinoTextFieldData?.clearButtonMode ?? kDefaultCupertinoTextFieldClearButtonMode,
    clearButtonSemanticLabel: cupertinoTextFieldData?.clearButtonSemanticLabel,
    crossAxisAlignment:
        cupertinoTextFieldData?.crossAxisAlignment ?? kDefaultCupertinoTextFieldCrossAxisAlignment,
    padding: cupertinoTextFieldData?.padding ?? kDefaultCupertinoTextFieldPadding,
    placeholder: cupertinoTextFieldData?.placeholder ?? hintText,
    placeholderStyle: cupertinoTextFieldData?.placeholderStyle,
    prefix: cupertinoTextFieldData?.prefix ?? prefix,
    prefixMode: cupertinoTextFieldData?.prefixMode ?? kDefaultCupertinoTextFieldPrefixMode,
    suffix: cupertinoTextFieldData?.suffix ?? suffix,
    suffixMode: cupertinoTextFieldData?.suffixMode ?? kDefaultCupertinoTextFieldSuffixMode,
  );
}

/// Bridges Cupertino's [PointerDownEvent]-typed `onTapUpOutside` callback to
/// the package's exposed [TapRegionUpCallback] (which takes [PointerUpEvent]).
/// Upstream Flutter bug — Cupertino names the param `onTapUpOutside` but types
/// it as if it received a tap-down event. [PlatformTextField.buildCupertino]
/// uses this extension to fabricate a [PointerUpEvent] with the same pointer
/// metadata so the caller's single [TapRegionUpCallback] works on both
/// platforms.
extension _PointerEventConversionExtension on PointerDownEvent {
  PointerUpEvent toPointerUpEvent() => PointerUpEvent(
    pointer: pointer,
    kind: kind,
    device: device,
    embedderId: embedderId,
    position: position,
    buttons: buttons,
    obscured: obscured,
    pressure: pressure,
    pressureMin: pressureMin,
    pressureMax: pressureMax,
    distance: distance,
    distanceMax: distanceMax,
    radiusMajor: radiusMajor,
    radiusMinor: radiusMinor,
    radiusMin: radiusMin,
    radiusMax: radiusMax,
    orientation: orientation,
    tilt: tilt,
    size: size,
    timeStamp: timeStamp,
    viewId: viewId,
  );
}
