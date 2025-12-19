import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dnd_project/data/datasources/remote/dnd5e_api_client.dart';
import 'package:dnd_project/data/datasources/remote/random_user_api_client.dart';
import 'package:dnd_project/data/repositories/reference_repository_impl.dart';
import 'package:dnd_project/domain/repositories/reference_repository.dart';
import 'package:dnd_project/domain/models/reference/class_model.dart';
import 'package:dnd_project/domain/models/reference/race_model.dart';
import 'package:dnd_project/domain/models/reference/monster_model.dart';
import 'package:dnd_project/domain/models/reference/spell_model.dart';

/// Провайдер API клиента D&D 5e
final dnd5eApiClientProvider = Provider<Dnd5eApiClient>((ref) {
  return Dnd5eApiClient();
});

/// Провайдер репозитория справочника
final referenceRepositoryProvider = Provider<ReferenceRepository>((ref) {
  final apiClient = ref.read(dnd5eApiClientProvider);
  return ReferenceRepositoryImpl(apiClient: apiClient);
});

/// Провайдер для получения списка классов
final classesProvider = FutureProvider<List<ClassModel>>((ref) async {
  final repository = ref.read(referenceRepositoryProvider);
  return await repository.getClasses();
});

/// Провайдер для получения класса по ID
final classByIdProvider = FutureProvider.family<ClassModel, String>((ref, id) async {
  final repository = ref.read(referenceRepositoryProvider);
  return await repository.getClassById(id);
});

/// Провайдер для получения списка рас
final racesProvider = FutureProvider<List<RaceModel>>((ref) async {
  final repository = ref.read(referenceRepositoryProvider);
  return await repository.getRaces();
});

/// Провайдер для получения расы по ID
final raceByIdProvider = FutureProvider.family<RaceModel, String>((ref, id) async {
  final repository = ref.read(referenceRepositoryProvider);
  return await repository.getRaceById(id);
});

/// Провайдер для получения монстра по ID
final monsterByIdProvider = FutureProvider.family<MonsterModel, String>((ref, id) async {
  final repository = ref.read(referenceRepositoryProvider);
  return await repository.getMonsterById(id);
});

/// Провайдер для получения списка заклинаний
final spellsProvider = FutureProvider<List<SpellModel>>((ref) async {
  final repository = ref.read(referenceRepositoryProvider);
  return await repository.getSpells();
});

/// Провайдер для получения заклинания по ID
final spellByIdProvider = FutureProvider.family<SpellModel, String>((ref, id) async {
  final repository = ref.read(referenceRepositoryProvider);
  return await repository.getSpellById(id);
});

/// Провайдер API клиента Random User Generator
final randomUserApiClientProvider = Provider<RandomUserApiClient>((ref) {
  return RandomUserApiClient();
});

/// Провайдер для получения случайного пользователя
/// Используем autoDispose для получения нового пользователя при каждом запросе
final randomUserProvider = FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final apiClient = ref.read(randomUserApiClientProvider);
  return await apiClient.getRandomUser();
});

