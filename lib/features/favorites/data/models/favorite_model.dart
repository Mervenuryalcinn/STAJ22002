import '../../domain/entities/favorite_entity.dart';
class FavoriteModel extends FavoriteEntity {
  const FavoriteModel({
    required super.id,
    required super.title,
    required super.type,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      id: json['id'],
      title: json['title'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type,
    };
  }
}