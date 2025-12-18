import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dnd_project/data/datasources/auth_remote_data_source.dart';
import 'package:dnd_project/data/datasources/local/auth_local_data_source.dart';
import 'package:dnd_project/data/datasources/local/shared_preferences_data_source.dart';
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

/// Провайдер SharedPreferences DataSource
final sharedPreferencesDataSourceProvider =
    Provider<SharedPreferencesDataSource>((ref) {
  return SharedPreferencesDataSource();
});

/// Провайдер локального источника данных для авторизации
final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  final sharedPrefs = ref.read(sharedPreferencesDataSourceProvider);
  return AuthLocalDataSource(sharedPrefs: sharedPrefs);
});

/// Провайдер репозитория авторизации (слой Data, реализующий Domain-интерфейс).
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = AuthRemoteDataSource();
  final localDataSource = ref.read(authLocalDataSourceProvider);
  return AuthRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );
});

/// StateNotifier, который использует [AuthRepository] и управляет состоянием авторизации.
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._repository) : super(const AuthState()) {
    // При инициализации проверяем сохранённую сессию
    _loadSavedSession();
  }

  final AuthRepository _repository;

  /// Загрузка сохранённой сессии при старте приложения
  Future<void> _loadSavedSession() async {
    if (_repository is AuthRepositoryImpl) {
      final savedUser = await (_repository as AuthRepositoryImpl).getSavedSession();
      if (savedUser != null) {
        state = AuthState(
          isAuthenticated: true,
          user: savedUser,
        );
      }
    }
  }

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