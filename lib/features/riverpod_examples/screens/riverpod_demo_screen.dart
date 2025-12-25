import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/counter_provider.dart';
import '../providers/async_provider.dart';
import '../providers/stream_provider.dart';

class RiverpodDemoScreen extends ConsumerWidget {
  const RiverpodDemoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riverpod Examples')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle('1. StateProvider - Simple Counter'),
          _buildStateProviderExample(ref),
          const SizedBox(height: 24),

          _buildSectionTitle('2. FutureProvider - Async Data'),
          _buildFutureProviderExample(ref),
          const SizedBox(height: 24),

          _buildSectionTitle('3. StreamProvider - Real-time Data'),
          _buildStreamProviderExample(ref),
          const SizedBox(height: 24),

          _buildSectionTitle('4. Provider Modifiers'),
          _buildProviderModifiersExample(ref),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF6366F1),
        ),
      ),
    );
  }

  Widget _buildStateProviderExample(WidgetRef ref) {
    final count = ref.watch(counterProvider);
    final doubleCount = ref.watch(doubleCounterProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'StateProvider is perfect for simple state management.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => ref.read(counterProvider.notifier).state--,
                  icon: const Icon(Icons.remove_circle_outline),
                  iconSize: 32,
                  color: const Color(0xFFEF4444),
                ),
                const SizedBox(width: 24),
                Column(
                  children: [
                    Text(
                      '$count',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6366F1),
                      ),
                    ),
                    Text(
                      'Double: $doubleCount',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(width: 24),
                IconButton(
                  onPressed: () => ref.read(counterProvider.notifier).state++,
                  icon: const Icon(Icons.add_circle_outline),
                  iconSize: 32,
                  color: const Color(0xFF10B981),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => ref.read(counterProvider.notifier).state = 0,
                child: const Text('Reset'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFutureProviderExample(WidgetRef ref) {
    final userAsync = ref.watch(userProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'FutureProvider handles async operations with loading, data, and error states.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            userAsync.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, stack) => Center(
                child: Column(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Color(0xFFEF4444),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Error: ${error.toString()}',
                      style: const TextStyle(color: Color(0xFFEF4444)),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              data: (user) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUserInfo('Name', user['name']),
                  _buildUserInfo('Email', user['email']),
                  _buildUserInfo('Role', user['role']),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => ref.invalidate(userProvider),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Refresh Data'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildStreamProviderExample(WidgetRef ref) {
    final timeAsync = ref.watch(timeStreamProvider);
    final randomAsync = ref.watch(randomNumberStreamProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'StreamProvider provides real-time data updates.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            timeAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Text('Error: $error'),
              data: (time) => Column(
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 48,
                    color: Color(0xFF6366F1),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6366F1),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${time.day}/${time.month}/${time.year}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Divider(height: 32),
            randomAsync.when(
              loading: () => const Text('Generating random number...'),
              error: (error, stack) => Text('Error: $error'),
              data: (number) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Random Number: ', style: TextStyle(fontSize: 16)),
                  Text(
                    '$number',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF10B981),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProviderModifiersExample(WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Provider modifiers like .family and .autoDispose add powerful capabilities.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            const Text(
              '.family - Creates separate instances for each parameter',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildFamilyExample(ref, 'counter-1'),
            const SizedBox(height: 8),
            _buildFamilyExample(ref, 'counter-2'),
            const SizedBox(height: 16),
            const Text(
              '.autoDispose - Automatically cleans up when not used',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Check console logs when navigating away to see cleanup!',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFamilyExample(WidgetRef ref, String id) {
    final count = ref.watch(counterFamilyProvider(id));

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(id, style: const TextStyle(fontWeight: FontWeight.w500)),
          Row(
            children: [
              IconButton(
                onPressed: () =>
                    ref.read(counterFamilyProvider(id).notifier).state--,
                icon: const Icon(Icons.remove),
                iconSize: 20,
              ),
              Text(
                '$count',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () =>
                    ref.read(counterFamilyProvider(id).notifier).state++,
                icon: const Icon(Icons.add),
                iconSize: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
