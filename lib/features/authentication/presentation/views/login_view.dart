import 'package:flutter/material.dart';
import '../../../../../app/router/route_paths.dart';
import 'package:go_router/go_router.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Eczane Giriş Paneli')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const TextField(
              decoration: InputDecoration(labelText: 'E-posta'),
            ),
            const SizedBox(height: 12),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: 'Şifre'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Giriş başarılı simülasyonu ile ana sayfaya yönlendir
                context.go(RoutePaths.home);
              },
              child: const Text('Giriş Yap'),
            ),
          ],
        ),
      ),
    );
  }
}