// lib/features/characters/presentation/screens/character_list_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '/core/constants/app_colors.dart';
import '/core/providers/character_providers.dart';
import '/domain/models/character.dart';

class CharacterListScreen extends ConsumerStatefulWidget {
  const CharacterListScreen({super.key});

  @override
  ConsumerState<CharacterListScreen> createState() => _CharacterListScreenState();
}

class _CharacterListScreenState extends ConsumerState<CharacterListScreen> {
  // Старые мок-данные (удалить после полной миграции)
  // ignore: unused_field
  final List<Map<String, dynamic>> _mockCharacters = [
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

  List<String> _getCampaigns(List<Character> characters) {
    final campaigns = characters
        .map((c) => c.campaign)
        .where((c) => c != null && c.isNotEmpty)
        .cast<String>()
        .toSet()
        .toList();
    campaigns.insert(0, 'Все кампании');
    return campaigns;
  }

  List<Character> _filterCharacters(List<Character> characters) {
    List<Character> filtered = List.from(characters);

    // Фильтрация по кампании
    if (_filterCampaign != 'all' && _filterCampaign != 'Все кампании') {
      filtered = filtered.where((c) => c.campaign == _filterCampaign).toList();
    }

    // Сортировка
    filtered.sort((a, b) {
      switch (_sortBy) {
        case 'level':
          return b.level.compareTo(a.level);
        case 'lastPlayed':
          final aDate = a.lastPlayed ?? DateTime(1970);
          final bDate = b.lastPlayed ?? DateTime(1970);
          return bDate.compareTo(aDate);
        case 'name':
        default:
          return a.name.compareTo(b.name);
      }
    });

    return filtered;
  }

  /// Удаление персонажа
  Future<void> _deleteCharacter(Character character) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить персонажа?'),
        content: Text('Вы уверены, что хотите удалить персонажа "${character.name}"?'),
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
      await ref.read(deleteCharacterProvider(character.id).future);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Персонаж "${character.name}" удален')),
        );
      }
    }
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

  void _showFilterDialog(List<Character> characters) {
    final campaigns = _getCampaigns(characters);
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
              ...campaigns.map((campaign) {
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

  Widget _buildCharacterCard(Character character) {
    // Определяем цвет аватара на основе имени
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.purple,
      Colors.orange,
      Colors.teal,
      Colors.pink,
      Colors.brown,
      Colors.indigo,
      Colors.cyan,
    ];
    final avatarColor = colors[character.name.hashCode.abs() % colors.length];

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
          context.go('/home/characters/${character.id}');
        },
        onLongPress: () {
          _deleteCharacter(character);
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
                  color: avatarColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: avatarColor.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    character.name.isNotEmpty ? character.name.substring(0, 1).toUpperCase() : '?',
                    style: GoogleFonts.cinzel(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: avatarColor,
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
                      character.name,
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
                      '${character.race} • ${character.characterClass}',
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
                            'Ур. ${character.level}',
                            style: GoogleFonts.cinzel(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.accentGold,
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        if (character.campaign != null && character.campaign!.isNotEmpty)
                          Expanded(
                            child: Text(
                              character.campaign!,
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

  void _showCharacterOptions(Character character) {
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
                  character.name,
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
                  context.go('/home/characters/${character.id}');
                },
              ),

              _buildOptionTile(
                Icons.edit_rounded,
                'Редактировать',
                    () {
                  Navigator.pop(context);
                  context.go('/home/characters/${character.id}/edit');
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
                  _deleteCharacter(character);
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

  void _duplicateCharacter(Character character) {
    // TODO: Реализовать копирование персонажа
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Создана копия ${character.name}',
          style: GoogleFonts.cinzel(),
        ),
        backgroundColor: AppColors.successGreen,
      ),
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
              Consumer(
                builder: (context, ref, child) {
                  final charactersAsync = ref.watch(charactersProvider);
                  return charactersAsync.when(
                    data: (characters) => IconButton(
                      onPressed: () => _showFilterDialog(characters),
                      icon: Icon(
                        Icons.filter_list_rounded,
                        color: AppColors.darkBrown,
                      ),
                      tooltip: 'Фильтровать',
                    ),
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  );
                },
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

          // Информация о фильтрах и список персонажей
          Consumer(
            builder: (context, ref, child) {
              final charactersAsync = ref.watch(charactersProvider);
              return charactersAsync.when(
                data: (characters) {
                  final filtered = _filterCharacters(characters);
                  return SliverList(
                    delegate: SliverChildListDelegate([
                      // Информация о фильтрах
                      Padding(
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
                              'Всего: ${filtered.length}',
                              style: GoogleFonts.cinzel(
                                fontSize: 14,
                                color: AppColors.woodBrown,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Список персонажей
                      if (filtered.isNotEmpty)
                        ...filtered.map((character) => _buildCharacterCard(character))
                      else
                        Padding(
                          padding: const EdgeInsets.all(32),
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
                            ],
                          ),
                        ),
                    ]),
                  );
                },
                loading: () => SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.primaryBrown),
                  ),
                ),
                error: (error, stack) => SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, color: Colors.red, size: 48),
                        const SizedBox(height: 16),
                        Text('Ошибка загрузки персонажей', style: GoogleFonts.cinzel(color: AppColors.darkBrown)),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () => ref.invalidate(charactersProvider),
                          child: const Text('Повторить'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
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