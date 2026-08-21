import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starelectricerp/features/auth/providers/auth_provider.dart';

class InactivityWrapper extends ConsumerStatefulWidget {
  final Widget child;

  const InactivityWrapper({super.key, required this.child});

  @override
  ConsumerState<InactivityWrapper> createState() => _InactivityWrapperState();
}

class _InactivityWrapperState extends ConsumerState<InactivityWrapper> {
  Timer? _inactivityTimer;

  @override
  void initState() {
    super.initState();
  }

  void _resetTimer(int timeoutMinutes, bool isLocked) {
    _inactivityTimer?.cancel();
    if (timeoutMinutes > 0 && !isLocked) {
      _inactivityTimer = Timer(Duration(minutes: timeoutMinutes), () {
        ref.read(authProvider.notifier).lockApp();
      });
    }
  }

  void _handleUserInteraction() {
    final authState = ref.read(authProvider);
    if (!authState.isLocked && authState.inactivityTimeoutMinutes > 0) {
      _resetTimer(authState.inactivityTimeoutMinutes, authState.isLocked);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (previous?.inactivityTimeoutMinutes != next.inactivityTimeoutMinutes || previous?.isLocked != next.isLocked) {
        _resetTimer(next.inactivityTimeoutMinutes, next.isLocked);
      }
    });

    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => _handleUserInteraction(),
      onPointerMove: (_) => _handleUserInteraction(),
      onPointerUp: (_) => _handleUserInteraction(),
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _inactivityTimer?.cancel();
    super.dispose();
  }
}
