import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Simulates a real-time data stream (like WebSocket or Firebase)
///
/// StreamProvider is perfect for continuous data streams
/// It automatically handles loading, data, and error states
final timeStreamProvider = StreamProvider<DateTime>((ref) {
  // Create a stream that emits current time every second
  return Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now());
});

/// Stream of random numbers
///
/// Demonstrates a stream that generates data
final randomNumberStreamProvider = StreamProvider<int>((ref) {
  return Stream.periodic(
    const Duration(seconds: 2),
    (count) => DateTime.now().millisecond,
  );
});

/// StreamProvider with family - creates separate streams for each ID
///
/// Useful for subscribing to different data channels
final messageStreamProvider = StreamProvider.family<String, String>((
  ref,
  channelId,
) {
  return Stream.periodic(
    const Duration(seconds: 3),
    (count) => 'Message $count from channel: $channelId',
  );
});

/// Auto-dispose StreamProvider
///
/// Automatically cancels the stream subscription when no longer needed
/// This is crucial for preventing memory leaks with streams
final autoDisposeStreamProvider = StreamProvider.autoDispose<int>((ref) {
  print('Stream started');

  // Cancel callback when provider is disposed
  ref.onDispose(() {
    print('Stream cancelled');
  });

  return Stream.periodic(
    const Duration(seconds: 1),
    (count) => count,
  ).take(10); // Only emit 10 values then complete
});

/// Stream that can error
///
/// Demonstrates error handling in streams
final errorProneStreamProvider = StreamProvider<String>((ref) async* {
  for (int i = 0; i < 10; i++) {
    await Future.delayed(const Duration(seconds: 1));

    if (i == 5) {
      throw Exception('Stream error at count 5');
    }

    yield 'Count: $i';
  }
});

/// Combined stream provider that depends on another provider
///
/// Shows how to compose streams with other providers
final enhancedTimeStreamProvider = StreamProvider<String>((ref) {
  final timeStream = ref.watch(timeStreamProvider.stream);

  return timeStream.map((time) {
    final hour = time.hour;
    final greeting = hour < 12
        ? 'Good Morning'
        : hour < 18
        ? 'Good Afternoon'
        : 'Good Evening';
    return '$greeting! Current time: ${time.hour}:${time.minute}:${time.second}';
  });
});
