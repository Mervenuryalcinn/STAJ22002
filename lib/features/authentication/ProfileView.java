package features.authentication;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_paths.dart';
import '../../../favorites/presentation/views/favorites_view.dart';
import '../../../../main.dart'; // ThemeCubit için import

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kullanıcı Profili'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Kullanıcı Bilgi Kartı
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Text(
              'Merve Yalçın',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'merve@example.com',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),

            // Menü Seçenekleri
            ListTile(
              leading: const Icon(Icons.shopping_bag, color: Colors.blue),
              title: const Text('Geçmiş Taleplerim / Siparişlerim'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                context.push('/orders');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.favorite, color: Colors.red),
              title: const Text('Favori Ürün ve Eczanelerim'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FavoritesView(),
                  ),
                );
              },
            ),
            const Divider(),
            
            // Karanlık Tema Switch Alanı (BlocBuilder ile güvenli senkronizasyon)
            BlocBuilder<ThemeCubit, bool>(
              builder: (context, isDarkMode) {
                return ListTile(
                  leading: const Icon(Icons.dark_mode, color: Colors.indigo),
                  title: const Text('Karanlık Tema (Dark Mode)'),
                  trailing: Switch(
                    value: isDarkMode,
                    onChanged: (value) {
                      context.read<ThemeCubit>().toggleTheme(value);
                    },
                  ),
                );
              },
            ),
            
            const Spacer(),

            // Çıkış Yap Butonu
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                ),
                icon: const Icon(Icons.logout),
                label: const Text('Çıkış Yap', style: TextStyle(fontSize: 16)),
                onPressed: () {
                  context.go(RoutePaths.login);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}