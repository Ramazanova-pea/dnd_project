/// Доменная модель расы из D&D 5e
class RaceModel {
  final String index;
  final String name;
  final int? speed;
  final Map<String, int>? abilityBonuses;
  final String? alignment;
  final String? age;
  final String? size;
  final String? sizeDescription;
  final List<Map<String, dynamic>>? startingProficiencies;
  final Map<String, dynamic>? startingProficiencyOptions;
  final List<Map<String, dynamic>>? languages;
  final String? languageDesc;
  final List<Map<String, dynamic>>? traits;
  final List<Map<String, dynamic>>? subraces;
  final String? url;

  RaceModel({
    required this.index,
    required this.name,
    this.speed,
    this.abilityBonuses,
    this.alignment,
    this.age,
    this.size,
    this.sizeDescription,
    this.startingProficiencies,
    this.startingProficiencyOptions,
    this.languages,
    this.languageDesc,
    this.traits,
    this.subraces,
    this.url,
  });

  /// Создать из JSON (из API)
  factory RaceModel.fromJson(Map<String, dynamic> json) {
    return RaceModel(
      index: json['index'] as String,
      name: json['name'] as String,
      speed: json['speed'] as int?,
      abilityBonuses: json['ability_bonuses'] != null
          ? Map<String, int>.from(
              (json['ability_bonuses'] as List).asMap().map(
                    (i, e) => MapEntry(
                      (e as Map<String, dynamic>)['ability_score']['name'] as String,
                      (e as Map<String, dynamic>)['bonus'] as int,
                    ),
                  ),
            )
          : null,
      alignment: json['alignment'] as String?,
      age: json['age'] as String?,
      size: json['size'] as String?,
      sizeDescription: json['size_description'] as String?,
      startingProficiencies: json['starting_proficiencies'] != null
          ? List<Map<String, dynamic>>.from(json['starting_proficiencies'])
          : null,
      startingProficiencyOptions: json['starting_proficiency_options'] != null
          ? Map<String, dynamic>.from(json['starting_proficiency_options'])
          : null,
      languages: json['languages'] != null
          ? List<Map<String, dynamic>>.from(json['languages'])
          : null,
      languageDesc: json['language_desc'] as String?,
      traits: json['traits'] != null
          ? List<Map<String, dynamic>>.from(json['traits'])
          : null,
      subraces: json['subraces'] != null
          ? List<Map<String, dynamic>>.from(json['subraces'])
          : null,
      url: json['url'] as String?,
    );
  }

  /// Преобразовать в JSON
  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'name': name,
      'speed': speed,
      'ability_bonuses': abilityBonuses,
      'alignment': alignment,
      'age': age,
      'size': size,
      'size_description': sizeDescription,
      'starting_proficiencies': startingProficiencies,
      'starting_proficiency_options': startingProficiencyOptions,
      'languages': languages,
      'language_desc': languageDesc,
      'traits': traits,
      'subraces': subraces,
      'url': url,
    };
  }
}

