import 'package:flutter/material.dart';
import 'package:lideatech_pharmacy_app/main.dart';

class LanguageBottomSheet extends StatelessWidget {
  const LanguageBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => const LanguageBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Şu anki aktif dili öğreniyoruz
    final currentLocale = Localizations.localeOf(context);
    final isTurkish = currentLocale.languageCode == 'tr';

    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Üst tutamaç çizgisi (Modern UI standardı)
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Text(
            'Dil Seçin / Choose Language',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Türkçe Seçeneği
          _buildLanguageTile(
            context,
            title: 'Türkçe',
            flag: '🇹🇷',
            locale: const Locale('tr'),
            isSelected: isTurkish,
            successMessage: 'Dil Türkçe olarak seçildi.',
          ),

          const SizedBox(height: 12),

          // İngilizce Seçeneği
          _buildLanguageTile(
            context,
            title: 'English',
            flag: '🇬🇧',
            locale: const Locale('en'),
            isSelected: !isTurkish,
            successMessage: 'Language changed to English.',
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildLanguageTile(
      BuildContext context, {
        required String title,
        required String flag,
        required Locale locale,
        required bool isSelected,
        required String successMessage,
      }) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.shade50 : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected ? Colors.blue : Colors.grey.shade200,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: ListTile(
        leading: Text(flag, style: const TextStyle(fontSize: 24)),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.blue.shade800 : Colors.black87,
          ),
        ),
        trailing: isSelected
            ? const Icon(Icons.check_circle, color: Colors.blue)
            : const Icon(Icons.circle_outlined, color: Colors.grey),
        onTap: () {
          MyApp.setLocale(context, locale);
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(successMessage),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.blue.shade800,
            ),
          );
        },
      ),
    );
  }
}