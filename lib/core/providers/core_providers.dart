import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/local/isar_service.dart';
import '../../data/remote/api_client.dart';
import '../../data/sync/sync_service.dart';

/// Singleton Isar database service.
final isarServiceProvider = Provider<IsarService>(
  (_) => IsarService.instance,
);

/// Placeholder API client for future Laravel backend.
final apiClientProvider = Provider<ApiClient>(
  (_) => const ApiClient(baseUrl: 'https://api.rihahome.app'),
);

/// Orchestrates local → remote sync (placeholder).
final syncServiceProvider = Provider<SyncService>(
  (ref) => SyncService(
    isarService: ref.watch(isarServiceProvider),
    apiClient: ref.watch(apiClientProvider),
  ),
);
