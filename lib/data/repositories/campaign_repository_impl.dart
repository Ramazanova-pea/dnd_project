import 'package:dnd_project/data/datasources/campaign_local_data_source.dart';
import 'package:dnd_project/domain/models/campaign.dart';
import 'package:dnd_project/domain/repositories/campaign_repository.dart';

class CampaignRepositoryImpl implements CampaignRepository {
  CampaignRepositoryImpl(this._local);

  final CampaignLocalDataSource _local;

  @override
  Future<List<Campaign>> getCampaigns() {
    return _local.getCampaigns();
  }
}


