import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _storage = FlutterSecureStorage();

class AuthState {
  final bool isInitialized;
  final bool isPinEnabled;
  final bool isLocked;
  final int inactivityTimeoutMinutes;
  final int failedAttempts;
  final DateTime? cooldownUntil;

  AuthState({
    this.isInitialized = false,
    this.isPinEnabled = false,
    this.isLocked = false,
    this.inactivityTimeoutMinutes = 0,
    this.failedAttempts = 0,
    this.cooldownUntil,
  });

  AuthState copyWith({
    bool? isInitialized,
    bool? isPinEnabled,
    bool? isLocked,
    int? inactivityTimeoutMinutes,
    int? failedAttempts,
    DateTime? cooldownUntil,
  }) {
    return AuthState(
      isInitialized: isInitialized ?? this.isInitialized,
      isPinEnabled: isPinEnabled ?? this.isPinEnabled,
      isLocked: isLocked ?? this.isLocked,
      inactivityTimeoutMinutes: inactivityTimeoutMinutes ?? this.inactivityTimeoutMinutes,
      failedAttempts: failedAttempts ?? this.failedAttempts,
      cooldownUntil: cooldownUntil ?? this.cooldownUntil,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    _init();
    return AuthState();
  }

  Future<void> _init() async {
    final enabledStr = await _storage.read(key: 'pin_enabled');
    final timeoutStr = await _storage.read(key: 'inactivity_timeout');
    
    final isPinEnabled = enabledStr == 'true';
    final timeout = int.tryParse(timeoutStr ?? '') ?? 0;
    
    state = state.copyWith(
      isInitialized: true,
      isPinEnabled: isPinEnabled,
      isLocked: isPinEnabled,
      inactivityTimeoutMinutes: timeout,
    );
  }

  String _hashPin(String pin) {
    var bytes = utf8.encode(pin);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<bool> verifyPin(String pin) async {
    if (state.cooldownUntil != null && DateTime.now().isBefore(state.cooldownUntil!)) {
      return false; // Still in cooldown
    }

    final storedHash = await _storage.read(key: 'pin_hash');
    if (storedHash == null) return false;

    final inputHash = _hashPin(pin);
    if (inputHash == storedHash) {
      // Success
      state = state.copyWith(
        isLocked: false,
        failedAttempts: 0,
        cooldownUntil: null,
      );
      return true;
    } else {
      // Failure
      final newAttempts = state.failedAttempts + 1;
      DateTime? newCooldown;
      if (newAttempts >= 5) {
        newCooldown = DateTime.now().add(const Duration(seconds: 30));
      }
      state = state.copyWith(
        failedAttempts: newAttempts,
        cooldownUntil: newCooldown,
      );
      return false;
    }
  }

  Future<void> setPin(String newPin) async {
    final hash = _hashPin(newPin);
    await _storage.write(key: 'pin_hash', value: hash);
    await _storage.write(key: 'pin_enabled', value: 'true');
    state = state.copyWith(isPinEnabled: true, isLocked: false);
  }

  Future<bool> disablePin(String currentPin) async {
    final isValid = await verifyPin(currentPin);
    if (isValid) {
      await _storage.delete(key: 'pin_hash');
      await _storage.write(key: 'pin_enabled', value: 'false');
      state = state.copyWith(isPinEnabled: false, isLocked: false);
      return true;
    }
    return false;
  }

  Future<bool> changePin(String currentPin, String newPin) async {
    final isValid = await verifyPin(currentPin);
    if (isValid) {
      final hash = _hashPin(newPin);
      await _storage.write(key: 'pin_hash', value: hash);
      return true;
    }
    return false;
  }

  Future<void> updateInactivityTimeout(int minutes) async {
    await _storage.write(key: 'inactivity_timeout', value: minutes.toString());
    state = state.copyWith(inactivityTimeoutMinutes: minutes);
  }

  void lockApp() {
    if (state.isPinEnabled) {
      state = state.copyWith(isLocked: true);
    }
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(() => AuthNotifier());
