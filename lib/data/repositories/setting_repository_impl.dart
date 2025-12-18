import 'package:dnd_project/data/datasources/setting_local_data_source.dart';
import 'package:dnd_project/domain/models/setting.dart';
import 'package:dnd_project/domain/repositories/setting_repository.dart';

class SettingRepositoryImpl implements SettingRepository {
  SettingRepositoryImpl(this._local);

  final SettingLocalDataSource _local;

  @override
  Future<List<Setting>> getSettings() {
    return _local.getSettings();
  }
}


