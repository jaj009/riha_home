import 'package:isar/isar.dart';

part 'birthday_model.g.dart';

// Sync status constants
const int kSyncPending = 0; // written locally, not yet sent
const int kSyncDone = 1; // confirmed synced with backend
const int kSyncError = 2; // last sync attempt failed

@collection
class BirthdayModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String uuid;

  @Index()
  late String name;

  late DateTime dateOfBirth;

  String? relation;
  String? notes;

  late DateTime createdAt;
  late DateTime updatedAt;

  /// Soft-delete flag — deleted records are hidden but kept for sync.
  bool isDeleted = false;

  /// 0 = pending, 1 = synced, 2 = error
  int syncStatus = kSyncPending;
}
