import 'dart:async';

/// Заглушка удалённого источника данных для авторизации.
/// На данном этапе имитирует сетевые вызовы, позже можно заменить на реальный API.
class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    // TODO: Заменить на реальный вызов API (например, через Dio).
    await Future.delayed(const Duration(seconds: 1));

    if (email.isEmpty || password.isEmpty) {
      throw Exception('Неверные учетные данные');
    }

    return <String, dynamic>{
      'id': 'user_${DateTime.now().millisecondsSinceEpoch}',
      'email': email,
      'name': email.split('@').first,
    };
  }

  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
  }) async {
    // TODO: Заменить на реальный вызов API регистрации.
    await Future.delayed(const Duration(seconds: 2));

    if (username.isEmpty) {
      throw Exception('Введите имя пользователя');
    }
    if (!email.contains('@')) {
      throw Exception('Некорректный email');
    }
    if (password.length < 6) {
      throw Exception('Пароль должен быть не менее 6 символов');
    }

    return <String, dynamic>{
      'id': 'user_${DateTime.now().millisecondsSinceEpoch}',
      'email': email,
      'name': username,
    };
  }

  Future<void> logout() async {
    // TODO: Реализовать логаут на сервере при необходимости (ревокация токена и т.п.).
    await Future.delayed(const Duration(milliseconds: 500));
  }
}


