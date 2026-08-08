import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/order_bloc.dart';
import '../bloc/order_event.dart';
import '../bloc/order_state.dart';

import '../../../authentication/presentation/bloc/auth_bloc.dart';
import '../../../authentication/presentation/bloc/auth_state.dart';

class OrdersView extends StatefulWidget {
  const OrdersView({super.key});

  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  @override
  void initState() {
    super.initState();
    // Siparişleri sadece sayfa ilk açıldığında bir kez yüklüyoruz
    _loadOrders();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Sayfa her odaklandığında listeyi otomatik günceller
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

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    String? userId;

    if (authState is AuthSuccessState) {
      userId = authState.userId;
    }

    if (userId == null || userId.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Kullanıcı bilgisi bulunamadı. Lütfen tekrar giriş yapın.',
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Geçmiş Taleplerim'),
        actions: [
          // Listeyi manuel yenilemek için opsiyonel buton
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
              return const Center(
                child: Text(
                  'Henüz verilmiş bir talep bulunmuyor.',
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
                      'Sipariş ID: #${order.id}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          'Adres: ${order.address}',
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tutar: ${order.totalAmount.toStringAsFixed(2)} ₺',
                          style: const TextStyle(
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    trailing: Chip(
                      label: Text(
                        order.status,
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
                'Hata: ${state.message}',
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
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