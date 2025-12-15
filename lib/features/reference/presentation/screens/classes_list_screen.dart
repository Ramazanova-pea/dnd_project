import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '/core/constants/app_colors.dart';

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

  // Пример данных о классах
  final List<Map<String, dynamic>> _classes = [
    {
      'id': '1',
      'name': 'Воин',
      'description': 'Мастер оружия и доспехов',
      'icon': Icons.sports_martial_arts,
      'color': const Color(0xFFC62828),
      'role': 'Защитник',
      'powerSource': 'Марсиальная',
      'primaryAbility': 'Сила',
      'hitDie': 'd10',
      'armor': 'Все доспехи, щиты',
      'weapons': 'Простое и воинское оружие',
      'skills': 2,
      'spellcasting': false,
    },
    {
      'id': '2',
      'name': 'Волшебник',
      'description': 'Мастер арканной магии',
      'icon': Icons.auto_awesome,
      'color': const Color(0xFF1565C0),
      'role': 'Контроллер',
      'powerSource': 'Аркана',
      'primaryAbility': 'Интеллект',
      'hitDie': 'd6',
      'armor': 'Нет',
      'weapons': 'Кинжалы, дротики, пращи, посохи, лёгкие арбалеты',
      'skills': 2,
      'spellcasting': true,
    },
    {
      'id': '3',
      'name': 'Жрец',
      'description': 'Посредник между смертными и божествами',
      'icon': Icons.emoji_people,
      'color': const Color(0xFFF9A825),
      'role': 'Лидер',
      'powerSource': 'Божественная',
      'primaryAbility': 'Мудрость',
      'hitDie': 'd8',
      'armor': 'Лёгкие и средние доспехи, щиты',
      'weapons': 'Простое оружие',
      'skills': 2,
      'spellcasting': true,
    },
    {
      'id': '4',
      'name': 'Плут',
      'description': 'Мастер скрытности и хитрости',
      'icon': Icons.directions_run,
      'color': const Color(0xFF4CAF50),
      'role': 'Штурмовик',
      'powerSource': 'Марсиальная',
      'primaryAbility': 'Ловкость',
      'hitDie': 'd8',
      'armor': 'Лёгкие доспехи',
      'weapons': 'Простое оружие, арбалеты, длинные мечи, рапиры, короткие мечи',
      'skills': 4,
      'spellcasting': false,
    },
    {
      'id': '5',
      'name': 'Варвар',
      'description': 'Неистовый воин-берсерк',
      'icon': Icons.fitness_center,
      'color': const Color(0xFF795548),
      'role': 'Штурмовик',
      'powerSource': 'Марсиальная',
      'primaryAbility': 'Сила',
      'hitDie': 'd12',
      'armor': 'Лёгкие и средние доспехи, щиты',
      'weapons': 'Простое и воинское оружие',
      'skills': 2,
      'spellcasting': false,
    },
    {
      'id': '6',
      'name': 'Бард',
      'description': 'Вдохновитель через музыку и магию',
      'icon': Icons.music_note,
      'color': const Color(0xFF9C27B0),
      'role': 'Лидер',
      'powerSource': 'Аркана',
      'primaryAbility': 'Харизма',
      'hitDie': 'd8',
      'armor': 'Лёгкие доспехи',
      'weapons': 'Простое оружие, длинные мечи, рапиры, короткие мечи, короткие луки',
      'skills': 3,
      'spellcasting': true,
    },
    {
      'id': '7',
      'name': 'Друид',
      'description': 'Жрец дикой природы',
      'icon': Icons.forest,
      'color': const Color(0xFF2E7D32),
      'role': 'Контроллер',
      'powerSource': 'Природная',
      'primaryAbility': 'Мудрость',
      'hitDie': 'd8',
      'armor': 'Лёгкие и средние доспехи, щиты (не металлические)',
      'weapons': 'Булавы, кинжалы, дротики, пращи, посохи, серпы, копья',
      'skills': 2,
      'spellcasting': true,
    },
    {
      'id': '8',
      'name': 'Паладин',
      'description': 'Святой воин, клятвенный защитник',
      'icon': Icons.shield,
      'color': const Color(0xFFD32F2F),
      'role': 'Защитник',
      'powerSource': 'Божественная',
      'primaryAbility': 'Сила и Харизма',
      'hitDie': 'd10',
      'armor': 'Все доспехи, щиты',
      'weapons': 'Простое и воинское оружие',
      'skills': 2,
      'spellcasting': true,
    },
    {
      'id': '9',
      'name': 'Следопыт',
      'description': 'Охотник и выживальщик',
      'icon': Icons.travel_explore,
      'color': const Color(0xFF689F38),
      'role': 'Штурмовик',
      'powerSource': 'Природная',
      'primaryAbility': 'Ловкость и Мудрость',
      'hitDie': 'd10',
      'armor': 'Лёгкие и средние доспехи, щиты',
      'weapons': 'Простое и воинское оружие',
      'skills': 3,
      'spellcasting': true,
    },
    {
      'id': '10',
      'name': 'Чародей',
      'description': 'Маг с врождённой магической силой',
      'icon': Icons.flash_on,
      'color': const Color(0xFF0277BD),
      'role': 'Штурмовик',
      'powerSource': 'Аркана',
      'primaryAbility': 'Харизма',
      'hitDie': 'd6',
      'armor': 'Нет',
      'weapons': 'Кинжалы, дротики, пращи, посохи, лёгкие арбалеты',
      'skills': 2,
      'spellcasting': true,
    },
    {
      'id': '11',
      'name': 'Колдун',
      'description': 'Заключивший сделку с потусторонней сущностью',
      'icon': Icons.auto_fix_high,
      'color': const Color(0xFF512DA8),
      'role': 'Штурмовик',
      'powerSource': 'Аркана',
      'primaryAbility': 'Харизма',
      'hitDie': 'd8',
      'armor': 'Лёгкие доспехи',
      'weapons': 'Простое оружие',
      'skills': 2,
      'spellcasting': true,
    },
    {
      'id': '12',
      'name': 'Монах',
      'description': 'Мастер боевых искусств и духовной дисциплины',
      'icon': Icons.sports_kabaddi,
      'color': const Color(0xFFEF6C00),
      'role': 'Штурмовик',
      'powerSource': 'Марсиальная',
      'primaryAbility': 'Ловкость и Мудрость',
      'hitDie': 'd8',
      'armor': 'Нет',
      'weapons': 'Простое оружие, короткие мечи',
      'skills': 2,
      'spellcasting': false,
    },
  ];

  List<Map<String, dynamic>> _filteredClasses = [];

  @override
  void initState() {
    super.initState();
    _filteredClasses = _classes;
    _searchController.addListener(_filterClasses);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _filterClasses() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      _filteredClasses = _classes.where((cls) {
        final matchesSearch = query.isEmpty ||
            cls['name'].toLowerCase().contains(query) ||
            cls['description'].toLowerCase().contains(query) ||
            cls['primaryAbility'].toLowerCase().contains(query);

        final matchesRole = _selectedRole == 'Все' ||
            cls['role'] == _selectedRole;

        final matchesPowerSource = _selectedPowerSource == 'Все' ||
            cls['powerSource'] == _selectedPowerSource;

        return matchesSearch && matchesRole && matchesPowerSource;
      }).toList();
    });
  }

  void _resetFilters() {
    setState(() {
      _selectedRole = 'Все';
      _selectedPowerSource = 'Все';
      _searchController.clear();
      _filteredClasses = _classes;
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
                      Text(
                        '${_filteredClasses.length} из ${_classes.length} классов',
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
                              _filterClasses();
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
                              _filterClasses();
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
          if (_filteredClasses.isNotEmpty)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildClassCard(_filteredClasses[index]),
                childCount: _filteredClasses.length,
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
                      'Классы не найдены',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.darkBrown.withOpacity(0.5),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Попробуйте изменить фильтры или поисковый запрос',
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
  Widget _buildClassCard(Map<String, dynamic> cls) {
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
            context.go('/home/reference/classes/${cls['id']}');
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  cls['color'].withOpacity(0.12),
                  cls['color'].withOpacity(0.05),
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
                      color: cls['color'].withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      cls['icon'],
                      color: cls['color'],
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
                          cls['name'],
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkBrown,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6.0,
                                vertical: 1.0,
                              ),
                              decoration: BoxDecoration(
                                color: cls['color'].withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Text(
                                cls['role'],
                                style: TextStyle(
                                  fontSize: 10,
                                  color: cls['color'],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '• ${cls['powerSource']}',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.darkBrown.withOpacity(0.6),
                              ),
                            ),
                          ],
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
                            color: cls['color'],
                            size: 10,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            cls['hitDie'],
                            style: TextStyle(
                              fontSize: 12,
                              color: cls['color'],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Основная характеристика
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6.0,
                          vertical: 2.0,
                        ),
                        decoration: BoxDecoration(
                          color: cls['color'].withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6.0),
                          border: Border.all(
                            color: cls['color'].withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          cls['primaryAbility'],
                          style: TextStyle(
                            fontSize: 10,
                            color: cls['color'],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),

                    ],
                  ),

                  const SizedBox(width: 8),

                  // Стрелка
                  Icon(
                    Icons.arrow_forward_ios,
                    color: cls['color'],
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