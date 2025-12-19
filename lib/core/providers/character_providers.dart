import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dnd_project/core/providers/storage_providers.dart';
import 'package:dnd_project/data/repositories/character_repository_impl.dart';
import 'package:dnd_project/domain/models/character.dart';
import 'package:uuid/uuid.dart';

/// Провайдер для получения списка персонажей из Hive
final charactersProvider = FutureProvider<List<Character>>((ref) async {
  final repository = await ref.watch(characterRepositoryProvider.future);
  return await repository.getCharacters();
});

/// Провайдер для создания персонажа
final createCharacterProvider = FutureProvider.family<Character, Character>((ref, character) async {
  final repository = await ref.watch(characterRepositoryProvider.future);
  if (repository is CharacterRepositoryImpl) {
    await repository.saveCharacter(character);
  }
  // Обновляем список персонажей
  ref.invalidate(charactersProvider);
  return character;
});

/// Провайдер для удаления персонажа
final deleteCharacterProvider = FutureProvider.family<void, String>((ref, characterId) async {
  final repository = await ref.watch(characterRepositoryProvider.future);
  if (repository is CharacterRepositoryImpl) {
    await repository.deleteCharacter(characterId);
  }
  // Обновляем список персонажей
  ref.invalidate(charactersProvider);
});

/// Провайдер для получения персонажа по ID
final characterByIdProvider = FutureProvider.family<Character?, String>((ref, characterId) async {
  final characters = await ref.watch(charactersProvider.future);
  try {
    return characters.firstWhere((c) => c.id == characterId);
  } catch (_) {
    return null;
  }
});

