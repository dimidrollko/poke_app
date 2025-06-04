import 'dart:async';

import 'package:flutter/foundation.dart';

/// A ChangeNotifier that listens to a Stream and notifies listeners on each event.
/// Used to trigger GoRouter refreshes.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream stream) {
    _subscription = stream.listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}