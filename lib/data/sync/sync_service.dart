// ignore_for_file: prefer_initializing_formals
import '../local/isar_service.dart';
import '../remote/api_client.dart';

/// Orchestrates syncing local Isar data with the remote Laravel API.
///
/// Currently a placeholder — no sync logic is implemented yet.
/// Strategy: query records where syncStatus == 0, push to API,
/// mark syncStatus == 1 on success.
class SyncService {
  // ignore: unused_field
  final IsarService _isarService;
  // ignore: unused_field
  final ApiClient _apiClient;

  SyncService({
    required IsarService isarService,
    required ApiClient apiClient,
  })  : _isarService = isarService,
        _apiClient = apiClient;

  /// Push all locally pending records to the backend.
  Future<void> syncAll() async {
    // TODO: Implement when Laravel API is ready.
    // ignore: avoid_print
    print('[SyncService] syncAll — not implemented yet');
  }
}
