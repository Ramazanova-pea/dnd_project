import 'package:dnd_project/domain/models/campaign.dart';

/// Локальный источник данных кампаний.
/// Пока возвращает встроенный список-демонстрацию (как в UI),
/// но структурирован под замену на реальное хранилище.
class CampaignLocalDataSource {
  Future<List<Campaign>> getCampaigns() async {
    // TODO: заменить на чтение из Hive/БД/файла.
    return <Campaign>[
      Campaign(
        id: '1',
        name: 'Потерянный трон Эльдора',
        description: 'Поиски древнего артефакта в раздираемом войной королевстве',
        status: 'Активная',
        system: 'D&D 5e',
        master: 'Артём В.',
        setting: 'Королевство Эльдора',
        players: 5,
        sessions: 12,
        nextSession: DateTime(2024, 1, 22),
        lastSession: DateTime(2024, 1, 15),
      ),
    ];
  }
}


