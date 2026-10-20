// Named after its function, not the private banner below.
// ignore_for_file: prefer-match-file-name

import 'dart:async' show Completer, Timer, unawaited;
import 'dart:ui' show ImageFilter;

import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoButton, CupertinoDynamicColor;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show ScaffoldMessenger, SnackBar, SnackBarAction;

import '/src/models/dialogs/platform_toast_data.dart';
import '/src/utils/design_language.dart';

/// Shows a short message with at most one [action], like Undo. A [SnackBar] along the bottom on Material,
/// and on Cupertino a banner that slides down from under the status bar. The returned future completes
/// once it's gone.
///
/// Without an action it leaves after [duration]. With one it stays until someone taps the action or
/// dismisses the toast, since a timer could take the action away before they get to it
/// ([HIG accessibility](https://developer.apple.com/design/human-interface-guidelines/accessibility#Cognitive)).
///
/// **On Cupertino, prefer showing the change itself**, like a row that goes away or a label that updates.
/// iOS has no toast, so the banner is a convenience the package draws, styled through [cupertinoToastData]
/// ([HIG feedback](https://developer.apple.com/design/human-interface-guidelines/feedback#Best-practices)).
///
/// Anything that must be acknowledged first wants `showPlatformAcknowledge` and a real dialog.
///
/// Material's `SnackBarClosedReason` is dropped on the way out. Reach for `ScaffoldMessenger` directly
/// if you need it.
///
/// Guidelines: [M3 snackbar](https://m3.material.io/components/snackbar/guidelines),
/// [HIG feedback](https://developer.apple.com/design/human-interface-guidelines/feedback#Best-practices).
Future<void> showPlatformToast({
  required BuildContext context,
  required String message,
  Duration duration = kDefaultPlatformToastDuration,
  PlatformToastAction? action,
  MaterialToastData? materialToastData,
  CupertinoToastData? cupertinoToastData,
}) => switch (designLanguage) {
  .material =>
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
            action: action == null
                ? null
                : SnackBarAction(label: action.label, onPressed: action.onPressed),
            actionOverflowThreshold: materialToastData?.actionOverflowThreshold,
            showCloseIcon: materialToastData?.showCloseIcon,
            closeIconColor: materialToastData?.closeIconColor,
            clipBehavior: materialToastData?.clipBehavior ?? Clip.hardEdge,
            animation: materialToastData?.animation,
            onVisible: materialToastData?.onVisible,
            dismissDirection: materialToastData?.dismissDirection,
          ),
        )
        .closed,
  .cupertino => _showCupertinoToast(
    context: context,
    message: message,
    duration: duration,
    action: action,
    data: cupertinoToastData ?? const CupertinoToastData(),
  ),
};

/// Completes when the banner goes away: its timer ran out, someone tapped it, or its action ran.
Future<void> _showCupertinoToast({
  required BuildContext context,
  required String message,
  required Duration duration,
  required PlatformToastAction? action,
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
      action: action,
      data: data,
      onDismiss: dismiss,
    ),
  );

  overlay.insert(entry);

  return completer.future;
}

/// Stateful for the slide-and-fade animation and the timer that closes a toast without an action.
class const _CupertinoToastOverlay({
  required final String message,
  required final Duration duration,
  required final PlatformToastAction? action,
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
    // One with an action waits until someone acts on it or dismisses it.
    if (widget.action == null) _dismissTimer = Timer(widget.duration, _startDismiss);
  }

  void _runAction() {
    // Already sliding away, so a second tap can't run the action twice.
    if (!_controller.isForwardOrCompleted) return;
    widget.action!.onPressed();
    unawaited(_startDismiss());
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
                child: Semantics(
                  container: true,
                  liveRegion: true,
                  // VoiceOver's escape gesture, the way out once an action stops the timer.
                  onDismiss: () => unawaited(_startDismiss()),
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
                              textAlign: widget.action == null ? TextAlign.center : TextAlign.start,
                              child: switch (widget.action) {
                                null => Text(widget.message),
                                final action => Row(
                                  children: [
                                    Expanded(child: Text(widget.message)),
                                    CupertinoButton(
                                      padding: const EdgeInsetsDirectional.only(start: 16),
                                      onPressed: _runAction,
                                      // The banner's own colour, since iOS blue is too dark to read on it.
                                      child: Text(
                                        action.label,
                                        style: resolvedTextStyle.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              },
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
      ),
    );
  }
}
