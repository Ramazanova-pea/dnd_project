// lib/features/characters/presentation/screens/character_list_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '/core/constants/app_colors.dart';

class CharacterListScreen extends StatefulWidget {
  const CharacterListScreen({super.key});

  @override
  State<CharacterListScreen> createState() => _CharacterListScreenState();
}

class _CharacterListScreenState extends State<CharacterListScreen> {
  final List<Map<String, dynamic>> _characters = [
    {
      'id': '1',
      'name': 'Арвен Веледа',
      'race': 'Эльф',
      'class': 'Рейнджер',
      'level': 5,
      'avatarColor': Colors.green,
      'campaign': 'Проклятие Страда',
      'lastPlayed': '2024-02-15',
    },
    {
      'id': '2',
      'name': 'Торгрим Стальной Кулак',
      'race': 'Дварф',
      'class': 'Воин',
      'level': 7,
      'avatarColor': Colors.blue,
      'campaign': 'Королевство Под Горой',
      'lastPlayed': '2024-02-14',
    },
    {
      'id': '3',
      'name': 'Морвина Теневой Шепот',
      'race': 'Темный Эльф',
      'class': 'Чародей',
      'level': 4,
      'avatarColor': Colors.purple,
      'campaign': 'Тени Недер-Рада',
      'lastPlayed': '2024-02-10',
    },
    {
      'id': '4',
      'name': 'Кейлеб Светлый',
      'race': 'Человек',
      'class': 'Жрец',
      'level': 6,
      'avatarColor': Colors.yellow,
      'campaign': 'Свет и Тьма',
      'lastPlayed': '2024-02-08',
    },
    {
      'id': '5',
      'name': 'Зоракс Чешуйчатый',
      'race': 'Драконорожденный',
      'class': 'Паладин',
      'level': 3,
      'avatarColor': Colors.red,
      'campaign': 'Дыхание Дракона',
      'lastPlayed': '2024-02-05',
    },
    {
      'id': '6',
      'name': 'Брик Каменная Стена',
      'race': 'Гном',
      'class': 'Изобретатель',
      'level': 8,
      'avatarColor': Colors.orange,
      'campaign': 'Механические Тайны',
      'lastPlayed': '2024-02-01',
    },
  ];

  String _sortBy = 'name'; // 'name', 'level', 'lastPlayed'
  String _filterCampaign = 'all';

  List<String> get _campaigns {
    final campaigns = _characters.map((c) => c['campaign'] as String).toSet().toList();
    campaigns.insert(0, 'Все кампании');
    return campaigns;
  }

  List<Map<String, dynamic>> get _filteredCharacters {
    List<Map<String, dynamic>> filtered = List.from(_characters);

    // Фильтрация по кампании
    if (_filterCampaign != 'all' && _filterCampaign != 'Все кампании') {
      filtered = filtered.where((c) => c['campaign'] == _filterCampaign).toList();
    }

    // Сортировка
    filtered.sort((a, b) {
      switch (_sortBy) {
        case 'level':
          return (b['level'] as int).compareTo(a['level'] as int);
        case 'lastPlayed':
          return (b['lastPlayed'] as String).compareTo(a['lastPlayed'] as String);
        case 'name':
        default:
          return (a['name'] as String).compareTo(b['name'] as String);
      }
    });

    return filtered;
  }

