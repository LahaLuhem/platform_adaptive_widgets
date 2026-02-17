import 'package:flutter/cupertino.dart' show CupertinoTextField;
import 'package:flutter/material.dart' show TextField;
import 'package:flutter/widgets.dart';

import '/src/models/interaction/platform_text_field_data.dart';
import '/src/models/platform_widget_base.dart';

/// A platform-adaptive text field that renders Material TextField on Android
/// and CupertinoTextField on iOS.
///
/// This widget automatically selects the appropriate text field implementation based on the target platform:
/// - On Android: renders Material Design TextField
/// - On iOS: renders CupertinoTextField
///
/// The text field can be configured with platform-specific data through [materialTextFieldData]
/// and [cupertinoTextFieldData], or with common properties through [platformTextFieldData].
///
/// Example:
/// ```dart
/// PlatformTextField(
///   platformTextFieldData: PlatformTextFieldData(
///     controller: _textController,
///     placeholder: 'Enter your name',
///   ),
/// )
/// ```
class PlatformTextField extends PlatformWidgetBase {
  /// Common text field data that applies to both platforms.
  ///
  /// These properties will be used unless overridden by platform-specific data.
  final PlatformTextFieldData? platformTextFieldData;

  /// Platform-specific data for Material Design text fields.
  ///
  /// If provided, these properties will override the common properties when
  /// rendering on Android. See [MaterialTextFieldData] for available options.
  final MaterialTextFieldData? materialTextFieldData;

  /// Platform-specific data for Cupertino text fields.
  ///
  /// If provided, these properties will override the common properties when
  /// rendering on iOS. See [CupertinoTextFieldData] for available options.
  final CupertinoTextFieldData? cupertinoTextFieldData;

  /// Creates a platform-adaptive text field.
  ///
  /// The text field will render as a Material TextField on Android and a CupertinoTextField on iOS.
  /// Use [platformTextFieldData] for common properties, or override with platform-specific data.
  const PlatformTextField({
    this.platformTextFieldData,
    this.materialTextFieldData,
    this.cupertinoTextFieldData,
    super.key,
  });

