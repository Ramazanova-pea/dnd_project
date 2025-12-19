import 'package:dio/dio.dart';

/// Централизованный Dio клиент для сетевых запросов
class DioClient {
  DioClient._();
  
  static Dio? _dnd5eClient;
  
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
}

