import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:lideatech_pharmacy_app/l10n/app_localizations.dart';

class PharmacyRegisterView extends StatefulWidget {
  const PharmacyRegisterView({super.key});

  @override
  State<PharmacyRegisterView> createState() => _PharmacyRegisterViewState();
}

class _PharmacyRegisterViewState extends State<PharmacyRegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _pharmacistNameController = TextEditingController();
  final _diplomaNoController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _latitudeController = TextEditingController(text: '36.4900');
  final _longitudeController = TextEditingController(text: '36.3600');

  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _nameController.dispose();
    _pharmacistNameController.dispose();
    _diplomaNoController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  Future<void> _registerPharmacy() async {
    if (!_formKey.currentState!.validate()) return;

    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:8000'));

      // Veritabanındaki tüm sütunlarla tam uyumlu veri yapısı
      final response = await dio.post(
        '/pharmacy/register',
        data: {
          'eczane_ad': _nameController.text.trim(),
          'eczaci_ad_soyad': _pharmacistNameController.text.trim(),
          'eczaci_diploma_no': int.tryParse(_diplomaNoController.text.trim()) ?? 0,
          'email': _emailController.text.trim(),
          'sifre': _passwordController.text.trim(),
          'telefon': _phoneController.text.trim(),
          'adres': _addressController.text.trim(),
          'latitude': double.tryParse(_latitudeController.text.trim()) ?? 36.49,
          'longitude': double.tryParse(_longitudeController.text.trim()) ?? 36.36,
        },
      );

      if (!mounted) return;

      if (response.data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.registerSuccess),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.pharmacyRegisterTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.local_pharmacy_rounded,
                    size: 70,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.pharmacyRegisterTitle,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Eczane Adı
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: l10n.pharmacyName,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.store),
                    ),
                    validator: (value) => value == null || value.trim().isEmpty ? l10n.pharmacyNameEmptyError : null,
                  ),
                  const SizedBox(height: 16),

                  // Eczacı Adı Soyadı
                  TextFormField(
                    controller: _pharmacistNameController,
                    decoration: const InputDecoration(
                      labelText: 'Eczacı Adı Soyadı',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) => value == null || value.trim().isEmpty ? 'Eczacı adı boş bırakılamaz' : null,
                  ),
                  const SizedBox(height: 16),

                  // Diploma Numarası
                  TextFormField(
                    controller: _diplomaNoController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Diploma Numarası',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.badge),
                    ),
                    validator: (value) => value == null || value.trim().isEmpty ? 'Diploma numarası boş bırakılamaz' : null,
                  ),
                  const SizedBox(height: 16),

                  // E-posta
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: l10n.pharmacyEmail,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.email),
                    ),
                    validator: (value) => value == null || value.trim().isEmpty ? l10n.emailEmptyError : null,
                  ),
                  const SizedBox(height: 16),

                  // Şifre
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: l10n.password,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return l10n.passwordEmptyError;
                      if (value.trim().length < 6) return l10n.passwordLengthError;
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Telefon
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: l10n.phone,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.phone),
                    ),
                    validator: (value) => value == null || value.trim().isEmpty ? l10n.phoneEmptyError : null,
                  ),
                  const SizedBox(height: 16),

                  // Adres
                  TextFormField(
                    controller: _addressController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: l10n.address,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.location_on),
                    ),
                    validator: (value) => value == null || value.trim().isEmpty ? l10n.addressEmptyError : null,
                  ),
                  const SizedBox(height: 16),

                  // Latitude & Longitude Yan Yana Alanlar
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _latitudeController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(
                            labelText: 'Latitude (Enlem)',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.map),
                          ),
                          validator: (value) => value == null || value.trim().isEmpty ? 'Boş olamaz' : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _longitudeController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(
                            labelText: 'Longitude (Boylam)',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.map_outlined),
                          ),
                          validator: (value) => value == null || value.trim().isEmpty ? 'Boş olamaz' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  if (_errorMessage.isNotEmpty)
                    Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  const SizedBox(height: 20),

                  // Kayıt Ol Butonu
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _isLoading ? null : _registerPharmacy,
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                        l10n.registerPharmacyButton,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}