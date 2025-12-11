import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  final bool isAuthenticated;
  final String? userId;
  final String? username;

  AuthState({
    required this.isAuthenticated,
    this.userId,
    this.username,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    String? userId,
    String? username,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userId: userId ?? this.userId,
      username: username ?? this.username,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState(isAuthenticated: false));

  void login(String userId, String username) {
    state = state.copyWith(
      isAuthenticated: true,
      userId: userId,
      username: username,
    );
  }

  void logout() {
    state = AuthState(isAuthenticated: false);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
      (ref) => AuthNotifier(),
);