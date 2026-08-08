import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/location_service.dart';
import '../bloc/pharmacy_bloc.dart';
import '../bloc/pharmacy_event.dart';
import '../bloc/pharmacy_state.dart';

class PharmacyListView extends StatefulWidget {
  const PharmacyListView({super.key});

  @override
  State<PharmacyListView> createState() => _PharmacyListViewState();
}

class _PharmacyListViewState extends State<PharmacyListView> {
  String _statusMessage =
      "Konum izni isteniyor ve en yakın eczaneler aranıyor...";

  bool _isDutyOnly = true;

  @override
  void initState() {
    super.initState();
    _fetchPharmaciesByGPS();
  }

  // GPS konumunu alıp backend'e gönderir
  Future<void> _fetchPharmaciesByGPS() async {
    setState(() {
      _statusMessage = "GPS konumunuz tespit ediliyor...";
    });

    try {
      final position = await LocationService.getCurrentLocation().timeout(
        const Duration(seconds: 10),
        onTimeout: () => null,
      );

      if (position == null) {
        setState(() {
          _statusMessage =
          "Konum alınamadı. Lütfen cihazınızın konum izinlerini ve GPS'i açın.";
        });
        return;
      }

      // DEBUG
      print('========================================');
      print('📍 EMÜLATÖR GPS KONUMU');
      print('Latitude : ${position.latitude}');
      print('Longitude: ${position.longitude}');
      print('========================================');

      setState(() {
        _statusMessage = _isDutyOnly
            ? "Konumunuza en yakın nöbetçi eczaneler aranıyor..."
            : "Konumunuza en yakın tüm eczaneler aranıyor...";
      });

      if (!mounted) return;

      // Şimdilik konuma göre endpoint'e gönderiyoruz.
      context.read<PharmacyBloc>().add(
        FetchPharmaciesByLocationEvent(
          lat: position.latitude,
          lng: position.longitude,
          isDuty: _isDutyOnly,
        ),
      );
    } catch (e) {
      print("❌ GPS HATASI: $e");

      if (!mounted) return;

      setState(() {
        _statusMessage = "Konum alınırken hata oluştu: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isDutyOnly ? 'Nöbetçi Eczaneler' : 'Tüm Eczaneler',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _fetchPharmaciesByGPS,
            tooltip: 'Konumu Güncelle',
          ),
        ],
      ),
      body: Column(
        children: [
          // ---------------------------------------------------------
          // NÖBETÇİ / TÜM ECZANELER
          // ---------------------------------------------------------
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            color: Colors.green.shade50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: const Text('Nöbetçi Eczaneler'),
                  selected: _isDutyOnly,
                  selectedColor: Colors.green.shade200,
                  onSelected: (selected) {
                    if (!selected) return;

                    setState(() {
                      _isDutyOnly = true;
                    });

                    _fetchPharmaciesByGPS();
                  },
                ),
                const SizedBox(width: 12),
                ChoiceChip(
                  label: const Text('Tüm Eczaneler'),
                  selected: !_isDutyOnly,
                  selectedColor: Colors.green.shade200,
                  onSelected: (selected) {
                    if (!selected) return;

                    setState(() {
                      _isDutyOnly = false;
                    });

                    _fetchPharmaciesByGPS();
                  },
                ),
              ],
            ),
          ),

          // ---------------------------------------------------------
          // DURUM MESAJI
          // ---------------------------------------------------------
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Colors.grey.shade100,
            child: Text(
              _statusMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.blueGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // ---------------------------------------------------------
          // ECZANE LİSTESİ
          // ---------------------------------------------------------
          Expanded(
            child: BlocBuilder<PharmacyBloc, PharmacyState>(
              builder: (context, state) {
                if (state is PharmacyInitial ||
                    state is PharmacyLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is PharmacyLoaded) {
                  if (state.pharmacies.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                          _isDutyOnly
                              ? 'Bulunduğunuz GPS konumuna yakın nöbetçi eczane bulunamadı.'
                              : 'Bulunduğunuz GPS konumuna yakın kayıtlı eczane bulunamadı.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: state.pharmacies.length,
                    itemBuilder: (context, index) {
                      final pharmacy = state.pharmacies[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: ListTile(
                          leading: Icon(
                            Icons.local_pharmacy,
                            color: _isDutyOnly
                                ? Colors.green
                                : Colors.blue,
                          ),
                          title: Text(pharmacy.name),
                          subtitle: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(pharmacy.address),
                              const SizedBox(height: 4),
                              Text(
                                'Tel: ${pharmacy.phone}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          isThreeLine: true,
                          trailing: Chip(
                            label: Text(
                              _isDutyOnly ? 'Nöbetçi' : 'Açık',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                              ),
                            ),
                            backgroundColor: _isDutyOnly
                                ? Colors.green
                                : Colors.blue,
                          ),
                        ),
                      );
                    },
                  );
                }

                if (state is PharmacyError) {
                  return Center(
                    child: Text(
                      'Hata: ${state.message}',
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}