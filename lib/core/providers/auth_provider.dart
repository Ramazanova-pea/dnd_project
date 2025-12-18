import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dnd_project/data/datasources/auth_remote_data_source.dart';
import 'package:dnd_project/data/repositories/auth_repository_impl.dart';
import 'package:dnd_project/domain/models/user.dart';
import 'package:dnd_project/domain/repositories/auth_repository.dart';

/// Состояние авторизации для UI-слоя.
class AuthState {
  final bool isAuthenticated;
  final User? user;

  const AuthState({
    this.isAuthenticated = false,
    this.user,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    User? user,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
    );
  }
}

/// Провайдер репозитория авторизации (слой Data, реализующий Domain-интерфейс).
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = AuthRemoteDataSource();
  return AuthRepositoryImpl(remoteDataSource: remoteDataSource);
});

/// StateNotifier, который использует [AuthRepository] и управляет состоянием авторизации.
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._repository) : super(const AuthState());

  final AuthRepository _repository;

  Future<bool> login(String email, String password) async {
    try {
      final user = await _repository.login(email: email, password: password);
      state = AuthState(
        isAuthenticated: true,
        user: user,
      );
      return true;
    } catch (_) {
      rethrow;
    }
  }

  Future<bool> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final user = await _repository.register(
        username: username,
        email: email,
        password: password,
      );
      state = AuthState(
        isAuthenticated: true,
        user: user,
      );
      return true;
    } catch (_) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const AuthState();
  }

  void updateProfile(String userName, String email) {
    final currentUser = state.user;
    if (currentUser == null) return;

    final updatedUser = User(
      id: currentUser.id,
      email: email,
      name: userName,
    );

    state = state.copyWith(user: updatedUser);
  }
}

/// Глобальный провайдер авторизации, доступный во всем приложении.
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return AuthNotifier(repository);
});