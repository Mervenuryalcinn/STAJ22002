import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.tckn,
    required super.email,
    required super.name,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',

      tckn: json['tckn']?.toString() ??
          json['hasta_tckn']?.toString() ??
          json['id']?.toString() ??
          '',

      email: json['email']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tckn': tckn,
      'email': email,
      'name': name,
    };
  }
}