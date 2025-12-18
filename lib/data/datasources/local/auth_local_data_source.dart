import 'package:dnd_project/data/datasources/local/shared_preferences_data_source.dart';
import 'package:dnd_project/data/datasources/local/secure_storage_data_source.dart';
import 'package:dnd_project/domain/models/user.dart';

/// Локальный источник данных для авторизации.
/// Использует SharedPreferences для нечувствительных данных (userId, email, name, флаги)
/// и Flutter Secure Storage для чувствительных данных (токен авторизации).
/// 
/// Согласно методичке "Практическая работа 12.pdf":
/// - SharedPreferences: для нечувствительных данных, которые часто используются
/// - Flutter Secure Storage: для конфиденциальной информации (токены), требующей шифрования
class AuthLocalDataSource {
  AuthLocalDataSource({
    required SharedPreferencesDataSource sharedPrefs,
    required SecureStorageDataSource secureStorage,
  })  : _sharedPrefs = sharedPrefs,
        _secureStorage = secureStorage;

  final SharedPreferencesDataSource _sharedPrefs;
  final SecureStorageDataSource _secureStorage;

  // Ключи для хранения данных авторизации в SharedPreferences (нечувствительные данные)
  static const String _keyUserId = 'auth_user_id';
  static const String _keyUserEmail = 'auth_user_email';
  static const String _keyUserName = 'auth_user_name';
  static const String _keyIsAuthenticated = 'auth_is_authenticated';

  // Ключ для хранения токена в Flutter Secure Storage (чувствительные данные)
  static const String _keyAuthToken = 'auth_token';

  /// Сохранение данных пользователя после успешной авторизации
  /// Токен сохраняется в Secure Storage, остальные данные - в SharedPreferences
  Future<void> saveUserSession(User user, {String? token}) async {
    // Сохраняем нечувствительные данные в SharedPreferences
    await Future.wait([
      _sharedPrefs.setString(_keyUserId, user.id),
      _sharedPrefs.setString(_keyUserEmail, user.email),
      _sharedPrefs.setString(_keyUserName, user.name),
      _sharedPrefs.setBool(_keyIsAuthenticated, true),
    ]);

    // Сохраняем токен в Secure Storage (если передан)
    if (token != null) {
      await _secureStorage.write(_keyAuthToken, token);
    }
  }

  /// Получение сохранённой сессии пользователя
  Future<User?> getSavedUserSession() async {
    final isAuthenticated = await _sharedPrefs.getBoolOrDefault(
      _keyIsAuthenticated,
      false,
    );

    if (!isAuthenticated) {
      return null;
    }

    final userId = await _sharedPrefs.getString(_keyUserId);
    final userEmail = await _sharedPrefs.getString(_keyUserEmail);
    final userName = await _sharedPrefs.getString(_keyUserName);

    if (userId == null || userEmail == null || userName == null) {
      return null;
    }

    return User(
      id: userId,
      email: userEmail,
      name: userName,
    );
  }

  /// Получение токена авторизации из Secure Storage
  Future<String?> getAuthToken() async {
    return await _secureStorage.read(_keyAuthToken);
  }

  /// Очистка данных сессии при выходе из системы
  /// Удаляет данные из обоих хранилищ
  Future<void> clearUserSession() async {
    // Очищаем нечувствительные данные из SharedPreferences
    await Future.wait([
      _sharedPrefs.removeValue(_keyUserId),
      _sharedPrefs.removeValue(_keyUserEmail),
      _sharedPrefs.removeValue(_keyUserName),
      _sharedPrefs.removeValue(_keyIsAuthenticated),
    ]);

    // Очищаем токен из Secure Storage
    await _secureStorage.delete(_keyAuthToken);
  }

  /// Проверка, есть ли сохранённая сессия
  Future<bool> hasSavedSession() async {
    return await _sharedPrefs.getBoolOrDefault(_keyIsAuthenticated, false);
  }

  /// Проверка наличия токена в Secure Storage
  Future<bool> hasAuthToken() async {
    final token = await _secureStorage.read(_keyAuthToken);
    return token != null && token.isNotEmpty;
  }
}

