// The decoration merge reads base's own slots so they beat the flat ones.
// ignore_for_file: avoid-passing-self-as-argument

import 'dart:ui' show BoxHeightStyle, BoxWidthStyle;

import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoTextField;
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '/src/models/interaction/platform_text_field_data.dart';
import '/src/models/platform_widget_base.dart';

/// Material [TextField] on Android, [CupertinoTextField] on iOS.
///
/// [hintText], [prefix] and [suffix] sit flat on the widget rather than behind a data record, since
/// those 3 come up constantly and routing them through per-platform records is the boilerplate this
/// package is meant to spare you. They land on Material's `decoration.hintText` / `prefixIcon` / `suffixIcon`
/// and Cupertino's `placeholder` / `prefix` / `suffix`.
///
/// Set the same slot on [materialTextFieldData] or [cupertinoTextFieldData] and that wins for its own
/// branch. So the flat value is the cross-platform default and the record is the per-platform override.
/// See `APPENDIX.md#cross-platform-field-mappings` and `APPENDIX.md#field-classification`.
///
/// Example:
/// {@example /example/lib/snippets/interaction/platform_text_field.dart#platform_text_field}
class const PlatformTextField({
  // ---- Common content slots (flat shared) ----------------------------------
  /// Shown while the field is empty. iOS calls it the placeholder.
  final String? hintText,

  /// Sits before the input, usually an icon. iOS keeps it visible at all times by default.
  final Widget? prefix,

  /// Sits after the input, usually an icon. iOS keeps it visible at all times by default.
  final Widget? suffix,

  // ---- Controllers / focus / state -----------------------------------------
  /// Groups this field's undo history with other editors sharing the same id.
  final Object groupId = EditableText,

  final TextEditingController? controller,

  final FocusNode? focusNode,

  final UndoHistoryController? undoController,

  /// One boolean for both, though Material's own `enabled` is nullable. See `APPENDIX.md#cross-platform-field-mappings`.
  final bool isEnabled = true,

  /// Still selectable and focusable, just not editable, unlike [isEnabled].
  final bool readOnly = false,

  final bool autofocus = false,

  // ---- Keyboard / IME -------------------------------------------------------
  final TextInputType? keyboardType,

  /// The action key in the keyboard's corner.
  final TextInputAction? textInputAction,

  final TextCapitalization textCapitalization = .none,

  final SmartDashesType? smartDashesType,

  final SmartQuotesType? smartQuotesType,

  final bool enableSuggestions = true,

  /// `true` to match Cupertino's own default. Material can't tell `true` from `null` anyway.
  final bool autocorrect = true,

  /// Lets the keyboard learn from what gets typed here.
  final bool enableIMEPersonalizedLearning = true,

  final bool stylusHandwritingEnabled = true,

  final Brightness? keyboardAppearance,

  // ---- Text rendering -------------------------------------------------------
  final TextStyle? style,

  final StrutStyle? strutStyle,

  final TextAlign textAlign = .start,

  final TextAlignVertical? textAlignVertical,

  final TextDirection? textDirection,

  /// What each character turns into while [obscureText] is on.
  final String obscuringCharacter = '•',

  /// For passwords and the like.
  final bool obscureText = false,

  /// `null` lets the field grow without limit.
  final int? maxLines = 1,

  final int? minLines,

  /// Fills the parent's height, which needs [maxLines] and [minLines] both `null`.
  final bool expands = false,

  final int? maxLength,

  /// Whether going over [maxLength] is blocked outright or merely flagged.
  final MaxLengthEnforcement? maxLengthEnforcement = MaxLengthEnforcement.enforced,

  final List<TextInputFormatter>? inputFormatters,

  // ---- Cursor ---------------------------------------------------------------
  /// Left out, the field decides from whether it has focus.
  final bool? showCursor,

  final double cursorWidth = 2.0,

  /// Left out, the field sizes it from the text.
  final double? cursorHeight,

  final Radius? cursorRadius = const Radius.circular(2),

  /// Whether the cursor fades in and out rather than blinking.
  final bool cursorOpacityAnimates = true,

  final Color? cursorColor,

  // ---- Selection ------------------------------------------------------------
  final BoxHeightStyle? selectionHeightStyle,

  final BoxWidthStyle? selectionWidthStyle,

  /// Lets the user select and copy text at all.
  final bool? enableInteractiveSelection = true,

  final bool? selectAllOnFocus,

  final TextSelectionControls? selectionControls,

  // ---- Callbacks ------------------------------------------------------------
  /// Optional, since plenty of fields are controller-driven and just read `controller.text` at the end.
  /// Same shape as Flutter's own [TextField.onChanged].
  final ValueChanged<String>? onChanged,

  final VoidCallback? onEditingComplete,

  final ValueChanged<String>? onSubmitted,

  final GestureTapCallback? onTap,

  final TapRegionCallback? onTapOutside,

  /// Cupertino hands its version a [PointerDownEvent] where the type says [PointerUpEvent], so the build
  /// site fakes up the right event. That way one [TapRegionUpCallback] works on both platforms.
  final TapRegionUpCallback? onTapUpOutside,

  // ---- Scrolling / layout ---------------------------------------------------
  final ScrollController? scrollController,

  final ScrollPhysics? scrollPhysics,

  /// How much room to keep around the cursor when scrolling it into view.
  final EdgeInsets scrollPadding = const .all(20),

  final DragStartBehavior dragStartBehavior = .start,

  final Clip clipBehavior = .hardEdge,

  // ---- Autofill / context ---------------------------------------------------
  /// Tells the OS autofill service what kind of value goes here.
  final Iterable<String>? autofillHints,

  /// Covers pasting and drag-and-drop of non-text content.
  final ContentInsertionConfiguration? contentInsertionConfiguration,

  final String? restorationId,

  final EditableTextContextMenuBuilder? contextMenuBuilder,

  final SpellCheckConfiguration? spellCheckConfiguration,

  /// The loupe that pops up while dragging the cursor.
  final TextMagnifierConfiguration? magnifierConfiguration,

  // ---- Per-platform records -------------------------------------------------
  /// Material-branch overrides, plus the knobs Cupertino has no answer for. Its `decoration` slots beat
  /// the flat [hintText] / [prefix] / [suffix] here.
  final MaterialTextFieldData? materialTextFieldData,

  /// Cupertino-branch overrides, plus the knobs Material has no answer for. Its `placeholder` / `prefix`
  /// / `suffix` beat the flat ones here.
  final CupertinoTextFieldData? cupertinoTextFieldData,
  super.widgetKey,
  super.key,
}) extends PlatformWidgetKeyedBase {
  /// Creates a platform-adaptive text field.
  this;

  @override
  Widget buildMaterial(BuildContext context) {
    // Merge widget-level flat slots into the Material decoration. Data-class values win when explicitly
    // set. Flat widget values fill the gaps.
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
    // Cupertino's cursorRadius is non-null with an inline default. Substitute
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
    // Pattern match binds the non-null callback in the match arm, that
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

/// Works around an upstream bug: Cupertino's `onTapUpOutside` is typed for a tap-down event despite
/// the name. Copies the pointer metadata across so callers get the [PointerUpEvent] they asked for.
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
