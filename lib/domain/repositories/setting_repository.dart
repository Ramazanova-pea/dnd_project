import 'package:dnd_project/domain/models/setting.dart';

abstract class SettingRepository {
  Future<List<Setting>> getSettings();
}


