import 'package:dnd_project/data/datasources/auth_remote_data_source.dart';
import 'package:dnd_project/data/datasources/local/auth_local_data_source.dart';
import 'package:dnd_project/domain/models/user.dart';
import 'package:dnd_project/domain/repositories/auth_repository.dart';

/// Реализация [AuthRepository], инкапсулирующая работу с источниками данных.
/// Использует SharedPreferences для нечувствительных данных и Flutter Secure Storage для токена.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  @override
  Future<User> login({
    required String email,
    required String password,
  }) async {
    // Выполняем авторизацию через удалённый источник
    final data = await _remoteDataSource.login(
      email: email,
      password: password,
    );

    final user = User(
      id: data['id'] as String,
      email: data['email'] as String,
      name: data['name'] as String,
    );

    // Получаем токен из ответа сервера
    final token = data['token'] as String?;

    // Сохраняем сессию в локальное хранилище:
    // - Нечувствительные данные (user) в SharedPreferences
    // - Токен в Flutter Secure Storage (зашифрованное хранилище)
    await _localDataSource.saveUserSession(user, token: token);

    return user;
  }

  @override
  Future<User> register({
    required String username,
    required String email,
    required String password,
  }) async {
    // Выполняем регистрацию через удалённый источник
    final data = await _remoteDataSource.register(
      username: username,
      email: email,
      password: password,
    );

    final user = User(
      id: data['id'] as String,
      email: data['email'] as String,
      name: data['name'] as String,
    );

    // Получаем токен из ответа сервера
    final token = data['token'] as String?;

    // Сохраняем сессию в локальное хранилище:
    // - Нечувствительные данные (user) в SharedPreferences
    // - Токен в Flutter Secure Storage (зашифрованное хранилище)
    await _localDataSource.saveUserSession(user, token: token);

    return user;
  }

  @override
  Future<void> logout() async {
    // Очищаем локальную сессию
    await _localDataSource.clearUserSession();
    // Выполняем логаут на сервере (если требуется)
    await _remoteDataSource.logout();
  }

  /// Получение сохранённой сессии пользователя (для восстановления после перезапуска)
  Future<User?> getSavedSession() async {
    return await _localDataSource.getSavedUserSession();
  }

  /// Получение токена авторизации из Secure Storage
  Future<String?> getAuthToken() async {
    return await _localDataSource.getAuthToken();
  }
}


