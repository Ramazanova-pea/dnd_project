import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '/core/constants/app_colors.dart';

class MobsListScreen extends ConsumerStatefulWidget {
  const MobsListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MobsListScreen> createState() => _MobsListScreenState();
}

class _MobsListScreenState extends ConsumerState<MobsListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  // Фильтры
  String _selectedChallenge = 'Все';
  String _selectedType = 'Все';
  String _selectedAlignment = 'Все';

  final List<String> _challengeOptions = ['Все', '0-4', '5-10', '11-16', '17+'];
  final List<String> _typeOptions = ['Все', 'Звери', 'Гуманоиды', 'Нежить', 'Драконы', 'Элементали', 'Феи'];
  final List<String> _alignmentOptions = ['Все', 'Доброе', 'Злое', 'Нейтральное', 'Хаотичное', 'Законное'];

  // Пример данных о существах
  final List<Map<String, dynamic>> _mobs = [
    {
      'id': '1',
      'name': 'Дракон (Красный)',
      'description': 'Огнедышащий дракон древнего зла',
      'icon': Icons.pets,
      'color': AppColors.errorRed,
      'type': 'Драконы',
      'challenge': '17+',
      'alignment': 'Злое',
      'size': 'Огромный',
      'hp': 256,
      'ac': 19,
    },
    {
      'id': '2',
      'name': 'Лич',
      'description': 'Могущественный некромант-нежить',
      'icon': Icons.auto_awesome,
      'color': const Color(0xFF673AB7),
      'type': 'Нежить',
      'challenge': '17+',
      'alignment': 'Злое',
      'size': 'Средний',
      'hp': 135,
      'ac': 17,
    },
    {
      'id': '3',
      'name': 'Великан (Огненный)',
      'description': 'Исполин, рождённый в пламени',
      'icon': Icons.whatshot,
      'color': AppColors.warningOrange,
      'type': 'Гуманоиды',
      'challenge': '11-16',
      'alignment': 'Злое',
      'size': 'Огромный',
      'hp': 162,
      'ac': 15,
    },
    {
      'id': '4',
      'name': 'Медведь-пещерник',
      'description': 'Массивный пещерный хищник',
      'icon': Icons.pets,
      'color': AppColors.primaryBrown,
      'type': 'Звери',
      'challenge': '5-10',
      'alignment': 'Нейтральное',
      'size': 'Большой',
      'hp': 42,
      'ac': 12,
    },
    {
      'id': '5',
      'name': 'Гоблин',
      'description': 'Маленький хитрый гуманоид',
      'icon': Icons.person,
      'color': AppColors.successGreen,
      'type': 'Гуманоиды',
      'challenge': '0-4',
      'alignment': 'Злое',
      'size': 'Маленький',
      'hp': 7,
      'ac': 13,
    },
    {
      'id': '6',
      'name': 'Скелет',
      'description': 'Оживлённые кости',
      'icon': Icons.sentiment_dissatisfied,
      'color': Colors.grey,
      'type': 'Нежить',
      'challenge': '0-4',
      'alignment': 'Злое',
      'size': 'Средний',
      'hp': 13,
      'ac': 13,
    },
    {
      'id': '7',
      'name': 'Дриада',
      'description': 'Дух леса в облике женщины',
      'icon': Icons.forest,
      'color': const Color(0xFF4CAF50),
      'type': 'Феи',
      'challenge': '5-10',
      'alignment': 'Доброе',
      'size': 'Средний',
      'hp': 22,
      'ac': 11,
    },
    {
      'id': '8',
      'name': 'Элементаль (Огненный)',
      'description': 'Живое воплощение огня',
      'icon': Icons.fireplace,
      'color': const Color(0xFFFF5722),
      'type': 'Элементали',
      'challenge': '5-10',
      'alignment': 'Нейтральное',
      'size': 'Большой',
      'hp': 102,
      'ac': 13,
    },
    {
      'id': '9',
      'name': 'Вампир',
      'description': 'Бессмертный кровопийца',
      'icon': Icons.dark_mode,
      'color': const Color(0xFFD32F2F),
      'type': 'Нежить',
      'challenge': '11-16',
      'alignment': 'Злое',
      'size': 'Средний',
      'hp': 144,
      'ac': 16,
    },
    {
      'id': '10',
      'name': 'Мантикора',
      'description': 'Лев с крыльями и жалом скорпиона',
      'icon': Icons.pest_control,
      'color': const Color(0xFF795548),
      'type': 'Звери',
      'challenge': '5-10',
      'alignment': 'Злое',
      'size': 'Большой',
      'hp': 68,
      'ac': 14,
    },
    {
      'id': '11',
      'name': 'Бехолдер',
      'description': 'Парящий глаз с множеством щупалец',
      'icon': Icons.remove_red_eye,
      'color': const Color(0xFF9C27B0),
      'type': 'Звери',
      'challenge': '11-16',
      'alignment': 'Злое',
      'size': 'Средний',
      'hp': 180,
      'ac': 18,
    },
    {
      'id': '12',
      'name': 'Ангел (Древний)',
      'description': 'Небесный воин высшего порядка',
      'icon': Icons.emoji_people,
      'color': AppColors.accentGold,
      'type': 'Гуманоиды',
      'challenge': '17+',
      'alignment': 'Доброе',
      'size': 'Большой',
      'hp': 200,
      'ac': 19,
    },
  ];

  List<Map<String, dynamic>> _filteredMobs = [];

  @override
  void initState() {
    super.initState();
    _filteredMobs = _mobs;
    _searchController.addListener(_filterMobs);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _filterMobs() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      _filteredMobs = _mobs.where((mob) {
        final matchesSearch = query.isEmpty ||
            mob['name'].toLowerCase().contains(query) ||
            mob['description'].toLowerCase().contains(query) ||
            mob['type'].toLowerCase().contains(query);

        final matchesChallenge = _selectedChallenge == 'Все' ||
            mob['challenge'] == _selectedChallenge;

        final matchesType = _selectedType == 'Все' ||
            mob['type'] == _selectedType;

        final matchesAlignment = _selectedAlignment == 'Все' ||
            mob['alignment'] == _selectedAlignment;

        return matchesSearch && matchesChallenge && matchesType && matchesAlignment;
      }).toList();
    });
  }

  void _resetFilters() {
    setState(() {
      _selectedChallenge = 'Все';
      _selectedType = 'Все';
      _selectedAlignment = 'Все';
      _searchController.clear();
      _filteredMobs = _mobs;
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
            backgroundColor: AppColors.errorRed,
            expandedHeight: 140.0,
            floating: false,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.pop(),
            ),
            title: Text(
              'Существа',
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
                      AppColors.errorRed.withOpacity(0.8),
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
                        'Монстры, NPC и другие существа',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.parchment,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${_filteredMobs.length} из ${_mobs.length} существ',
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
                          hintText: 'Поиск существ...',
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
                            color: AppColors.errorRed,
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
                          value: _selectedChallenge,
                          items: _challengeOptions,
                          hint: 'Сложность',
                          onChanged: (value) {
                            setState(() {
                              _selectedChallenge = value!;
                              _filterMobs();
                            });
                          },
                          icon: Icons.bar_chart,
                        ),

                        const SizedBox(width: 8),

                        _buildFilterDropdown(
                          value: _selectedType,
                          items: _typeOptions,
                          hint: 'Тип',
                          onChanged: (value) {
                            setState(() {
                              _selectedType = value!;
                              _filterMobs();
                            });
                          },
                          icon: Icons.category,
                        ),

                        const SizedBox(width: 8),

                        _buildFilterDropdown(
                          value: _selectedAlignment,
                          items: _alignmentOptions,
                          hint: 'Мировоззрение',
                          onChanged: (value) {
                            setState(() {
                              _selectedAlignment = value!;
                              _filterMobs();
                            });
                          },
                          icon: Icons.psychology,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),

          // Список существ
          if (_filteredMobs.isNotEmpty)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildMobCard(_filteredMobs[index]),
                childCount: _filteredMobs.length,
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
                      'Существа не найдены',
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
                          color: AppColors.errorRed,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Информация о существах
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
                          color: AppColors.errorRed,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'О существах',
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
                      'Существа включают монстров, NPC и других обитателей мира. '
                          'Каждое существо имеет характеристики, способности и сложность (CR), '
                          'которая показывает насколько оно опасно.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.darkBrown.withOpacity(0.7),
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildLegendItem('0-4', 'Низкая', AppColors.successGreen),
                        const SizedBox(width: 12),
                        _buildLegendItem('5-10', 'Средняя', AppColors.warningOrange),
                        const SizedBox(width: 12),
                        _buildLegendItem('11+', 'Высокая', AppColors.errorRed),
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

  Widget _buildLegendItem(String cr, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '$cr ($label)',
          style: TextStyle(
            fontSize: 11,
            color: AppColors.darkBrown.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  // Карточка существа
  Widget _buildMobCard(Map<String, dynamic> mob) {
    // Определяем цвет сложности
    Color challengeColor = AppColors.successGreen;
    if (mob['challenge'] == '5-10') {
      challengeColor = AppColors.warningOrange;
    } else if (mob['challenge'] == '11-16' || mob['challenge'] == '17+') {
      challengeColor = AppColors.errorRed;
    }

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
            // Навигация к детальной информации о существе
            context.go('/home/reference/mobs/${mob['id']}');
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  mob['color'].withOpacity(0.12),
                  mob['color'].withOpacity(0.05),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Row(
                children: [
                  // Иконка существа
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: mob['color'].withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      mob['icon'],
                      color: mob['color'],
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
                          mob['name'],
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
                                color: mob['color'].withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Text(
                                mob['type'],
                                style: TextStyle(
                                  fontSize: 10,
                                  color: mob['color'],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '• ${mob['alignment']}',
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
                      // Сложность
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 2.0,
                        ),
                        decoration: BoxDecoration(
                          color: challengeColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6.0),
                          border: Border.all(
                            color: challengeColor.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          'CR: ${mob['challenge']}',
                          style: TextStyle(
                            fontSize: 11,
                            color: challengeColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      // ХП и КБ
                      Row(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.favorite,
                                color: mob['color'],
                                size: 10,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '${mob['hp']}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: mob['color'],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 6),
                          Row(
                            children: [
                              Icon(
                                Icons.shield,
                                color: mob['color'],
                                size: 10,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '${mob['ac']}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: mob['color'],
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
                    color: mob['color'],
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