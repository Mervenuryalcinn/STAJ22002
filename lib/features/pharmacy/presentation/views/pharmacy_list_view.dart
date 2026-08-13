import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/utils/location_service.dart';
import '../bloc/pharmacy_bloc.dart';
import '../bloc/pharmacy_event.dart';
import '../bloc/pharmacy_state.dart';
import 'package:lideatech_pharmacy_app/l10n/app_localizations.dart';

class PharmacyListView extends StatefulWidget {
  const PharmacyListView({super.key});

  @override
  State<PharmacyListView> createState() => _PharmacyListViewState();
}

class _PharmacyListViewState extends State<PharmacyListView> {
  bool _isDutyOnly = true;

  @override
  void initState() {
    super.initState();
    // Sayfa ilk açıldığında render motorunun tamamlanmasını bekleyip otomatik GPS çağrısı yapıyoruz
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchPharmaciesByGPS();
    });
  }

  Future<void> _fetchPharmaciesByGPS() async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;

    try {
      final position = await LocationService.getCurrentLocation().timeout(
        const Duration(seconds: 10),
        onTimeout: () => null,
      );

      if (!mounted) return;

      if (position == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.locationError),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        return;
      }

      context.read<PharmacyBloc>().add(
        FetchPharmaciesByLocationEvent(
          lat: position.latitude,
          lng: position.longitude,
          isDuty: _isDutyOnly,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${l10n.error}: $e'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          _isDutyOnly ? l10n.dutyPharmacies : l10n.allPharmacies,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black87),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location_rounded),
            onPressed: _fetchPharmaciesByGPS,
            tooltip: l10n.updateLocation,
          ),
        ],
      ),
      body: Column(
        children: [
          // --- ÜST FİLTRE ALANI ---
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (_isDutyOnly) return;
                        setState(() => _isDutyOnly = true);
                        _fetchPharmaciesByGPS();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _isDutyOnly ? Colors.green : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          l10n.dutyPharmacies,
                          style: TextStyle(
                            color: _isDutyOnly
                                ? Colors.white
                                : (isDark ? Colors.grey.shade400 : Colors.black54),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (!_isDutyOnly) return;
                        setState(() => _isDutyOnly = false);
                        _fetchPharmaciesByGPS();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: !_isDutyOnly ? Colors.green : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          l10n.allPharmacies,
                          style: TextStyle(
                            color: !_isDutyOnly
                                ? Colors.white
                                : (isDark ? Colors.grey.shade400 : Colors.black54),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- LİSTE ALANI ---
          Expanded(
            child: BlocBuilder<PharmacyBloc, PharmacyState>(
              builder: (context, state) {
                if (state is PharmacyInitial || state is PharmacyLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is PharmacyLoaded) {
                  if (state.pharmacies.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                          _isDutyOnly
                              ? l10n.noDutyPharmaciesFound
                              : l10n.noAllPharmaciesFound,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isDark ? Colors.grey.shade400 : Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: state.pharmacies.length,
                    itemBuilder: (context, index) {
                      final pharmacy = state.pharmacies[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(isDark ? 0.3 : 0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () async {
                              final query = Uri.encodeComponent('${pharmacy.name} ${pharmacy.address}');
                              final googleMapsUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');

                              if (await canLaunchUrl(googleMapsUrl)) {
                                await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
                              } else {
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(l10n.mapOpenError)),
                                );
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: isDark ? Colors.green.shade900.withOpacity(0.4) : Colors.green.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.local_pharmacy_rounded,
                                      color: _isDutyOnly ? Colors.green : Colors.blue,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                pharmacy.name,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: isDark ? Colors.white : Colors.black87,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: _isDutyOnly ? Colors.green.shade100 : Colors.blue.shade100,
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                _isDutyOnly ? l10n.duty : l10n.open,
                                                style: TextStyle(
                                                  color: _isDutyOnly ? Colors.green.shade800 : Colors.blue.shade800,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 11,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          pharmacy.address,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade500,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '${l10n.phone}: ${pharmacy.phone}',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: isDark ? Colors.grey.shade300 : Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Text(
                                              l10n.mapTouchInstruction,
                                              style: const TextStyle(
                                                color: Colors.blue,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            const Icon(Icons.location_pin, color: Colors.red, size: 14),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }

                if (state is PharmacyError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(
                        '${l10n.error}: ${state.message}',
                        style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}