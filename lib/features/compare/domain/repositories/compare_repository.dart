/// Persists the ordered comparison selection without exposing storage details.
abstract interface class CompareRepository {
  /// Loads the persisted, ordered selection.
  Future<List<String>> loadSelection();

  /// Persists [deviceIds] as the complete ordered selection.
  Future<void> saveSelection(List<String> deviceIds);
}
