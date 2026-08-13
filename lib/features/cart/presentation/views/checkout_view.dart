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
import 'package:lideatech_pharmacy_app/l10n/app_localizations.dart';

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
  late String _statusMessage;
  int? selectedPharmacyId;

  @override
  void initState() {
    super.initState();
    // Dinamik metin ataması build context gerektirdiği için didChangeDependencies veya postFrameCallback içinde yapılıyor
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _findPharmaciesForCart();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final l10n = AppLocalizations.of(context)!;
    _statusMessage = l10n.searchingPharmacies;
  }

  Future<void> _findPharmaciesForCart() async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    final cartState = context.read<CartBloc>().state;

    if (cartState.items.isEmpty) {
      setState(() {
        _statusMessage = l10n.cartEmptyOrderError;
      });
      return;
    }

    setState(() {
      _statusMessage = l10n.gettingLocation;
    });

    try {
      final position = await LocationService.getCurrentLocation()
          .timeout(const Duration(seconds: 10), onTimeout: () => null);

      if (position == null) {
        if (!mounted) return;
        setState(() {
          _statusMessage = l10n.locationFailed;
        });
        return;
      }

      final productIds = cartState.items.map((item) => int.parse(item.product.id)).toList();
      final quantities = cartState.items.map((item) => item.quantity).toList();

      if (!mounted) return;

      setState(() {
        _statusMessage = l10n.searchingMatchingPharmacies;
      });

      context.read<PharmacyBloc>().add(
        FetchPharmaciesForCartEvent(
          lat: position.latitude,
          lng: position.longitude,
          productIds: productIds,
          quantities: quantities,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _statusMessage = '${l10n.pharmacySearchError}: $e';
      });
    }
  }

  void _onCompleteOrder(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cartState = context.read<CartBloc>().state;

    if (cartState.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.cartEmptyOrderError)),
      );
      return;
    }

    if (selectedPharmacyId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.selectPharmacyWarning),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final authState = context.read<AuthBloc>().state;
    String currentUserId = "1";

    if (authState is AuthSuccessState) {
      currentUserId = authState.userId;
    }

    final List<Map<String, dynamic>> orderItems = cartState.items.map((item) {
      return {
        'product_id': int.parse(item.product.id),
        'quantity': item.quantity,
      };
    }).toList();

    context.read<OrderBloc>().add(
      CreateOrderEvent(
        userId: currentUserId,
        eczaneId: selectedPharmacyId!,
        totalAmount: cartState.totalAmount,
        items: orderItems,
      ),
    );
  }

  Widget _buildPharmacyCard(BuildContext context, dynamic pharmacy) {
    final l10n = AppLocalizations.of(context)!;
    final int pharmacyId = int.tryParse(pharmacy.pharmacyId.toString()) ?? 0;
    final bool selected = selectedPharmacyId == pharmacyId;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: selected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: selected ? Colors.green : Colors.grey.shade300,
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
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.local_pharmacy, color: Colors.green),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      pharmacy.pharmacyName,
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ),
                  if (selected) const Icon(Icons.check_circle, color: Colors.green),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.location_on_outlined, size: 20, color: Colors.grey),
                  const SizedBox(width: 6),
                  Expanded(child: Text(pharmacy.address, style: const TextStyle(color: Colors.black87))),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.phone_outlined, size: 19, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text(pharmacy.phone, style: const TextStyle(color: Colors.black87)),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.directions_walk, size: 19, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text('${pharmacy.distanceKm.toStringAsFixed(2)} km ${l10n.distanceAway}', style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              Text(l10n.productStockStatus, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              ...pharmacy.productStocks.entries.map((entry) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      const Icon(Icons.medication_outlined, size: 18, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(child: Text('Ürün #${entry.key}', style: const TextStyle(fontWeight: FontWeight.w500))),
                      Text('${entry.value} ${l10n.units}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      selectedPharmacyId = pharmacyId;
                    });
                  },
                  icon: Icon(selected ? Icons.check : Icons.local_pharmacy_outlined),
                  label: Text(selected ? l10n.pharmacySelected : l10n.selectThisPharmacy),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.green,
                    side: BorderSide(color: selected ? Colors.green : Colors.green.shade300),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final userDistrict = widget.currentDistrict;

    return Scaffold(
      appBar: AppBar(
        title: Text('${l10n.orderApproval} ($userDistrict)'),
      ),
      body: BlocListener<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state is OrderLoadedState) {
            context.read<CartBloc>().add(ClearCartEvent());
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.orderSuccess), backgroundColor: Colors.green),
            );
            context.go(RoutePaths.home);
          }
          if (state is OrderErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${l10n.error}: ${state.message}'), backgroundColor: Colors.red),
            );
          }
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '📍 ${l10n.selectPharmacyByLocation} ($userDistrict)',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(_statusMessage, style: const TextStyle(fontSize: 13, color: Colors.blueGrey)),
              ),
            ),
            Expanded(
              child: BlocBuilder<PharmacyBloc, PharmacyState>(
                builder: (context, state) {
                  if (state is PharmacyInitial || state is PharmacyLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is PharmacyCartLoaded) {
                    final pharmacies = state.pharmacies;
                    if (pharmacies.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            l10n.noMatchingPharmacyFound,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.grey, fontSize: 15),
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                      itemCount: pharmacies.length,
                      itemBuilder: (context, index) {
                        return _buildPharmacyCard(context, pharmacies[index]);
                      },
                    );
                  }
                  if (state is PharmacyError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.error_outline, size: 50, color: Colors.red),
                            const SizedBox(height: 12),
                            Text('${l10n.error}: ${state.message}', textAlign: TextAlign.center),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: _findPharmaciesForCart,
                              icon: const Icon(Icons.refresh),
                              label: Text(l10n.retry),
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
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: () => _onCompleteOrder(context),
                    child: Text(
                      l10n.completeOrder,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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