  @override
  Widget buildMaterial(BuildContext context) => TextField(
    key: materialTextFieldData?.widgetKey ?? platformTextFieldData?.widgetKey,
    groupId:
        platformTextFieldData?.groupId ??
        materialTextFieldData?.groupId ??
        PlatformTextFieldData.kDefaultGroupId,
    controller: materialTextFieldData?.controller ?? platformTextFieldData?.controller,
    focusNode: materialTextFieldData?.focusNode ?? platformTextFieldData?.focusNode,
    undoController: materialTextFieldData?.undoController ?? platformTextFieldData?.undoController,
    keyboardType: materialTextFieldData?.keyboardType ?? platformTextFieldData?.keyboardType,
    textInputAction:
        materialTextFieldData?.textInputAction ?? platformTextFieldData?.textInputAction,
    textCapitalization:
        materialTextFieldData?.textCapitalization ??
        platformTextFieldData?.textCapitalization ??
        PlatformTextFieldData.kDefaultTextCapitalization,
    style: materialTextFieldData?.style ?? platformTextFieldData?.style,
    strutStyle: materialTextFieldData?.strutStyle ?? platformTextFieldData?.strutStyle,
    textAlign:
        materialTextFieldData?.textAlign ??
        platformTextFieldData?.textAlign ??
        PlatformTextFieldData.kDefaultTextAlign,
    textAlignVertical:
        materialTextFieldData?.textAlignVertical ?? platformTextFieldData?.textAlignVertical,
    textDirection: materialTextFieldData?.textDirection ?? platformTextFieldData?.textDirection,
    readOnly:
        materialTextFieldData?.readOnly ??
        platformTextFieldData?.readOnly ??
        PlatformTextFieldData.kDefaultReadOnly,
    showCursor: materialTextFieldData?.showCursor ?? platformTextFieldData?.showCursor,
    autofocus:
        materialTextFieldData?.autofocus ??
        platformTextFieldData?.autofocus ??
        PlatformTextFieldData.kDefaultAutofocus,
    obscuringCharacter:
        materialTextFieldData?.obscuringCharacter ??
        platformTextFieldData?.obscuringCharacter ??
        PlatformTextFieldData.kDefaultObscuringCharacter,
    obscureText:
        materialTextFieldData?.obscureText ??
        platformTextFieldData?.obscureText ??
        PlatformTextFieldData.kDefaultObscureText,
    autocorrect: materialTextFieldData?.autocorrect ?? platformTextFieldData?.autocorrect,
    smartDashesType:
        materialTextFieldData?.smartDashesType ?? platformTextFieldData?.smartDashesType,
    smartQuotesType:
        materialTextFieldData?.smartQuotesType ?? platformTextFieldData?.smartQuotesType,
    enableSuggestions:
        materialTextFieldData?.enableSuggestions ??
        platformTextFieldData?.enableSuggestions ??
        PlatformTextFieldData.kDefaultEnableSuggestions,
    maxLines:
        materialTextFieldData?.maxLines ??
        platformTextFieldData?.maxLines ??
        PlatformTextFieldData.kDefaultMaxLines,
    minLines: materialTextFieldData?.minLines ?? platformTextFieldData?.minLines,
    expands:
        materialTextFieldData?.expands ??
        platformTextFieldData?.expands ??
        PlatformTextFieldData.kDefaultExpands,
    maxLength: materialTextFieldData?.maxLength ?? platformTextFieldData?.maxLength,
    maxLengthEnforcement:
        materialTextFieldData?.maxLengthEnforcement ?? platformTextFieldData?.maxLengthEnforcement,
    onChanged: materialTextFieldData?.onChanged ?? platformTextFieldData?.onChanged,
    onEditingComplete:
        materialTextFieldData?.onEditingComplete ?? platformTextFieldData?.onEditingComplete,
    onSubmitted: materialTextFieldData?.onSubmitted ?? platformTextFieldData?.onSubmitted,
    inputFormatters:
        materialTextFieldData?.inputFormatters ?? platformTextFieldData?.inputFormatters,
    enabled: materialTextFieldData?.enabled ?? platformTextFieldData?.enabled,
    cursorWidth:
        materialTextFieldData?.cursorWidth ??
        platformTextFieldData?.cursorWidth ??
        PlatformTextFieldData.kDefaultCursorWidth,
    cursorHeight: materialTextFieldData?.cursorHeight ?? platformTextFieldData?.cursorHeight,
    cursorRadius:
        materialTextFieldData?.cursorRadius ??
        platformTextFieldData?.cursorRadius ??
        PlatformTextFieldData.kDefaultCursorRadius,
    cursorOpacityAnimates:
        materialTextFieldData?.cursorOpacityAnimates ??
        platformTextFieldData?.cursorOpacityAnimates ??
        PlatformTextFieldData.kDefaultCursorOpacityAnimates,
    cursorColor: materialTextFieldData?.cursorColor ?? platformTextFieldData?.cursorColor,
    selectionHeightStyle:
        materialTextFieldData?.selectionHeightStyle ?? platformTextFieldData?.selectionHeightStyle,
    selectionWidthStyle:
        materialTextFieldData?.selectionWidthStyle ?? platformTextFieldData?.selectionWidthStyle,
    keyboardAppearance:
        materialTextFieldData?.keyboardAppearance ?? platformTextFieldData?.keyboardAppearance,
    scrollPadding:
        materialTextFieldData?.scrollPadding ??
        platformTextFieldData?.scrollPadding ??
        PlatformTextFieldData.kDefaultScrollPadding,
    dragStartBehavior:
        materialTextFieldData?.dragStartBehavior ??
        platformTextFieldData?.dragStartBehavior ??
        PlatformTextFieldData.kDefaultDragStartBehavior,
    enableInteractiveSelection:
        materialTextFieldData?.enableInteractiveSelection ??
        platformTextFieldData?.enableInteractiveSelection ??
        PlatformTextFieldData.kDefaultEnableInteractiveSelection,
    selectAllOnFocus:
        materialTextFieldData?.selectAllOnFocus ??
        platformTextFieldData?.selectAllOnFocus ??
        PlatformTextFieldData.kDefaultSelectAllOnFocus,
    selectionControls:
        materialTextFieldData?.selectionControls ?? platformTextFieldData?.selectionControls,
    onTap: materialTextFieldData?.onTap ?? platformTextFieldData?.onTap,
    onTapOutside: materialTextFieldData?.onTapOutside ?? platformTextFieldData?.onTapOutside,
    onTapUpOutside: materialTextFieldData?.onTapUpOutside ?? platformTextFieldData?.onTapUpOutside,
    scrollController:
        materialTextFieldData?.scrollController ?? platformTextFieldData?.scrollController,
    scrollPhysics: materialTextFieldData?.scrollPhysics ?? platformTextFieldData?.scrollPhysics,
    autofillHints: materialTextFieldData?.autofillHints ?? platformTextFieldData?.autofillHints,
    contentInsertionConfiguration:
        materialTextFieldData?.contentInsertionConfiguration ??
        platformTextFieldData?.contentInsertionConfiguration,
    clipBehavior:
        materialTextFieldData?.clipBehavior ??
        platformTextFieldData?.clipBehavior ??
        PlatformTextFieldData.kDefaultClipBehavior,
    restorationId: materialTextFieldData?.restorationId ?? platformTextFieldData?.restorationId,
    stylusHandwritingEnabled:
        materialTextFieldData?.stylusHandwritingEnabled ??
        platformTextFieldData?.stylusHandwritingEnabled ??
        PlatformTextFieldData.kDefaultStylusHandwritingEnabled,
    enableIMEPersonalizedLearning:
        materialTextFieldData?.enableIMEPersonalizedLearning ??
        platformTextFieldData?.enableIMEPersonalizedLearning ??
        PlatformTextFieldData.kDefaultEnableIMEPersonalizedLearning,
    contextMenuBuilder:
        materialTextFieldData?.contextMenuBuilder ?? platformTextFieldData?.contextMenuBuilder,
    spellCheckConfiguration:
        materialTextFieldData?.spellCheckConfiguration ??
        platformTextFieldData?.spellCheckConfiguration,
    magnifierConfiguration:
        materialTextFieldData?.magnifierConfiguration ??
        platformTextFieldData?.magnifierConfiguration,
    buildCounter: materialTextFieldData?.buildCounter,
    canRequestFocus:
        materialTextFieldData?.canRequestFocus ?? MaterialTextFieldData.kDefaultCanRequestFocus,
    cursorErrorColor: materialTextFieldData?.cursorErrorColor,
    decoration: materialTextFieldData?.decoration ?? MaterialTextFieldData.kDefaultDecoration,
    hintLocales: materialTextFieldData?.hintLocales,
    ignorePointers: materialTextFieldData?.ignorePointers,
    mouseCursor: materialTextFieldData?.mouseCursor,
    onAppPrivateCommand: materialTextFieldData?.onAppPrivateCommand,
    onTapAlwaysCalled:
        materialTextFieldData?.onTapAlwaysCalled ?? MaterialTextFieldData.kDefaultOnTapAlwaysCalled,
    statesController: materialTextFieldData?.statesController,
  );

