import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/favorite_bloc.dart';
import '../bloc/favorite_event.dart';
import '../bloc/favorite_state.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favori Eczane ve Ürünlerim'),
      ),
      body: BlocBuilder<FavoriteBloc, FavoriteState>(
        builder: (context, state) {
          if (state is FavoriteLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FavoritesLoadedState) {
            if (state.favorites.isEmpty) {
              return const Center(child: Text('Henüz favoriye eklenen öğe yok.'));
            }

            return ListView.builder(
              itemCount: state.favorites.length,
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final fav = state.favorites[index];
                return Card(
                  child: ListTile(
                    leading: Icon(
                      fav.type == 'pharmacy' ? Icons.local_pharmacy : Icons.medical_services,
                      color: Colors.blue,
                    ),
                    title: Text(fav.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Tür: ${fav.type.toUpperCase()}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        context.read<FavoriteBloc>().add(ToggleFavoriteEvent(favorite: fav));
                      },
                    ),
                  ),
                );
              },
            );
          } else if (state is FavoriteErrorState) {
            return Center(child: Text('Hata: ${state.message}'));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}