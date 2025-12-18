import 'package:shared_preferences/shared_preferences.dart';

/// DataSource для работы с SharedPreferences.
/// Используется для хранения простых данных: настроек, флагов, токенов авторизации.
/// 
/// Согласно методичке "Практическая работа 12.pdf", SharedPreferences подходит для:
/// - Хранения настроек приложения
/// - Сохранения простых типов данных (String, int, double, bool, List<String>)
/// - Максимальный объём данных обычно ограничен 1-2 МБ
class SharedPreferencesDataSource {
  SharedPreferences? _prefs;

  /// Получение экземпляра SharedPreferences (ленивая инициализация)
  Future<SharedPreferences> _getPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // ========== Работа со строками ==========

  /// Сохранение строкового значения
  Future<bool> setString(String key, String value) async {
    final prefs = await _getPrefs();
    return await prefs.setString(key, value);
  }

  /// Получение строкового значения
  Future<String?> getString(String key) async {
    final prefs = await _getPrefs();
    return prefs.getString(key);
  }

  /// Получение строкового значения с значением по умолчанию
  Future<String> getStringOrDefault(String key, String defaultValue) async {
    final prefs = await _getPrefs();
    return prefs.getString(key) ?? defaultValue;
  }

  // ========== Работа с числами ==========

  /// Сохранение целого числа
  Future<bool> setInt(String key, int value) async {
    final prefs = await _getPrefs();
    return await prefs.setInt(key, value);
  }

  /// Получение целого числа
  Future<int?> getInt(String key) async {
    final prefs = await _getPrefs();
    return prefs.getInt(key);
  }

  /// Получение целого числа с значением по умолчанию
  Future<int> getIntOrDefault(String key, int defaultValue) async {
    final prefs = await _getPrefs();
    return prefs.getInt(key) ?? defaultValue;
  }

  // ========== Работа с числами с плавающей точкой ==========

  /// Сохранение числа с плавающей точкой
  Future<bool> setDouble(String key, double value) async {
    final prefs = await _getPrefs();
    return await prefs.setDouble(key, value);
  }

  /// Получение числа с плавающей точкой
  Future<double?> getDouble(String key) async {
    final prefs = await _getPrefs();
    return prefs.getDouble(key);
  }

  /// Получение числа с плавающей точкой с значением по умолчанию
  Future<double> getDoubleOrDefault(String key, double defaultValue) async {
    final prefs = await _getPrefs();
    return prefs.getDouble(key) ?? defaultValue;
  }

  // ========== Работа с булевыми значениями ==========

  /// Сохранение булевого значения
  Future<bool> setBool(String key, bool value) async {
    final prefs = await _getPrefs();
    return await prefs.setBool(key, value);
  }

  /// Получение булевого значения
  Future<bool?> getBool(String key) async {
    final prefs = await _getPrefs();
    return prefs.getBool(key);
  }

  /// Получение булевого значения с значением по умолчанию
  Future<bool> getBoolOrDefault(String key, bool defaultValue) async {
    final prefs = await _getPrefs();
    return prefs.getBool(key) ?? defaultValue;
  }

  // ========== Работа со списками строк ==========

  /// Сохранение списка строк
  Future<bool> setStringList(String key, List<String> value) async {
    final prefs = await _getPrefs();
    return await prefs.setStringList(key, value);
  }

  /// Получение списка строк
  Future<List<String>?> getStringList(String key) async {
    final prefs = await _getPrefs();
    return prefs.getStringList(key);
  }

  /// Получение списка строк с значением по умолчанию
  Future<List<String>> getStringListOrDefault(
    String key,
    List<String> defaultValue,
  ) async {
    final prefs = await _getPrefs();
    return prefs.getStringList(key) ?? defaultValue;
  }

  // ========== Удаление и очистка ==========

  /// Удаление конкретного значения по ключу
  Future<bool> removeValue(String key) async {
    final prefs = await _getPrefs();
    return await prefs.remove(key);
  }

  /// Очистка всех сохранённых данных (осторожно!)
  Future<bool> clearAll() async {
    final prefs = await _getPrefs();
    return await prefs.clear();
  }

  /// Проверка существования значения по ключу
  Future<bool> containsKey(String key) async {
    final prefs = await _getPrefs();
    return prefs.containsKey(key);
  }

  /// Получение всех ключей
  Future<Set<String>> getAllKeys() async {
    final prefs = await _getPrefs();
    return prefs.getKeys();
  }
}

