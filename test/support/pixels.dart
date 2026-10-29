import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

/// What [finder]'s widget paints, as raw RGBA at 4 bytes a pixel, with its width in pixels.
Future<({Uint8List rgba, int width})> pixelsOf(WidgetTester tester, Finder finder) async {
  final image = (await tester.runAsync(() => captureImage(tester.element(finder))))!;
  final rgba = (await tester.runAsync(image.toByteData))!.buffer.asUint8List();
  final width = image.width;
  image.dispose();

  return (rgba: rgba, width: width);
}
