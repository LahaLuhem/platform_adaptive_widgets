// ignore_for_file: prefer-match-file-name

import 'package:flutter/widgets.dart';

abstract final class _PlatformMenuPickerData {
  final Widget? leadingIcon;
  final String? labelText;

  const _PlatformMenuPickerData({this.leadingIcon, this.labelText});
}

final class MaterialMenuPickerData extends _PlatformMenuPickerData {
  final EdgeInsetsGeometry? expandedInsets;

  const MaterialMenuPickerData({super.leadingIcon, super.labelText, this.expandedInsets});
}

final class CupertinoMenuPickerData extends _PlatformMenuPickerData {
  final Color? backgroundColor;

  const CupertinoMenuPickerData({super.leadingIcon, super.labelText, this.backgroundColor});
}
