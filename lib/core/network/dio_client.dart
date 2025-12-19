import 'package:dio/dio.dart';

/// Централизованный Dio клиент для сетевых запросов
class DioClient {
  DioClient._();
  
  static Dio? _dnd5eClient;
  static Dio? _randomUserClient;
  
  /// Получить клиент для D&D 5e API
  static Dio getDnd5eClient() {
    _dnd5eClient ??= Dio(
      BaseOptions(
        baseUrl: 'https://www.dnd5eapi.co/api',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    return _dnd5eClient!;
  }

  /// Получить клиент для Random User Generator API
  static Dio getRandomUserClient() {
    _randomUserClient ??= Dio(
      BaseOptions(
        baseUrl: 'https://randomuser.me',
        connectTimeout: const Duration(seconds: 60), // Увеличенный таймаут для первого запроса
        receiveTimeout: const Duration(seconds: 60),
        headers: {
          'Accept': 'application/json',
        },
        // Для веб-платформы: не устанавливаем Content-Type для GET запросов
        // чтобы избежать проблем с CORS
        validateStatus: (status) => status != null && status < 500,
      ),
    );
    return _randomUserClient!;
  }
}

