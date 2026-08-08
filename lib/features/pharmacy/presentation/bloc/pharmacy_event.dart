abstract class PharmacyEvent {}

class FetchNearbyPharmaciesEvent extends PharmacyEvent {}

class FetchPharmaciesByLocationEvent extends PharmacyEvent {
  final double lat;
  final double lng;
  final bool isDuty;

  FetchPharmaciesByLocationEvent({
    required this.lat,
    required this.lng,
    required this.isDuty,
  });
}

class FetchPharmaciesByCityEvent extends PharmacyEvent {
  final String city;
  final String district;

  FetchPharmaciesByCityEvent({
    required this.city,
    required this.district,
  });
}

class FetchAllPharmaciesByCityEvent extends PharmacyEvent {
  final String city;
  final String district;

  FetchAllPharmaciesByCityEvent({
    required this.city,
    required this.district,
  });
}

class FetchPharmaciesForCartEvent extends PharmacyEvent {
  final double lat;
  final double lng;
  final List<int> productIds;
  final List<int> quantities;

  FetchPharmaciesForCartEvent({
    required this.lat,
    required this.lng,
    required this.productIds,
    required this.quantities,
  });
}