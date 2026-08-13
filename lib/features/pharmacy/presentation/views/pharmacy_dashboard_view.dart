import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'pharmacy_order_detail_view.dart';
import 'package:lideatech_pharmacy_app/l10n/app_localizations.dart';

class PharmacyDashboardView extends StatefulWidget {
  final int pharmacyId;
  final List<dynamic>? initialOrders; // Arka planda önceden yüklenmiş siparişler

  const PharmacyDashboardView({
    super.key,
    required this.pharmacyId,
    this.initialOrders,
  });

  @override
  State<PharmacyDashboardView> createState() => _PharmacyDashboardViewState();
}

class _PharmacyDashboardViewState extends State<PharmacyDashboardView> {
  bool _isLoading = true;
  List<dynamic> _orders = [];
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();

    // Eğer giriş ekranından hazır veri geldiyse direkt göster, gelmediyse güvenli bir şekilde çağır
    if (widget.initialOrders != null && widget.initialOrders!.isNotEmpty) {
      _orders = widget.initialOrders!;
      _isLoading = false;
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fetchPharmacyOrders();
      });
    }
  }

  Future<void> _fetchPharmacyOrders() async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final dio = Dio(BaseOptions(
        baseUrl: 'http://10.0.2.2:8000',
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
      ));

      final response = await dio.get('/pharmacies/${widget.pharmacyId}/orders');

      if (!mounted) return;

      if (response.data['success'] == true) {
        setState(() {
          _orders = response.data['result'] ?? [];
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = response.data['message'] ?? l10n.error;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = '${l10n.error}: $e';
        _isLoading = false;
      });
    }
  }

  // Backend'den gelen statüleri dile göre çeviren fonksiyon
  String _getTranslatedStatus(BuildContext context, String status) {
    final l10n = AppLocalizations.of(context)!;
    switch (status.toLowerCase().trim()) {
      case 'talep alındı':
      case 'pending':
        return l10n.step1Title;
      case 'hazırlanıyor':
      case 'preparing':
        return l10n.step2Title;
      case 'yola çıktı':
      case 'on the way':
        return l10n.step3Title;
      case 'tamamlandı':
      case 'completed':
        return l10n.step4Title;
      default:
        return status;
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
        title: Text(l10n.pharmacyManagementPanel),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l10n.refresh,
            onPressed: _fetchPharmacyOrders,
          ),
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 12),
              Text(
                _errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _fetchPharmacyOrders,
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
      );
    }

    if (_orders.isEmpty) {
      return Center(
        child: Text(
          l10n.noPharmacyOrders,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: _orders.length,
      padding: const EdgeInsets.all(12),
      itemBuilder: (context, index) {
        final order = _orders[index];
        final currentStatus = order['status'] ?? 'Talep Alındı';

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${l10n.orderId}: #${order['id']}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Chip(
                      label: Text(
                        _getTranslatedStatus(context, currentStatus),
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: _getStatusColor(currentStatus),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('${l10n.patientTckn}: ${order['user_id']}'),
                Text(
                  '${l10n.totalAmount}: ${order['total_amount']} ₺',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text('${l10n.date}: ${order['created_at']}'),
                const Divider(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade50,
                      foregroundColor: Colors.blue.shade800,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.visibility),
                    label: Text(l10n.viewAndManageOrderDetails),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PharmacyOrderDetailView(
                            orderId: int.parse(order['id'].toString()),
                          ),
                        ),
                      );
                      _fetchPharmacyOrders();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}