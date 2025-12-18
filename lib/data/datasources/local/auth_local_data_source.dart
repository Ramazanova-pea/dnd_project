import 'package:dnd_project/data/datasources/local/shared_preferences_data_source.dart';
import 'package:dnd_project/domain/models/user.dart';

/// Локальный источник данных для авторизации.
/// Использует SharedPreferences для сохранения сессии пользователя между запусками приложения.
class AuthLocalDataSource {
  AuthLocalDataSource({
    required SharedPreferencesDataSource sharedPrefs,
  }) : _sharedPrefs = sharedPrefs;

  final SharedPreferencesDataSource _sharedPrefs;

  // Ключи для хранения данных авторизации
  static const String _keyUserId = 'auth_user_id';
  static const String _keyUserEmail = 'auth_user_email';
  static const String _keyUserName = 'auth_user_name';
  static const String _keyIsAuthenticated = 'auth_is_authenticated';
  static const String _keyAuthToken = 'auth_token'; // Для будущего использования

  /// Сохранение данных пользователя после успешной авторизации
  Future<void> saveUserSession(User user, {String? token}) async {
    await Future.wait([
      _sharedPrefs.setString(_keyUserId, user.id),
      _sharedPrefs.setString(_keyUserEmail, user.email),
      _sharedPrefs.setString(_keyUserName, user.name),
      _sharedPrefs.setBool(_keyIsAuthenticated, true),
      if (token != null) _sharedPrefs.setString(_keyAuthToken, token),
    ]);
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

  /// Получение токена авторизации (если сохранён)
  Future<String?> getAuthToken() async {
    return await _sharedPrefs.getString(_keyAuthToken);
  }

  /// Очистка данных сессии при выходе из системы
  Future<void> clearUserSession() async {
    await Future.wait([
      _sharedPrefs.removeValue(_keyUserId),
      _sharedPrefs.removeValue(_keyUserEmail),
      _sharedPrefs.removeValue(_keyUserName),
      _sharedPrefs.removeValue(_keyIsAuthenticated),
      _sharedPrefs.removeValue(_keyAuthToken),
    ]);
  }

  /// Проверка, есть ли сохранённая сессия
  Future<bool> hasSavedSession() async {
    return await _sharedPrefs.getBoolOrDefault(_keyIsAuthenticated, false);
  }
}

