import 'package:dnd_project/domain/models/user.dart';

/// Абстрактный контракт репозитория авторизации.
/// Говорит на языке предметной области и не зависит от Dio/Hive/Flutter.
abstract class AuthRepository {
  Future<User> login({
    required String email,
    required String password,
  });

  Future<User> register({
    required String username,
    required String email,
    required String password,
  });

  Future<void> logout();
}


