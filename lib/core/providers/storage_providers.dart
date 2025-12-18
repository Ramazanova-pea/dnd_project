import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dnd_project/data/datasources/local/hive_data_source.dart';
import 'package:dnd_project/data/repositories/campaign_repository_impl.dart';
import 'package:dnd_project/data/repositories/character_repository_impl.dart';
import 'package:dnd_project/data/repositories/setting_repository_impl.dart';
import 'package:dnd_project/data/repositories/chat_repository_impl.dart';
import 'package:dnd_project/domain/repositories/campaign_repository.dart';
import 'package:dnd_project/domain/repositories/character_repository.dart';
import 'package:dnd_project/domain/repositories/setting_repository.dart';
import 'package:dnd_project/domain/repositories/chat_repository.dart';

/// Провайдер Hive DataSource для инициализации и работы с NoSQL хранилищем
final hiveDataSourceProvider = FutureProvider<HiveDataSource>((ref) async {
  final hiveDataSource = HiveDataSource();
  await hiveDataSource.init();
  return hiveDataSource;
});

/// Провайдер репозитория кампаний с использованием Hive
final campaignRepositoryProvider = FutureProvider<CampaignRepository>((ref) async {
  final hiveDataSource = await ref.watch(hiveDataSourceProvider.future);
  return CampaignRepositoryImpl(hiveDataSource: hiveDataSource);
});

/// Провайдер репозитория персонажей с использованием Hive
final characterRepositoryProvider = FutureProvider<CharacterRepository>((ref) async {
  final hiveDataSource = await ref.watch(hiveDataSourceProvider.future);
  return CharacterRepositoryImpl(hiveDataSource: hiveDataSource);
});

/// Провайдер репозитория сеттингов с использованием Hive
final settingRepositoryProvider = FutureProvider<SettingRepository>((ref) async {
  final hiveDataSource = await ref.watch(hiveDataSourceProvider.future);
  return SettingRepositoryImpl(hiveDataSource: hiveDataSource);
});

/// Провайдер репозитория чатов с использованием Hive
final chatRepositoryProvider = FutureProvider<ChatRepository>((ref) async {
  final hiveDataSource = await ref.watch(hiveDataSourceProvider.future);
  return ChatRepositoryImpl(hiveDataSource: hiveDataSource);
});

