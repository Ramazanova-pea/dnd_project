import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '/core/constants/app_colors.dart';
import '/core/providers/reference_providers.dart';
import '/domain/models/reference/race_model.dart';

class RaceDetailScreen extends ConsumerStatefulWidget {
  final String raceId;

  const RaceDetailScreen({
    Key? key,
    required this.raceId,
  }) : super(key: key);

  @override
  ConsumerState<RaceDetailScreen> createState() => _RaceDetailScreenState();
}

class _RaceDetailScreenState extends ConsumerState<RaceDetailScreen> {
  // Маппинг имен рас на иконки и цвета для UI
  Map<String, dynamic> _getRaceStyle(String raceName) {
    final styles = <String, Map<String, dynamic>>{
      'human': {
        'icon': Icons.person,
        'color': AppColors.infoBlue,
      },
      'elf': {
        'icon': Icons.forest,
        'color': AppColors.successGreen,
      },
      'dwarf': {
        'icon': Icons.landscape,
        'color': AppColors.warningOrange,
      },
      'halfling': {
        'icon': Icons.grass,
        'color': AppColors.accentGold,
      },
      'gnome': {
        'icon': Icons.emoji_objects,
        'color': AppColors.primaryBrown,
      },
      'tiefling': {
        'icon': Icons.whatshot,
        'color': AppColors.errorRed,
      },
      'dragonborn': {
        'icon': Icons.pets,
        'color': const Color(0xFF9C27B0),
      },
      'half-orc': {
        'icon': Icons.fitness_center,
        'color': const Color(0xFF795548),
      },
    };
    return styles[raceName.toLowerCase()] ?? {
      'icon': Icons.person,
      'color': AppColors.primaryBrown,
    };
  }

