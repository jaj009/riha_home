/// Domain entity for a birthday — decoupled from the Isar model.
///
/// Business logic (age calculation, days until birthday) lives here
/// so it can be tested without a database.
class Birthday {
  final int id;
  final String uuid;
  final String name;
  final DateTime dateOfBirth;
  final String? relation;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Birthday({
    required this.id,
    required this.uuid,
    required this.name,
    required this.dateOfBirth,
    this.relation,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Age the person will turn on their next birthday (or current age if today).
  int get nextAge {
    final now = DateTime.now();
    // Normalize to date-only so today's birthday is not rolled forward.
    final today = DateTime(now.year, now.month, now.day);
    var next = DateTime(today.year, dateOfBirth.month, dateOfBirth.day);
    if (next.isBefore(today)) {
      next = DateTime(today.year + 1, dateOfBirth.month, dateOfBirth.day);
    }
    return next.year - dateOfBirth.year;
  }

  /// Number of days until the next birthday (0 = today).
  int get daysUntilBirthday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    var next = DateTime(today.year, dateOfBirth.month, dateOfBirth.day);
    if (next.isBefore(today)) {
      next = DateTime(today.year + 1, dateOfBirth.month, dateOfBirth.day);
    }
    return next.difference(today).inDays;
  }
}
