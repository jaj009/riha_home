import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../data/models/birthday_model.dart';
import '../providers/birthday_providers.dart';

class BirthdayListScreen extends ConsumerWidget {
  const BirthdayListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final birthdaysAsync = ref.watch(birthdayListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Birthdays')),
      body: birthdaysAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (birthdays) {
          if (birthdays.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cake_outlined,
                    size: 72,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(height: 16),
                  const Text('No birthdays yet.'),
                  const SizedBox(height: 4),
                  const Text('Tap + to add one.'),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemCount: birthdays.length,
            itemBuilder: (context, index) =>
                _BirthdayTile(birthday: birthdays[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/birthdays/add'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _BirthdayTile extends ConsumerWidget {
  final BirthdayModel birthday;

  const _BirthdayTile({required this.birthday});

  static int _nextAge(DateTime dob) {
    final now = DateTime.now();
    // Normalize to date-only so today's birthday is not rolled forward.
    final today = DateTime(now.year, now.month, now.day);
    var next = DateTime(today.year, dob.month, dob.day);
    if (next.isBefore(today)) next = DateTime(today.year + 1, dob.month, dob.day);
    return next.year - dob.year;
  }

  static int _daysUntil(DateTime dob) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    var next = DateTime(today.year, dob.month, dob.day);
    if (next.isBefore(today)) next = DateTime(today.year + 1, dob.month, dob.day);
    return next.difference(today).inDays;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dob = birthday.dateOfBirth;
    final daysUntil = _daysUntil(dob);
    final nextAge = _nextAge(dob);
    final dateStr = DateFormat('MMM d').format(dob);
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: colorScheme.primaryContainer,
          child: Text(
            birthday.name.isNotEmpty ? birthday.name[0].toUpperCase() : '?',
            style: TextStyle(color: colorScheme.onPrimaryContainer),
          ),
        ),
        title: Text(birthday.name),
        subtitle: Text(
          [
            if (birthday.relation != null) birthday.relation!,
            '$dateStr · turns $nextAge',
          ].join(' · '),
        ),
        trailing: Text(
          daysUntil == 0 ? '🎂 Today!' : '$daysUntil days',
          style: TextStyle(
            color: daysUntil <= 7 ? colorScheme.error : colorScheme.outline,
            fontWeight: daysUntil <= 7 ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
        onTap: () => context.push('/birthdays/edit/${birthday.id}'),
        onLongPress: () => _showDeleteDialog(context, ref),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Birthday'),
        content: Text("Remove ${birthday.name}'s birthday?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(birthdayRepositoryProvider)
                  .deleteBirthday(birthday.id);
              Navigator.pop(ctx);
            },
            child: Text(
              'Delete',
              style: TextStyle(color: Theme.of(ctx).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}
