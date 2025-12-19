import 'package:dnd_project/domain/models/reference/class_model.dart';
import 'package:dnd_project/domain/models/reference/race_model.dart';
import 'package:dnd_project/domain/models/reference/monster_model.dart';
import 'package:dnd_project/domain/models/reference/spell_model.dart';

/// Абстрактный репозиторий для работы со справочной информацией D&D 5e
abstract class ReferenceRepository {
  // Классы
  Future<List<ClassModel>> getClasses();
  Future<ClassModel> getClassById(String id);

  // Расы
  Future<List<RaceModel>> getRaces();
  Future<RaceModel> getRaceById(String id);

  // Монстры
  Future<MonsterModel> getMonsterById(String id);

  // Заклинания
  Future<List<SpellModel>> getSpells();
  Future<SpellModel> getSpellById(String id);
}

