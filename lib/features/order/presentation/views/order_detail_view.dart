import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/order_bloc.dart';
import '../bloc/order_event.dart';
import '../bloc/order_state.dart';
import 'package:lideatech_pharmacy_app/l10n/app_localizations.dart';

class OrderDetailView extends StatefulWidget {
  final String orderId;

  const OrderDetailView({super.key, required this.orderId});

  @override
  State<OrderDetailView> createState() => _OrderDetailViewState();
}

class _OrderDetailViewState extends State<OrderDetailView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchOrderDetail();
    });
  }

  void _fetchOrderDetail() {
    if (mounted) {
      context.read<OrderBloc>().add(LoadOrderDetailEvent(orderId: widget.orderId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text('${l10n.orderTracking} #${widget.orderId}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/orders');
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Yenile',
            onPressed: _fetchOrderDetail,
          ),
        ],
      ),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderLoadingState ||
              state is OrderLoadedState ||
              state.runtimeType.toString() == 'OrderInitial' ||
              state is OrderInitialState) {

            if (state is OrderLoadedState) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _fetchOrderDetail();
              });
            }

            return const Center(child: CircularProgressIndicator());
          }

          if (state is OrderDetailLoadedState) {
            final order = state.order;
            return RefreshIndicator(
              onRefresh: () async => _fetchOrderDetail(),
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  Text(l10n.deliveryAddress, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
                  const SizedBox(height: 4),
                  Text(order.address, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 16),
                  Text('${l10n.totalAmount}: ${order.totalAmount.toStringAsFixed(2)} ₺', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  Text(
                    l10n.requestedProducts,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...order.items.map((item) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const Icon(Icons.medical_services, color: Colors.green),
                      title: Text(item.productName),
                      trailing: Text('${item.quantity} ${l10n.units}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  )),
                  const SizedBox(height: 16),
                  Text(l10n.orderStatusSteps, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 300,
                    child: ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _buildStepItem(l10n.step1Title, l10n.step1Desc, true),
                        _buildStepItem(l10n.step2Title, l10n.step2Desc, _isStepActive(order.status, 'Hazırlanıyor')),
                        _buildStepItem(l10n.step3Title, l10n.step3Desc, _isStepActive(order.status, 'Yola Çıktı')),
                        _buildStepItem(l10n.step4Title, l10n.step4Desc, _isStepActive(order.status, 'Tamamlandı')),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is OrderErrorState) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 12),
                    Text('${l10n.error}: ${state.message}', textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _fetchOrderDetail,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Tekrar Dene'),
                    ),
                  ],
                ),
              ),
            );
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _fetchOrderDetail,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Detayları Yükle'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  bool _isStepActive(String currentStatus, String targetStatus) {
    List<String> statuses = ['talep alındı', 'hazırlanıyor', 'yola çıktı', 'tamamlandı'];
    int currentIndex = statuses.indexOf(currentStatus.toLowerCase());
    int targetIndex = statuses.indexOf(targetStatus.toLowerCase());
    return currentIndex >= targetIndex;
  }

  Widget _buildStepItem(String title, String subtitle, bool isActive) {
    return ListTile(
      leading: Icon(
        isActive ? Icons.check_circle : Icons.radio_button_unchecked,
        color: isActive ? Colors.green : Colors.grey,
        size: 28,
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: isActive ? Colors.black : Colors.grey)),
      subtitle: Text(subtitle),
    );
  }
}