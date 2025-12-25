import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Simulates fetching user data from an API
///
/// FutureProvider is perfect for async operations that complete once
/// It automatically handles loading, data, and error states
final userProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  // Simulate network delay
  await Future.delayed(const Duration(seconds: 2));

  // Simulate API response
  return {
    'id': 1,
    'name': 'John Doe',
    'email': 'john.doe@example.com',
    'role': 'Flutter Developer',
  };
});

/// FutureProvider with family - fetch user by ID
///
/// This allows fetching different users based on the ID parameter
final userByIdProvider = FutureProvider.family<Map<String, dynamic>, int>((
  ref,
  userId,
) async {
  await Future.delayed(const Duration(seconds: 1));

  return {
    'id': userId,
    'name': 'User $userId',
    'email': 'user$userId@example.com',
    'role': 'Developer',
  };
});

/// Example of a FutureProvider that might fail
///
/// Demonstrates error handling in async providers
final riskyOperationProvider = FutureProvider<String>((ref) async {
  await Future.delayed(const Duration(seconds: 1));

  // Simulate random success/failure
  if (DateTime.now().second % 2 == 0) {
    return 'Operation succeeded!';
  } else {
    throw Exception('Operation failed! Try again.');
  }
});

/// FutureProvider that depends on another provider
///
/// This shows how providers can compose and depend on each other
final userGreetingProvider = FutureProvider<String>((ref) async {
  final user = await ref.watch(userProvider.future);
  return 'Welcome, ${user['name']}!';
});

/// Auto-dispose FutureProvider
///
/// Automatically cancels the future when no longer needed
final autoDisposeFutureProvider = FutureProvider.autoDispose<List<String>>((
  ref,
) async {
  await Future.delayed(const Duration(seconds: 1));
  return ['Item 1', 'Item 2', 'Item 3', 'Item 4', 'Item 5'];
});
