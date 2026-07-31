class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'Sunucu hatası oluş eksik']);
}