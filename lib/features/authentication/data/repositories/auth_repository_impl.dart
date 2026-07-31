import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;

  AuthRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, UserEntity>> login(String email, String password) async {
    try {
      // Datasource'dan UserModel çekilir
      final userModel = await remoteDatasource.login(email, password);

      // Model, Entity'ye dönüştürülüp döndürülür (Mapper ile veya doğrudan extends ile)
      return Right(userModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Ağ bağlantı hatası'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      // Çıkış işlemleri (token silme vb.) buraya eklenebilir
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Ağ bağlantı hatası'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}