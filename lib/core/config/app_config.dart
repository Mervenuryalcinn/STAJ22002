class AppConfig {
  // Ortam tipi (Development, Production vb.)
  static const String environment = 'development';

  // API bağlantı zaman aşımı süreleri (Milisaniye cinsinden)
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Uygulama geneli diğer konfigürasyon sabitleri
  static const bool enableLogging = true;
}