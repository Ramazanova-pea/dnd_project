import 'package:dio/dio.dart';
import 'package:dnd_project/core/network/dio_client.dart';

/// Клиент для работы с D&D 5e API
/// Документация: https://www.dnd5eapi.co/docs/
class Dnd5eApiClient {
  final Dio _dio;

  Dnd5eApiClient() : _dio = DioClient.getDnd5eClient();

  /// Получить список всех классов
  /// GET /classes
  Future<Map<String, dynamic>> getClasses() async {
    try {
      final response = await _dio.get('/classes');
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Получить информацию о конкретном классе
  /// GET /classes/{index}
  Future<Map<String, dynamic>> getClassById(String index) async {
    try {
      final response = await _dio.get('/classes/$index');
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Получить список всех рас
  /// GET /races
  Future<Map<String, dynamic>> getRaces() async {
    try {
      final response = await _dio.get('/races');
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Получить информацию о конкретной расе
  /// GET /races/{index}
  Future<Map<String, dynamic>> getRaceById(String index) async {
    try {
      final response = await _dio.get('/races/$index');
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Получить информацию о монстре
  /// GET /monsters/{index}
  Future<Map<String, dynamic>> getMonsterById(String index) async {
    try {
      final response = await _dio.get('/monsters/$index');
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Получить список всех заклинаний
  /// GET /spells
  Future<Map<String, dynamic>> getSpells() async {
    try {
      final response = await _dio.get('/spells');
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Получить информацию о конкретном заклинании
  /// GET /spells/{index}
  Future<Map<String, dynamic>> getSpellById(String index) async {
    try {
      final response = await _dio.get('/spells/$index');
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Обработка ошибок Dio
  Exception _handleError(DioException error) {
    if (error.response != null) {
      return Exception(
        'API Error: ${error.response?.statusCode} - ${error.response?.statusMessage}',
      );
    } else {
      return Exception('Network Error: ${error.message}');
    }
  }
}

