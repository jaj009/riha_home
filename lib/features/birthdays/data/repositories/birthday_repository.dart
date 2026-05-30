import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';
import '../../../../data/local/isar_service.dart';
import '../models/birthday_model.dart';

/// Repository for all birthday CRUD operations.
///
/// All writes go to Isar first (offline-first).
/// syncStatus is reset to [kSyncPending] on every write so the
/// sync layer knows which records need to be pushed to the backend.
class BirthdayRepository {
  final IsarService _isarService;

  BirthdayRepository(this._isarService);

  Future<void> addBirthday(BirthdayModel birthday) async {
    final now = DateTime.now();
    birthday
      ..uuid = const Uuid().v4()
      ..createdAt = now
      ..updatedAt = now
      ..syncStatus = kSyncPending;

    final db = await _isarService.db;
    await db.writeTxn(() => db.birthdayModels.put(birthday));
  }

  Future<void> updateBirthday(BirthdayModel birthday) async {
    birthday
      ..updatedAt = DateTime.now()
      ..syncStatus = kSyncPending;

    final db = await _isarService.db;
    await db.writeTxn(() => db.birthdayModels.put(birthday));
  }

  /// Soft-deletes a birthday by setting [isDeleted] = true.
  Future<void> deleteBirthday(int id) async {
    final db = await _isarService.db;
    await db.writeTxn(() async {
      final birthday = await db.birthdayModels.get(id);
      if (birthday != null) {
        birthday
          ..isDeleted = true
          ..updatedAt = DateTime.now()
          ..syncStatus = kSyncPending;
        await db.birthdayModels.put(birthday);
      }
    });
  }

  /// Returns null if the record does not exist or has been soft-deleted.
  Future<BirthdayModel?> getBirthdayById(int id) async {
    final db = await _isarService.db;
    final record = await db.birthdayModels.get(id);
    if (record == null || record.isDeleted) return null;
    return record;
  }

  Future<List<BirthdayModel>> getBirthdays() async {
    final db = await _isarService.db;
    return db.birthdayModels
        .filter()
        .isDeletedEqualTo(false)
        .sortByName()
        .findAll();
  }

  /// Reactive stream — emits a new list whenever birthdays change.
  Stream<List<BirthdayModel>> watchBirthdays() async* {
    final db = await _isarService.db;
    yield* db.birthdayModels
        .filter()
        .isDeletedEqualTo(false)
        .sortByName()
        .watch(fireImmediately: true);
  }
}
