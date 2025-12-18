class Campaign {
  final String id;
  final String name;
  final String description;
  final String status;
  final String system;
  final String master;
  final String setting;
  final int players;
  final int sessions;
  final DateTime? nextSession;
  final DateTime? lastSession;

  const Campaign({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.system,
    required this.master,
    required this.setting,
    required this.players,
    required this.sessions,
    this.nextSession,
    this.lastSession,
  });
}


