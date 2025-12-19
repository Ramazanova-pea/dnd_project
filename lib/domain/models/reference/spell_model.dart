/// Доменная модель заклинания из D&D 5e
class SpellModel {
  final String index;
  final String name;
  final List<String>? desc;
  final String? higherLevel;
  final String? range;
  final List<String>? components;
  final String? material;
  final bool? ritual;
  final String? duration;
  final bool? concentration;
  final String? castingTime;
  final int? level;
  final Map<String, dynamic>? school;
  final List<Map<String, dynamic>>? classes;
  final List<Map<String, dynamic>>? subclasses;
  final String? url;

  SpellModel({
    required this.index,
    required this.name,
    this.desc,
    this.higherLevel,
    this.range,
    this.components,
    this.material,
    this.ritual,
    this.duration,
    this.concentration,
    this.castingTime,
    this.level,
    this.school,
    this.classes,
    this.subclasses,
    this.url,
  });

  /// Создать из JSON (из API)
  factory SpellModel.fromJson(Map<String, dynamic> json) {
    return SpellModel(
      index: json['index'] as String,
      name: json['name'] as String,
      desc: json['desc'] != null ? List<String>.from(json['desc']) : null,
      higherLevel: json['higher_level'] != null
          ? (json['higher_level'] as List).join('\n')
          : null,
      range: json['range'] as String?,
      components: json['components'] != null
          ? List<String>.from(json['components'])
          : null,
      material: json['material'] as String?,
      ritual: json['ritual'] as bool?,
      duration: json['duration'] as String?,
      concentration: json['concentration'] as bool?,
      castingTime: json['casting_time'] as String?,
      level: json['level'] as int?,
      school: json['school'] != null
          ? Map<String, dynamic>.from(json['school'])
          : null,
      classes: json['classes'] != null
          ? List<Map<String, dynamic>>.from(json['classes'])
          : null,
      subclasses: json['subclasses'] != null
          ? List<Map<String, dynamic>>.from(json['subclasses'])
          : null,
      url: json['url'] as String?,
    );
  }

  /// Преобразовать в JSON
  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'name': name,
      'desc': desc,
      'higher_level': higherLevel,
      'range': range,
      'components': components,
      'material': material,
      'ritual': ritual,
      'duration': duration,
      'concentration': concentration,
      'casting_time': castingTime,
      'level': level,
      'school': school,
      'classes': classes,
      'subclasses': subclasses,
      'url': url,
    };
  }
}

