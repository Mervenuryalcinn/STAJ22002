import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:lideatech_pharmacy_app/l10n/app_localizations.dart';

class PharmacyOrderDetailView extends StatefulWidget {
  final int orderId;

  const PharmacyOrderDetailView({super.key, required this.orderId});

  @override
  State<PharmacyOrderDetailView> createState() => _PharmacyOrderDetailViewState();
}

class _PharmacyOrderDetailViewState extends State<PharmacyOrderDetailView> {
  bool _isLoading = true;
  Map<String, dynamic>? _orderDetail;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchOrderDetail();
    });
  }

  Future<void> _fetchOrderDetail() async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final dio = Dio(BaseOptions(
        baseUrl: 'http://10.0.2.2:8000',
        connectTimeout: const Duration(seconds: 5), // 5 saniyeden uzun sürerse hata versin, donmasın
        receiveTimeout: const Duration(seconds: 5),
      ));

      print('🔍 İSTEK ATILIYOR: /orders/${widget.orderId}');
      final response = await dio.get('/orders/${widget.orderId}');
      print('📦 YANIT GELDİ: ${response.data}');

      if (!mounted) return;

      if (response.data['success'] == true) {
        setState(() {
          _orderDetail = response.data['result'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = response.data['message'] ?? l10n.error;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('❌ DETAY ÇEKME HATASI: $e');
      if (!mounted) return;
      setState(() {
        _errorMessage = '${l10n.error}: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _updateStatus(String newStatus) async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    try {
      final dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:8000'));
      final response = await dio.put(
        '/orders/${widget.orderId}/status',
        data: {'status': newStatus},
      );

      if (!mounted) return;

      if (response.data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.statusUpdated} ("$newStatus")')),
        );
        _fetchOrderDetail();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.error}: ${response.data['message']}')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${l10n.error}: $e')),
      );
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase().trim()) {
      case 'talep alındı':
      case 'pending':
        return Colors.orange;
      case 'hazırlanıyor':
      case 'preparing':
        return Colors.blue;
      case 'yola çıktı':
      case 'on the way':
        return Colors.purple;
      case 'tamamlandı':
      case 'completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text('${l10n.orderDetailTitle} #${widget.orderId}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Yenile',
            onPressed: _fetchOrderDetail,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 12),
              Text(_errorMessage, textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _fetchOrderDetail,
                icon: const Icon(Icons.refresh),
                label: Text(l10n.retry),
              ),
            ],
          ),
        ),
      )
          : _orderDetail == null
          ? Center(child: Text(l10n.noProductsFound))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.currentStatus, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Chip(
                  label: Text(
                    _orderDetail!['status'] ?? 'Talep Alındı',
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: _getStatusColor(_orderDetail!['status'] ?? ''),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text('${l10n.pharmacyProducts.substring(0, 7)}: ${_orderDetail!['pharmacy_name'] ?? ''}'),
            Text('${l10n.totalAmount}: ${_orderDetail!['total_amount']} ₺', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
            Text('${l10n.date}: ${_orderDetail!['created_at']}'),
            const Divider(height: 30),

            Text(
              l10n.requestedProducts,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 10),
            ...((_orderDetail!['items'] as List<dynamic>? ?? []).map((item) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const Icon(Icons.medication, color: Colors.green),
                title: Text(item['product_name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${l10n.unitPrice}: ${item['unit_price']} ₺'),
                trailing: Text('${item['quantity']} ${l10n.units}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ),
            ))),

            const Divider(height: 30),
            Text(
              l10n.updateOrderStatus,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 12),
            Column(
              children: [
                _buildActionButton('Talep Alındı', Colors.orange, l10n),
                const SizedBox(height: 8),
                _buildActionButton('Hazırlanıyor', Colors.blue, l10n),
                const SizedBox(height: 8),
                _buildActionButton('Yola Çıktı', Colors.purple, l10n),
                const SizedBox(height: 8),
                _buildActionButton('Tamamlandı', Colors.green, l10n),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String statusName, Color color, AppLocalizations l10n) {
    bool isSelected = (_orderDetail!['status'] ?? '').toLowerCase().trim() == statusName.toLowerCase().trim();

    return SizedBox(
      width: double.infinity,
      child: isSelected
          ? ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white),
        onPressed: () {},
        child: Text('$statusName (${l10n.active})'),
      )
          : OutlinedButton(
        style: OutlinedButton.styleFrom(foregroundColor: color, side: BorderSide(color: color)),
        onPressed: () => _updateStatus(statusName),
        child: Text(statusName),
      ),
    );
  }
}