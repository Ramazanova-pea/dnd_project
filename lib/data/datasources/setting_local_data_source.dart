import 'package:dnd_project/domain/models/setting.dart';

/// Локальный источник данных игровых миров (сеттингов).
class SettingLocalDataSource {
  Future<List<Setting>> getSettings() async {
    // TODO: заменить на реальное хранилище.
    return <Setting>[
      Setting(
        id: '1',
        name: 'Королевство Эльдора',
        description: 'Средневековое фэнтези с магией и драконами',
        status: 'Активный',
        genre: 'Фэнтези',
        players: 5,
        sessions: 12,
        lastSession: DateTime(2024, 1, 15),
        npcs: 8,
        locations: 15,
      ),
    ];
  }
}