  @override
  Widget build(BuildContext context) {
    final raceAsync = ref.watch(raceByIdProvider(widget.raceId));

    return raceAsync.when(
      data: (raceModel) {
        final style = _getRaceStyle(raceModel.index);
        final raceColor = style['color'] as Color;
        final raceIcon = style['icon'] as IconData;
        return _buildRaceDetail(raceModel, raceColor, raceIcon);
      },
      loading: () => Scaffold(
        backgroundColor: AppColors.getHomeBackground(context),
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryBrown,
          ),
        ),
      ),
      error: (error, stack) => Scaffold(
        backgroundColor: AppColors.getHomeBackground(context),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: AppColors.errorRed,
                size: 60,
              ),
              const SizedBox(height: 16),
              Text(
                'Ошибка загрузки расы',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.darkBrown,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.darkBrown.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRaceDetail(RaceModel raceModel, Color raceColor, IconData raceIcon) {
    return Scaffold(
      backgroundColor: AppColors.getHomeBackground(context),
      body: CustomScrollView(
        slivers: [
          // Заголовок экрана с изображением расы
          SliverAppBar(
            backgroundColor: raceColor,
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.pop(),
            ),
            title: Text(
              raceModel.name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 4.0,
                    color: Colors.black.withOpacity(0.5),
                    offset: const Offset(1, 1),
                  ),
                ],
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      raceColor,
                      raceColor.withOpacity(0.8),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 50.0, 16.0, 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Иконка расы
                      Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          raceIcon,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        raceModel.sizeDescription ?? raceModel.size ?? 'Раса',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Основной контент
          SliverPadding(
            padding: const EdgeInsets.all(12.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Блок с основной информацией
                _buildInfoSection(raceModel, raceColor),

                const SizedBox(height: 16),

                // Бонусы к характеристикам
                if (raceModel.abilityBonuses != null && raceModel.abilityBonuses!.isNotEmpty)
                  _buildAbilityScoresSection(raceModel, raceColor),

                const SizedBox(height: 16),

                // Особенности расы
                if (raceModel.traits != null && raceModel.traits!.isNotEmpty)
                  _buildTraitsSection(raceModel, raceColor),

                const SizedBox(height: 16),

                // Подрасы (если есть)
                if (raceModel.subraces != null && raceModel.subraces!.isNotEmpty)
                  _buildSubracesSection(raceModel, raceColor),

                const SizedBox(height: 16),

                // Дополнительная информация
                _buildAdditionalInfoSection(raceModel, raceColor),

                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(RaceModel raceModel, Color raceColor) {
    return Card(
      elevation: 1.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Описание',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: raceColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                raceModel.sizeDescription ?? 'Раса ${raceModel.name} из D&D 5e',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.darkBrown.withOpacity(0.8),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),
              Divider(
                color: AppColors.lightBrown.withOpacity(0.3),
                height: 1,
              ),
              const SizedBox(height: 12),
              // Основные параметры
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (raceModel.speed != null)
                    _buildInfoItem('Скорость', '${raceModel.speed} фт.', Icons.directions_run, raceColor),
                  if (raceModel.size != null)
                    _buildInfoItem('Размер', raceModel.size!, Icons.height, raceColor),
                  if (raceModel.age != null)
                    _buildInfoItem('Возраст', raceModel.age!, Icons.cake, raceColor),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 11,
            color: AppColors.darkBrown.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.darkBrown,
          ),
        ),
      ],
    );
  }

  Widget _buildAbilityScoresSection(RaceModel raceModel, Color raceColor) {
    return Card(
      elevation: 1.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Бонусы к характеристикам',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: raceColor,
                ),
              ),
              const SizedBox(height: 12),
              // Сетка характеристик
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 1.5,
                ),
                itemCount: raceModel.abilityBonuses!.length,
                itemBuilder: (context, index) {
                  final entry = raceModel.abilityBonuses!.entries.elementAt(index);
                  final abilityName = entry.key;
                  final bonus = entry.value;
                  return Container(
                    decoration: BoxDecoration(
                      color: raceColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: raceColor.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _getAbilityShortName(abilityName),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.darkBrown,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${bonus >= 0 ? '+' : ''}$bonus',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: raceColor,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getAbilityShortName(String abilityName) {
    final names = {
      'STR': 'СИЛ',
      'DEX': 'ЛОВ',
      'CON': 'ТЕЛ',
      'INT': 'ИНТ',
      'WIS': 'МДР',
      'CHA': 'ХАР',
    };
    return names[abilityName.toUpperCase()] ?? abilityName;
  }

  Widget _buildTraitsSection(RaceModel raceModel, Color raceColor) {
    return Card(
      elevation: 1.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Особенности расы',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: raceColor,
                ),
              ),
              const SizedBox(height: 12),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: raceModel.traits!.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final trait = raceModel.traits![index];
                  final traitName = trait['name'] as String? ?? '';
                  final traitDesc = trait['desc'] != null
                      ? (trait['desc'] as List).join('\n')
                      : '';
                  return Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: raceColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: raceColor.withOpacity(0.1),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6.0),
                          decoration: BoxDecoration(
                            color: raceColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.star,
                            color: raceColor,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                traitName,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.darkBrown,
                                ),
                              ),
                              if (traitDesc.isNotEmpty) ...[
                                const SizedBox(height: 2),
                                Text(
                                  traitDesc,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.darkBrown.withOpacity(0.7),
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubracesSection(RaceModel raceModel, Color raceColor) {
    return Card(
      elevation: 1.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Подрасы',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: raceColor,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Эта раса имеет несколько вариантов с уникальными особенностями:',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.darkBrown.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 8),
              ...raceModel.subraces!.map((subrace) {
                final subraceName = subrace['name'] as String? ?? '';
                final subraceDesc = subrace['desc'] != null
                    ? (subrace['desc'] as List).join('\n')
                    : '';
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: raceColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: raceColor.withOpacity(0.1),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subraceName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkBrown,
                        ),
                      ),
                      if (subraceDesc.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          subraceDesc,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.darkBrown.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdditionalInfoSection(RaceModel raceModel, Color raceColor) {
    return Card(
      elevation: 1.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Дополнительная информация',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: raceColor,
                ),
              ),
              const SizedBox(height: 12),

              // Языки
              if (raceModel.languages != null && raceModel.languages!.isNotEmpty)
                _buildAdditionalInfoItem(
                  'Языки',
                  raceModel.languages!.map((l) => l['name'] as String? ?? '').join(', '),
                  Icons.language,
                  raceColor,
                ),

              if (raceModel.languageDesc != null) ...[
                const SizedBox(height: 8),
                Text(
                  raceModel.languageDesc!,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.darkBrown.withOpacity(0.7),
                  ),
                ),
              ],

              const SizedBox(height: 8),

              // Мировоззрение
              if (raceModel.alignment != null)
                _buildAdditionalInfoItem(
                  'Мировоззрение',
                  raceModel.alignment!,
                  Icons.psychology,
                  raceColor,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdditionalInfoItem(String title, String value, IconData icon, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: color,
          size: 18,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.darkBrown,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.darkBrown.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
      '1': {
        'id': '1',
        'name': 'Человек',
        'description': 'Люди - самый разнообразный и адаптивный народ среди всех рас. Они быстро осваивают новые земли и культуры, что делает их доминирующей расой во многих регионах.',
        'icon': Icons.person,
        'color': AppColors.infoBlue,
        'traits': [
          {
            'name': 'Адаптируемость',
            'description': 'Получают +1 ко всем характеристикам',
            'icon': Icons.auto_awesome,
          },
          {
            'name': 'Дополнительный навык',
            'description': 'Владеют одним дополнительным навыком на выбор',
            'icon': Icons.school,
          },
          {
            'name': 'Универсальное обучение',
            'description': 'Выбирают одно умение владения на выбор',
            'icon': Icons.menu_book,
          },
        ],
        'abilities': [
          {'name': 'Сила', 'value': '+1'},
          {'name': 'Ловкость', 'value': '+1'},
          {'name': 'Телосложение', 'value': '+1'},
          {'name': 'Интеллект', 'value': '+1'},
          {'name': 'Мудрость', 'value': '+1'},
          {'name': 'Харизма', 'value': '+1'},
        ],
        'size': 'Средний',
        'speed': 30,
        'languages': ['Общий', 'Один на выбор'],
        'age': 'До 100 лет',
        'alignment': 'Любое',
        'features': [
          'Быстро адаптируются к новым условиям',
          'Обладают невероятным разнообразием внешности',
          'Стремятся к власти и достижениям',
        ],
        'subraces': [
          {'name': 'Стандартный', 'description': 'Классический вариант'},
          {'name': 'Вариант', 'description': 'С дополнительными умениями'},
        ],
      },
      '2': {
        'id': '2',
        'name': 'Эльф',
        'description': 'Эльфы - грациозный народ, живущий в гармонии с природой. Они известны своей красотой, долголетием и магическими способностями.',
        'icon': Icons.forest,
        'color': AppColors.successGreen,
        'traits': [
          {
            'name': 'Тёмное зрение',
            'description': 'Видят в темноте на расстоянии 60 футов',
            'icon': Icons.remove_red_eye,
          },
          {
            'name': 'Кeen Senses',
            'description': 'Владение навыком Восприятие',
            'icon': Icons.hearing,
          },
          {
            'name': 'Fey Ancestry',
            'description': 'Преимущество против чар и иммунитет к магическому сну',
            'icon': Icons.auto_awesome,
          },
        ],
        'abilities': [
          {'name': 'Ловкость', 'value': '+2'},
          {'name': 'Интеллект', 'value': '+1'},
        ],
        'size': 'Средний',
        'speed': 30,
        'languages': ['Общий', 'Эльфийский'],
        'age': 'До 750 лет',
        'alignment': 'Хаотично-добрый',
        'features': [
          'Не нуждаются во сне',
          'Имеют врождённую связь с магией',
          'Обладают изысканным вкусом и чувством прекрасного',
        ],
        'subraces': [
          {'name': 'Высший эльф', 'description': '+1 к Интеллекту, дополнительные заклинания'},
          {'name': 'Лесной эльф', 'description': '+1 к Мудрости, скрытность в лесу'},
          {'name': 'Тёмный эльф', 'description': '+1 к Харизме, превосходное тёмное зрение'},
        ],
      },
      '3': {
        'id': '3',
        'name': 'Дварф',
        'description': 'Дварфы - выносливый и искусный народ, живущий в горных крепостях. Они славятся как лучшие кузнецы, инженеры и воины.',
        'icon': Icons.landscape,
        'color': AppColors.warningOrange,
        'traits': [
          {
            'name': 'Тёмное зрение',
            'description': 'Видят в темноте на расстоянии 60 футов',
            'icon': Icons.remove_red_eye,
          },
          {
            'name': 'Устойчивость дварфа',
            'description': 'Преимущество против яда и сопротивление урону ядом',
            'icon': Icons.health_and_safety,
          },
          {
            'name': 'Боевая тренировка',
            'description': 'Владение боевым топором, ручным топором, лёгким и боевым молотом',
            'icon': Icons.sports_martial_arts,
          },
        ],
        'abilities': [
          {'name': 'Телосложение', 'value': '+2'},
          {'name': 'Мудрость', 'value': '+1'},
        ],
        'size': 'Средний',
        'speed': 25,
        'languages': ['Общий', 'Дварфский'],
        'age': 'До 350 лет',
        'alignment': 'Законопослушный-добрый',
        'features': [
          'Иммунитет к ядам',
          'Знание каменной кладки',
          'Устойчивы к магии',
        ],
        'subraces': [
          {'name': 'Горный дварф', 'description': '+2 к Силе, владение лёгкими и средними доспехами'},
          {'name': 'Холмовой дварф', 'value': '+1 к Мудрости, дополнительные хиты'},
        ],
      },
    };

    setState(() {
      _race = racesData[widget.raceId];
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_race == null) {
      return Scaffold(
        backgroundColor: AppColors.getHomeBackground(context),
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryBrown,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.getHomeBackground(context),
      body: CustomScrollView(
        slivers: [
          // Заголовок экрана с изображением расы
          SliverAppBar(
            backgroundColor: _race!['color'],
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.pop(),
            ),
            title: Text(
              _race!['name'],
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 4.0,
                    color: Colors.black.withOpacity(0.5),
                    offset: const Offset(1, 1),
                  ),
                ],
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _race!['color'],
                      _race!['color'].withOpacity(0.8),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 50.0, 16.0, 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Иконка расы
                      Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _race!['icon'],
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _race!['description'].split('.')[0] + '.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Основной контент
          SliverPadding(
            padding: const EdgeInsets.all(12.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Блок с основной информацией
                _buildInfoSection(),

                const SizedBox(height: 16),

                // Бонусы к характеристикам
                _buildAbilityScoresSection(),

                const SizedBox(height: 16),

                // Особенности расы
                _buildTraitsSection(),

                const SizedBox(height: 16),

                // Подрасы (если есть)
                if (_race!['subraces'] != null && (_race!['subraces'] as List).isNotEmpty)
                  _buildSubracesSection(),

                const SizedBox(height: 16),

                // Дополнительная информация
                _buildAdditionalInfoSection(),

                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
    return Card(
      elevation: 1.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Описание',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _race!['color'],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _race!['description'],
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.darkBrown.withOpacity(0.8),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),
              Divider(
                color: AppColors.lightBrown.withOpacity(0.3),
                height: 1,
              ),
              const SizedBox(height: 12),
              // Основные параметры
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildInfoItem('Скорость', '${_race!['speed']} фт.', Icons.directions_run),
                  _buildInfoItem('Размер', _race!['size'], Icons.height),
                  _buildInfoItem('Возраст', _race!['age'], Icons.cake),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: _race!['color'],
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 11,
            color: AppColors.darkBrown.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.darkBrown,
          ),
        ),
      ],
    );
  }

  Widget _buildAbilityScoresSection() {
    return Card(
      elevation: 1.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Бонусы к характеристикам',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _race!['color'],
                ),
              ),
              const SizedBox(height: 12),
              // Сетка характеристик
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 1.5,
                ),
                itemCount: _race!['abilities'].length,
                itemBuilder: (context, index) {
                  final ability = _race!['abilities'][index];
                  return Container(
                    decoration: BoxDecoration(
                      color: _race!['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: _race!['color'].withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          ability['name'],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.darkBrown,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          ability['value'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _race!['color'],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTraitsSection() {
    final traits = _race!['traits'] as List;

    return Card(
      elevation: 1.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Особенности расы',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _race!['color'],
                ),
              ),
              const SizedBox(height: 12),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: traits.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final trait = traits[index];
                  return Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: _race!['color'].withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: _race!['color'].withOpacity(0.1),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6.0),
                          decoration: BoxDecoration(
                            color: _race!['color'].withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            trait['icon'],
                            color: _race!['color'],
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                trait['name'],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.darkBrown,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                trait['description'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.darkBrown.withOpacity(0.7),
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubracesSection() {
    final subraces = _race!['subraces'] as List;

    return Card(
      elevation: 1.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Подрасы',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _race!['color'],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Эта раса имеет несколько вариантов с уникальными особенностями:',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.darkBrown.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 8),
              ...subraces.map((subrace) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: _race!['color'].withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: _race!['color'].withOpacity(0.1),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subrace['name'],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkBrown,
                        ),
                      ),
                      if (subrace['description'] != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subrace['description'],
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.darkBrown.withOpacity(0.7),
                          ),
                        ),
                      ],
                      if (subrace['value'] != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subrace['value'],
                          style: TextStyle(
                            fontSize: 12,
                            color: _race!['color'],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdditionalInfoSection() {
    return Card(
      elevation: 1.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Дополнительная информация',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _race!['color'],
                ),
              ),
              const SizedBox(height: 12),

              // Языки
              _buildAdditionalInfoItem(
                'Языки',
                _race!['languages'].join(', '),
                Icons.language,
              ),

              const SizedBox(height: 8),

              // Мировоззрение
              _buildAdditionalInfoItem(
                'Мировоззрение',
                _race!['alignment'],
                Icons.psychology,
              ),

              const SizedBox(height: 8),

              // Особенности
              if (_race!['features'] != null && (_race!['features'] as List).isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: _race!['color'],
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Ключевые особенности:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.darkBrown,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ...(_race!['features'] as List).map((feature) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 26.0, top: 2.0),
                        child: Text(
                          '• $feature',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.darkBrown.withOpacity(0.7),
                            height: 1.4,
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdditionalInfoItem(String title, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: _race!['color'],
          size: 18,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.darkBrown,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.darkBrown.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}