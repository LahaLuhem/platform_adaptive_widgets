// The Material section and the header both looks share, in one file.
// ignore_for_file: prefer-match-file-name

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show Theme;

/// Lines the header up with the rows' titles, which start past their leading control.
const _kMaterialHeaderPadding = EdgeInsetsDirectional.fromSTEB(72, 16, 24, 8);

/// The list sits in a page, whose own title is the level 1 heading.
const _kHeaderHeadingLevel = 2;

/// A select list's rows on Material, under its header.
@internal
final class const MaterialSelectListSection({
  required final List<Widget> rows,
  final String? header,
  super.key,
}) extends StatelessWidget {
  /// Creates the Material frame around a list's rows.
  this;

  @override
  Widget build(BuildContext context) {
    final header = this.header;
    final themeData = Theme.of(context);

    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      children: [
        if (header != null)
          Padding(
            padding: _kMaterialHeaderPadding,
            child: SelectListHeader(
              text: header,
              style: themeData.textTheme.titleSmall?.copyWith(color: themeData.colorScheme.primary),
            ),
          ),
        ...rows,
      ],
    );
  }
}

/// A select list's header, which screen readers read as a heading.
@internal
final class const SelectListHeader({required final String text, final TextStyle? style, super.key})
    extends StatelessWidget {
  /// Creates a select list's header.
  this;

  @override
  Widget build(BuildContext context) => Semantics(
    header: true,
    // iOS and Android take a heading from its level, not from `header`.
    headingLevel: _kHeaderHeadingLevel,
    child: Text(text, style: style),
  );
}
