enum Environment { dev, prod }

class AppConfig {
  // Aktif ortamı burada seçebilirsin
  static const Environment _currentEnvironment = Environment.dev;

  // Ortama göre dinamik Base URL yönetimi
  static String get baseUrl {
    switch (_currentEnvironment) {
      case Environment.dev:
        return 'https://dev-api.lideatech-pharmacy.com/api/v1'; // Mock veya Dev API
      case Environment.prod:
        return 'https://api.lideatech-pharmacy.com/api/v1';       // Canlı API
    }
  }

  static String get environmentName => _currentEnvironment == Environment.dev ? 'Development' : 'Production';

  // API bağlantı zaman aşımı süreleri
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Ortama göre loglama kontrolü (Dev'de açık, Prod'da kapalı)
  static bool get enableLogging => _currentEnvironment == Environment.dev;
}