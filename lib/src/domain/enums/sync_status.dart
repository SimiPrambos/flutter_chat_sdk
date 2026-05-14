/// Status of synchronization.
enum SyncStatus {
  /// No sync in progress.
  idle,

  /// Sync is in progress.
  syncing,

  /// Sync completed successfully.
  completed,

  /// Sync failed with error.
  error,
}
