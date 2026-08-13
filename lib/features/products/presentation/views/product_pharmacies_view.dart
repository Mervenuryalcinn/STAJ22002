import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:lideatech_pharmacy_app/l10n/app_localizations.dart';

class ProductPharmaciesView extends StatefulWidget {
  final String productId;
  final String productName;

  const ProductPharmaciesView({super.key, required this.productId, required this.productName});

  @override
  State<ProductPharmaciesView> createState() => _ProductPharmaciesViewState();
}

class _ProductPharmaciesViewState extends State<ProductPharmaciesView> {
  List<dynamic> pharmacies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPharmaciesForProduct();
  }

  Future<void> _fetchPharmaciesForProduct() async {
    try {
      final dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:8000'));
      final response = await dio.get('/products/${widget.productId}/pharmacies');

      if (response.statusCode == 200 && response.data['success'] == true) {
        setState(() {
          pharmacies = response.data['result'];
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.productName} ${l10n.pharmaciesContainingProduct}'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : pharmacies.isEmpty
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            l10n.noProductInPharmacies,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      )
          : ListView.builder(
        itemCount: pharmacies.length,
        itemBuilder: (context, index) {
          final pharmacy = pharmacies[index];
          final String pharmacyName = pharmacy['name']?.toString() ?? 'Eczane';
          final String stockAmount = pharmacy['stock']?.toString() ?? '0';
          final String phoneNum = pharmacy['phone']?.toString() ?? 'Belirtilmemiş';

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: const Icon(Icons.local_hospital, color: Colors.red, size: 36),
              title: Text(pharmacyName, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${l10n.stockAmount}: $stockAmount ${l10n.units}\n${l10n.phone}: $phoneNum'),
              trailing: IconButton(
                icon: const Icon(Icons.map, color: Colors.blue, size: 30),
                onPressed: () {
                  double lat = double.tryParse(pharmacy['latitude'].toString()) ?? 36.49;
                  double lng = double.tryParse(pharmacy['longitude'].toString()) ?? 36.36;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PharmacyMapView(
                        latitude: lat,
                        longitude: lng,
                        pharmacyName: pharmacyName,
                        pharmacyPhone: phoneNum,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

// Harita ekranı ve sağ alt köşe zoom butonları aynı dosya içerisinde yer alır
class PharmacyMapView extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String pharmacyName;
  final String pharmacyPhone;

  const PharmacyMapView({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.pharmacyName,
    required this.pharmacyPhone,
  });

  @override
  State<PharmacyMapView> createState() => _PharmacyMapViewState();
}

class _PharmacyMapViewState extends State<PharmacyMapView> {
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pharmacyName),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: LatLng(widget.latitude, widget.longitude),
              initialZoom: 15.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.lideatech.lideatech_pharmacy_app',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(widget.latitude, widget.longitude),
                    width: 80.0,
                    height: 80.0,
                    child: const Icon(
                      Icons.location_pin,
                      color: Colors.red,
                      size: 50,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            right: 16,
            bottom: 32,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  heroTag: 'zoom_in_btn',
                  mini: true,
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.add, color: Colors.black87),
                  onPressed: () {
                    final currentZoom = _mapController.camera.zoom;
                    _mapController.move(_mapController.camera.center, currentZoom + 1);
                  },
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  heroTag: 'zoom_out_btn',
                  mini: true,
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.remove, color: Colors.black87),
                  onPressed: () {
                    final currentZoom = _mapController.camera.zoom;
                    _mapController.move(_mapController.camera.center, currentZoom - 1);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}