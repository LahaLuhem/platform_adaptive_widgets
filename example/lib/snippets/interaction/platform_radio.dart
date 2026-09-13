// Named after the widget file it mirrors, not after its first host class.
// ignore_for_file: prefer-match-file-name

import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

class PlatformRadioSnippet extends StatefulWidget {
  const PlatformRadioSnippet({super.key});

  @override
  State<PlatformRadioSnippet> createState() => _PlatformRadioSnippetState();
}

class _PlatformRadioSnippetState extends State<PlatformRadioSnippet> {
  AxisDirection? _selected;

  @override
  Widget build(BuildContext context) =>
      // #region platform_radio
      RadioGroup<AxisDirection>(
        groupValue: _selected,
        onChanged: (value) => setState(() => _selected = value),
        child: Row(
          children: [
            for (final direction in AxisDirection.values)
              Row(
                mainAxisSize: .min,
                children: [
                  PlatformRadio(value: direction),
                  Text(direction.name),
                ],
              ),
          ],
        ),
      );
  // #endregion
}

class PlatformRadioGroupBuilderSnippet extends StatefulWidget {
  const PlatformRadioGroupBuilderSnippet({super.key});

  @override
  State<PlatformRadioGroupBuilderSnippet> createState() => _PlatformRadioGroupBuilderSnippetState();
}

class _PlatformRadioGroupBuilderSnippetState extends State<PlatformRadioGroupBuilderSnippet> {
  AxisDirection? _directionality;

  @override
  Widget build(BuildContext context) =>
      // #region platform_radio_group_builder
      PlatformRadioGroupBuilder<AxisDirection>(
        values: AxisDirection.values,
        groupValue: _directionality,
        onChanged: (value) => setState(() => _directionality = value),
        itemBuilder: (_, direction) => Row(
          mainAxisSize: .min,
          children: [
            PlatformRadio(value: direction),
            Text(direction.name),
          ],
        ),
      );
  // #endregion
}
