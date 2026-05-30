import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/models/birthday_model.dart';
import '../../data/repositories/birthday_repository.dart';

final birthdayRepositoryProvider = Provider<BirthdayRepository>((ref) {
  return BirthdayRepository(ref.watch(isarServiceProvider));
});

/// Reactive stream of non-deleted birthdays, sorted by name.
final birthdayListProvider = StreamProvider<List<BirthdayModel>>((ref) {
  return ref.watch(birthdayRepositoryProvider).watchBirthdays();
});
