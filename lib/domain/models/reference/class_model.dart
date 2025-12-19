/// Доменная модель класса персонажа из D&D 5e
class ClassModel {
  final String index;
  final String name;
  final int? hitDie;
  final List<String>? proficiencyChoices;
  final List<Map<String, dynamic>>? proficiencies;
  final List<Map<String, dynamic>>? savingThrows;
  final Map<String, dynamic>? startingEquipment;
  final String? url;

  ClassModel({
    required this.index,
    required this.name,
    this.hitDie,
    this.proficiencyChoices,
    this.proficiencies,
    this.savingThrows,
    this.startingEquipment,
    this.url,
  });

  /// Создать из JSON (из API)
  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      index: json['index'] as String,
      name: json['name'] as String,
      hitDie: json['hit_die'] as int?,
      proficiencyChoices: json['proficiency_choices'] != null
          ? (json['proficiency_choices'] as List)
              .map((e) => e.toString())
              .toList()
          : null,
      proficiencies: json['proficiencies'] != null
          ? List<Map<String, dynamic>>.from(json['proficiencies'])
          : null,
      savingThrows: json['saving_throws'] != null
          ? List<Map<String, dynamic>>.from(json['saving_throws'])
          : null,
      startingEquipment: json['starting_equipment'] != null
          ? Map<String, dynamic>.from(json['starting_equipment'])
          : null,
      url: json['url'] as String?,
    );
  }

  /// Преобразовать в JSON
  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'name': name,
      'hit_die': hitDie,
      'proficiency_choices': proficiencyChoices,
      'proficiencies': proficiencies,
      'saving_throws': savingThrows,
      'starting_equipment': startingEquipment,
      'url': url,
    };
  }
}

