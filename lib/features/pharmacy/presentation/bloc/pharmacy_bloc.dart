import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_nearby_pharmacies_usecase.dart';
import 'pharmacy_event.dart';
import 'pharmacy_state.dart';

class PharmacyBloc extends Bloc<PharmacyEvent, PharmacyState> {
  final GetNearbyPharmaciesUseCase getNearbyPharmaciesUseCase;

  PharmacyBloc({required this.getNearbyPharmaciesUseCase}) : super(PharmacyInitial()) {
    on<FetchNearbyPharmaciesEvent>((event, emit) async {
      emit(PharmacyLoading());
      final result = await getNearbyPharmaciesUseCase();
      result.fold(
            (failure) => emit(PharmacyError(failure.message)),
            (pharmacies) => emit(PharmacyLoaded(pharmacies)),
      );
    });

    on<FetchPharmaciesByLocationEvent>((event, emit) async {
      emit(PharmacyLoading());
      final result = await getNearbyPharmaciesUseCase(lat: event.lat, lng: event.lng);
      result.fold(
            (failure) => emit(PharmacyError(failure.message)),
            (pharmacies) => emit(PharmacyLoaded(pharmacies)),
      );
    });

    on<FetchPharmaciesByCityEvent>((event, emit) async {
      emit(PharmacyLoading());
      final result = await getNearbyPharmaciesUseCase(city: event.city, district: event.district);
      result.fold(
            (failure) => emit(PharmacyError(failure.message)),
            (pharmacies) => emit(PharmacyLoaded(pharmacies)),
      );
    });
  }
}