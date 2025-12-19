import 'package:dnd_project/data/datasources/remote/dnd5e_api_client.dart';
import 'package:dnd_project/domain/models/reference/class_model.dart';
import 'package:dnd_project/domain/models/reference/race_model.dart';
import 'package:dnd_project/domain/models/reference/monster_model.dart';
import 'package:dnd_project/domain/models/reference/spell_model.dart';
import 'package:dnd_project/domain/repositories/reference_repository.dart';

/// Реализация репозитория справочника с использованием D&D 5e API
class ReferenceRepositoryImpl implements ReferenceRepository {
  final Dnd5eApiClient _apiClient;

  ReferenceRepositoryImpl({
    required Dnd5eApiClient apiClient,
  }) : _apiClient = apiClient;

  @override
  Future<List<ClassModel>> getClasses() async {
    final data = await _apiClient.getClasses();
    final results = data['results'] as List;
    return results
        .map((json) => ClassModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ClassModel> getClassById(String id) async {
    final data = await _apiClient.getClassById(id);
    return ClassModel.fromJson(data);
  }

  @override
  Future<List<RaceModel>> getRaces() async {
    final data = await _apiClient.getRaces();
    final results = data['results'] as List;
    return results
        .map((json) => RaceModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<RaceModel> getRaceById(String id) async {
    final data = await _apiClient.getRaceById(id);
    return RaceModel.fromJson(data);
  }

  @override
  Future<MonsterModel> getMonsterById(String id) async {
    final data = await _apiClient.getMonsterById(id);
    return MonsterModel.fromJson(data);
  }

  @override
  Future<List<SpellModel>> getSpells() async {
    final data = await _apiClient.getSpells();
    final results = data['results'] as List;
    return results
        .map((json) => SpellModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<SpellModel> getSpellById(String id) async {
    final data = await _apiClient.getSpellById(id);
    return SpellModel.fromJson(data);
  }
}