  void _showSortDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.parchment.withOpacity(0.95),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Сортировка',
                style: GoogleFonts.cinzel(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkBrown,
                ),
              ),
              const SizedBox(height: 16),
              _buildSortOption('По имени', 'name', Icons.sort_by_alpha_rounded),
              _buildSortOption('По уровню', 'level', Icons.trending_up_rounded),
              _buildSortOption('По дате игры', 'lastPlayed', Icons.calendar_today_rounded),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSortOption(String title, String value, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: AppColors.darkBrown),
      title: Text(
        title,
        style: GoogleFonts.cinzel(
          fontSize: 16,
          color: AppColors.darkBrown,
        ),
      ),
      trailing: _sortBy == value
          ? Icon(Icons.check_rounded, color: AppColors.accentGold)
          : null,
      onTap: () {
        setState(() {
          _sortBy = value;
        });
        Navigator.pop(context);
      },
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.parchment.withOpacity(0.95),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Фильтр по кампании',
                style: GoogleFonts.cinzel(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkBrown,
                ),
              ),
              const SizedBox(height: 16),
              ..._campaigns.map((campaign) {
                final isSelected = _filterCampaign == campaign ||
                    (campaign == 'Все кампании' && _filterCampaign == 'all');

                return ListTile(
                  title: Text(
                    campaign,
                    style: GoogleFonts.cinzel(
                      fontSize: 16,
                      color: AppColors.darkBrown,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(Icons.check_rounded, color: AppColors.accentGold)
                      : null,
                  onTap: () {
                    setState(() {
                      _filterCampaign = campaign == 'Все кампании' ? 'all' : campaign;
                    });
                    Navigator.pop(context);
                  },
                );
              }),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCharacterCard(Map<String, dynamic> character) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.lightBrown.withOpacity(0.3)),
      ),
      color: AppColors.parchment.withOpacity(0.9),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          context.go('/home/characters/${character['id']}');
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Аватар персонажа
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: (character['avatarColor'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: (character['avatarColor'] as Color).withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    character['name'].toString().substring(0, 1),
                    style: GoogleFonts.cinzel(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: character['avatarColor'] as Color,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Информация о персонаже
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      character['name'] as String,
                      style: GoogleFonts.cinzel(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkBrown,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    Text(
                      '${character['race']} • ${character['class']}',
                      style: GoogleFonts.cinzel(
                        fontSize: 14,
                        color: AppColors.woodBrown,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.accentGold.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.accentGold.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            'Ур. ${character['level']}',
                            style: GoogleFonts.cinzel(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.accentGold,
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        Expanded(
                          child: Text(
                            character['campaign'] as String,
                            style: GoogleFonts.cinzel(
                              fontSize: 12,
                              color: AppColors.woodBrown.withOpacity(0.8),
                              fontStyle: FontStyle.italic,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Кнопка действий
              IconButton(
                onPressed: () {
                  _showCharacterOptions(character);
                },
                icon: Icon(
                  Icons.more_vert_rounded,
                  color: AppColors.darkBrown.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCharacterOptions(Map<String, dynamic> character) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.parchment.withOpacity(0.95),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  character['name'] as String,
                  style: GoogleFonts.cinzel(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkBrown,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              Divider(color: AppColors.lightBrown.withOpacity(0.3), height: 1),

              _buildOptionTile(
                Icons.visibility_rounded,
                'Просмотреть',
                    () {
                  Navigator.pop(context);
                  context.go('/home/characters/${character['id']}');
                },
              ),

              _buildOptionTile(
                Icons.edit_rounded,
                'Редактировать',
                    () {
                  Navigator.pop(context);
                  context.go('/home/characters/${character['id']}/edit');
                },
              ),

              _buildOptionTile(
                Icons.copy_rounded,
                'Создать копию',
                    () {
                  Navigator.pop(context);
                  _duplicateCharacter(character);
                },
              ),

              Divider(color: AppColors.lightBrown.withOpacity(0.3), height: 1),

              _buildOptionTile(
                Icons.delete_rounded,
                'Удалить',
                    () {
                  Navigator.pop(context);
                  _showDeleteDialog(character);
                },
                isDestructive: true,
              ),

              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOptionTile(IconData icon, String text, VoidCallback onTap, {bool isDestructive = false}) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? AppColors.errorRed : AppColors.darkBrown,
      ),
      title: Text(
        text,
        style: GoogleFonts.cinzel(
          fontSize: 16,
          color: isDestructive ? AppColors.errorRed : AppColors.darkBrown,
        ),
      ),
      onTap: onTap,
    );
  }

  void _duplicateCharacter(Map<String, dynamic> character) {
    // TODO: Реализовать копирование персонажа
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Создана копия ${character['name']}',
          style: GoogleFonts.cinzel(),
        ),
        backgroundColor: AppColors.successGreen,
      ),
    );
  }

  void _showDeleteDialog(Map<String, dynamic> character) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.parchment,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Удалить персонажа?',
            style: GoogleFonts.cinzel(
              fontWeight: FontWeight.w700,
              color: AppColors.darkBrown,
            ),
          ),
          content: Text(
            'Вы уверены, что хотите удалить "${character['name']}"? Это действие нельзя отменить.',
            style: GoogleFonts.cinzel(
              color: AppColors.woodBrown,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Отмена',
                style: GoogleFonts.cinzel(
                  color: AppColors.woodBrown,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _characters.removeWhere((c) => c['id'] == character['id']);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Персонаж "${character['name']}" удален',
                      style: GoogleFonts.cinzel(),
                    ),
                    backgroundColor: AppColors.errorRed,
                  ),
                );
              },
              child: Text(
                'Удалить',
                style: GoogleFonts.cinzel(
                  color: AppColors.errorRed,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.parchment.withOpacity(0.97),
      body: CustomScrollView(
        slivers: [
          // Заголовок
          SliverAppBar(
            backgroundColor: AppColors.parchment,
            elevation: 0,
            pinned: true,
            title: Text(
              'Персонажи',
              style: GoogleFonts.cinzel(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: AppColors.darkBrown,
              ),
            ),
            actions: [
              IconButton(
                onPressed: _showFilterDialog,
                icon: Icon(
                  Icons.filter_list_rounded,
                  color: AppColors.darkBrown,
                ),
                tooltip: 'Фильтровать',
              ),
              IconButton(
                onPressed: _showSortDialog,
                icon: Icon(
                  Icons.sort_rounded,
                  color: AppColors.darkBrown,
                ),
                tooltip: 'Сортировать',
              ),
            ],
          ),

          // Информация о фильтрах
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  if (_filterCampaign != 'all')
                    Chip(
                      label: Text(
                        _filterCampaign == 'Все кампании' ? 'Все кампании' : _filterCampaign,
                        style: GoogleFonts.cinzel(fontSize: 12),
                      ),
                      backgroundColor: AppColors.primaryBrown.withOpacity(0.1),
                      side: BorderSide(color: AppColors.primaryBrown.withOpacity(0.3)),
                      onDeleted: () {
                        setState(() {
                          _filterCampaign = 'all';
                        });
                      },
                    ),
                  const Spacer(),
                  Text(
                    'Всего: ${_filteredCharacters.length}',
                    style: GoogleFonts.cinzel(
                      fontSize: 14,
                      color: AppColors.woodBrown,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Список персонажей
          if (_filteredCharacters.isNotEmpty)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return _buildCharacterCard(_filteredCharacters[index]);
                },
                childCount: _filteredCharacters.length,
              ),
            )
          else
            SliverFillRemaining(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_outline_rounded,
                    size: 80,
                    color: AppColors.lightBrown.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Нет персонажей',
                    style: GoogleFonts.cinzel(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkBrown,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _filterCampaign == 'all'
                        ? 'Создайте своего первого персонажа!'
                        : 'Нет персонажей в этой кампании',
                    style: GoogleFonts.cinzel(
                      fontSize: 14,
                      color: AppColors.woodBrown,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  if (_filterCampaign != 'all')
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _filterCampaign = 'all';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBrown,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Показать всех',
                        style: GoogleFonts.cinzel(fontSize: 14),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),

      // Кнопка создания нового персонажа
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.go('/home/characters/create');
        },
        backgroundColor: AppColors.accentGold,
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.add_rounded),
        label: Text(
          'Создать',
          style: GoogleFonts.cinzel(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}