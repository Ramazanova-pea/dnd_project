import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  final bool isAuthenticated;
  final String? userId;
  final String? username;
  final String? email;
  final bool isGuest;

  AuthState({
    required this.isAuthenticated,
    this.userId,
    this.username,
    this.email,
    this.isGuest = false,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    String? userId,
    String? username,
    String? email,
    bool? isGuest,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      email: email ?? this.email,
      isGuest: isGuest ?? this.isGuest,
    );
  }
}

class LoginResult {
  final bool success;
  final String? message;

  LoginResult({required this.success, this.message});
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState(isAuthenticated: false));

  Future<LoginResult> login(String email, String password) async {
    // TODO: Реализовать реальную логику авторизации
    await Future.delayed(const Duration(seconds: 1));

    // Временная заглушка для демонстрации
    if (email.isNotEmpty && password.isNotEmpty) {
      state = state.copyWith(
        isAuthenticated: true,
        userId: 'temp_${DateTime.now().millisecondsSinceEpoch}',
        username: email.split('@').first,
        email: email,
        isGuest: false,
      );
      return LoginResult(success: true);
    }

    return LoginResult(
      success: false,
      message: 'Неверный email или пароль',
    );
  }

  Future<LoginResult> register({
    required String username,
    required String email,
    required String password,
  }) async {
    // TODO: Реализовать реальную логику регистрации
    await Future.delayed(const Duration(seconds: 1));

    // Временная заглушка для демонстрации
    if (username.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
      state = state.copyWith(
        isAuthenticated: true,
        userId: 'user_${DateTime.now().millisecondsSinceEpoch}',
        username: username,
        email: email,
        isGuest: false,
      );
      return LoginResult(success: true);
    }

    return LoginResult(
      success: false,
      message: 'Ошибка регистрации. Проверьте данные',
    );
  }

  void guestLogin() {
    state = state.copyWith(
      isAuthenticated: true,
      userId: 'guest_${DateTime.now().millisecondsSinceEpoch}',
      username: 'Гость',
      isGuest: true,
    );
  }

  void logout() {
    state = AuthState(isAuthenticated: false);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
      (ref) => AuthNotifier(),
);