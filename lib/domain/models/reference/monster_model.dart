/// Доменная модель монстра из D&D 5e
class MonsterModel {
  final String index;
  final String name;
  final String? size;
  final String? type;
  final String? alignment;
  final int? armorClass;
  final int? hitPoints;
  final String? hitDice;
  final Map<String, int>? stats; // strength, dexterity, etc.
  final List<String>? damageVulnerabilities;
  final List<String>? damageResistances;
  final List<String>? damageImmunities;
  final List<String>? conditionImmunities;
  final String? languages;
  final double? challengeRating;
  final int? xp;
  final List<Map<String, dynamic>>? specialAbilities;
  final List<Map<String, dynamic>>? actions;
  final List<Map<String, dynamic>>? legendaryActions;
  final String? url;

  MonsterModel({
    required this.index,
    required this.name,
    this.size,
    this.type,
    this.alignment,
    this.armorClass,
    this.hitPoints,
    this.hitDice,
    this.stats,
    this.damageVulnerabilities,
    this.damageResistances,
    this.damageImmunities,
    this.conditionImmunities,
    this.languages,
    this.challengeRating,
    this.xp,
    this.specialAbilities,
    this.actions,
    this.legendaryActions,
    this.url,
  });

  /// Создать из JSON (из API)
  factory MonsterModel.fromJson(Map<String, dynamic> json) {
    final stats = <String, int>{};
    if (json['strength'] != null) stats['strength'] = json['strength'] as int;
    if (json['dexterity'] != null) stats['dexterity'] = json['dexterity'] as int;
    if (json['constitution'] != null) stats['constitution'] = json['constitution'] as int;
    if (json['intelligence'] != null) stats['intelligence'] = json['intelligence'] as int;
    if (json['wisdom'] != null) stats['wisdom'] = json['wisdom'] as int;
    if (json['charisma'] != null) stats['charisma'] = json['charisma'] as int;

    return MonsterModel(
      index: json['index'] as String,
      name: json['name'] as String,
      size: json['size'] as String?,
      type: json['type'] as String?,
      alignment: json['alignment'] as String?,
      armorClass: json['armor_class'] != null
          ? (json['armor_class'] as List).isNotEmpty
              ? (json['armor_class'][0] as Map<String, dynamic>)['value'] as int?
              : null
          : null,
      hitPoints: json['hit_points'] as int?,
      hitDice: json['hit_dice'] as String?,
      stats: stats.isNotEmpty ? stats : null,
      damageVulnerabilities: json['damage_vulnerabilities'] != null
          ? List<String>.from(json['damage_vulnerabilities'])
          : null,
      damageResistances: json['damage_resistances'] != null
          ? List<String>.from(json['damage_resistances'])
          : null,
      damageImmunities: json['damage_immunities'] != null
          ? List<String>.from(json['damage_immunities'])
          : null,
      conditionImmunities: json['condition_immunities'] != null
          ? (json['condition_immunities'] as List)
              .map((e) => (e as Map<String, dynamic>)['name'] as String)
              .toList()
          : null,
      languages: json['languages'] as String?,
      challengeRating: json['challenge_rating'] != null
          ? (json['challenge_rating'] as num).toDouble()
          : null,
      xp: json['xp'] as int?,
      specialAbilities: json['special_abilities'] != null
          ? List<Map<String, dynamic>>.from(json['special_abilities'])
          : null,
      actions: json['actions'] != null
          ? List<Map<String, dynamic>>.from(json['actions'])
          : null,
      legendaryActions: json['legendary_actions'] != null
          ? List<Map<String, dynamic>>.from(json['legendary_actions'])
          : null,
      url: json['url'] as String?,
    );
  }

  /// Преобразовать в JSON
  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'name': name,
      'size': size,
      'type': type,
      'alignment': alignment,
      'armor_class': armorClass,
      'hit_points': hitPoints,
      'hit_dice': hitDice,
      'stats': stats,
      'damage_vulnerabilities': damageVulnerabilities,
      'damage_resistances': damageResistances,
      'damage_immunities': damageImmunities,
      'condition_immunities': conditionImmunities,
      'languages': languages,
      'challenge_rating': challengeRating,
      'xp': xp,
      'special_abilities': specialAbilities,
      'actions': actions,
      'legendary_actions': legendaryActions,
      'url': url,
    };
  }
}

