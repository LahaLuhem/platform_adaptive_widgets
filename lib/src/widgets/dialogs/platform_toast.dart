// Callback-first
// ignore_for_file: prefer-match-file-name

import 'dart:async' show Completer, Timer, unawaited;
import 'dart:ui' show ImageFilter;

import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoDynamicColor;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show ScaffoldMessenger, SnackBar;

import '/src/models/dialogs/platform_toast_data.dart';

/// Shows a transient, self-dismissing message — Material [SnackBar] via
/// [ScaffoldMessenger] on Android (anchored to the bottom of the screen),
/// and a custom HUD-style banner overlay on iOS (slides in from the top,
/// translucent dark background).
///
/// **Why two distinct primitives?** [showPlatformToast] is for routine
/// feedback that doesn't require the user to act ("Saved", "Copied to
/// clipboard"). For messages that *must* be acknowledged before continuing
/// (errors, confirmations), use `showPlatformAcknowledge` — that wraps a
/// proper alert dialog on both platforms.
///
/// **iOS HUD overlay.** Cupertino ships no native toast / banner primitive;
/// the package implements one here that follows iOS visual conventions
/// (translucent rounded banner under the status bar, safe-area aware,
/// tap-to-dismiss). Tuning via [cupertinoToastData].
///
/// Returns a `Future<void>` that resolves when the toast is gone. The
/// Material branch's `SnackBarClosedReason` is collapsed to `void` — callers
/// who need the reason should use `ScaffoldMessenger` directly (see
/// [PlatformToastClosedReason] in `platform_toast_data.dart` if you re-add a
/// non-void return shape).
Future<void> showPlatformToast({
  required BuildContext context,
  required String message,
  Duration duration = kDefaultPlatformToastDuration,
  MaterialToastData? materialToastData,
  CupertinoToastData? cupertinoToastData,
}) => switch (defaultTargetPlatform) {
  .android =>
    ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            content: Text(message),
            duration: duration,
            backgroundColor: materialToastData?.backgroundColor,
            elevation: materialToastData?.elevation,
            margin: materialToastData?.margin,
            padding: materialToastData?.padding,
            width: materialToastData?.width,
            shape: materialToastData?.shape,
            hitTestBehavior: materialToastData?.hitTestBehavior,
            behavior: materialToastData?.snackBarBehavior,
            action: materialToastData?.action,
            actionOverflowThreshold: materialToastData?.actionOverflowThreshold,
            showCloseIcon: materialToastData?.showCloseIcon,
            closeIconColor: materialToastData?.closeIconColor,
            clipBehavior: materialToastData?.clipBehavior ?? Clip.hardEdge,
            persist: materialToastData?.persist,
            animation: materialToastData?.animation,
            onVisible: materialToastData?.onVisible,
            dismissDirection: materialToastData?.dismissDirection,
          ),
        )
        .closed,
  .iOS => _showCupertinoToast(
    context: context,
    message: message,
    duration: duration,
    data: cupertinoToastData ?? const CupertinoToastData(),
  ),
  _ => throw UnsupportedError('This platform is not supported: $defaultTargetPlatform'),
};

/// Inserts the HUD overlay into the nearest [Overlay] and returns a future
/// that completes when the overlay is dismissed (by timer or by tap).
Future<void> _showCupertinoToast({
  required BuildContext context,
  required String message,
  required Duration duration,
  required CupertinoToastData data,
}) {
  final overlay = Overlay.of(context, rootOverlay: true);
  final completer = Completer<void>();
  late final OverlayEntry entry;

  void dismiss() {
    if (completer.isCompleted) return;
    completer.complete();
    entry.remove();
  }

  entry = OverlayEntry(
    builder: (_) => _CupertinoToastOverlay(
      message: message,
      duration: duration,
      data: data,
      onDismiss: dismiss,
    ),
  );

  overlay.insert(entry);

  return completer.future;
}

/// The HUD-style banner widget — stateful so it can drive the slide+fade
/// animation and the auto-dismiss timer.
class _CupertinoToastOverlay extends StatefulWidget {
  final String message;
  final Duration duration;
  final CupertinoToastData data;
  final VoidCallback onDismiss;

  const _CupertinoToastOverlay({
    required this.message,
    required this.duration,
    required this.data,
    required this.onDismiss,
  });

  @override
  State<_CupertinoToastOverlay> createState() => _CupertinoToastOverlayState();
}

class _CupertinoToastOverlayState extends State<_CupertinoToastOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;
  Timer? _dismissTimer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.data.transitionDuration);
    _slideAnimation = Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic, reverseCurve: Curves.easeIn),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    unawaited(_controller.forward());
    _dismissTimer = Timer(widget.duration, _startDismiss);
  }

  /// Plays the reverse animation, then calls [_CupertinoToastOverlay.onDismiss]
  /// to remove the overlay entry from the host overlay.
  Future<void> _startDismiss() async {
    _dismissTimer?.cancel();
    if (!mounted) return;

    await _controller.reverse();
    widget.onDismiss();
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // CupertinoDynamicColor.resolve accepts both dynamic and plain Color —
    // returns the input unchanged if it isn't a dynamic colour.
    final resolvedBackground = CupertinoDynamicColor.resolve(widget.data.backgroundColor, context);
    final resolvedForeground = CupertinoDynamicColor.resolve(widget.data.foregroundColor, context);
    final resolvedTextStyle =
        widget.data.textStyle ?? TextStyle(color: resolvedForeground, fontSize: 15);

    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: widget.data.outerMargin,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: widget.data.maxWidth),
            child: SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: GestureDetector(
                  onTap: () => unawaited(_startDismiss()),
                  // Opaque so taps anywhere on the toast count, not just on
                  // the text glyphs.
                  behavior: HitTestBehavior.opaque,
                  child: ClipRRect(
                    borderRadius: widget.data.borderRadius,
                    // BackdropFilter gives the iOS-native frosted-glass feel
                    // — the toast's translucent background tints whatever's
                    // behind it after a gentle blur.
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: DecoratedBox(
                        decoration: BoxDecoration(color: resolvedBackground),
                        child: Padding(
                          padding: widget.data.padding,
                          child: DefaultTextStyle(
                            style: resolvedTextStyle,
                            textAlign: TextAlign.center,
                            child: Text(widget.message),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
