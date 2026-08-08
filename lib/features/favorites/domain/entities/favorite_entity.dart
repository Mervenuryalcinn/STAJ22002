class FavoriteEntity {
  final String id;
  final String title;
  final String type; // Örn: 'product' veya 'pharmacy'

  const FavoriteEntity({
    required this.id,
    required this.title,
    required this.type,
  });
}