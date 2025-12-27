import 'package:flutter/material.dart';
import 'features/riverpod_examples/screens/riverpod_demo_screen.dart';
import 'features/bloc_examples/counter/counter_screen.dart';
import 'features/task_manager/presentation/screens/task_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Pro Course'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildWelcomeCard(),
          const SizedBox(height: 24),
          _buildSectionTitle('Module 1: State Management'),
          const SizedBox(height: 12),
          _buildNavigationCard(
            context,
            title: 'Riverpod Examples',
            subtitle: 'StateProvider, FutureProvider, StreamProvider',
            icon: Icons.water_drop,
            color: const Color(0xFF6366F1),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RiverpodDemoScreen()),
            ),
          ),
          const SizedBox(height: 12),
          _buildNavigationCard(
            context,
            title: 'Bloc Examples',
            subtitle: 'Events, States, Business Logic',
            icon: Icons.architecture,
            color: const Color(0xFF8B5CF6),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CounterScreen()),
            ),
          ),
          const SizedBox(height: 12),
          _buildNavigationCard(
            context,
            title: 'Task Manager (Riverpod)',
            subtitle: 'Full app with offline storage',
            icon: Icons.task_alt,
            color: const Color(0xFF10B981),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TaskListScreen()),
            ),
          ),
          const SizedBox(height: 12),
          _buildNavigationCard(
            context,
            title: 'Task Manager (Bloc)',
            subtitle: 'Same app, different approach',
            icon: Icons.checklist,
            color: const Color(0xFFF59E0B),
            onTap: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Coming soon!')));
            },
          ),
          const SizedBox(height: 24),
          _buildProgressCard(),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      color: const Color(0xFF6366F1),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.school,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome to Flutter Pro!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Your journey from intermediate to pro starts here',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1F2937),
      ),
    );
  }

  Widget _buildNavigationCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressCard() {
    return Card(
      color: const Color(0xFFF9FAFB),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.emoji_events, color: Color(0xFFF59E0B)),
                SizedBox(width: 8),
                Text(
                  'Your Progress',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildProgressItem('Module 1: State Management', 0.25),
            _buildProgressItem('Module 2: Navigation', 0.0),
            _buildProgressItem('Module 3: Performance', 0.0),
            const SizedBox(height: 8),
            const Text(
              '8 modules total • Keep going!',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressItem(String title, double progress) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF10B981),
              ),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}
