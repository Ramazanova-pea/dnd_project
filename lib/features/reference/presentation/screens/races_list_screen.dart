import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '/core/constants/app_colors.dart';
import '/core/providers/reference_providers.dart';
import '/domain/models/reference/race_model.dart';

class RacesListScreen extends ConsumerStatefulWidget {
  const RacesListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RacesListScreen> createState() => _RacesListScreenState();
}

class _RacesListScreenState extends ConsumerState<RacesListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

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

  List<RaceModel> _filterRaces(List<RaceModel> races) {
    final query = _searchController.text.toLowerCase();

    return races.where((race) {
      return query.isEmpty ||
          race.name.toLowerCase().contains(query) ||
          (race.size != null && race.size!.toLowerCase().contains(query));
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {}); // Обновляем UI при изменении поиска
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final racesAsync = ref.watch(racesProvider);

    return Scaffold(
      backgroundColor: AppColors.getHomeBackground(context),
      body: CustomScrollView(
        slivers: [
          // Заголовок экрана
          SliverAppBar(
            backgroundColor: AppColors.primaryBrown,
            expandedHeight: 140.0,
            floating: false,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.pop(),
            ),
            title: Text(
              'Расы',
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
                      AppColors.infoBlue.withOpacity(0.7),
                      AppColors.primaryBrown,
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 50.0, 16.0, 12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Народы и происхождения',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.parchment,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      racesAsync.when(
                        data: (races) => Text(
                          '${races.length} рас доступно',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.lightBrown,
                            height: 1.2,
                          ),
                        ),
                        loading: () => Text(
                          'Загрузка...',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.lightBrown,
                            height: 1.2,
                          ),
                        ),
                        error: (_, __) => Text(
                          'Ошибка загрузки',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.lightBrown,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Поле поиска
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
            sliver: SliverToBoxAdapter(
              child: Container(
                height: 45.0,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: AppColors.lightBrown.withOpacity(0.3),
                    width: 0.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    Icon(
                      Icons.search,
                      color: AppColors.darkBrown.withOpacity(0.5),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        decoration: InputDecoration(
                          hintText: 'Поиск рас...',
                          hintStyle: TextStyle(
                            color: AppColors.darkBrown.withOpacity(0.4),
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.darkBrown,
                        ),
                      ),
                    ),
                    if (_searchController.text.isNotEmpty)
                      IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: AppColors.darkBrown.withOpacity(0.5),
                          size: 18,
                        ),
                        onPressed: () {
                          _searchController.clear();
                        },
                      ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
            ),
          ),

          // Список рас
          racesAsync.when(
            data: (races) {
              final filtered = _filterRaces(races);
              if (filtered.isNotEmpty) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildRaceCard(filtered[index]),
                    childCount: filtered.length,
                  ),
                );
              } else {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          color: AppColors.darkBrown.withOpacity(0.3),
                          size: 60,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Расы не найдены',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.darkBrown.withOpacity(0.5),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Попробуйте изменить запрос',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.darkBrown.withOpacity(0.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
            loading: () => SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryBrown,
                ),
              ),
            ),
            error: (error, stack) => SliverFillRemaining(
              child: Center(
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
                      'Ошибка загрузки рас',
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
          ),

          // Информация о расах
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
            sliver: SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: AppColors.parchment.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: AppColors.lightBrown.withOpacity(0.15),
                    width: 0.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppColors.infoBlue,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Что такое расы?',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.darkBrown,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Расы определяют происхождение и физические особенности персонажа. '
                          'Каждая раса даёт уникальные способности, бонусы к характеристикам '
                          'и особенности, влияющие на игровой процесс.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.darkBrown.withOpacity(0.7),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Карточка расы
  Widget _buildRaceCard(RaceModel race) {
    final style = _getRaceStyle(race.index);
    final raceColor = style['color'] as Color;
    final raceIcon = style['icon'] as IconData;

    return Container(
      height: 80.0, // Фиксированная высота карточки
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: Card(
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(10.0),
          onTap: () {
            // Навигация к детальной информации о расе
            context.go('/home/reference/races/${race.index}');
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  raceColor.withOpacity(0.12),
                  raceColor.withOpacity(0.05),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Row(
                children: [
                  // Иконка расы
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: raceColor.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      raceIcon,
                      color: raceColor,
                      size: 20,
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Основная информация
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          race.name,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkBrown,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          race.sizeDescription ?? race.size ?? 'Раса',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.darkBrown.withOpacity(0.6),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // Статистика и иконка
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Скорость
                      if (race.speed != null)
                        Row(
                          children: [
                            Icon(
                              Icons.directions_run,
                              color: raceColor,
                              size: 12,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${race.speed}',
                              style: TextStyle(
                                fontSize: 10,
                                color: raceColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 2),
                      // Размер
                      if (race.size != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6.0,
                            vertical: 2.0,
                          ),
                          decoration: BoxDecoration(
                            color: raceColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: Text(
                            race.size![0], // Первая буква размера
                            style: TextStyle(
                              fontSize: 10,
                              color: raceColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(width: 8),

                  // Стрелка
                  Icon(
                    Icons.arrow_forward_ios,
                    color: raceColor,
                    size: 12,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
    {
      'id': '1',
      'name': 'Человек',
      'description': 'Адаптивные и разнообразные',
      'icon': Icons.person,
      'color': AppColors.infoBlue,
      'traits': ['Адаптируемость', 'Дополнительный навык'],
      'size': 'Средний',
      'speed': 30,
    },
    {
      'id': '2',
      'name': 'Эльф',
      'description': 'Грациозные и долгоживущие',
      'icon': Icons.forest,
      'color': AppColors.successGreen,
      'traits': ['Тёмное зрение', 'Преимущество против чар'],
      'size': 'Средний',
      'speed': 30,
    },
    {
      'id': '3',
      'name': 'Дварф',
      'description': 'Выносливые и искусные мастера',
      'icon': Icons.landscape,
      'color': AppColors.warningOrange,
      'traits': ['Тёмное зрение', 'Сопротивление яду'],
      'size': 'Средний',
      'speed': 25,
    },
    {
      'id': '4',
      'name': 'Халфлинг',
      'description': 'Ловкие и удачливые',
      'icon': Icons.grass,
      'color': AppColors.accentGold,
      'traits': ['Удачливость', 'Смелость'],
      'size': 'Маленький',
      'speed': 25,
    },
    {
      'id': '5',
      'name': 'Гном',
      'description': 'Изобретательные и любознательные',
      'icon': Icons.emoji_objects,
      'color': AppColors.primaryBrown,
      'traits': ['Тёмное зрение', 'Мастерство гнома'],
      'size': 'Маленький',
      'speed': 25,
    },
    {
      'id': '6',
      'name': 'Тифлинг',
      'description': 'Потомки демонов',
      'icon': Icons.whatshot,
      'color': AppColors.errorRed,
      'traits': ['Тёмное зрение', 'Адское сопротивление'],
      'size': 'Средний',
      'speed': 30,
    },
    {
      'id': '7',
      'name': 'Драконорождённый',
      'description': 'Потомки драконов',
      'icon': Icons.pets,
      'color': const Color(0xFF9C27B0),
      'traits': ['Дыхание дракона', 'Сопротивление урону'],
      'size': 'Средний',
      'speed': 30,
    },
    {
      'id': '8',
      'name': 'Полуорк',
      'description': 'Сильные и свирепые',
      'icon': Icons.fitness_center,
      'color': const Color(0xFF795548),
      'traits': ['Тёмное зрение', 'Свирепость'],
      'size': 'Средний',
      'speed': 30,
    },
  ];

  List<Map<String, dynamic>> _filteredRaces = [];

  @override
  void initState() {
    super.initState();
    _filteredRaces = _races;
    _searchController.addListener(_filterRaces);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _filterRaces() {
    final query = _searchController.text.toLowerCase();

    if (query.isEmpty) {
      setState(() {
        _filteredRaces = _races;
      });
    } else {
      setState(() {
        _filteredRaces = _races.where((race) {
          return race['name'].toLowerCase().contains(query) ||
              race['description'].toLowerCase().contains(query) ||
              race['traits'].any((trait) => trait.toLowerCase().contains(query));
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getHomeBackground(context),
      body: CustomScrollView(
        slivers: [
          // Заголовок экрана
          SliverAppBar(
            backgroundColor: AppColors.primaryBrown,
            expandedHeight: 140.0,
            floating: false,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.pop(),
            ),
            title: Text(
              'Расы',
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
                      AppColors.infoBlue.withOpacity(0.7),
                      AppColors.primaryBrown,
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 50.0, 16.0, 12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Народы и происхождения',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.parchment,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${_races.length} рас доступно',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.lightBrown,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Поле поиска
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
            sliver: SliverToBoxAdapter(
              child: Container(
                height: 45.0,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: AppColors.lightBrown.withOpacity(0.3),
                    width: 0.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    Icon(
                      Icons.search,
                      color: AppColors.darkBrown.withOpacity(0.5),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        decoration: InputDecoration(
                          hintText: 'Поиск рас...',
                          hintStyle: TextStyle(
                            color: AppColors.darkBrown.withOpacity(0.4),
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.darkBrown,
                        ),
                      ),
                    ),
                    if (_searchController.text.isNotEmpty)
                      IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: AppColors.darkBrown.withOpacity(0.5),
                          size: 18,
                        ),
                        onPressed: () {
                          _searchController.clear();
                        },
                      ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
            ),
          ),

          // Список рас
          if (_filteredRaces.isNotEmpty)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildRaceCard(_filteredRaces[index]),
                childCount: _filteredRaces.length,
              ),
            )
          else
          // Сообщение, если ничего не найдено
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off,
                      color: AppColors.darkBrown.withOpacity(0.3),
                      size: 60,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Расы не найдены',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.darkBrown.withOpacity(0.5),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Попробуйте изменить запрос',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.darkBrown.withOpacity(0.4),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Информация о расах
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
            sliver: SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: AppColors.parchment.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: AppColors.lightBrown.withOpacity(0.15),
                    width: 0.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppColors.infoBlue,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Что такое расы?',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.darkBrown,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Расы определяют происхождение и физические особенности персонажа. '
                          'Каждая раса даёт уникальные способности, бонусы к характеристикам '
                          'и особенности, влияющие на игровой процесс.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.darkBrown.withOpacity(0.7),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Карточка расы
  Widget _buildRaceCard(Map<String, dynamic> race) {
    return Container(
      height: 80.0, // Фиксированная высота карточки
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: Card(
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(10.0),
          onTap: () {
            // Навигация к детальной информации о расе
            context.go('/home/reference/races/${race['id']}');
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  race['color'].withOpacity(0.12),
                  race['color'].withOpacity(0.05),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Row(
                children: [
                  // Иконка расы
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: race['color'].withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      race['icon'],
                      color: race['color'],
                      size: 20,
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Основная информация
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          race['name'],
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkBrown,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          race['description'],
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.darkBrown.withOpacity(0.6),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // Статистика и иконка
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Скорость
                      Row(
                        children: [
                          Icon(
                            Icons.directions_run,
                            color: race['color'],
                            size: 12,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${race['speed']}',
                            style: TextStyle(
                              fontSize: 10,
                              color: race['color'],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      // Размер
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6.0,
                          vertical: 2.0,
                        ),
                        decoration: BoxDecoration(
                          color: race['color'].withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        child: Text(
                          race['size'][0], // Первая буква размера
                          style: TextStyle(
                            fontSize: 10,
                            color: race['color'],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 8),

                  // Стрелка
                  Icon(
                    Icons.arrow_forward_ios,
                    color: race['color'],
                    size: 12,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}