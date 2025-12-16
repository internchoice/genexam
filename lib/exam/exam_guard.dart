import 'package:flutter/widgets.dart';

class ExamGuard extends WidgetsBindingObserver {
  final VoidCallback onViolation;

  ExamGuard({required this.onViolation});

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      onViolation();
    }
  }
}
