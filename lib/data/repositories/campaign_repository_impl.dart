import 'package:dnd_project/data/datasources/local/hive_data_source.dart';
import 'package:dnd_project/domain/models/campaign.dart';
import 'package:dnd_project/domain/repositories/campaign_repository.dart';

/// Реализация [CampaignRepository] с использованием Hive для локального хранения.
class CampaignRepositoryImpl implements CampaignRepository {
  CampaignRepositoryImpl({
    required HiveDataSource hiveDataSource,
  }) : _hiveDataSource = hiveDataSource;

  final HiveDataSource _hiveDataSource;

  @override
  Future<List<Campaign>> getCampaigns() async {
    // Получаем кампании из Hive
    final campaigns = await _hiveDataSource.getCampaigns();
    
    // Если в Hive нет данных, возвращаем пустой список
    // (в будущем можно добавить загрузку из удалённого источника)
    return campaigns;
  }

  /// Сохранение кампании в локальное хранилище
  Future<void> saveCampaign(Campaign campaign) async {
    await _hiveDataSource.saveCampaign(campaign);
  }

  /// Удаление кампании из локального хранилища
  Future<void> deleteCampaign(String campaignId) async {
    await _hiveDataSource.deleteCampaign(campaignId);
  }
}


