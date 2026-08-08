import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_nearby_pharmacies_usecase.dart';
import '../../domain/usecases/get_pharmacies_for_cart_usecase.dart';
import '../../domain/repositories/pharmacy_repository.dart';

import 'pharmacy_event.dart';
import 'pharmacy_state.dart';

class PharmacyBloc extends Bloc<PharmacyEvent, PharmacyState> {
  final GetNearbyPharmaciesUseCase getNearbyPharmaciesUseCase;
  final GetPharmaciesForCartUseCase getPharmaciesForCartUseCase;
  final PharmacyRepository pharmacyRepository;

  PharmacyBloc({
    required this.getNearbyPharmaciesUseCase,
    required this.getPharmaciesForCartUseCase,
    required this.pharmacyRepository,
  }) : super(PharmacyInitial()) {

    // ============================================================
    // 1. GENEL NÖBETÇİ ECZANELER
    // ============================================================

    on<FetchNearbyPharmaciesEvent>((event, emit) async {
      emit(PharmacyLoading());

      final result = await getNearbyPharmaciesUseCase(
        isDuty: true,
      );

      result.fold(
            (failure) {
          emit(PharmacyError(failure.message));
        },
            (pharmacies) {
          emit(PharmacyLoaded(pharmacies));
        },
      );
    });

    // ============================================================
    // 2. GPS KONUMUNA GÖRE ECZANELER
    // ============================================================

    on<FetchPharmaciesByLocationEvent>((event, emit) async {
      emit(PharmacyLoading());

      final result = await getNearbyPharmaciesUseCase(
        lat: event.lat,
        lng: event.lng,
        isDuty: event.isDuty,
      );

      result.fold(
            (failure) {
          emit(PharmacyError(failure.message));
        },
            (pharmacies) {
          emit(PharmacyLoaded(pharmacies));
        },
      );
    });

    // ============================================================
    // 3. ŞEHİR / İLÇEYE GÖRE NÖBETÇİ ECZANELER
    // ============================================================

    on<FetchPharmaciesByCityEvent>((event, emit) async {
      emit(PharmacyLoading());

      final result = await getNearbyPharmaciesUseCase(
        city: event.city,
        district: event.district,
        isDuty: true,
      );

      result.fold(
            (failure) {
          emit(PharmacyError(failure.message));
        },
            (pharmacies) {
          emit(PharmacyLoaded(pharmacies));
        },
      );
    });

    // ============================================================
    // 4. ŞEHİR / İLÇEYE GÖRE TÜM ECZANELER
    // ============================================================

    on<FetchAllPharmaciesByCityEvent>((event, emit) async {
      emit(PharmacyLoading());

      final result = await pharmacyRepository.getAllPharmacies(
        city: event.city,
        district: event.district,
      );

      result.fold(
            (failure) {
          emit(PharmacyError(failure.message));
        },
            (pharmacies) {
          emit(PharmacyLoaded(pharmacies));
        },
      );
    });

    // ============================================================
    // 5. SEPETE UYGUN ECZANELER
    // ============================================================

    on<FetchPharmaciesForCartEvent>((event, emit) async {
      emit(PharmacyLoading());

      print('========================================');
      print('🛒 PHARMACY BLOC - SEPET ECZANE ARAMA');
      print('========================================');
      print('📍 LAT: ${event.lat}');
      print('📍 LNG: ${event.lng}');
      print('💊 PRODUCT IDS: ${event.productIds}');
      print('📦 QUANTITIES: ${event.quantities}');
      print('========================================');

      final result = await getPharmaciesForCartUseCase(
        lat: event.lat,
        lng: event.lng,
        productIds: event.productIds,
        quantities: event.quantities,
      );

      result.fold(
            (failure) {
          print(
            '❌ SEPET ECZANE HATASI: ${failure.message}',
          );

          emit(
            PharmacyError(
              failure.message,
            ),
          );
        },
            (pharmacies) {
          print(
            '✅ UYGUN ECZANE SAYISI: ${pharmacies.length}',
          );

          emit(
            PharmacyCartLoaded(
              pharmacies,
            ),
          );
        },
      );
    });
  }
}