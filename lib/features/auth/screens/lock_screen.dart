import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starelectricerp/features/auth/providers/auth_provider.dart';
import 'package:starelectricerp/core/widgets/app_button.dart';

class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({super.key});

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen> {
  final TextEditingController _pinController = TextEditingController();
  bool _isLoading = false;
  String? _error;
  Timer? _cooldownTimer;
  int _secondsLeft = 0;

  @override
  void initState() {
    super.initState();
    _checkCooldown();
  }

  void _checkCooldown() {
    final state = ref.read(authProvider);
    if (state.cooldownUntil != null) {
      final diff = state.cooldownUntil!.difference(DateTime.now()).inSeconds;
      if (diff > 0) {
        setState(() {
          _secondsLeft = diff;
        });
        _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() {
            _secondsLeft--;
            if (_secondsLeft <= 0) {
              _secondsLeft = 0;
              _error = null;
              timer.cancel();
            }
          });
        });
      }
    }
  }

  @override
  void dispose() {
    _pinController.dispose();
    _cooldownTimer?.cancel();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_secondsLeft > 0) return;
    
    final pin = _pinController.text.trim();
    if (pin.isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final success = await ref.read(authProvider.notifier).verifyPin(pin);

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        // Redirection will be handled by GoRouter's redirect logic
      } else {
        _pinController.clear();
        final authState = ref.read(authProvider);
        if (authState.cooldownUntil != null && authState.cooldownUntil!.isAfter(DateTime.now())) {
          _error = 'Too many incorrect attempts.';
          _checkCooldown();
        } else {
          _error = 'Incorrect PIN.';
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 350,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text('App Locked', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              TextField(
                controller: _pinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Enter PIN',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.password),
                ),
                onSubmitted: (_) => _submit(),
                enabled: _secondsLeft == 0,
              ),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(_error!, style: const TextStyle(color: Colors.red)),
                ),
              if (_secondsLeft > 0)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text('Try again in $_secondsLeft seconds.', style: const TextStyle(color: Colors.red)),
                ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  label: 'Unlock',
                  onPressed: _secondsLeft > 0 ? () {} : _submit,
                  isLoading: _isLoading,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
