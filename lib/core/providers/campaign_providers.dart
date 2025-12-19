import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dnd_project/core/providers/storage_providers.dart';
import 'package:dnd_project/data/repositories/campaign_repository_impl.dart';
import 'package:dnd_project/domain/models/campaign.dart';
import 'package:uuid/uuid.dart';

/// Провайдер для получения списка кампаний из Hive
final campaignsProvider = FutureProvider<List<Campaign>>((ref) async {
  final repository = await ref.watch(campaignRepositoryProvider.future);
  return await repository.getCampaigns();
});

/// Провайдер для создания кампании
final createCampaignProvider = FutureProvider.family<Campaign, Campaign>((ref, campaign) async {
  final repository = await ref.watch(campaignRepositoryProvider.future);
  if (repository is CampaignRepositoryImpl) {
    await repository.saveCampaign(campaign);
  }
  // Обновляем список кампаний
  ref.invalidate(campaignsProvider);
  return campaign;
});

/// Провайдер для удаления кампании
final deleteCampaignProvider = FutureProvider.family<void, String>((ref, campaignId) async {
  final repository = await ref.watch(campaignRepositoryProvider.future);
  if (repository is CampaignRepositoryImpl) {
    await repository.deleteCampaign(campaignId);
  }
  // Обновляем список кампаний
  ref.invalidate(campaignsProvider);
});

/// Провайдер для получения кампании по ID
final campaignByIdProvider = FutureProvider.family<Campaign?, String>((ref, campaignId) async {
  final campaigns = await ref.watch(campaignsProvider.future);
  try {
    return campaigns.firstWhere((c) => c.id == campaignId);
  } catch (_) {
    return null;
  }
});

