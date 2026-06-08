import 'package:flutter/foundation.dart';

/// Selects [material] on Android and [cupertino] on iOS — both evaluated eagerly at the call site.
///
/// Eager: both arms are constructed *before* dispatch, so the unused arm is also built at runtime
/// and immediately discarded. The most expensive form at runtime; irrelevant for cheap values.
///
/// {@template platform_adaptive_widgets.pruning_size_cost}
/// **Binary-size cost — empirically verified.** Every argument-taking selector here receives both
/// the Material and the Cupertino value, so both are present at the call site before the internal
/// `switch (defaultTargetPlatform)` runs. The AOT compiler const-folds that switch to one branch
/// in release builds, but the unused argument's expression — and any platform-specific class it
/// constructs or closes over — stays lexically reachable and is **not** tree-shaken.
///
/// Measured with `tool/size_harness` on an `android-arm64` release build:
/// dispatching a `CupertinoDatePicker` through any selector here left its symbols in the binary
/// ≈48.7 KB versus ≈1.8 KB when dispatched with an inline `switch (defaultTargetPlatform)` (~27× larger),
/// and ≈342 KB heavier in total once transitive dependencies are counted.
/// Cupertino-pathed bytes overall rose ≈28.7 KB → ≈88.2 KB (+207%).
///
/// **Prefer an inline `switch (defaultTargetPlatform)` (or `isAndroid ? … : …`)
/// whenever an arm builds a platform-specific widget.** These selectors are for
/// cheap values — colors, enums, `IconData`, primitives — that carry no
/// platform-specific code to prune.
/// {@endtemplate}
T platformValue<T extends Object>({required T material, required T cupertino}) =>
    _valueProvider(material: material, cupertino: cupertino);

/// Nullable [platformValue]: selects [material] on Android and [cupertino] on
/// iOS, either of which may be `null`.
///
/// {@macro platform_adaptive_widgets.pruning_size_cost}
T? platformValueNullable<T extends Object>({T? material, T? cupertino}) =>
    _valueProviderNullable(material: material, cupertino: cupertino);

/// Selects [material] on Android and [cupertino] on iOS, invoking **only** the getter for the current platform.
///
/// Lazy: skips the *runtime build* of the discarded arm - its sole advantage over [platformValue],
/// worth it when an arm is expensive to construct. It does **not** reduce binary size:
/// in `tool/size_harness` the lazy and eager forms shipped byte-identical Cupertino symbols
/// (49,913 B each — 0% smaller than eager), because a closure passed as an argument keeps its body reachable
/// exactly as an eager value does.
///
/// {@macro platform_adaptive_widgets.pruning_size_cost}
T platformLazyValue<T extends Object>({
  required ValueGetter<T> material,
  required ValueGetter<T> cupertino,
}) => _valueProvider(material: material, cupertino: cupertino).call();

/// Nullable [platformLazyValue]: invokes only the current platform's getter, or
/// returns `null` when that getter is `null`. Saves the discarded arm's runtime
/// build but not binary size — see [platformLazyValue].
///
/// {@macro platform_adaptive_widgets.pruning_size_cost}
T? platformLazyNullable<T extends Object>({ValueGetter<T>? material, ValueGetter<T>? cupertino}) =>
    _valueProviderNullable(material: material, cupertino: cupertino)?.call();

T _valueProvider<T extends Object>({required T material, required T cupertino}) =>
    switch (defaultTargetPlatform) {
      .android => material,
      .iOS => cupertino,
      _ => throw UnsupportedError('This platform is not supported: $defaultTargetPlatform'),
    };

T? _valueProviderNullable<T extends Object>({T? material, T? cupertino}) =>
    switch (defaultTargetPlatform) {
      .android => material,
      .iOS => cupertino,
      _ => throw UnsupportedError('This platform is not supported: $defaultTargetPlatform'),
    };
