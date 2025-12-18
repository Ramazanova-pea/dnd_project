import 'package:dnd_project/data/datasources/local/hive_data_source.dart';
import 'package:dnd_project/domain/models/character.dart';
import 'package:dnd_project/domain/repositories/character_repository.dart';

/// Реализация [CharacterRepository] с использованием Hive для локального хранения.
class CharacterRepositoryImpl implements CharacterRepository {
  CharacterRepositoryImpl({
    required HiveDataSource hiveDataSource,
  }) : _hiveDataSource = hiveDataSource;

  final HiveDataSource _hiveDataSource;

  @override
  Future<List<Character>> getCharacters() async {
    return await _hiveDataSource.getCharacters();
  }

  /// Сохранение персонажа в локальное хранилище
  Future<void> saveCharacter(Character character) async {
    await _hiveDataSource.saveCharacter(character);
  }

  /// Удаление персонажа из локального хранилища
  Future<void> deleteCharacter(String characterId) async {
    await _hiveDataSource.deleteCharacter(characterId);
  }
}


