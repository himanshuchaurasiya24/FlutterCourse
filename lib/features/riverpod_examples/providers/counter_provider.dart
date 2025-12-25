import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Simple counter provider demonstrating StateProvider
///
/// StateProvider is best for simple state that can be modified from the UI
/// It's perfect for toggles, counters, and simple values
final counterProvider = StateProvider<int>((ref) => 0);

/// Auto-dispose counter that cleans up when no longer used
///
/// The .autoDispose modifier ensures the state is destroyed when
/// there are no more listeners, preventing memory leaks
final autoDisposeCounterProvider = StateProvider.autoDispose<int>((ref) => 0);

/// Counter with family modifier - creates a separate instance for each ID
///
/// The .family modifier allows you to create parameterized providers
/// Each unique parameter gets its own provider instance
final counterFamilyProvider = StateProvider.family<int, String>((ref, id) => 0);

/// Example of a computed provider that depends on another provider
///
/// This provider automatically updates when counterProvider changes
final doubleCounterProvider = Provider<int>((ref) {
  final count = ref.watch(counterProvider);
  return count * 2;
});

/// Example of a provider that can be overridden for testing
final greetingProvider = Provider<String>((ref) => 'Hello from Riverpod!');
