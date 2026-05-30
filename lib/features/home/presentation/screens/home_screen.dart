import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RiHa Home'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        children: const [
          _DashboardCard(
            label: 'Memories',
            icon: Icons.photo_library_outlined,
            route: '/memories',
          ),
          _DashboardCard(
            label: 'Health',
            icon: Icons.favorite_outline,
            route: '/health',
          ),
          _DashboardCard(
            label: 'Period Tracker',
            icon: Icons.calendar_month_outlined,
            route: '/periods',
          ),
          _DashboardCard(
            label: 'Birthdays',
            icon: Icons.cake_outlined,
            route: '/birthdays',
          ),
          _DashboardCard(
            label: 'Notes',
            icon: Icons.note_outlined,
            route: '/notes',
          ),
          _DashboardCard(
            label: 'Reminders',
            icon: Icons.notifications_outlined,
            route: '/reminders',
          ),
          _DashboardCard(
            label: 'Calculators',
            icon: Icons.calculate_outlined,
            route: '/calculators',
          ),
          _DashboardCard(
            label: 'Settings',
            icon: Icons.settings_outlined,
            route: '/settings',
          ),
        ],
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final String route;

  const _DashboardCard({
    required this.label,
    required this.icon,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        onTap: () => context.push(route),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: colorScheme.primary),
              const SizedBox(height: 12),
              Text(
                label,
                style: Theme.of(context).textTheme.titleSmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
