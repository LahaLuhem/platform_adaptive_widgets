// Callback-first
// ignore_for_file: prefer-match-file-name

import 'dart:async' show Completer, Timer, unawaited;
import 'dart:ui' show ImageFilter;

import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoDynamicColor;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show ScaffoldMessenger, SnackBar;

import '/src/models/dialogs/platform_toast_data.dart';

/// Shows a message that fades on its own. A [SnackBar] along the bottom on Android, and on iOS a banner
/// that slides down from under the status bar. The returned future completes once it's gone.
///
/// For the "Saved" and "Copied to clipboard" sort of thing, that nobody needs to act on. Anything that
/// must be acknowledged first wants `showPlatformAcknowledge` and a real dialog.
///
/// iOS ships no toast at all, so that banner is ours: translucent, rounded, safe-area aware and tap-to-dismiss,
/// tuned through [cupertinoToastData].
///
/// Material's `SnackBarClosedReason` is dropped on the way out. Reach for `ScaffoldMessenger` directly
/// if you need it.
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

/// Completes when the banner goes away, whether the timer ran out or someone tapped it.
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

/// Stateful for the slide-and-fade animation and the auto-dismiss timer.
class const _CupertinoToastOverlay({
  required final String message,
  required final Duration duration,
  required final CupertinoToastData data,
  required final VoidCallback onDismiss,
}) extends StatefulWidget {
  @override
  State<_CupertinoToastOverlay> createState() => _CupertinoToastOverlayState();
}

class _CupertinoToastOverlayState()
    extends State<_CupertinoToastOverlay>
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
    _controller.forward();
    _dismissTimer = Timer(widget.duration, _startDismiss);
  }

  /// Runs the animation backwards first, then pulls the overlay entry.
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
    // resolve() hands a plain Color straight back, so no need to check first.
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
                  // Opaque, so a tap anywhere on the banner counts, not just on the glyphs.
                  behavior: HitTestBehavior.opaque,
                  child: ClipRRect(
                    borderRadius: widget.data.borderRadius,
                    // Blur first, then tint through the translucent background, for the frosted glass look.
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
