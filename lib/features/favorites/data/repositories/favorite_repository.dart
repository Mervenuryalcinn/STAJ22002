import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/favorite_entity.dart';

abstract class FavoriteRepository {
  Future<List<FavoriteEntity>> getFavorites();
  Future<void> toggleFavorite(FavoriteEntity item);
  Future<bool> isFavorite(String id);
}

class FavoriteRepositoryImpl implements FavoriteRepository {
  static const String _storageKey = 'offline_favorites_key';

  @override
  Future<List<FavoriteEntity>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_storageKey);
    if (jsonString == null) return [];

    final List<dynamic> decoded = jsonDecode(jsonString);
    return decoded.map((item) => FavoriteEntity(
      id: item['id'],
      title: item['title'],
      type: item['type'],
    )).toList();
  }

  @override
  Future<void> toggleFavorite(FavoriteEntity item) async {
    final prefs = await SharedPreferences.getInstance();
    final currentFavorites = await getFavorites();

    final exists = currentFavorites.any((fav) => fav.id == item.id);
    if (exists) {
      currentFavorites.removeWhere((fav) => fav.id == item.id);
    } else {
      currentFavorites.add(item);
    }

    final encoded = jsonEncode(currentFavorites.map((fav) => {
      'id': fav.id,
      'title': fav.title,
      'type': fav.type,
    }).toList());

    await prefs.setString(_storageKey, encoded);
  }

  @override
  Future<bool> isFavorite(String id) async {
    final currentFavorites = await getFavorites();
    return currentFavorites.any((fav) => fav.id == id);
  }
}