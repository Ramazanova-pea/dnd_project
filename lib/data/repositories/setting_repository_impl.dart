import 'package:dnd_project/data/datasources/local/hive_data_source.dart';
import 'package:dnd_project/domain/models/setting.dart';
import 'package:dnd_project/domain/repositories/setting_repository.dart';

/// Реализация [SettingRepository] с использованием Hive для локального хранения.
class SettingRepositoryImpl implements SettingRepository {
  SettingRepositoryImpl({
    required HiveDataSource hiveDataSource,
  }) : _hiveDataSource = hiveDataSource;

  final HiveDataSource _hiveDataSource;

  @override
  Future<List<Setting>> getSettings() async {
    return await _hiveDataSource.getSettings();
  }

  /// Сохранение сеттинга в локальное хранилище
  Future<void> saveSetting(Setting setting) async {
    await _hiveDataSource.saveSetting(setting);
  }

  /// Удаление сеттинга из локального хранилища
  Future<void> deleteSetting(String settingId) async {
    await _hiveDataSource.deleteSetting(settingId);
  }
}


