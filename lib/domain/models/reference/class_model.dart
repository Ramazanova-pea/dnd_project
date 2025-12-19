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
    // Безопасная обработка списка объектов в список карт
    List<Map<String, dynamic>>? parseListOfMaps(dynamic value) {
      if (value == null) return null;
      if (value is List) {
        return value.map((e) {
          if (e is Map) {
            return Map<String, dynamic>.from(e);
          } else if (e is Map<String, dynamic>) {
            return e;
          } else {
            // Если элемент не карта, создаем карту с именем
            return {'name': e.toString()};
          }
        }).toList();
      }
      return null;
    }

    // Обработка starting_equipment - может быть список или карта
    Map<String, dynamic>? parseStartingEquipment(dynamic value) {
      if (value == null) return null;
      if (value is Map) {
        return Map<String, dynamic>.from(value);
      }
      if (value is Map<String, dynamic>) {
        return value;
      }
      if (value is List) {
        return {'items': value};
      }
      return null;
    }

    return ClassModel(
      index: json['index'] as String,
      name: json['name'] as String,
      hitDie: json['hit_die'] as int?,
      proficiencyChoices: json['proficiency_choices'] != null
          ? (json['proficiency_choices'] as List)
              .map((e) => e.toString())
              .toList()
          : null,
      proficiencies: parseListOfMaps(json['proficiencies']),
      savingThrows: parseListOfMaps(json['saving_throws']),
      startingEquipment: parseStartingEquipment(json['starting_equipment']),
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

