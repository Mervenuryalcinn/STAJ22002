import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'pharmacy_dashboard_view.dart';
import 'pharmacy_register_view.dart';
import 'package:lideatech_pharmacy_app/l10n/app_localizations.dart';
import '../../../../core/widgets/app_logo.dart';

class PharmacyLoginView extends StatefulWidget {
  const PharmacyLoginView({super.key});

  @override
  State<PharmacyLoginView> createState() => _PharmacyLoginViewState();
}

class _PharmacyLoginViewState extends State<PharmacyLoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loginPharmacy() async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:8000'));
      final response = await dio.post(
        '/pharmacy/login',
        data: {
          'email': _emailController.text.trim(),
          'sifre': _passwordController.text.trim(),
        },
      );

      if (!mounted) return;

      if (response.data['success'] == true) {
        final pharmacyData = response.data['pharmacy'];
        final int pharmacyId = pharmacyData['eczane_id'];
        // Dashboard ekranı açıldıktan sonra kendi içinde verileri hızlıca yüklemek için
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PharmacyDashboardView(
              pharmacyId: pharmacyId,
              initialOrders: const [],
            ),
          ),
        );
      } else {
        setState(() {
          _errorMessage = response.data['message'] ?? l10n.error;
          _isLoading = false; // Hata durumunda yüklenme durumu kapatılıyor
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = '${l10n.error}: $e';
        _isLoading = false; // Exception durumunda yüklenme durumu kapatılıyor
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          l10n.pharmacyStaffLoginTitle,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black87),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Ortak Logo Bileşeni Entegrasyonu
                const Center(
                  child: AppLogo(size: 84),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.pharmacyManagementPanel,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _emailController,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                  decoration: InputDecoration(
                    labelText: l10n.pharmacyEmail,
                    prefixIcon: const Icon(Icons.email_outlined, color: Colors.green),
                    filled: true,
                    fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                  decoration: InputDecoration(
                    labelText: l10n.password,
                    prefixIcon: const Icon(Icons.lock_outline, color: Colors.green),
                    filled: true,
                    fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                if (_errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Text(
                      _errorMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
                    ),
                  ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 54,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: _isLoading ? null : _loginPharmacy,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                      l10n.loginButton,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.pharmacyNoAccount,
                      style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PharmacyRegisterView(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(foregroundColor: Colors.green),
                      child: Text(
                        l10n.pharmacyRegisterButton,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}