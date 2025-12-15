import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '/core/constants/app_colors.dart';

// Временные модели и провайдеры (замените на реальные)
class CampaignNote {
  final String id;
  final String campaignId;
  final String authorId;
  final String authorName;
  final String title;
  final String content;
  final String type;
  final String? sessionId;
  final String? characterId;
  final String? location;
  final List<String> tags;
  final bool isPrivate;
  final bool isPinned;
  final DateTime createdAt;
  final DateTime? updatedAt;

  CampaignNote({
    required this.id,
    required this.campaignId,
    required this.authorId,
    required this.authorName,
    required this.title,
    required this.content,
    required this.type,
    this.sessionId,
    this.characterId,
    this.location,
    required this.tags,
    required this.isPrivate,
    required this.isPinned,
    required this.createdAt,
    this.updatedAt,
  });
}

final campaignNotesProvider = FutureProvider.family<List<CampaignNote>, String>((ref, campaignId) async {
  await Future.delayed(const Duration(seconds: 1));
  return [
    CampaignNote(
      id: '1',
      campaignId: campaignId,
      authorId: '1',
      authorName: 'Алексей',
      title: 'Важная NPC',
      content: 'Старуха-пророчица у входа в лес знает путь к храму. Может помочь за соответствующую плату. Характер: мудрая, но жадная.',
      type: 'npc',
      tags: ['npc', 'пророчица', 'помощник'],
      isPrivate: false,
      isPinned: true,
      createdAt: DateTime(2023, 12, 15),
      updatedAt: DateTime(2023, 12, 16),
    ),
    CampaignNote(
      id: '2',
      campaignId: campaignId,
      authorId: '2',
      authorName: 'Мария',
      title: 'Слабость гоблинов',
      content: 'Гоблины из Темного леса боятся яркого света и серебряного оружия. Также они ненавидят запах хвои.',
      type: 'enemy',
      sessionId: '1',
      tags: ['гоблины', 'слабость', 'комбат'],
      isPrivate: false,
      isPinned: true,
      createdAt: DateTime(2023, 12, 16),
    ),
    CampaignNote(
      id: '3',
      campaignId: campaignId,
      authorId: '3',
      authorName: 'Дмитрий',
      title: 'Сокровище в пещере',
      content: 'В северной части леса есть скрытая пещера с сундуком. Сундук заперт магическим замком, ключ у вождя гоблинов.',
      type: 'location',
      sessionId: '2',
      location: 'Северная пещера',
      tags: ['сокровище', 'локация', 'квест'],
      isPrivate: false,
      isPinned: false,
      createdAt: DateTime(2023, 12, 23),
    ),
    CampaignNote(
      id: '4',
      campaignId: campaignId,
      authorId: '1',
      authorName: 'Алексей',
      title: 'Тайна храма',
      content: 'Храм охраняется древним големом. Чтобы пройти, нужно решить три загадки у статуй богов.',
      type: 'puzzle',
      tags: ['голем', 'загадки', 'храм'],
      isPrivate: true,
      isPinned: false,
      createdAt: DateTime(2023, 12, 25),
    ),
    CampaignNote(
      id: '5',
      campaignId: campaignId,
      authorId: '4',
      authorName: 'Ольга',
      title: 'Магический артефакт',
      content: 'В центре храма находится "Око Провидения" - кристалл, показывающий прошлое любого, кто коснется его.',
      type: 'item',
      tags: ['артефакт', 'магия', 'квестовый предмет'],
      isPrivate: false,
      isPinned: false,
      createdAt: DateTime(2023, 12, 28),
    ),
    CampaignNote(
      id: '6',
      campaignId: campaignId,
      authorId: '2',
      authorName: 'Мария',
      title: 'Заметки о драконе',
      content: 'Древний красный дракон охраняет сокровищницу. Слабость: ледяная магия. Любит загадки и может быть обманут.',
      type: 'enemy',
      tags: ['дракон', 'босс', 'слабость'],
      isPrivate: false,
      isPinned: false,
      createdAt: DateTime(2024, 1, 2),
    ),
  ];
});

final campaignProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, campaignId) async {
  await Future.delayed(const Duration(milliseconds: 500));
  return {
    'id': campaignId,
    'name': 'Поход за Священным Граалем',
  };
});

class NotesScreen extends ConsumerStatefulWidget {
  final String campaignId;

  const NotesScreen({
    Key? key,
    required this.campaignId,
  }) : super(key: key);

  @override
  ConsumerState<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends ConsumerState<NotesScreen> {
  String _selectedFilter = 'all';
  String _selectedType = 'all';
  String _searchQuery = '';
  bool _showOnlyPinned = false;
  bool _showOnlyMine = false;

  final List<String> _typeFilters = [
    'all',
    'npc',
    'enemy',
    'location',
    'item',
    'puzzle',
    'plot',
    'session',
    'character',
  ];

  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final campaignAsync = ref.watch(campaignProvider(widget.campaignId));
    final notesAsync = ref.watch(campaignNotesProvider(widget.campaignId));

    return Scaffold(
      backgroundColor: AppColors.lightParchment,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _createNote(),
        backgroundColor: AppColors.primaryBrown,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.note_add),
        label: const Text('Новая заметка'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      body: Column(
        children: [
          // Заголовок и поиск
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  // Аппбар
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: AppColors.darkBrown,
                          ),
                          onPressed: () => context.pop(),
                        ),
                        Expanded(
                          child: campaignAsync.when(
                            loading: () => Text(
                              'Заметки',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.darkBrown,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            error: (error, stackTrace) => Text(
                              'Заметки',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.darkBrown,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            data: (campaign) => Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  campaign['name'] ?? 'Кампания',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.darkBrown,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'Заметки',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.darkBrown,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.filter_list,
                            color: AppColors.primaryBrown,
                          ),
                          onPressed: () => _showFilters(),
                        ),
                      ],
                    ),
                  ),

                  // Поиск
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Поиск заметок...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _searchQuery = '';
                              _searchController.clear();
                            });
                          },
                        )
                            : null,
                        filled: true,
                        fillColor: AppColors.lightParchment,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Активные фильтры
          _buildActiveFilters(),

          // Статистика
          _buildStatistics(notesAsync),

          // Список заметок
          Expanded(
            child: notesAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryBrown,
                ),
              ),
              error: (error, stackTrace) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: AppColors.errorRed,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Ошибка загрузки заметок',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.darkBrown,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        error.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.mediumBrown,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => ref.refresh(campaignNotesProvider(widget.campaignId)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBrown,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('ПОВТОРИТЬ ПОПЫТКУ'),
                    ),
                  ],
                ),
              ),
              data: (notes) {
                final filteredNotes = _filterNotes(notes);
                return _buildNotesList(filteredNotes);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFilters() {
    final activeFilters = <String>[];

    if (_selectedType != 'all') {
      activeFilters.add(_getTypeName(_selectedType));
    }
    if (_showOnlyPinned) {
      activeFilters.add('Закрепленные');
    }
    if (_showOnlyMine) {
      activeFilters.add('Мои');
    }
    if (_selectedFilter != 'all') {
      activeFilters.add(_selectedFilter == 'private' ? 'Приватные' : 'Публичные');
    }

    if (activeFilters.isEmpty) return const SizedBox();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: AppColors.lightParchment,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: activeFilters.map((filter) {
          return Chip(
            label: Text(filter),
            backgroundColor: AppColors.primaryBrown.withOpacity(0.1),
            deleteIcon: const Icon(Icons.close, size: 16),
            onDeleted: () {
              setState(() {
                if (filter == _getTypeName(_selectedType)) {
                  _selectedType = 'all';
                } else if (filter == 'Закрепленные') {
                  _showOnlyPinned = false;
                } else if (filter == 'Мои') {
                  _showOnlyMine = false;
                } else if (filter == 'Приватные' || filter == 'Публичные') {
                  _selectedFilter = 'all';
                }
              });
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStatistics(AsyncValue<List<CampaignNote>> notesAsync) {
    return notesAsync.when(
      loading: () => Container(),
      error: (error, stackTrace) => Container(),
      data: (notes) {
        final pinned = notes.where((n) => n.isPinned).length;
        final private = notes.where((n) => n.isPrivate).length;
        final total = notes.length;

        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.accentGold.withOpacity(0.1),
                AppColors.primaryBrown.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.accentGold.withOpacity(0.2),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                value: total.toString(),
                label: 'Всего',
                icon: Icons.note,
                color: AppColors.darkBrown,
              ),
              _buildStatItem(
                value: pinned.toString(),
                label: 'Закреплено',
                icon: Icons.push_pin,
                color: AppColors.accentGold,
              ),
              _buildStatItem(
                value: private.toString(),
                label: 'Приватных',
                icon: Icons.lock,
                color: AppColors.primaryBrown,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem({
    required String value,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: AppColors.mediumBrown,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildNotesList(List<CampaignNote> notes) {
    if (notes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.note,
              size: 80,
              color: AppColors.mediumBrown.withOpacity(0.3),
            ),
            const SizedBox(height: 20),
            Text(
              _searchQuery.isNotEmpty
                  ? 'Заметок не найдено'
                  : 'Заметок пока нет',
              style: TextStyle(
                fontSize: 20,
                color: AppColors.darkBrown,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _searchQuery.isNotEmpty
                  ? 'Попробуйте изменить запрос или фильтры'
                  : 'Создайте первую заметку для этой кампании',
              style: TextStyle(
                color: AppColors.mediumBrown,
              ),
            ),
            const SizedBox(height: 24),
            if (!_searchQuery.isNotEmpty)
              ElevatedButton.icon(
                onPressed: () => _createNote(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBrown,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                icon: const Icon(Icons.note_add),
                label: const Text('СОЗДАТЬ ЗАМЕТКУ'),
              ),
          ],
        ),
      );
    }

    // Разделяем на закрепленные и обычные
    final pinnedNotes = notes.where((n) => n.isPinned).toList();
    final regularNotes = notes.where((n) => !n.isPinned).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Закрепленные заметки
        if (pinnedNotes.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Icon(
                  Icons.push_pin,
                  color: AppColors.accentGold,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Закрепленные заметки',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBrown,
                  ),
                ),
              ],
            ),
          ),
          ...pinnedNotes.map((note) => _buildNoteCard(note)),
          const SizedBox(height: 24),
        ],

        // Обычные заметки
        if (regularNotes.isNotEmpty) ...[
          if (pinnedNotes.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Icon(
                    Icons.note,
                    color: AppColors.primaryBrown,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Все заметки',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkBrown,
                    ),
                  ),
                ],
              ),
            ),
          ...regularNotes.map((note) => _buildNoteCard(note)),
        ],
      ],
    );
  }

  Widget _buildNoteCard(CampaignNote note) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: note.isPinned ? 3 : 2,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _viewNote(note),
          onLongPress: () => _showNoteOptions(note),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Заголовок и иконки
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            note.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkBrown,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                _getTypeIcon(note.type),
                                size: 14,
                                color: _getTypeColor(note.type),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _getTypeName(note.type),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: _getTypeColor(note.type),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '${note.authorName} • ${DateFormat('dd.MM.yyyy').format(note.createdAt)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.mediumBrown,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (note.isPinned)
                      Icon(
                        Icons.push_pin,
                        color: AppColors.accentGold,
                        size: 20,
                      ),
                    if (note.isPrivate)
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Icon(
                          Icons.lock,
                          color: AppColors.primaryBrown,
                          size: 16,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 12),

                // Содержимое
                Text(
                  note.content,
                  style: TextStyle(
                    color: AppColors.darkBrown.withOpacity(0.8),
                    fontSize: 14,
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),

                // Теги и дополнительная информация
                if (note.tags.isNotEmpty || note.location != null) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      // Теги
                      ...note.tags.map((tag) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.lightBrown.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.mediumBrown,
                          ),
                        ),
                      )).toList(),

                      // Локация
                      if (note.location != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.infoBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 10,
                                color: AppColors.infoBlue,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                note.location!,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.infoBlue,
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Сессия
                      if (note.sessionId != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.successGreen.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.event,
                                size: 10,
                                color: AppColors.successGreen,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Сессия #${note.sessionId}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.successGreen,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<CampaignNote> _filterNotes(List<CampaignNote> notes) {
    var filtered = notes;

    // Фильтр по типу
    if (_selectedType != 'all') {
      filtered = filtered.where((note) => note.type == _selectedType).toList();
    }

    // Фильтр по приватности
    if (_selectedFilter != 'all') {
      filtered = filtered.where((note) =>
      _selectedFilter == 'private' ? note.isPrivate : !note.isPrivate
      ).toList();
    }

    // Фильтр по закрепленным
    if (_showOnlyPinned) {
      filtered = filtered.where((note) => note.isPinned).toList();
    }

    // Фильтр по автору (мои заметки)
    if (_showOnlyMine) {
      // TODO: Заменить 'currentUserId' на реальный ID текущего пользователя
      filtered = filtered.where((note) => note.authorId == 'currentUserId').toList();
    }

    // Поиск
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((note) =>
      note.title.toLowerCase().contains(query) ||
          note.content.toLowerCase().contains(query) ||
          note.tags.any((tag) => tag.toLowerCase().contains(query))
      ).toList();
    }

    // Сортировка: сначала закрепленные, потом по дате создания
    filtered.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return b.createdAt.compareTo(a.createdAt);
    });

    return filtered;
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'npc':
        return Icons.person;
      case 'enemy':
        return Icons.security;
      case 'location':
        return Icons.location_on;
      case 'item':
        return Icons.inventory;
      case 'puzzle':
        return Icons.psychology;
      case 'plot':
        return Icons.auto_stories;
      case 'session':
        return Icons.event;
      case 'character':
        return Icons.face;
      default:
        return Icons.note;
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'npc':
        return AppColors.infoBlue;
      case 'enemy':
        return AppColors.errorRed;
      case 'location':
        return AppColors.successGreen;
      case 'item':
        return AppColors.accentGold;
      case 'puzzle':
        return AppColors.warningOrange;
      case 'plot':
        return AppColors.primaryBrown;
      case 'session':
        return AppColors.darkBrown;
      case 'character':
        return AppColors.accentGold;
      default:
        return AppColors.mediumBrown;
    }
  }

  String _getTypeName(String type) {
    switch (type) {
      case 'all':
        return 'Все';
      case 'npc':
        return 'NPC';
      case 'enemy':
        return 'Враги';
      case 'location':
        return 'Локации';
      case 'item':
        return 'Предметы';
      case 'puzzle':
        return 'Загадки';
      case 'plot':
        return 'Сюжет';
      case 'session':
        return 'Сессии';
      case 'character':
        return 'Персонажи';
      default:
        return 'Заметка';
    }
  }

  void _createNote() {
    // TODO: Реализовать создание заметки
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Создание новой заметки'),
      ),
    );
  }

  void _viewNote(CampaignNote note) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.lightParchment,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return _buildNoteDetails(note);
      },
    );
  }

  Widget _buildNoteDetails(CampaignNote note) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.lightBrown.withOpacity(0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Заголовок и тип
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getTypeColor(note.type).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getTypeIcon(note.type),
                  color: _getTypeColor(note.type),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkBrown,
                      ),
                    ),
                    Text(
                      _getTypeName(note.type),
                      style: TextStyle(
                        color: _getTypeColor(note.type),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              if (note.isPinned)
                Icon(
                  Icons.push_pin,
                  color: AppColors.accentGold,
                ),
              if (note.isPrivate)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Icon(
                    Icons.lock,
                    color: AppColors.primaryBrown,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),

          // Автор и дата
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.accentGold.withOpacity(0.2),
                child: Icon(
                  Icons.person,
                  size: 16,
                  color: AppColors.accentGold,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.authorName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkBrown,
                      ),
                    ),
                    Text(
                      DateFormat('dd.MM.yyyy HH:mm').format(note.createdAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.mediumBrown,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Содержимое
          Text(
            note.content,
            style: TextStyle(
              color: AppColors.darkBrown.withOpacity(0.9),
              fontSize: 16,
              height: 1.5,
            ),
          ),

          // Теги
          if (note.tags.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text(
              'Теги',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.darkBrown,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: note.tags.map((tag) => Chip(
                label: Text(tag),
                backgroundColor: AppColors.lightBrown.withOpacity(0.1),
                labelStyle: TextStyle(
                  color: AppColors.darkBrown,
                  fontSize: 12,
                ),
              )).toList(),
            ),
          ],

          // Дополнительная информация
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.lightBrown.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.lightBrown.withOpacity(0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Дополнительная информация',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBrown,
                  ),
                ),
                const SizedBox(height: 12),
                if (note.location != null)
                  _buildDetailRow(
                    icon: Icons.location_on,
                    label: 'Локация',
                    value: note.location!,
                  ),
                if (note.sessionId != null)
                  _buildDetailRow(
                    icon: Icons.event,
                    label: 'Сессия',
                    value: '№${note.sessionId}',
                  ),
                if (note.characterId != null)
                  _buildDetailRow(
                    icon: Icons.face,
                    label: 'Персонаж',
                    value: 'ID: ${note.characterId}',
                  ),
                _buildDetailRow(
                  icon: Icons.lock,
                  label: 'Видимость',
                  value: note.isPrivate ? 'Только для меня' : 'Для всех участников',
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Кнопки действий
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _editNote(note);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBrown,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.edit),
                  label: const Text('РЕДАКТИРОВАТЬ'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.darkBrown,
                    side: BorderSide(
                      color: AppColors.darkBrown.withOpacity(0.3),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.close),
                  label: const Text('ЗАКРЫТЬ'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: AppColors.mediumBrown,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.mediumBrown,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.darkBrown,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.lightParchment,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.lightBrown.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Text(
                    'Фильтры заметок',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkBrown,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Тип заметки
                  Text(
                    'Тип заметки',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkBrown,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _typeFilters.map((type) {
                      final isSelected = type == _selectedType;
                      return FilterChip(
                        label: Text(
                          _getTypeName(type),
                          style: TextStyle(
                            color: isSelected ? Colors.white : AppColors.darkBrown,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedType = selected ? type : 'all';
                          });
                        },
                        backgroundColor: Colors.white,
                        selectedColor: _getTypeColor(type),
                        checkmarkColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSelected
                                ? _getTypeColor(type)
                                : AppColors.lightBrown.withOpacity(0.5),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  // Дополнительные фильтры
                  Text(
                    'Дополнительные фильтры',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkBrown,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Column(
                    children: [
                      _buildFilterSwitch(
                        label: 'Только закрепленные заметки',
                        value: _showOnlyPinned,
                        onChanged: (value) {
                          setState(() {
                            _showOnlyPinned = value;
                          });
                        },
                        icon: Icons.push_pin,
                        color: AppColors.accentGold,
                      ),
                      _buildFilterSwitch(
                        label: 'Только мои заметки',
                        value: _showOnlyMine,
                        onChanged: (value) {
                          setState(() {
                            _showOnlyMine = value;
                          });
                        },
                        icon: Icons.person,
                        color: AppColors.primaryBrown,
                      ),
                      _buildFilterRadio(
                        label: 'Приватные заметки',
                        value: 'private',
                        groupValue: _selectedFilter,
                        onChanged: (value) {
                          setState(() {
                            _selectedFilter = value!;
                          });
                        },
                      ),
                      _buildFilterRadio(
                        label: 'Публичные заметки',
                        value: 'public',
                        groupValue: _selectedFilter,
                        onChanged: (value) {
                          setState(() {
                            _selectedFilter = value!;
                          });
                        },
                      ),
                      _buildFilterRadio(
                        label: 'Все заметки',
                        value: 'all',
                        groupValue: _selectedFilter,
                        onChanged: (value) {
                          setState(() {
                            _selectedFilter = value!;
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Кнопки
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _selectedType = 'all';
                              _showOnlyPinned = false;
                              _showOnlyMine = false;
                              _selectedFilter = 'all';
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.darkBrown,
                            side: BorderSide(
                              color: AppColors.darkBrown.withOpacity(0.3),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('СБРОСИТЬ ФИЛЬТРЫ'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            setState(() {});
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBrown,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('ПРИМЕНИТЬ'),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFilterSwitch({
    required String label,
    required bool value,
    required Function(bool) onChanged,
    required IconData icon,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.darkBrown,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: color,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterRadio({
    required String label,
    required String value,
    required String? groupValue,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Radio(
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
            activeColor: AppColors.primaryBrown,
          ),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.darkBrown,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showNoteOptions(CampaignNote note) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.lightParchment,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                note.title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkBrown,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              ListTile(
                leading: Icon(
                  Icons.edit,
                  color: AppColors.primaryBrown,
                ),
                title: const Text('Редактировать'),
                onTap: () {
                  Navigator.pop(context);
                  _editNote(note);
                },
              ),

              ListTile(
                leading: Icon(
                  note.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                  color: AppColors.accentGold,
                ),
                title: Text(note.isPinned ? 'Открепить' : 'Закрепить'),
                onTap: () {
                  Navigator.pop(context);
                  _togglePinNote(note);
                },
              ),

              ListTile(
                leading: Icon(
                  note.isPrivate ? Icons.lock_open : Icons.lock,
                  color: AppColors.primaryBrown,
                ),
                title: Text(note.isPrivate ? 'Сделать публичной' : 'Сделать приватной'),
                onTap: () {
                  Navigator.pop(context);
                  _togglePrivacyNote(note);
                },
              ),

              ListTile(
                leading: Icon(
                  Icons.share,
                  color: AppColors.infoBlue,
                ),
                title: const Text('Поделиться'),
                onTap: () {
                  Navigator.pop(context);
                  _shareNote(note);
                },
              ),

              ListTile(
                leading: Icon(
                  Icons.copy,
                  color: AppColors.successGreen,
                ),
                title: const Text('Копировать'),
                onTap: () {
                  Navigator.pop(context);
                  _copyNote(note);
                },
              ),

              ListTile(
                leading: Icon(
                  Icons.delete,
                  color: AppColors.errorRed,
                ),
                title: const Text('Удалить'),
                onTap: () {
                  Navigator.pop(context);
                  _deleteNote(note);
                },
              ),

              const SizedBox(height: 16),

              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.mediumBrown,
                  side: BorderSide(color: AppColors.mediumBrown.withOpacity(0.3)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text('ЗАКРЫТЬ'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _editNote(CampaignNote note) {
    // TODO: Реализовать редактирование заметки
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Редактирование заметки: ${note.title}'),
      ),
    );
  }

  void _togglePinNote(CampaignNote note) {
    // TODO: Обновить статус закрепления заметки
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(note.isPinned ? 'Заметка откреплена' : 'Заметка закреплена'),
        backgroundColor: AppColors.successGreen,
      ),
    );
  }

  void _togglePrivacyNote(CampaignNote note) {
    // TODO: Обновить статус приватности заметки
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(note.isPrivate ? 'Заметка стала публичной' : 'Заметка стала приватной'),
        backgroundColor: AppColors.successGreen,
      ),
    );
  }

  void _shareNote(CampaignNote note) {
    // TODO: Реализовать шеринг заметки
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Поделиться заметкой: ${note.title}'),
      ),
    );
  }

  void _copyNote(CampaignNote note) {
    // TODO: Реализовать копирование заметки
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Заметка "${note.title}" скопирована'),
        backgroundColor: AppColors.successGreen,
      ),
    );
  }

  void _deleteNote(CampaignNote note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить заметку'),
        content: Text('Вы уверены, что хотите удалить заметку "${note.title}"? Это действие нельзя отменить.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ОТМЕНА'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Удалить заметку из базы данных
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Заметка "${note.title}" удалена'),
                  backgroundColor: AppColors.successGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorRed,
            ),
            child: const Text('УДАЛИТЬ'),
          ),
        ],
      ),
    );
  }
}