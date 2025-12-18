import 'package:dnd_project/data/datasources/character_local_data_source.dart';
import 'package:dnd_project/domain/models/character.dart';
import 'package:dnd_project/domain/repositories/character_repository.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  CharacterRepositoryImpl(this._local);

  final CharacterLocalDataSource _local;

  @override
  Future<List<Character>> getCharacters() {
    return _local.getCharacters();
  }
}


