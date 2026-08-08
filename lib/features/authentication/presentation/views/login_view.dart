import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../app/router/route_paths.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  // E-posta ve şifre alanlarını okumak için controller'lar
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Eczane Giriş Paneli')),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccessState) {

            print(state.userId);
            print(state.email);
            print(state.name);

            ScaffoldMessenger.of(context).showSnackBar(

              const SnackBar(

                content: Text("Giriş başarılı"),

              ),

            );

            context.go(RoutePaths.home);

          } else if (state is AuthErrorState) {
            // Hata olursa kullanıcıya bildir
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Hata: ${state.message}')),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'E-posta'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Şifre'),
              ),
              const SizedBox(height: 24),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthLoadingState) {
                    return const CircularProgressIndicator();
                  }
                  return ElevatedButton(
                    onPressed: () {
                      // Bloc üzerinden giriş isteğini tetikliyoruz
                      final email = _emailController.text.trim();
                      final password = _passwordController.text.trim();

                      if (email.isNotEmpty && password.isNotEmpty) {
                        BlocProvider.of<AuthBloc>(context).add(
                          LoginRequestedEvent(email: email, password: password),
                        );
                      } else {
                        // Eğer boş bırakıldıysa test amaçlı direkt geçiş yapabilmesi için
                        // veya hata göstermek için:
                        BlocProvider.of<AuthBloc>(context).add(
                          LoginRequestedEvent(email: "merve@gmail.com", password: "123"),
                        );
                      }
                    },
                    child: const Text('Giriş Yap'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}