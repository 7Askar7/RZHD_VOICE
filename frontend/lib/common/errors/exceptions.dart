class ServerException implements Exception {
  final String cause;
  ServerException(this.cause);
}