import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '/core/constants/app_colors.dart';
import '/core/providers/reference_providers.dart';
import '/domain/models/reference/class_model.dart';

class ClassesListScreen extends ConsumerStatefulWidget {
  const ClassesListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ClassesListScreen> createState() => _ClassesListScreenState();
}

class _ClassesListScreenState extends ConsumerState<ClassesListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  // Фильтры
  String _selectedRole = 'Все';
  String _selectedPowerSource = 'Все';

  final List<String> _roleOptions = ['Все', 'Защитник', 'Контроллер', 'Лидер', 'Штурмовик'];
  final List<String> _powerSourceOptions = ['Все', 'Божественная', 'Марсиальная', 'Аркана', 'Природная'];

  // Маппинг имен классов на иконки и цвета для UI
  Map<String, dynamic> _getClassStyle(String className) {
    final styles = <String, Map<String, dynamic>>{
      'barbarian': {
        'icon': Icons.fitness_center,
        'color': const Color(0xFF795548),
      },
      'bard': {
        'icon': Icons.music_note,
        'color': const Color(0xFF9C27B0),
      },
      'cleric': {
        'icon': Icons.emoji_people,
        'color': const Color(0xFFF9A825),
      },
      'druid': {
        'icon': Icons.forest,
        'color': const Color(0xFF2E7D32),
      },
      'fighter': {
        'icon': Icons.sports_martial_arts,
        'color': const Color(0xFFC62828),
      },
      'monk': {
        'icon': Icons.sports_kabaddi,
        'color': const Color(0xFFEF6C00),
      },
      'paladin': {
        'icon': Icons.shield,
        'color': const Color(0xFFD32F2F),
      },
      'ranger': {
        'icon': Icons.travel_explore,
        'color': const Color(0xFF689F38),
      },
      'rogue': {
        'icon': Icons.directions_run,
        'color': const Color(0xFF4CAF50),
      },
      'sorcerer': {
        'icon': Icons.flash_on,
        'color': const Color(0xFF0277BD),
      },
      'warlock': {
        'icon': Icons.auto_fix_high,
        'color': const Color(0xFF512DA8),
      },
      'wizard': {
        'icon': Icons.auto_awesome,
        'color': const Color(0xFF1565C0),
      },
    };
    return styles[className.toLowerCase()] ?? {
      'icon': Icons.person,
      'color': AppColors.primaryBrown,
    };
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

  List<ClassModel> _filterClasses(List<ClassModel> classes) {
    final query = _searchController.text.toLowerCase();

    return classes.where((cls) {
      final matchesSearch = query.isEmpty ||
          cls.name.toLowerCase().contains(query) ||
          cls.index.toLowerCase().contains(query);

      // Фильтры по роли и источнику силы не применяем, так как API не предоставляет эти данные
      return matchesSearch;
    }).toList();
  }

  void _resetFilters() {
    setState(() {
      _selectedRole = 'Все';
      _selectedPowerSource = 'Все';
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getHomeBackground(context),
      body: CustomScrollView(
        slivers: [
          // Заголовок экрана
          SliverAppBar(
            backgroundColor: AppColors.successGreen,
            expandedHeight: 140.0,
            floating: false,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.pop(),
            ),
            title: Text(
              'Классы',
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
                      AppColors.successGreen.withOpacity(0.8),
                      AppColors.darkBrown,
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
                        'Профессии и специализации',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.parchment,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Consumer(
                        builder: (context, ref, child) {
                          final classesAsync = ref.watch(classesProvider);
                          return classesAsync.when(
                            data: (classes) => Text(
                              '${_filterClasses(classes).length} из ${classes.length} классов',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.lightBrown,
                                height: 1.2,
                              ),
                            ),
                            loading: () => const SizedBox.shrink(),
                            error: (_, __) => const SizedBox.shrink(),
                          );
                        },
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
                          hintText: 'Поиск классов...',
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

          // Фильтры
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Фильтры:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.darkBrown,
                        ),
                      ),
                      TextButton(
                        onPressed: _resetFilters,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Сбросить',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.successGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Выпадающие списки фильтров
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterDropdown(
                          value: _selectedRole,
                          items: _roleOptions,
                          hint: 'Роль',
                          onChanged: (value) {
                            setState(() {
                              _selectedRole = value!;
                            });
                          },
                          icon: Icons.group,
                        ),

                        const SizedBox(width: 8),

                        _buildFilterDropdown(
                          value: _selectedPowerSource,
                          items: _powerSourceOptions,
                          hint: 'Источник силы',
                          onChanged: (value) {
                            setState(() {
                              _selectedPowerSource = value!;
                            });
                          },
                          icon: Icons.power,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),

          // Список классов
          Consumer(
            builder: (context, ref, child) {
              final classesAsync = ref.watch(classesProvider);
              return classesAsync.when(
                data: (classes) {
                  final filtered = _filterClasses(classes);
                  if (filtered.isNotEmpty) {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => _buildClassCard(filtered[index]),
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
                              'Классы не найдены',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.darkBrown.withOpacity(0.5),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Попробуйте изменить поисковый запрос',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.darkBrown.withOpacity(0.4),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: _resetFilters,
                              child: Text(
                                'Сбросить фильтры',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.successGreen,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
                loading: () => const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(),
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
                          'Ошибка загрузки классов',
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
            },
          ),

          // Информация о классах
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
                          color: AppColors.successGreen,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Что такое классы?',
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
                      'Класс определяет основные способности, навыки и стиль игры персонажа. '
                          'Каждый класс имеет уникальные особенности, прогрессию и возможности развития.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.darkBrown.withOpacity(0.7),
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Легенда ролей
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Роли в группе:',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.darkBrown,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            _buildRoleLegend('Защитник', 'Защищает союзников', Icons.shield),
                            _buildRoleLegend('Контроллер', 'Управляет полем боя', Icons.auto_awesome),
                            _buildRoleLegend('Лидер', 'Поддерживает группу', Icons.emoji_people),
                            _buildRoleLegend('Штурмовик', 'Наносит урон', Icons.flash_on),
                          ],
                        ),
                      ],
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

  Widget _buildFilterDropdown({
    required String value,
    required List<String> items,
    required String hint,
    required ValueChanged<String?> onChanged,
    required IconData icon,
  }) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.lightBrown.withOpacity(0.3),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: AppColors.darkBrown.withOpacity(0.6),
            size: 16,
          ),
          const SizedBox(width: 4),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              icon: Icon(
                Icons.arrow_drop_down,
                color: AppColors.darkBrown.withOpacity(0.6),
                size: 20,
              ),
              iconSize: 16,
              elevation: 8,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.darkBrown,
              ),
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.circular(8),
              onChanged: onChanged,
              items: items.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.darkBrown,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleLegend(String role, String description, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(6.0),
        border: Border.all(
          color: AppColors.lightBrown.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: AppColors.darkBrown.withOpacity(0.7),
          ),
          const SizedBox(width: 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                role,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkBrown,
                ),
              ),
              Text(
                description,
                style: TextStyle(
                  fontSize: 9,
                  color: AppColors.darkBrown.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Карточка класса
  Widget _buildClassCard(ClassModel cls) {
    final style = _getClassStyle(cls.index);
    final classColor = style['color'] as Color;
    final classIcon = style['icon'] as IconData;
    final hitDie = cls.hitDie != null ? 'd${cls.hitDie}' : 'N/A';

    return Container(
      height: 80.0,
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: Card(
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(10.0),
          onTap: () {
            // Навигация к детальной информации о классе
            context.go('/home/reference/classes/${cls.index}');
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  classColor.withOpacity(0.12),
                  classColor.withOpacity(0.05),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Row(
                children: [
                  // Иконка класса
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: classColor.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      classIcon,
                      color: classColor,
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
                          cls.name,
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
                          'Класс персонажа',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.darkBrown.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Статистика
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Кость хитов
                      Row(
                        children: [
                          Icon(
                            Icons.favorite,
                            color: classColor,
                            size: 10,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            hitDie,
                            style: TextStyle(
                              fontSize: 12,
                              color: classColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(width: 8),

                  // Стрелка
                  Icon(
                    Icons.arrow_forward_ios,
                    color: classColor,
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