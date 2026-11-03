import 'package:flutter/foundation.dart';

/// Takes booleans, since 2 platform builder params would trip the AOT-pruning guard.
@internal
void assertBuilderInvariant({
  required bool hasBuilder,
  required bool hasMaterialBuilder,
  required bool hasCupertinoBuilder,
}) {
  assert(
    (hasBuilder ^ hasMaterialBuilder) && hasMaterialBuilder == hasCupertinoBuilder,
    'Pass `builder`, or both `materialBuilder` and `cupertinoBuilder`, not a mix.',
  );
}
