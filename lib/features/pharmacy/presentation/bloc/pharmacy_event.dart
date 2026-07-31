abstract class PharmacyEvent {}

class FetchNearbyPharmaciesEvent extends PharmacyEvent {}

class FetchPharmaciesByLocationEvent extends PharmacyEvent {
  final double lat;
  final double lng;

  FetchPharmaciesByLocationEvent({required this.lat, required this.lng});
}

class FetchPharmaciesByCityEvent extends PharmacyEvent {
  final String city;
  final String district;

  FetchPharmaciesByCityEvent({required this.city, required this.district});
}