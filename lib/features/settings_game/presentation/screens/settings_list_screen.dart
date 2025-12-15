import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '/core/constants/app_colors.dart';

class SettingsListScreen extends ConsumerStatefulWidget {
  const SettingsListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SettingsListScreen> createState() => _SettingsListScreenState();
}

class _SettingsListScreenState extends ConsumerState<SettingsListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  // Фильтры
  String _selectedStatus = 'Все';
  String _selectedGenre = 'Все';

  final List<String> _statusOptions = ['Все', 'Активный', 'Завершенный', 'В разработке'];
  final List<String> _genreOptions = ['Все', 'Фэнтези', 'Научная фантастика', 'Стимпанк', 'Постапокалипсис', 'Исторический'];

  // Пример данных о сеттингах
  final List<Map<String, dynamic>> _settings = [
    {
      'id': '1',
      'name': 'Королевство Эльдора',
      'description': 'Средневековое фэнтези с магией и драконами',
      'icon': Icons.castle,
      'color': const Color(0xFF795548),
      'status': 'Активный',
      'genre': 'Фэнтези',
      'players': 5,
      'sessions': 12,
      'lastSession': '2024-01-15',
      'npcs': 8,
      'locations': 15,
    },
    {
      'id': '2',
      'name': 'Некрономикон',
      'description': 'Тёмное фэнтези с ужасами и культистами',
      'icon': Icons.auto_awesome,
      'color': const Color(0xFF673AB7),
      'status': 'Активный',
      'genre': 'Фэнтези',
      'players': 4,
      'sessions': 8,
      'lastSession': '2024-01-10',
      'npcs': 12,
      'locations': 20,
    },
    {
      'id': '3',
      'name': 'Кибер-Мегаполис 2077',
      'description': 'Киберпанк будущего с технологиями и корпорациями',
      'icon': Icons.computer,
      'color': const Color(0xFF2196F3),
      'status': 'В разработке',
      'genre': 'Научная фантастика',
      'players': 0,
      'sessions': 0,
      'lastSession': null,
      'npcs': 3,
      'locations': 8,
    },
    {
      'id': '4',
      'name': 'Пар Чугунных Дорог',
      'description': 'Стимпанк в викторианскую эпоху с паровыми машинами',
      'icon': Icons.train,
      'color': const Color(0xFFFF9800),
      'status': 'Завершенный',
      'genre': 'Стимпанк',
      'players': 6,
      'sessions': 24,
      'lastSession': '2023-11-30',
      'npcs': 18,
      'locations': 32,
    },
    {
      'id': '5',
      'name': 'Пустоши Радиации',
      'description': 'Выживание в постапокалиптическом мире',
      'icon': Icons.landscape,
      'color': const Color(0xFF4CAF50),
      'status': 'Активный',
      'genre': 'Постапокалипсис',
      'players': 3,
      'sessions': 6,
      'lastSession': '2024-01-12',
      'npcs': 7,
      'locations': 12,
    },
    {
      'id': '6',
      'name': 'Эпоха Войны Роз',
      'description': 'Историческая драма в средневековой Англии',
      'icon': Icons.history,
      'color': const Color(0xFFF44336),
      'status': 'В разработке',
      'genre': 'Исторический',
      'players': 0,
      'sessions': 0,
      'lastSession': null,
      'npcs': 5,
      'locations': 10,
    },
    {
      'id': '7',
      'name': 'Космическая Одиссея',
      'description': 'Исследование далёких галактик и древних цивилизаций',
      'icon': Icons.rocket_launch,
      'color': const Color(0xFF9C27B0),
      'status': 'Активный',
      'genre': 'Научная фантастика',
      'players': 5,
      'sessions': 10,
      'lastSession': '2024-01-14',
      'npcs': 14,
      'locations': 25,
    },
    {
      'id': '8',
      'name': 'Тени Венеции',
      'description': 'Детектив и интриги в эпоху Возрождения',
      'icon': Icons.theater_comedy,
      'color': const Color(0xFF00BCD4),
      'status': 'Завершенный',
      'genre': 'Исторический',
      'players': 4,
      'sessions': 18,
      'lastSession': '2023-12-20',
      'npcs': 22,
      'locations': 28,
    },
  ];

  List<Map<String, dynamic>> _filteredSettings = [];

  @override
  void initState() {
    super.initState();
    _filteredSettings = _settings;
    _searchController.addListener(_filterSettings);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _filterSettings() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      _filteredSettings = _settings.where((setting) {
        final matchesSearch = query.isEmpty ||
            setting['name'].toLowerCase().contains(query) ||
            setting['description'].toLowerCase().contains(query);

        final matchesStatus = _selectedStatus == 'Все' ||
            setting['status'] == _selectedStatus;

        final matchesGenre = _selectedGenre == 'Все' ||
            setting['genre'] == _selectedGenre;

        return matchesSearch && matchesStatus && matchesGenre;
      }).toList();
    });
  }

  void _resetFilters() {
    setState(() {
      _selectedStatus = 'Все';
      _selectedGenre = 'Все';
      _searchController.clear();
      _filteredSettings = _settings;
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
            backgroundColor: AppColors.primaryBrown,
            expandedHeight: 160.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Игровые миры',
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
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primaryBrown,
                      AppColors.darkBrown,
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 60.0, 16.0, 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Создавайте и управляйте мирами',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.parchment,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_filteredSettings.length} из ${_settings.length} миров',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.lightBrown,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () {
                  context.go('/home/settings_game/create');
                },
              ),
            ],
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
                          hintText: 'Поиск миров...',
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
                            color: AppColors.primaryBrown,
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
                          value: _selectedStatus,
                          items: _statusOptions,
                          hint: 'Статус',
                          onChanged: (value) {
                            setState(() {
                              _selectedStatus = value!;
                              _filterSettings();
                            });
                          },
                          icon: Icons.circle,
                        ),

                        const SizedBox(width: 8),

                        _buildFilterDropdown(
                          value: _selectedGenre,
                          items: _genreOptions,
                          hint: 'Жанр',
                          onChanged: (value) {
                            setState(() {
                              _selectedGenre = value!;
                              _filterSettings();
                            });
                          },
                          icon: Icons.category,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),

          // Список сеттингов
          if (_filteredSettings.isNotEmpty)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildSettingCard(_filteredSettings[index]),
                childCount: _filteredSettings.length,
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
                      Icons.public_off,
                      color: AppColors.darkBrown.withOpacity(0.3),
                      size: 60,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Миры не найдены',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.darkBrown.withOpacity(0.5),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Попробуйте изменить фильтры или создайте новый мир',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.darkBrown.withOpacity(0.4),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.go('/home/settings_game/create');
                      },
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Создать мир'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBrown,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Информация о сеттингах
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
                          color: AppColors.primaryBrown,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Что такое игровые миры?',
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
                      'Игровой мир - это вселенная, в которой происходят ваши приключения. '
                          'Здесь вы можете создать историю, населить мир персонажами, '
                          'разработать локации и управлять ходом кампании.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.darkBrown.withOpacity(0.7),
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        _buildStatInfo('Активные', _settings.where((s) => s['status'] == 'Активный').length.toString()),
                        _buildStatInfo('В разработке', _settings.where((s) => s['status'] == 'В разработке').length.toString()),
                        _buildStatInfo('Завершенные', _settings.where((s) => s['status'] == 'Завершенный').length.toString()),
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

  Widget _buildStatInfo(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
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
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.darkBrown.withOpacity(0.7),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.darkBrown,
            ),
          ),
        ],
      ),
    );
  }

  // Карточка сеттинга
  Widget _buildSettingCard(Map<String, dynamic> setting) {
    // Цвет статуса
    Color statusColor;
    switch (setting['status']) {
      case 'Активный':
        statusColor = Colors.green;
        break;
      case 'Завершенный':
        statusColor = Colors.blue;
        break;
      case 'В разработке':
        statusColor = Colors.orange;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      height: 90.0,
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: Card(
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(10.0),
          onTap: () {
            context.go('/home/settings_game/${setting['id']}');
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  setting['color'].withOpacity(0.12),
                  setting['color'].withOpacity(0.05),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
              child: Row(
                children: [
                  // Иконка сеттинга
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: setting['color'].withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      setting['icon'],
                      color: setting['color'],
                      size: 22,
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Основная информация
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                setting['name'],
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.darkBrown,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6.0,
                                vertical: 2.0,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4.0),
                                border: Border.all(
                                  color: statusColor.withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                setting['status'],
                                style: TextStyle(
                                  fontSize: 10,
                                  color: statusColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          setting['description'],
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.darkBrown.withOpacity(0.6),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6.0,
                                vertical: 2.0,
                              ),
                              decoration: BoxDecoration(
                                color: setting['color'].withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Text(
                                setting['genre'],
                                style: TextStyle(
                                  fontSize: 10,
                                  color: setting['color'],
                                  fontWeight: FontWeight.w500,
                                ),
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
                      // Игроки и сессии
                      Row(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.people,
                                color: setting['color'],
                                size: 12,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '${setting['players']}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: setting['color'],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.event,
                                color: setting['color'],
                                size: 12,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '${setting['sessions']}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: setting['color'],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // NPC и локации
                      Row(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.person,
                                color: setting['color'],
                                size: 12,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '${setting['npcs']}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: setting['color'],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: setting['color'],
                                size: 12,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '${setting['locations']}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: setting['color'],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(width: 8),

                  // Стрелка
                  Icon(
                    Icons.arrow_forward_ios,
                    color: setting['color'],
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