  @override
  Widget buildCupertino(BuildContext context) {
    final resolvedOnTapUpOutside =
        cupertinoTextFieldData?.onTapUpOutside ?? platformTextFieldData?.onTapUpOutside;

    return CupertinoTextField(
      key: cupertinoTextFieldData?.widgetKey ?? platformTextFieldData?.widgetKey,
      groupId:
          platformTextFieldData?.groupId ??
          cupertinoTextFieldData?.groupId ??
          PlatformTextFieldData.kDefaultGroupId,
      controller: cupertinoTextFieldData?.controller ?? platformTextFieldData?.controller,
      focusNode: cupertinoTextFieldData?.focusNode ?? platformTextFieldData?.focusNode,
      undoController:
          cupertinoTextFieldData?.undoController ?? platformTextFieldData?.undoController,
      keyboardType: cupertinoTextFieldData?.keyboardType ?? platformTextFieldData?.keyboardType,
      textInputAction:
          cupertinoTextFieldData?.textInputAction ?? platformTextFieldData?.textInputAction,
      textCapitalization:
          cupertinoTextFieldData?.textCapitalization ??
          platformTextFieldData?.textCapitalization ??
          PlatformTextFieldData.kDefaultTextCapitalization,
      style: cupertinoTextFieldData?.style ?? platformTextFieldData?.style,
      strutStyle: cupertinoTextFieldData?.strutStyle ?? platformTextFieldData?.strutStyle,
      textAlign:
          cupertinoTextFieldData?.textAlign ??
          platformTextFieldData?.textAlign ??
          PlatformTextFieldData.kDefaultTextAlign,
      textAlignVertical:
          cupertinoTextFieldData?.textAlignVertical ?? platformTextFieldData?.textAlignVertical,
      textDirection: cupertinoTextFieldData?.textDirection ?? platformTextFieldData?.textDirection,
      readOnly:
          cupertinoTextFieldData?.readOnly ??
          platformTextFieldData?.readOnly ??
          PlatformTextFieldData.kDefaultReadOnly,
      showCursor: cupertinoTextFieldData?.showCursor ?? platformTextFieldData?.showCursor,
      autofocus:
          cupertinoTextFieldData?.autofocus ??
          platformTextFieldData?.autofocus ??
          PlatformTextFieldData.kDefaultAutofocus,
      obscuringCharacter:
          cupertinoTextFieldData?.obscuringCharacter ??
          platformTextFieldData?.obscuringCharacter ??
          PlatformTextFieldData.kDefaultObscuringCharacter,
      obscureText:
          cupertinoTextFieldData?.obscureText ??
          platformTextFieldData?.obscureText ??
          PlatformTextFieldData.kDefaultObscureText,
      autocorrect: cupertinoTextFieldData?.autocorrect ?? platformTextFieldData?.autocorrect,
      smartDashesType:
          cupertinoTextFieldData?.smartDashesType ?? platformTextFieldData?.smartDashesType,
      smartQuotesType:
          cupertinoTextFieldData?.smartQuotesType ?? platformTextFieldData?.smartQuotesType,
      enableSuggestions:
          cupertinoTextFieldData?.enableSuggestions ??
          platformTextFieldData?.enableSuggestions ??
          PlatformTextFieldData.kDefaultEnableSuggestions,
      maxLines: cupertinoTextFieldData?.maxLines ?? platformTextFieldData?.maxLines,
      minLines: cupertinoTextFieldData?.minLines ?? platformTextFieldData?.minLines,
      expands:
          cupertinoTextFieldData?.expands ??
          platformTextFieldData?.expands ??
          PlatformTextFieldData.kDefaultExpands,
      maxLength: cupertinoTextFieldData?.maxLength ?? platformTextFieldData?.maxLength,
      maxLengthEnforcement:
          cupertinoTextFieldData?.maxLengthEnforcement ??
          platformTextFieldData?.maxLengthEnforcement,
      onChanged: cupertinoTextFieldData?.onChanged ?? platformTextFieldData?.onChanged,
      onEditingComplete:
          cupertinoTextFieldData?.onEditingComplete ?? platformTextFieldData?.onEditingComplete,
      onSubmitted: cupertinoTextFieldData?.onSubmitted ?? platformTextFieldData?.onSubmitted,
      inputFormatters:
          cupertinoTextFieldData?.inputFormatters ?? platformTextFieldData?.inputFormatters,
      enabled:
          cupertinoTextFieldData?.enabled ??
          platformTextFieldData?.enabled ??
          CupertinoTextFieldData.kDefaultEnabled,
      cursorWidth:
          cupertinoTextFieldData?.cursorWidth ??
          platformTextFieldData?.cursorWidth ??
          PlatformTextFieldData.kDefaultCursorWidth,
      cursorHeight: cupertinoTextFieldData?.cursorHeight ?? platformTextFieldData?.cursorHeight,
      cursorRadius:
          cupertinoTextFieldData?.cursorRadius ??
          platformTextFieldData?.cursorRadius ??
          PlatformTextFieldData.kDefaultCursorRadius,
      cursorOpacityAnimates:
          cupertinoTextFieldData?.cursorOpacityAnimates ??
          platformTextFieldData?.cursorOpacityAnimates ??
          PlatformTextFieldData.kDefaultCursorOpacityAnimates,
      cursorColor: cupertinoTextFieldData?.cursorColor ?? platformTextFieldData?.cursorColor,
      selectionHeightStyle:
          cupertinoTextFieldData?.selectionHeightStyle ??
          platformTextFieldData?.selectionHeightStyle,
      selectionWidthStyle:
          cupertinoTextFieldData?.selectionWidthStyle ?? platformTextFieldData?.selectionWidthStyle,
      keyboardAppearance:
          cupertinoTextFieldData?.keyboardAppearance ?? platformTextFieldData?.keyboardAppearance,
      scrollPadding:
          cupertinoTextFieldData?.scrollPadding ??
          platformTextFieldData?.scrollPadding ??
          PlatformTextFieldData.kDefaultScrollPadding,
      dragStartBehavior:
          cupertinoTextFieldData?.dragStartBehavior ??
          platformTextFieldData?.dragStartBehavior ??
          PlatformTextFieldData.kDefaultDragStartBehavior,
      enableInteractiveSelection:
          cupertinoTextFieldData?.enableInteractiveSelection ??
          platformTextFieldData?.enableInteractiveSelection ??
          PlatformTextFieldData.kDefaultEnableInteractiveSelection,
      selectAllOnFocus:
          cupertinoTextFieldData?.selectAllOnFocus ??
          platformTextFieldData?.selectAllOnFocus ??
          PlatformTextFieldData.kDefaultSelectAllOnFocus,
      selectionControls:
          cupertinoTextFieldData?.selectionControls ?? platformTextFieldData?.selectionControls,
      onTap: cupertinoTextFieldData?.onTap ?? platformTextFieldData?.onTap,
      onTapOutside: cupertinoTextFieldData?.onTapOutside ?? platformTextFieldData?.onTapOutside,
      onTapUpOutside: resolvedOnTapUpOutside == null
          ? null
          : (event) => resolvedOnTapUpOutside(event.toPointerUpEvent()),
      scrollController:
          cupertinoTextFieldData?.scrollController ?? platformTextFieldData?.scrollController,
      scrollPhysics: cupertinoTextFieldData?.scrollPhysics ?? platformTextFieldData?.scrollPhysics,
      autofillHints: cupertinoTextFieldData?.autofillHints ?? platformTextFieldData?.autofillHints,
      contentInsertionConfiguration:
          cupertinoTextFieldData?.contentInsertionConfiguration ??
          platformTextFieldData?.contentInsertionConfiguration,
      clipBehavior:
          cupertinoTextFieldData?.clipBehavior ??
          platformTextFieldData?.clipBehavior ??
          PlatformTextFieldData.kDefaultClipBehavior,
      restorationId: cupertinoTextFieldData?.restorationId ?? platformTextFieldData?.restorationId,
      stylusHandwritingEnabled:
          cupertinoTextFieldData?.stylusHandwritingEnabled ??
          platformTextFieldData?.stylusHandwritingEnabled ??
          PlatformTextFieldData.kDefaultStylusHandwritingEnabled,
      enableIMEPersonalizedLearning:
          cupertinoTextFieldData?.enableIMEPersonalizedLearning ??
          platformTextFieldData?.enableIMEPersonalizedLearning ??
          PlatformTextFieldData.kDefaultEnableIMEPersonalizedLearning,
      contextMenuBuilder:
          cupertinoTextFieldData?.contextMenuBuilder ?? platformTextFieldData?.contextMenuBuilder,
      spellCheckConfiguration:
          cupertinoTextFieldData?.spellCheckConfiguration ??
          platformTextFieldData?.spellCheckConfiguration,
      magnifierConfiguration:
          cupertinoTextFieldData?.magnifierConfiguration ??
          platformTextFieldData?.magnifierConfiguration,
      decoration: cupertinoTextFieldData?.decoration,
      clearButtonMode:
          cupertinoTextFieldData?.clearButtonMode ?? CupertinoTextFieldData.kDefaultClearButtonMode,
      clearButtonSemanticLabel: cupertinoTextFieldData?.clearButtonSemanticLabel,
      crossAxisAlignment:
          cupertinoTextFieldData?.crossAxisAlignment ??
          CupertinoTextFieldData.kDefaultCrossAxisAlignment,
      padding: cupertinoTextFieldData?.padding ?? CupertinoTextFieldData.kDefaultPadding,
      placeholder: cupertinoTextFieldData?.placeholder,
      placeholderStyle: cupertinoTextFieldData?.placeholderStyle,
      prefix: cupertinoTextFieldData?.prefix,
      prefixMode: cupertinoTextFieldData?.prefixMode ?? CupertinoTextFieldData.kDefaultPrefixMode,
      suffix: cupertinoTextFieldData?.suffix,
      suffixMode: cupertinoTextFieldData?.suffixMode ?? CupertinoTextFieldData.kDefaultSuffixMode,
    );
  }
}

/// This exists solely as a fix for Cupertino's mismatched signature for `onTapOutside`.
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
