import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// DataSource для работы с Flutter Secure Storage.
/// Используется для хранения чувствительных данных: токенов авторизации, паролей, API-ключей.
/// 
/// Согласно методичке "Практическая работа 12.pdf", Flutter Secure Storage подходит для:
/// - Хранения конфиденциальной информации (токены, пароли, ключи)
/// - Использования шифрования на уровне платформы (Keychain на iOS, EncryptedSharedPreferences на Android)
/// - Обеспечения защиты от несанкционированного доступа к конфиденциальной информации
class SecureStorageDataSource {
  // Настройки для платформо-специфичного шифрования
  static const AndroidOptions _androidOptions = AndroidOptions(
    encryptedSharedPreferences: true, // Использование EncryptedSharedPreferences на Android
  );

  static const IOSOptions _iosOptions = IOSOptions(
    accessibility: KeychainAccessibility.first_unlock_this_device, // Доступ после первого разблокирования устройства
  );

  static const LinuxOptions _linuxOptions = LinuxOptions(
    useSessionKeyring: true, // Использование session keyring на Linux
  );

  static const MacOsOptions _macOsOptions = MacOsOptions(
    accessibility: KeychainAccessibility.first_unlock_this_device,
  );

  static const WindowsOptions _windowsOptions = WindowsOptions(
    useBackwardCompatibility: false,
  );

  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: _androidOptions,
    iOptions: _iosOptions,
    lOptions: _linuxOptions,
    mOptions: _macOsOptions,
    wOptions: _windowsOptions,
  );

  // ========== Работа со строками ==========

  /// Сохранение строкового значения
  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// Получение строкового значения
  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  /// Получение строкового значения с значением по умолчанию
  Future<String> readOrDefault(String key, String defaultValue) async {
    return await _storage.read(key: key) ?? defaultValue;
  }

  // ========== Удаление и очистка ==========

  /// Удаление конкретного значения по ключу
  Future<bool> delete(String key) async {
    await _storage.delete(key: key);
    return true;
  }

  /// Удаление всех значений
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  /// Проверка существования значения по ключу
  Future<bool> containsKey(String key) async {
    return await _storage.containsKey(key: key);
  }

  /// Получение всех ключей
  Future<Map<String, String>> readAll() async {
    return await _storage.readAll();
  }
}

