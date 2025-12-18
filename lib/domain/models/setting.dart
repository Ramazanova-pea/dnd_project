class Setting {
  final String id;
  final String name;
  final String description;
  final String status;
  final String genre;
  final int players;
  final int sessions;
  final DateTime? lastSession;
  final int npcs;
  final int locations;

  const Setting({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.genre,
    required this.players,
    required this.sessions,
    this.lastSession,
    required this.npcs,
    required this.locations,
  });
}


