import 'package:dnd_project/domain/models/campaign.dart';

abstract class CampaignRepository {
  Future<List<Campaign>> getCampaigns();
}


