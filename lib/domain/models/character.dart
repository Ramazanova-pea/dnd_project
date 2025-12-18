class Character {
  final String id;
  final String name;
  final String race;
  final String characterClass;
  final int level;
  final String? campaign;
  final DateTime? lastPlayed;

  const Character({
    required this.id,
    required this.name,
    required this.race,
    required this.characterClass,
    required this.level,
    this.campaign,
    this.lastPlayed,
  });
}


