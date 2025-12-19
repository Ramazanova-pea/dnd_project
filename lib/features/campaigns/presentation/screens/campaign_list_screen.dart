import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '/core/constants/app_colors.dart';
import '/core/providers/campaign_providers.dart';
import '/domain/models/campaign.dart';

class CampaignListScreen extends ConsumerStatefulWidget {
  const CampaignListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CampaignListScreen> createState() => _CampaignListScreenState();
}

class _CampaignListScreenState extends ConsumerState<CampaignListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  // Фильтры
  String _selectedStatus = 'Все';
  String _selectedSystem = 'Все';

  final List<String> _statusOptions = ['Все', 'Активная', 'Завершена', 'В планах', 'На паузе'];
  final List<String> _systemOptions = ['Все', 'D&D 5e', 'Pathfinder', 'Warhammer', 'GURPS', 'Другая'];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {}); // Обновляем UI при изменении поиска
    });
  }

  // Старые мок-данные (удалить после полной миграции)
  final List<Map<String, dynamic>> _mockCampaigns = [
    {
      'id': '1',
      'name': 'Потерянный трон Эльдора',
      'description': 'Поиски древнего артефакта в раздираемом войной королевстве',
      'icon': Icons.castle,
      'color': const Color(0xFF795548),
      'status': 'Активная',
      'system': 'D&D 5e',
      'players': 5,
      'sessions': 12,
      'nextSession': '2024-01-22',
      'lastSession': '2024-01-15',
      'master': 'Артём В.',
      'setting': 'Королевство Эльдора',
      'notes': 8,
    },
    {
      'id': '2',
      'name': 'Тени Венеции',
      'description': 'Детективная история в эпоху Возрождения',
      'icon': Icons.theater_comedy,
      'color': const Color(0xFF00BCD4),
      'status': 'Завершена',
      'system': 'D&D 5e',
      'players': 4,
      'sessions': 24,
      'nextSession': null,
      'lastSession': '2023-12-20',
      'master': 'Мария С.',
      'setting': 'Эпоха Войны Роз',
      'notes': 42,
    },
    {
      'id': '3',
      'name': 'Кибер-Мегаполис 2077',
      'description': 'Борьба с корпорациями в неоновом городе будущего',
      'icon': Icons.computer,
      'color': const Color(0xFF2196F3),
      'status': 'В планах',
      'system': 'GURPS',
      'players': 0,
      'sessions': 0,
      'nextSession': null,
      'lastSession': null,
      'master': 'Иван К.',
      'setting': 'Кибер-Мегаполис 2077',
      'notes': 3,
    },
    {
      'id': '4',
      'name': 'Проклятие вампиров',
      'description': 'Охота на ночных охотников в готическом городе',
      'icon': Icons.nightlife,
      'color': const Color(0xFF673AB7),
      'status': 'На паузе',
      'system': 'Warhammer',
      'players': 3,
      'sessions': 8,
      'nextSession': '2024-02-10',
      'lastSession': '2023-11-30',
      'master': 'Алексей П.',
      'setting': 'Некрономикон',
      'notes': 15,
    },
    {
      'id': '5',
      'name': 'Морские приключения',
      'description': 'Исследование островов и сражения с пиратами',
      'icon': Icons.sailing,
      'color': const Color(0xFF2196F3),
      'status': 'Активная',
      'system': 'D&D 5e',
      'players': 6,
      'sessions': 18,
      'nextSession': '2024-01-25',
      'lastSession': '2024-01-18',
      'master': 'Сергей М.',
      'setting': 'Острова Удачи',
      'notes': 22,
    },
    {
      'id': '6',
      'name': 'Подземелья Дракона',
      'description': 'Классическое подземелье с загадками и сокровищами',
      'icon': Icons.landscape,
      'color': const Color(0xFF4CAF50),
      'status': 'Активная',
      'system': 'Pathfinder',
      'players': 4,
      'sessions': 10,
      'nextSession': '2024-01-23',
      'lastSession': '2024-01-16',
      'master': 'Дмитрий Л.',
      'setting': 'Глубины Гор',
      'notes': 12,
    },
    {
      'id': '7',
      'name': 'Космическая одиссея',
      'description': 'Исследование далёких галактик и древних цивилизаций',
      'icon': Icons.rocket_launch,
      'color': const Color(0xFF9C27B0),
      'status': 'В планах',
      'system': 'Другая',
      'players': 0,
      'sessions': 0,
      'nextSession': null,
      'lastSession': null,
      'master': 'Елена В.',
      'setting': 'Космическая Одиссея',
      'notes': 5,
    },
    {
      'id': '8',
      'name': 'Легенды о драконах',
      'description': 'Война кланов драконьих наездников',
      'icon': Icons.pets,
      'color': const Color(0xFFF44336),
      'status': 'Активная',
      'system': 'D&D 5e',
      'players': 5,
      'sessions': 15,
      'nextSession': '2024-01-24',
      'lastSession': '2024-01-17',
      'master': 'Ольга Н.',
      'setting': 'Земли Драконов',
      'notes': 18,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  /// Фильтрация кампаний по поисковому запросу и фильтрам
  List<Campaign> _filterCampaigns(List<Campaign> campaigns) {
    final query = _searchController.text.toLowerCase();

    return campaigns.where((campaign) {
      final matchesSearch = query.isEmpty ||
          campaign.name.toLowerCase().contains(query) ||
          campaign.description.toLowerCase().contains(query) ||
          campaign.master.toLowerCase().contains(query) ||
          campaign.setting.toLowerCase().contains(query);

      final matchesStatus = _selectedStatus == 'Все' ||
          campaign.status == _selectedStatus;

      final matchesSystem = _selectedSystem == 'Все' ||
          campaign.system == _selectedSystem;

      return matchesSearch && matchesStatus && matchesSystem;
    }).toList();
  }

  void _resetFilters() {
    setState(() {
      _selectedStatus = 'Все';
      _selectedSystem = 'Все';
      _searchController.clear();
    });
  }

  /// Удаление кампании
  Future<void> _deleteCampaign(Campaign campaign) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить кампанию?'),
        content: Text('Вы уверены, что хотите удалить кампанию "${campaign.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(deleteCampaignProvider(campaign.id).future);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Кампания "${campaign.name}" удалена')),
        );
      }
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '—';
    return '${date.day}.${date.month}.${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final darkBrownColor = AppColors.darkBrown;
    final primaryBrownColor = AppColors.primaryBrown;
    final lightBrownColor = AppColors.lightBrown;
    final parchmentColor = AppColors.parchment;

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
                'Кампании',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  shadows: [
                    const Shadow(
                      blurRadius: 4.0,
                      color: Colors.black,
                      offset: Offset(1, 1),
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
                        'Приключения и истории',
                        style: TextStyle(
                          fontSize: 14,
                          color: parchmentColor,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Consumer(
                        builder: (context, ref, child) {
                          final campaignsAsync = ref.watch(campaignsProvider);
                          return campaignsAsync.when(
                            data: (campaigns) => Text(
                              '${_filterCampaigns(campaigns).length} из ${campaigns.length} кампаний',
                              style: TextStyle(
                                fontSize: 12,
                                color: lightBrownColor,
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
            actions: [
              IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () {
                  context.go('/home/campaigns/create');
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
                    color: lightBrownColor.withOpacity(0.3),
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
                      color: darkBrownColor.withOpacity(0.5),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        decoration: InputDecoration(
                          hintText: 'Поиск кампаний...',
                          hintStyle: TextStyle(
                            color: darkBrownColor.withOpacity(0.4),
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: TextStyle(
                          fontSize: 14,
                          color: darkBrownColor,
                        ),
                      ),
                    ),
                    if (_searchController.text.isNotEmpty)
                      IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: darkBrownColor.withOpacity(0.5),
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
                          color: darkBrownColor,
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
                            color: primaryBrownColor,
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
                            });
                          },
                          icon: Icons.circle,
                        ),

                        const SizedBox(width: 8),

                        _buildFilterDropdown(
                          value: _selectedSystem,
                          items: _systemOptions,
                          hint: 'Система',
                          onChanged: (value) {
                            setState(() {
                              _selectedSystem = value!;
                            });
                          },
                          icon: Icons.sports_esports,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),

          // Список кампаний
          Consumer(
            builder: (context, ref, child) {
              final campaignsAsync = ref.watch(campaignsProvider);
              return campaignsAsync.when(
                data: (campaigns) {
                  final filtered = _filterCampaigns(campaigns);
                  if (filtered.isNotEmpty) {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => _buildCampaignCard(filtered[index]),
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
                      Icons.campaign_outlined,
                      color: darkBrownColor.withOpacity(0.3),
                      size: 60,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Кампании не найдены',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: darkBrownColor.withOpacity(0.5),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Попробуйте изменить фильтры или создайте новую кампанию',
                      style: TextStyle(
                        fontSize: 14,
                        color: darkBrownColor.withOpacity(0.4),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.go('/home/campaigns/create');
                      },
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Создать кампанию'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBrownColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
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
                    child: CircularProgressIndicator(color: primaryBrownColor),
                  ),
                ),
                error: (error, stack) => SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, color: Colors.red, size: 48),
                        const SizedBox(height: 16),
                        Text('Ошибка загрузки кампаний', style: TextStyle(color: darkBrownColor)),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () => ref.invalidate(campaignsProvider),
                          child: const Text('Повторить'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          // Информация о кампаниях
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
            sliver: SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: parchmentColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: lightBrownColor.withOpacity(0.15),
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
                          color: primaryBrownColor,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'О кампаниях',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: darkBrownColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Кампания - это серия связанных приключений с одними и теми же персонажами. '
                          'Здесь вы можете отслеживать прогресс, планировать сессии и делиться заметками с игроками.',
                      style: TextStyle(
                        fontSize: 12,
                        color: darkBrownColor.withOpacity(0.7),
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Статистика
                    Consumer(
                      builder: (context, ref, child) {
                        final campaignsAsync = ref.watch(campaignsProvider);
                        return campaignsAsync.when(
                          data: (campaigns) => Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              _buildStatItem(
                                'Активные',
                                campaigns.where((c) => c.status == 'Активная').length.toString(),
                                Icons.play_arrow,
                              ),
                              _buildStatItem(
                                'Завершённые',
                                campaigns.where((c) => c.status == 'Завершена').length.toString(),
                                Icons.check,
                              ),
                              _buildStatItem(
                                'Всего сессий',
                                campaigns.fold<int>(0, (sum, c) => sum + c.sessions).toString(),
                                Icons.event,
                              ),
                            ],
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
    final darkBrownColor = AppColors.darkBrown;

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
            color: darkBrownColor.withOpacity(0.6),
            size: 16,
          ),
          const SizedBox(width: 4),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              icon: Icon(
                Icons.arrow_drop_down,
                color: darkBrownColor.withOpacity(0.6),
                size: 20,
              ),
              iconSize: 16,
              elevation: 8,
              style: TextStyle(
                fontSize: 12,
                color: darkBrownColor,
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
                      color: darkBrownColor,
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
    final darkBrownColor = AppColors.darkBrown;

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
            color: darkBrownColor.withOpacity(0.7),
          ),
          const SizedBox(width: 4),
          Text(
            '$label: $value',
            style: TextStyle(
              fontSize: 11,
              color: darkBrownColor.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  // Карточка кампании
  Widget _buildCampaignCard(Campaign campaign) {
    final darkBrownColor = AppColors.darkBrown;

    // Цвет статуса
    Color statusColor;
    switch (campaign.status) {
      case 'Активная':
        statusColor = Colors.green;
        break;
      case 'Завершена':
        statusColor = Colors.blue;
        break;
      case 'В планах':
        statusColor = Colors.orange;
        break;
      case 'На паузе':
        statusColor = Colors.grey;
        break;
      default:
        statusColor = Colors.grey;
    }

    // Иконка и цвет на основе названия
    IconData campaignIcon = Icons.castle;
    Color campaignColor = AppColors.primaryBrown;
    if (campaign.name.toLowerCase().contains('море') || campaign.name.toLowerCase().contains('пират')) {
      campaignIcon = Icons.sailing;
      campaignColor = Colors.blue;
    } else if (campaign.name.toLowerCase().contains('кибер') || campaign.name.toLowerCase().contains('техно')) {
      campaignIcon = Icons.computer;
      campaignColor = Colors.cyan;
    } else if (campaign.name.toLowerCase().contains('космос')) {
      campaignIcon = Icons.rocket_launch;
      campaignColor = Colors.purple;
    } else if (campaign.name.toLowerCase().contains('вампир') || campaign.name.toLowerCase().contains('тьма')) {
      campaignIcon = Icons.nightlife;
      campaignColor = Colors.deepPurple;
    } else if (campaign.name.toLowerCase().contains('дракон')) {
      campaignIcon = Icons.pets;
      campaignColor = Colors.red;
    }

    return Container(
      height: 120.0,
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: Card(
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(10.0),
          onTap: () {
            context.go('/home/campaigns/${campaign.id}');
          },
          onLongPress: () {
            _deleteCampaign(campaign);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  campaignColor.withOpacity(0.12),
                  campaignColor.withOpacity(0.05),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
              child: Row(
                children: [
                  // Иконка кампании
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: campaignColor.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      campaignIcon,
                      color: campaignColor,
                      size: 24,
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
                                campaign.name,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: darkBrownColor,
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
                                campaign.status,
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
                          campaign.description,
                          style: TextStyle(
                            fontSize: 12,
                            color: darkBrownColor.withOpacity(0.6),
                          ),
                          maxLines: 2,
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
                                color: campaignColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Text(
                                campaign.system,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: campaignColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Мастер: ${campaign.master}',
                              style: TextStyle(
                                fontSize: 11,
                                color: darkBrownColor.withOpacity(0.6),
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
                                color: campaignColor,
                                size: 12,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '${campaign.players}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: campaignColor,
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
                                color: campaignColor,
                                size: 12,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '${campaign.sessions}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: campaignColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Следующая сессия
                      if (campaign.nextSession != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6.0,
                            vertical: 2.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: Colors.green,
                                size: 10,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                _formatDate(campaign.nextSession),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )
                      else if (campaign.lastSession != null)
                        Text(
                          'Последняя: ${_formatDate(campaign.lastSession)}',
                          style: TextStyle(
                            fontSize: 10,
                            color: darkBrownColor.withOpacity(0.5),
                          ),
                        ),

                      const SizedBox(height: 4),

                      // Заметки (можно добавить поле notes в модель Campaign в будущем)
                      // Row(
                      //   children: [
                      //     Icon(
                      //       Icons.note,
                      //       color: campaignColor,
                      //       size: 10,
                      //     ),
                      //     const SizedBox(width: 2),
                      //     Text(
                      //       '0',
                      //       style: TextStyle(
                      //         fontSize: 10,
                      //         color: campaignColor,
                      //         fontWeight: FontWeight.w500,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),

                  const SizedBox(width: 8),

                  // Стрелка
                  Icon(
                    Icons.arrow_forward_ios,
                    color: campaignColor,
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