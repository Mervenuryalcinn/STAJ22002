import 'package:geolocator/geolocator.dart';

class LocationService {
  // Kullanıcıdan konum izni istemek ve konumu almak için ana fonksiyon
  static Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 1. Konum servisleri açık mı kontrol et
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Konum servisleri kapalı. Lütfen açın.');
    }

    // 2. İzin durumunu kontrol et
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Konum izinleri reddedildi.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Konum izinleri kalıcı olarak reddedildi, ayarlardan açmanız gerekiyor.',
      );
    }

    // 3. İzinler tamamsa mevcut konumu döndür
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}