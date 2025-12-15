import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '/core/constants/app_colors.dart';

class NpcListScreen extends ConsumerStatefulWidget {
  final String settingId;

  const NpcListScreen({
    Key? key,
    required this.settingId,
  }) : super(key: key);

  @override
  ConsumerState<NpcListScreen> createState() => _NpcListScreenState();
}

class _NpcListScreenState extends ConsumerState<NpcListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  // Фильтры
  String _selectedType = 'Все';
  String _selectedImportance = 'Все';
  String _selectedAlignment = 'Все';

  final List<String> _typeOptions = ['Все', 'Персонаж', 'Монстр', 'Существо', 'Божество'];
  final List<String> _importanceOptions = ['Все', 'Ключевой', 'Второстепенный', 'Эпизодический'];
  final List<String> _alignmentOptions = ['Все', 'Доброе', 'Злое', 'Нейтральное', 'Хаотичное', 'Законное'];

  // Mock данные о NPC для конкретного сеттинга
  // В реальном приложении будут загружаться по settingId
  final List<Map<String, dynamic>> _npcs = [
    {
      'id': '1',
      'name': 'Король Альдрик',
      'description': 'Мудрый правитель Эльдоры',
      'icon': Icons.emoji_people,
      'color': const Color(0xFF795548),
      'type': 'Персонаж',
      'importance': 'Ключевой',
      'alignment': 'Законопослушный-добрый',
      'race': 'Человек',
      'role': 'Правитель королевства',
      'location': 'Столица Эльдоры',
      'status': 'Жив',
      'notes': 'Ищет наследника для престола',
    },
    {
      'id': '2',
      'name': 'Архимаг Маликор',
      'description': 'Хранитель древних знаний',
      'icon': Icons.auto_awesome,
      'color': const Color(0xFF673AB7),
      'type': 'Персонаж',
      'importance': 'Ключевой',
      'alignment': 'Нейтральное',
      'race': 'Человек',
      'role': 'Глава магической академии',
      'location': 'Башня Арканы',
      'status': 'Жив',
      'notes': 'Изучает запретные заклинания',
    },
    {
      'id': '3',
      'name': 'Некролорд Мортис',
      'description': 'Древний некромант',
      'icon': Icons.sentiment_very_dissatisfied,
      'color': const Color(0xFF212121),
      'type': 'Персонаж',
      'importance': 'Ключевой',
      'alignment': 'Хаотично-злое',
      'race': 'Лич',
      'role': 'Лидер культа Некросити',
      'location': 'Руины Некросити',
      'status': 'Нежить',
      'notes': 'Пытается вернуться к жизни',
    },
    {
      'id': '4',
      'name': 'Леди Элоиза',
      'description': 'Придворная дама и интриганка',
      'icon': Icons.person,
      'color': const Color(0xFFE91E63),
      'type': 'Персонаж',
      'importance': 'Второстепенный',
      'alignment': 'Хаотично-нейтральное',
      'race': 'Человек',
      'role': 'Придворная',
      'location': 'Королевский дворец',
      'status': 'Жив',
      'notes': 'Имеет связи с гильдией воров',
    },
    {
      'id': '5',
      'name': 'Капитан Стражи Годрик',
      'description': 'Честный и преданный страж',
      'icon': Icons.security,
      'color': const Color(0xFF2196F3),
      'type': 'Персонаж',
      'importance': 'Второстепенный',
      'alignment': 'Законопослушный-добрый',
      'race': 'Человек',
      'role': 'Капитан королевской стражи',
      'location': 'Казармы стражи',
      'status': 'Жив',
      'notes': 'Подозревает измену при дворе',
    },
    {
      'id': '6',
      'name': 'Старый Бард Финн',
      'description': 'Бродячий сказитель',
      'icon': Icons.music_note,
      'color': const Color(0xFF9C27B0),
      'type': 'Персонач',
      'importance': 'Эпизодический',
      'alignment': 'Хаотично-добрый',
      'race': 'Халфлинг',
      'role': 'Бард',
      'location': 'Таверна "Пьяный гном"',
      'status': 'Жив',
      'notes': 'Знает много тайн и слухов',
    },
    {
      'id': '7',
      'name': 'Верховная Жрица Лираэль',
      'description': 'Глава храма Света',
      'icon': Icons.emoji_people,
      'color': const Color(0xFFFFC107),
      'type': 'Персонаж',
      'importance': 'Ключевой',
      'alignment': 'Законопослушный-добрый',
      'race': 'Эльф',
      'role': 'Верховная жрица',
      'location': 'Храм Света',
      'status': 'Жив',
      'notes': 'Имеет видения о надвигающейся угрозе',
    },
    {
      'id': '8',
      'name': 'Мастер-кузнец Торвин',
      'description': 'Лучший кузнец королевства',
      'icon': Icons.build,
      'color': const Color(0xFF795548),
      'type': 'Персонаж',
      'importance': 'Второстепенный',
      'alignment': 'Нейтральное',
      'race': 'Дварф',
      'role': 'Кузнец',
      'location': 'Кузница у городских ворот',
      'status': 'Жив',
      'notes': 'Может выковать уникальное оружие',
    },
    {
      'id': '9',
      'name': 'Гримгор Жестокий',
      'description': 'Вождь орков с севера',
      'icon': Icons.emoji_people,
      'color': const Color(0xFF4CAF50),
      'type': 'Персонаж',
      'importance': 'Ключевой',
      'alignment': 'Хаотично-злое',
      'race': 'Орк',
      'role': 'Вождь орков',
      'location': 'Северные степи',
      'status': 'Жив',
      'notes': 'Готовит вторжение на юг',
    },
    {
      'id': '10',
      'name': 'Торговец Сильван',
      'description': 'Богатый купец',
      'icon': Icons.attach_money,
      'color': const Color(0xFF009688),
      'type': 'Персонаж',
      'importance': 'Эпизодический',
      'alignment': 'Нейтральное',
      'race': 'Человек',
      'role': 'Торговец',
      'location': 'Торговый квартал',
      'status': 'Жив',
      'notes': 'Продаёт редкие и экзотические товары',
    },
    {
      'id': '11',
      'name': 'Дракон Игнис',
      'description': 'Древний красный дракон',
      'icon': Icons.pets,
      'color': const Color(0xFFF44336),
      'type': 'Монстр',
      'importance': 'Ключевой',
      'alignment': 'Хаотично-злое',
      'race': 'Дракон',
      'role': 'Хранитель сокровищ',
      'location': 'Огненные горы',
      'status': 'Жив',
      'notes': 'Спит на огромной куче золота',
    },
    {
      'id': '12',
      'name': 'Дух леса',
      'description': 'Древний дух природы',
      'icon': Icons.forest,
      'color': const Color(0xFF2E7D32),
      'type': 'Существо',
      'importance': 'Второстепенный',
      'alignment': 'Нейтральное',
      'race': 'Дух',
      'role': 'Защитник леса',
      'location': 'Вечнозелёный лес',
      'status': 'Бессмертный',
      'notes': 'Появляется только в полнолуние',
    },
  ];

  List<Map<String, dynamic>> _filteredNpcs = [];

  @override
  void initState() {
    super.initState();
    _filteredNpcs = _npcs;
    _searchController.addListener(_filterNpcs);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _filterNpcs() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      _filteredNpcs = _npcs.where((npc) {
        final matchesSearch = query.isEmpty ||
            npc['name'].toLowerCase().contains(query) ||
            npc['description'].toLowerCase().contains(query) ||
            npc['role'].toLowerCase().contains(query) ||
            npc['location'].toLowerCase().contains(query);

        final matchesType = _selectedType == 'Все' ||
            npc['type'] == _selectedType;

        final matchesImportance = _selectedImportance == 'Все' ||
            npc['importance'] == _selectedImportance;

        final matchesAlignment = _selectedAlignment == 'Все' ||
            npc['alignment'].contains(_selectedAlignment);

        return matchesSearch && matchesType && matchesImportance && matchesAlignment;
      }).toList();
    });
  }

  void _resetFilters() {
    setState(() {
      _selectedType = 'Все';
      _selectedImportance = 'Все';
      _selectedAlignment = 'Все';
      _searchController.clear();
      _filteredNpcs = _npcs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getHomeBackground(context),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryBrown,
        foregroundColor: Colors.white,
        onPressed: () {
          context.go('/home/settings_game/${widget.settingId}/npcs/create');
        },
        child: const Icon(Icons.add),
      ),
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
              'Персонажи мира',
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
                      AppColors.primaryBrown,
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
                        'NPC и другие существа',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.parchment,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${_filteredNpcs.length} из ${_npcs.length} персонажей',
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
                          hintText: 'Поиск персонажей...',
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
                          value: _selectedType,
                          items: _typeOptions,
                          hint: 'Тип',
                          onChanged: (value) {
                            setState(() {
                              _selectedType = value!;
                              _filterNpcs();
                            });
                          },
                          icon: Icons.category,
                        ),

                        const SizedBox(width: 8),

                        _buildFilterDropdown(
                          value: _selectedImportance,
                          items: _importanceOptions,
                          hint: 'Важность',
                          onChanged: (value) {
                            setState(() {
                              _selectedImportance = value!;
                              _filterNpcs();
                            });
                          },
                          icon: Icons.star,
                        ),

                        const SizedBox(width: 8),

                        _buildFilterDropdown(
                          value: _selectedAlignment,
                          items: _alignmentOptions,
                          hint: 'Мировоззрение',
                          onChanged: (value) {
                            setState(() {
                              _selectedAlignment = value!;
                              _filterNpcs();
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

          // Список NPC
          if (_filteredNpcs.isNotEmpty)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildNpcCard(_filteredNpcs[index]),
                childCount: _filteredNpcs.length,
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
                      Icons.people_outline,
                      color: AppColors.darkBrown.withOpacity(0.3),
                      size: 60,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Персонажи не найдены',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.darkBrown.withOpacity(0.5),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Попробуйте изменить фильтры или создайте нового персонажа',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.darkBrown.withOpacity(0.4),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.go('/home/settings_game/${widget.settingId}/npcs/create');
                      },
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Создать персонажа'),
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

          // Информация о NPC
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
                          'О персонажах мира',
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
                      'NPC (Non-Player Character) - это персонажи, которых играет мастер. '
                          'Они населяют мир, двигают сюжет и взаимодействуют с игроками. '
                          'Каждый NPC имеет свою роль, мотивацию и место в истории мира.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.darkBrown.withOpacity(0.7),
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Статистика по важности
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        _buildStatItem('Ключевые', _npcs.where((n) => n['importance'] == 'Ключевой').length.toString(), Icons.star),
                        _buildStatItem('Второстепенные', _npcs.where((n) => n['importance'] == 'Второстепенный').length.toString(), Icons.star_half),
                        _buildStatItem('Эпизодические', _npcs.where((n) => n['importance'] == 'Эпизодический').length.toString(), Icons.star_border),
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

  Widget _buildStatItem(String label, String value, IconData icon) {
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
          Icon(
            icon,
            size: 12,
            color: AppColors.darkBrown.withOpacity(0.7),
          ),
          const SizedBox(width: 4),
          Text(
            '$label: $value',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.darkBrown.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  // Карточка NPC
  Widget _buildNpcCard(Map<String, dynamic> npc) {
    // Цвет важности
    Color importanceColor;
    switch (npc['importance']) {
      case 'Ключевой':
        importanceColor = Colors.red;
        break;
      case 'Второстепенный':
        importanceColor = Colors.orange;
        break;
      case 'Эпизодический':
        importanceColor = Colors.blue;
        break;
      default:
        importanceColor = Colors.grey;
    }

    // Цвет статуса
    Color statusColor;
    switch (npc['status']) {
      case 'Жив':
        statusColor = Colors.green;
        break;
      case 'Нежить':
        statusColor = Colors.purple;
        break;
      case 'Бессмертный':
        statusColor = Colors.blue;
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
            context.go('/home/settings_game/${widget.settingId}/npcs/${npc['id']}');
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  npc['color'].withOpacity(0.12),
                  npc['color'].withOpacity(0.05),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
              child: Row(
                children: [
                  // Иконка NPC
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: npc['color'].withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      npc['icon'],
                      color: npc['color'],
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
                                npc['name'],
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
                                color: importanceColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4.0),
                                border: Border.all(
                                  color: importanceColor.withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                npc['importance'][0], // Первая буква важности
                                style: TextStyle(
                                  fontSize: 10,
                                  color: importanceColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          npc['description'],
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
                                color: npc['color'].withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Text(
                                npc['race'],
                                style: TextStyle(
                                  fontSize: 10,
                                  color: npc['color'],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6.0,
                                vertical: 2.0,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Text(
                                npc['status'],
                                style: TextStyle(
                                  fontSize: 10,
                                  color: statusColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Дополнительная информация
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Роль
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6.0,
                          vertical: 2.0,
                        ),
                        decoration: BoxDecoration(
                          color: npc['color'].withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6.0),
                          border: Border.all(
                            color: npc['color'].withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          npc['role'],
                          style: TextStyle(
                            fontSize: 10,
                            color: npc['color'],
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Локация
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: npc['color'],
                            size: 10,
                          ),
                          const SizedBox(width: 2),
                          SizedBox(
                            width: 60,
                            child: Text(
                              npc['location'],
                              style: TextStyle(
                                fontSize: 10,
                                color: npc['color'],
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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
                    color: npc['color'],
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