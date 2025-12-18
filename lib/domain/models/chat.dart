class Chat {
  final String id;
  final String name;
  final String? description;
  final String type; // 'campaign', 'group', 'private'
  final String? campaignId;
  final int unreadCount;
  final bool isPinned;
  final bool isMuted;
  final DateTime? lastActivity;

  const Chat({
    required this.id,
    required this.name,
    this.description,
    required this.type,
    this.campaignId,
    required this.unreadCount,
    required this.isPinned,
    required this.isMuted,
    this.lastActivity,
  });
}


