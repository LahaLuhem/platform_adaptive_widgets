import 'package:flutter/foundation.dart';

/// [material] on Android, [cupertino] on iOS. Both arms are built before the pick happens, so the loser
/// is built and thrown away. Fine for cheap values, which is what these are for.
///
/// {@template platform_adaptive_widgets.pruning_size_cost}
/// **Costs binary size, measured.** Passing both values means both are reachable at the call site
/// before the internal switch runs. AOT folds the switch away, but the losing argument's expression,
/// and every platform class it touches, stays lexically reachable and survives tree-shaking.
///
/// It is not a small effect. `tool/size_harness` puts a `CupertinoDatePicker` dispatched this way at
/// roughly 27 times the symbol weight of the same thing behind an inline `switch (defaultTargetPlatform)`.
/// Run the harness for current figures, and see `APPENDIX.md#aot-pruning-rules`.
///
/// **So inline the switch, or `isAndroid ? … : …`, any time an arm builds a platform widget.** Save
/// these for colours, enums, `IconData` and other values that drag no code behind them.
/// {@endtemplate}
T platformValue<T extends Object>({required T material, required T cupertino}) =>
    _valueProvider(material: material, cupertino: cupertino);

/// [platformValue] where either side may be `null`.
///
/// {@macro platform_adaptive_widgets.pruning_size_cost}
T? platformValueNullable<T extends Object>({T? material, T? cupertino}) =>
    _valueProviderNullable(material: material, cupertino: cupertino);

/// [material] on Android, [cupertino] on iOS, calling only the getter that wins.
///
/// Skips *building* the losing arm, which is worth it when that's expensive. It saves no binary size
/// at all, though. The harness shipped identical Cupertino symbols either way, since a closure keeps
/// its body just as reachable as a value does.
///
/// {@macro platform_adaptive_widgets.pruning_size_cost}
T platformLazyValue<T extends Object>({
  required ValueGetter<T> material,
  required ValueGetter<T> cupertino,
}) => _valueProvider(material: material, cupertino: cupertino).call();

/// [platformLazyValue] where either getter may be `null`, in which case you get `null` back.
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
