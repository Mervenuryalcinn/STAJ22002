import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/order_bloc.dart';
import '../bloc/order_event.dart';
import '../bloc/order_state.dart';
import '../../../authentication/presentation/bloc/auth_bloc.dart';
import '../../../authentication/presentation/bloc/auth_state.dart';
import 'package:lideatech_pharmacy_app/l10n/app_localizations.dart';

class OrdersView extends StatefulWidget {
  const OrdersView({super.key});

  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadOrders();
  }

  void _loadOrders() {
    final authState = context.read<AuthBloc>().state;
    String? userId;

    if (authState is AuthSuccessState) {
      userId = authState.userId;
    }

    if (userId != null && userId.isNotEmpty) {
      context.read<OrderBloc>().add(
        LoadOrdersEvent(userId: userId),
      );
    }
  }

  // Backend'den Türkçe gelen statüleri dile göre çeviren fonksiyon
  String _getTranslatedStatus(BuildContext context, String status) {
    final l10n = AppLocalizations.of(context)!;
    switch (status.toLowerCase().trim()) {
      case 'talep alındı':
        return l10n.step1Title;
      case 'hazırlanıyor':
        return l10n.step2Title;
      case 'yola çıktı':
        return l10n.step3Title;
      case 'tamamlandı':
        return l10n.step4Title;
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authState = context.read<AuthBloc>().state;
    String? userId;

    if (authState is AuthSuccessState) {
      userId = authState.userId;
    }

    if (userId == null || userId.isEmpty) {
      return Scaffold(
        body: Center(
          child: Text(
            l10n.userInfoNotFoundLogin,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.pastOrders),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadOrders,
          ),
        ],
      ),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is OrderLoadedState) {
            if (state.orders.isEmpty) {
              return Center(
                child: Text(
                  l10n.noOrdersYet,
                ),
              );
            }

            return ListView.builder(
              itemCount: state.orders.length,
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final order = state.orders[index];

                return Card(
                  margin: const EdgeInsets.only(
                    bottom: 12,
                  ),
                  child: ListTile(
                    title: Text(
                      '${l10n.orderId}: #${order.id}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          '${l10n.address}: ${order.address}',
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${l10n.amount}: ${order.totalAmount.toStringAsFixed(2)} ₺',
                          style: const TextStyle(
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    trailing: Chip(
                      label: Text(
                        _getTranslatedStatus(context, order.status),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      backgroundColor: _getStatusColor(order.status),
                    ),
                    onTap: () async {
                      await context.push('/orders/${order.id}');
                      _loadOrders();
                    },
                  ),
                );
              },
            );
          } else if (state is OrderErrorState) {
            return Center(
              child: Text(
                '${l10n.error}: ${state.message}',
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase().trim()) {
      case 'talep alındı':
        return Colors.orange;
      case 'hazırlanıyor':
        return Colors.blue;
      case 'yola çıktı':
        return Colors.purple;
      case 'tamamlandı':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}