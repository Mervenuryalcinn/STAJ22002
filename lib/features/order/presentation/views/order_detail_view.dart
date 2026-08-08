import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/order_bloc.dart';
import '../bloc/order_event.dart';
import '../bloc/order_state.dart';

class OrderDetailView extends StatelessWidget {
  final String orderId;

  const OrderDetailView({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    // Belirli bir siparişin detayını yükle
    context.read<OrderBloc>().add(LoadOrderDetailEvent(orderId: orderId));

    return Scaffold(
      appBar: AppBar(
        title: Text('Sipariş Takibi #$orderId'),
        // Sol üst köşeye şık ve garantili geri dönüş butonu eklendi:
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
      ),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OrderDetailLoadedState) {
            final order = state.order;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Teslimat Adresi:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
                  Text(order.address, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 16),
                  Text('Toplam Tutar: ${order.totalAmount.toStringAsFixed(2)} ₺', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  const Text(
                    'Talep Edilen Ürünler',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...order.items.map((item) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const Icon(Icons.medication, color: Colors.green),
                      title: Text(item.productName),
                      trailing: Text('${item.quantity} Adet', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  )),
                  const Text('Sipariş Durumu Adımları', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),

                  // Görsel Adım Takip Bileşeni (Stepleneer Mantığı)
                  Expanded(
                    child: ListView(
                      children: [
                        _buildStepItem('Talep Alındı', 'Eczaneniz talebinizi incelemeye aldı.', true),
                        _buildStepItem('Hazırlanıyor', 'İlaçlarınız eczacı tarafından hazırlanıyor.', _isStepActive(order.status, 'Hazırlanıyor')),
                        _buildStepItem('Yola Çıktı / Hazır', 'Kurye yola çıktı veya eczaneden teslim alabilirsiniz.', _isStepActive(order.status, 'Yola Çıktı')),
                        _buildStepItem('Tamamlandı', 'Sipariş başarıyla sonuçlandı.', _isStepActive(order.status, 'Tamamlandı')),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (state is OrderErrorState) {
            return Center(child: Text('Hata: ${state.message}'));
          }
          return const Center(child: Text('Bilgiler yükleniyor...'));
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