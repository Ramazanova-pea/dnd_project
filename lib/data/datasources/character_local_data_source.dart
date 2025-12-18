import 'package:dnd_project/domain/models/character.dart';

/// Локальный источник данных персонажей (демо-данные).
class CharacterLocalDataSource {
  Future<List<Character>> getCharacters() async {
    // TODO: заменить на реальное хранилище.
    return <Character>[
      Character(
        id: '1',
        name: 'Арвен Веледа',
        race: 'Эльф',
        characterClass: 'Рейнджер',
        level: 5,
        campaign: 'Проклятие Страда',
        lastPlayed: DateTime(2024, 2, 15),
      ),
    ];
  }
}


