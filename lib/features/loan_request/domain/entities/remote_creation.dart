/// The confirmed remote result of creating a loan-request object.
final class RemoteCreation {
  /// Creates a confirmed remote creation.
  const RemoteCreation({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.status,
    required this.data,
  });

  /// The remote identifier.
  final String id;

  /// The remote object name.
  final String name;

  /// The remote creation timestamp.
  final DateTime createdAt;

  /// The status returned in the nested response data.
  final String status;

  /// The returned nested response data.
  final Map<String, Object?> data;
}
