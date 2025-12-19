import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dnd_project/core/providers/storage_providers.dart';
import 'package:dnd_project/data/repositories/setting_repository_impl.dart';
import 'package:dnd_project/domain/models/setting.dart';
import 'package:uuid/uuid.dart';

/// Провайдер для получения списка сеттингов из Hive
final settingsProvider = FutureProvider<List<Setting>>((ref) async {
  final repository = await ref.watch(settingRepositoryProvider.future);
  return await repository.getSettings();
});

/// Провайдер для создания сеттинга
final createSettingProvider = FutureProvider.family<Setting, Setting>((ref, setting) async {
  final repository = await ref.watch(settingRepositoryProvider.future);
  if (repository is SettingRepositoryImpl) {
    await repository.saveSetting(setting);
  }
  // Обновляем список сеттингов
  ref.invalidate(settingsProvider);
  return setting;
});

/// Провайдер для удаления сеттинга
final deleteSettingProvider = FutureProvider.family<void, String>((ref, settingId) async {
  final repository = await ref.watch(settingRepositoryProvider.future);
  if (repository is SettingRepositoryImpl) {
    await repository.deleteSetting(settingId);
  }
  // Обновляем список сеттингов
  ref.invalidate(settingsProvider);
});

/// Провайдер для получения сеттинга по ID
final settingByIdProvider = FutureProvider.family<Setting?, String>((ref, settingId) async {
  final settings = await ref.watch(settingsProvider.future);
  try {
    return settings.firstWhere((s) => s.id == settingId);
  } catch (_) {
    return null;
  }
});

