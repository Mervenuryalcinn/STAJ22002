import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_paths.dart';
import '../../../../core/utils/location_service.dart';

import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';

import '../../../order/presentation/bloc/order_bloc.dart';
import '../../../order/presentation/bloc/order_event.dart';
import '../../../order/presentation/bloc/order_state.dart';

import '../../../pharmacy/presentation/bloc/pharmacy_bloc.dart';
import '../../../pharmacy/presentation/bloc/pharmacy_event.dart';
import '../../../pharmacy/presentation/bloc/pharmacy_state.dart';

import '../../../authentication/presentation/bloc/auth_bloc.dart';
import '../../../authentication/presentation/bloc/auth_state.dart';

class CheckoutView extends StatefulWidget {
  final String currentDistrict;
  final String currentCity;

  const CheckoutView({
    super.key,
    required this.currentDistrict,
    required this.currentCity,
  });

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  String _statusMessage = 'Konumunuza göre eczaneler aranıyor...';

  int? selectedPharmacyId;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _findPharmaciesForCart();
    });
  }

  // ============================================================
  // SEPETE GÖRE ECZANE ARA
  // ============================================================

  Future<void> _findPharmaciesForCart() async {
    if (!mounted) return;

    final cartState = context.read<CartBloc>().state;

    // ------------------------------------------------------------
    // Sepet boş mu?
    // ------------------------------------------------------------

    if (cartState.items.isEmpty) {
      setState(() {
        _statusMessage = 'Sepetinizde ürün bulunmuyor.';
      });
      return;
    }

    setState(() {
      _statusMessage = 'Konumunuz alınıyor...';
    });

    try {
      // ----------------------------------------------------------
      // GPS
      // ----------------------------------------------------------

      final position = await LocationService.getCurrentLocation()
          .timeout(
        const Duration(seconds: 10),
        onTimeout: () => null,
      );

      if (position == null) {
        if (!mounted) return;

        setState(() {
          _statusMessage =
          'Konum alınamadı. Lütfen GPS ve konum izinlerini kontrol edin.';
        });

        return;
      }

      // ----------------------------------------------------------
      // Ürün ID'leri
      // ----------------------------------------------------------

      final productIds = cartState.items.map((item) {
        return int.parse(item.product.id);
      }).toList();

      // ----------------------------------------------------------
      // Ürün miktarları
      // ----------------------------------------------------------

      final quantities = cartState.items.map((item) {
        return item.quantity;
      }).toList();

      // ----------------------------------------------------------
      // DEBUG
      // ----------------------------------------------------------

      print('========================================');
      print('🛒 CHECKOUT ECZANE ARAMA');
      print('========================================');

      print('📍 LATITUDE : ${position.latitude}');
      print('📍 LONGITUDE: ${position.longitude}');

      print('💊 PRODUCT IDS: $productIds');
      print('📦 QUANTITIES: $quantities');

      print('========================================');

      if (!mounted) return;

      setState(() {
        _statusMessage =
        'Sepetinizdeki ürünlerin tamamına sahip eczaneler aranıyor...';
      });

      // ----------------------------------------------------------
      // PharmacyBloc
      // ----------------------------------------------------------

      context.read<PharmacyBloc>().add(
        FetchPharmaciesForCartEvent(
          lat: position.latitude,
          lng: position.longitude,
          productIds: productIds,
          quantities: quantities,
        ),
      );
    } catch (e) {
      print('❌ CHECKOUT ECZANE ARAMA HATASI: $e');

      if (!mounted) return;

      setState(() {
        _statusMessage = 'Eczaneler aranırken hata oluştu: $e';
      });
    }
  }

  // ============================================================
  // SİPARİŞİ TAMAMLA
  // ============================================================

  void _onCompleteOrder(BuildContext context) {
    final cartState = context.read<CartBloc>().state;

    if (cartState.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sepetiniz boş olduğu için sipariş oluşturulamadı.'),
        ),
      );
      return;
    }

    if (selectedPharmacyId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Lütfen talebinizi göndermek için bir eczane seçin!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // ==========================================
    // GİRİŞ YAPAN KULLANICININ GERÇEK TCKN'SİNİ ALIYORuz
    // ==========================================
    final authState = context.read<AuthBloc>().state;
    String currentUserId = "1"; // Yedek değer

    if (authState is AuthSuccessState) {
      currentUserId = authState.userId; // Örn: "55544433322"
    }

    final List<Map<String, dynamic>> orderItems = cartState.items.map((item) {
      return {
        'product_id': int.parse(item.product.id),
        'quantity': item.quantity,
      };
    }).toList();

    print('========================================');
    print('🛒 SİPARİŞ OLUŞTURULUYOR (Gerçek TCKN: $currentUserId)');
    print('🏥 ECZANE ID: $selectedPharmacyId');
    print('💰 TOPLAM: ${cartState.totalAmount}');
    print('========================================');

    context.read<OrderBloc>().add(
      CreateOrderEvent(
        userId: currentUserId,
        eczaneId: selectedPharmacyId!,
        totalAmount: cartState.totalAmount,
        items: orderItems,
      ),
    );
  }

  // ============================================================
  // ECZANE KARTI
  // ============================================================

  Widget _buildPharmacyCard(
      BuildContext context,
      dynamic pharmacy,
      ) {
    final int pharmacyId =
        int.tryParse(pharmacy.pharmacyId.toString()) ?? 0;

    final bool selected =
        selectedPharmacyId == pharmacyId;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: selected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: selected
              ? Colors.green
              : Colors.grey.shade300,
          width: selected ? 2 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          setState(() {
            selectedPharmacyId = pharmacyId;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --------------------------------------------------
              // ECZANE BAŞLIK
              // --------------------------------------------------

              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.local_pharmacy,
                      color: Colors.green,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      pharmacy.pharmacyName,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  if (selected)
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),
                ],
              ),

              const SizedBox(height: 12),

              // --------------------------------------------------
              // KONUM
              // --------------------------------------------------

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 20,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      pharmacy.address,
                      style: const TextStyle(
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              // --------------------------------------------------
              // TELEFON
              // --------------------------------------------------

              Row(
                children: [
                  const Icon(
                    Icons.phone_outlined,
                    size: 19,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    pharmacy.phone,
                    style: const TextStyle(
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              // --------------------------------------------------
              // MESAFE
              // --------------------------------------------------

              Row(
                children: [
                  const Icon(
                    Icons.directions_walk,
                    size: 19,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${pharmacy.distanceKm.toStringAsFixed(2)} km uzaklıkta',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              const Divider(),

              const SizedBox(height: 8),

              // --------------------------------------------------
              // ÜRÜNLER / STOKLAR
              // --------------------------------------------------

              const Text(
                'Sepetinizdeki ürünlerin stok durumu',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 8),

              ...pharmacy.productStocks.entries.map(
                    (entry) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.medication_outlined,
                          size: 18,
                          color: Colors.green,
                        ),

                        const SizedBox(width: 8),

                        Expanded(
                          child: Text(
                            'Ürün #${entry.key}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        Text(
                          '${entry.value} adet',
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 8),

              // --------------------------------------------------
              // SEÇ
              // --------------------------------------------------

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      selectedPharmacyId = pharmacyId;
                    });
                  },
                  icon: Icon(
                    selected
                        ? Icons.check
                        : Icons.local_pharmacy_outlined,
                  ),
                  label: Text(
                    selected
                        ? 'Eczane Seçildi'
                        : 'Bu Eczaneyi Seç',
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.green,
                    side: BorderSide(
                      color: selected
                          ? Colors.green
                          : Colors.green.shade300,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final userDistrict = widget.currentDistrict;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sipariş / Talep Onayı ($userDistrict)',
        ),
      ),

      body: BlocListener<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state is OrderLoadedState) {
            context.read<CartBloc>().add(
              ClearCartEvent(),
            );

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Siparişiniz başarıyla kaydedildi!',
                ),
                backgroundColor: Colors.green,
              ),
            );

            context.go(RoutePaths.home);
          }

          if (state is OrderErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Hata oluştu: ${state.message}',
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        },

        child: Column(
          children: [
            // ----------------------------------------------------
            // BAŞLIK
            // ----------------------------------------------------

            Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                16,
                16,
                8,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '📍 Konumunuza Göre Eczane Seçimi ($userDistrict)',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // ----------------------------------------------------
            // DURUM
            // ----------------------------------------------------

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 6,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _statusMessage,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
            ),

            // ----------------------------------------------------
            // ECZANELER
            // ----------------------------------------------------

            Expanded(
              child: BlocBuilder<PharmacyBloc, PharmacyState>(
                builder: (context, state) {
                  // ----------------------------------------------
                  // LOADING
                  // ----------------------------------------------

                  if (state is PharmacyInitial ||
                      state is PharmacyLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  // ----------------------------------------------
                  // SEPET ECZANELERİ
                  // ----------------------------------------------

                  if (state is PharmacyCartLoaded) {
                    final pharmacies = state.pharmacies;

                    if (pharmacies.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: Text(
                            'Sepetinizdeki ürünlerin tamamına sahip yakın bir eczane bulunamadı.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(
                        16,
                        8,
                        16,
                        100,
                      ),
                      itemCount: pharmacies.length,
                      itemBuilder: (context, index) {
                        return _buildPharmacyCard(
                          context,
                          pharmacies[index],
                        );
                      },
                    );
                  }

                  // ----------------------------------------------
                  // HATA
                  // ----------------------------------------------

                  if (state is PharmacyError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 50,
                              color: Colors.red,
                            ),

                            const SizedBox(height: 12),

                            Text(
                              'Hata: ${state.message}',
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 16),

                            ElevatedButton.icon(
                              onPressed: _findPharmaciesForCart,
                              icon: const Icon(Icons.refresh),
                              label: const Text(
                                'Tekrar Dene',
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),

            // ----------------------------------------------------
            // TAMAMLA BUTONU
            // ----------------------------------------------------

            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  8,
                  16,
                  12,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                      ),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      _onCompleteOrder(context);
                    },
                    child: const Text(
                      'Siparişi / Talebi Tamamla',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}