import 'package:dnd_project/data/datasources/auth_remote_data_source.dart';
import 'package:dnd_project/domain/models/user.dart';
import 'package:dnd_project/domain/repositories/auth_repository.dart';

/// Реализация [AuthRepository], инкапсулирующая работу с источниками данных.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<User> login({
    required String email,
    required String password,
  }) async {
    final data = await _remoteDataSource.login(
      email: email,
      password: password,
    );

    return User(
      id: data['id'] as String,
      email: data['email'] as String,
      name: data['name'] as String,
    );
  }

  @override
  Future<User> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final data = await _remoteDataSource.register(
      username: username,
      email: email,
      password: password,
    );

    return User(
      id: data['id'] as String,
      email: data['email'] as String,
      name: data['name'] as String,
    );
  }

  @override
  Future<void> logout() {
    return _remoteDataSource.logout();
  }
}


