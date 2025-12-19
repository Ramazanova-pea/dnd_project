import 'package:dio/dio.dart';
import 'package:dnd_project/core/network/dio_client.dart';

/// Клиент для работы с Random User Generator API
/// Документация: https://randomuser.me/documentation
class RandomUserApiClient {
  final Dio _dio;

  RandomUserApiClient() : _dio = DioClient.getRandomUserClient();

  /// Получить случайного пользователя
  /// GET /api
  /// С повторными попытками для первого медленного запроса
  Future<Map<String, dynamic>> getRandomUser() async {
    // Используем полный URL для избежания проблем с CORS на веб-платформе
    // Создаем Dio с увеличенными таймаутами для первого запроса
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 60), // Увеличенный таймаут для первого запроса
        receiveTimeout: const Duration(seconds: 60),
        headers: {
          'Accept': 'application/json',
        },
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    // Повторные попытки с экспоненциальной задержкой
    const maxRetries = 3;
    int attempt = 0;
    
    while (attempt < maxRetries) {
      try {
        final response = await dio.get(
          'https://randomuser.me/api',
          options: Options(
            headers: {
              'Accept': 'application/json',
            },
          ),
        );
        return response.data as Map<String, dynamic>;
      } on DioException catch (e) {
        attempt++;
        
        // Если это последняя попытка, выбрасываем ошибку
        if (attempt >= maxRetries) {
          throw _handleError(e);
        }
        
        // Проверяем, стоит ли повторять попытку
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.connectionError) {
          // Экспоненциальная задержка: 2 секунды, 4 секунды, 8 секунд
          final delaySeconds = 2 * (1 << (attempt - 1));
          await Future.delayed(Duration(seconds: delaySeconds));
          continue; // Повторяем попытку
        } else {
          // Для других типов ошибок не повторяем
          throw _handleError(e);
        }
      } catch (e) {
        if (attempt >= maxRetries) {
          throw Exception('Unexpected error: $e');
        }
        // Для других ошибок тоже делаем задержку перед повтором
        final delaySeconds = 2 * (1 << (attempt - 1));
        await Future.delayed(Duration(seconds: delaySeconds));
        attempt++;
      }
    }
    
    throw Exception('Не удалось получить данные после $maxRetries попыток');
  }

  /// Получить несколько случайных пользователей
  /// GET /api?results={count}
  Future<Map<String, dynamic>> getRandomUsers({int count = 1}) async {
    try {
      final response = await _dio.get('/api', queryParameters: {'results': count});
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
    } else if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return Exception('Таймаут соединения. Проверьте интернет-соединение.');
    } else if (error.type == DioExceptionType.connectionError) {
      return Exception('Ошибка соединения. Проверьте интернет-соединение и доступность API.');
    } else {
      return Exception('Network Error: ${error.message ?? error.toString()}');
    }
  }
}

