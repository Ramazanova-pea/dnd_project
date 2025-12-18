import 'package:dnd_project/domain/models/character.dart';

abstract class CharacterRepository {
  Future<List<Character>> getCharacters();
}


