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
  final TextEditingController _cityController = TextEditingController(text: 'Hatay');
  final TextEditingController _districtController = TextEditingController(text: 'Kırıkhan');
  String _statusMessage = "Konum veya manuel arama bekleniyor...";

  @override
  void initState() {
    super.initState();
    _initLocationOrManual();
  }

  Future<void> _initLocationOrManual() async {
    try {
      final position = await LocationService.getCurrentLocation().timeout(
        const Duration(seconds: 3),
        onTimeout: () => null,
      );

      if (position != null) {
        setState(() {
          _statusMessage = "GPS Konumu ile nöbetçi eczaneler listeleniyor.";
        });
        if (mounted) {
          BlocProvider.of<PharmacyBloc>(context).add(
            FetchPharmaciesByLocationEvent(
              lat: position.latitude,
              lng: position.longitude,
            ),
          );
        }
      } else {
        _fetchManual();
      }
    } catch (e) {
      _fetchManual();
    }
  }

  void _fetchManual() {
    setState(() {
      _statusMessage = "Konum alınamadı. ${_cityController.text} / ${_districtController.text} için nöbetçi eczaneler gösteriliyor.";
    });
    BlocProvider.of<PharmacyBloc>(context).add(
      FetchPharmaciesByCityEvent(
        city: _cityController.text,
        district: _districtController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nöbetçi Eczaneler'),
      ),
      body: Column(
        children: [
          // Manuel İl/İlçe Arama Paneli
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.grey.shade100,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _cityController,
                        decoration: const InputDecoration(
                          labelText: 'İl (Örn: Hatay)',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _districtController,
                        decoration: const InputDecoration(
                          labelText: 'İlçe (Örn: Kırıkhan)',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _fetchManual,
                      child: const Text('Ara'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _statusMessage,
                  style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<PharmacyBloc, PharmacyState>(
              builder: (context, state) {
                if (state is PharmacyInitial || state is PharmacyLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is PharmacyLoaded) {
                  if (state.pharmacies.isEmpty) {
                    return const Center(child: Text('Bu bölgede nöbetçi eczane bulunamadı.'));
                  }
                  return ListView.builder(
                    itemCount: state.pharmacies.length,
                    itemBuilder: (context, index) {
                      final pharmacy = state.pharmacies[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: const Icon(Icons.local_pharmacy, color: Colors.green),
                          title: Text(pharmacy.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(pharmacy.address),
                              const SizedBox(height: 4),
                              Text('Tel: ${pharmacy.phone}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          isThreeLine: true,
                          trailing: const Chip(
                            label: Text('Nöbetçi', style: TextStyle(color: Colors.white, fontSize: 11)),
                            backgroundColor: Colors.green,
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is PharmacyError) {
                  return Center(child: Text('Hata: ${state.message}'));
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