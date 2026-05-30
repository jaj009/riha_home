import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../../features/birthdays/data/models/birthday_model.dart';

/// Manages the single Isar database instance for the app.
///
/// Add new collection schemas to [_open] as features are built.
class IsarService {
  IsarService._();
  static final IsarService instance = IsarService._();

  Isar? _db;

  /// Returns the open Isar instance, initialising it on first call.
  Future<Isar> get db async {
    if (_db != null && _db!.isOpen) return _db!;
    _db = await _open();
    return _db!;
  }

  Future<Isar> _open() async {
    final dir = await getApplicationDocumentsDirectory();
    return Isar.open(
      [BirthdayModelSchema],
      directory: dir.path,
    );
  }
}
