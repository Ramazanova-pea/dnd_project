import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '/core/constants/app_colors.dart';

// Временные модели и провайдеры (замените на реальные)
class Chat {
  final String id;
  final String name;
  final String? description;
  final String type; // 'campaign', 'group', 'private'
  final String? campaignId;
  final List<Map<String, dynamic>> participants;
  final Map<String, dynamic>? lastMessage;
  final int unreadCount;
  final bool isPinned;
  final bool isMuted;
  final DateTime? lastActivity;
  final String? avatarUrl;

  Chat({
    required this.id,
    required this.name,
    this.description,
    required this.type,
    this.campaignId,
    required this.participants,
    this.lastMessage,
    required this.unreadCount,
    required this.isPinned,
    required this.isMuted,
    this.lastActivity,
    this.avatarUrl,
  });
}

final chatsProvider = FutureProvider<List<Chat>>((ref) async {
  await Future.delayed(const Duration(seconds: 1));
  return [
    Chat(
      id: '1',
      name: 'Поход за Граалем',
      description: 'Основной чат кампании',
      type: 'campaign',
      campaignId: '1',
      participants: [
        {'id': '1', 'name': 'Алексей', 'role': 'master'},
        {'id': '2', 'name': 'Мария', 'role': 'player'},
        {'id': '3', 'name': 'Дмитрий', 'role': 'player'},
        {'id': '4', 'name': 'Ольга', 'role': 'player'},
      ],
      lastMessage: {
        'senderId': '2',
        'senderName': 'Мария',
        'text': 'Я нашла карту храма!',
        'timestamp': DateTime.now().subtract(const Duration(minutes: 15)),
        'isRead': false,
      },
      unreadCount: 3,
      isPinned: true,
      isMuted: false,
      lastActivity: DateTime.now().subtract(const Duration(minutes: 15)),
      avatarUrl: null,
    ),
    Chat(
      id: '2',
      name: 'Мария',
      type: 'private',
      participants: [
        {'id': '2', 'name': 'Мария', 'role': 'player'},
      ],
      lastMessage: {
        'senderId': '2',
        'senderName': 'Мария',
        'text': 'Спасибо за помощь с квестом!',
        'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
        'isRead': true,
      },
      unreadCount: 0,
      isPinned: true,
      isMuted: false,
      lastActivity: DateTime.now().subtract(const Duration(hours: 2)),
      avatarUrl: null,
    ),
    Chat(
      id: '3',
      name: 'Обсуждение тактики',
      description: 'Боевые сценарии и стратегии',
      type: 'group',
      participants: [
        {'id': '1', 'name': 'Алексей', 'role': 'master'},
        {'id': '2', 'name': 'Мария', 'role': 'player'},
        {'id': '3', 'name': 'Дмитрий', 'role': 'player'},
      ],
      lastMessage: {
        'senderId': '3',
        'senderName': 'Дмитрий',
        'text': 'Предлагаю атаковать с фланга',
        'timestamp': DateTime.now().subtract(const Duration(hours: 5)),
        'isRead': true,
      },
      unreadCount: 0,
      isPinned: false,
      isMuted: true,
      lastActivity: DateTime.now().subtract(const Duration(hours: 5)),
      avatarUrl: null,
    ),
    Chat(
      id: '4',
      name: 'Сокровища и добыча',
      description: 'Распределение находок',
      type: 'group',
      participants: [
        {'id': '1', 'name': 'Алексей', 'role': 'master'},
        {'id': '2', 'name': 'Мария', 'role': 'player'},
        {'id': '3', 'name': 'Дмитрий', 'role': 'player'},
        {'id': '4', 'name': 'Ольга', 'role': 'player'},
      ],
      lastMessage: {
        'senderId': '1',
        'senderName': 'Алексей',
        'text': 'Завтра разберем сокровища из пещеры',
        'timestamp': DateTime.now().subtract(const Duration(days: 1)),
        'isRead': true,
      },
      unreadCount: 0,
      isPinned: false,
      isMuted: false,
      lastActivity: DateTime.now().subtract(const Duration(days: 1)),
      avatarUrl: null,
    ),
    Chat(
      id: '5',
      name: 'Дмитрий',
      type: 'private',
      participants: [
        {'id': '3', 'name': 'Дмитрий', 'role': 'player'},
      ],
      lastMessage: {
        'senderId': '3',
        'senderName': 'Дмитрий',
        'text': 'Мой персонаж готов к сессии',
        'timestamp': DateTime.now().subtract(const Duration(days: 2)),
        'isRead': true,
      },
      unreadCount: 0,
      isPinned: false,
      isMuted: false,
      lastActivity: DateTime.now().subtract(const Duration(days: 2)),
      avatarUrl: null,
    ),
    Chat(
      id: '6',
      name: 'Общий D&D чат',
      description: 'Обсуждение правил и механик',
      type: 'group',
      participants: [
        {'id': '1', 'name': 'Алексей', 'role': 'master'},
        {'id': '2', 'name': 'Мария', 'role': 'player'},
        {'id': '3', 'name': 'Дмитрий', 'role': 'player'},
        {'id': '4', 'name': 'Ольга', 'role': 'player'},
        {'id': '5', 'name': 'Иван', 'role': 'player'},
      ],
      lastMessage: {
        'senderId': '5',
        'senderName': 'Иван',
        'text': 'Кто играет в субботу?',
        'timestamp': DateTime.now().subtract(const Duration(days: 3)),
        'isRead': true,
      },
      unreadCount: 0,
      isPinned: false,
      isMuted: false,
      lastActivity: DateTime.now().subtract(const Duration(days: 3)),
      avatarUrl: null,
    ),
  ];
});

class ChatListScreen extends ConsumerStatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends ConsumerState<ChatListScreen> {
  String _selectedFilter = 'all';
  String _searchQuery = '';
  final List<String> _filters = ['all', 'unread', 'pinned', 'campaigns', 'groups', 'private'];

  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatsAsync = ref.watch(chatsProvider);

    return Scaffold(
      backgroundColor: AppColors.lightParchment,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createChat(),
        backgroundColor: AppColors.primaryBrown,
        foregroundColor: Colors.white,
        child: const Icon(Icons.chat_bubble_outline),
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
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Чаты',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkBrown,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.group_add,
                            color: AppColors.primaryBrown,
                          ),
                          onPressed: () => _createGroupChat(),
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
                        hintText: 'Поиск чатов или сообщений...',
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

                  // Фильтры
                  SizedBox(
                    height: 60,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: _filters.map((filter) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(
                              _getFilterText(filter),
                              style: TextStyle(
                                color: _selectedFilter == filter
                                    ? Colors.white
                                    : AppColors.darkBrown,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            selected: _selectedFilter == filter,
                            onSelected: (selected) {
                              setState(() {
                                _selectedFilter = selected ? filter : 'all';
                              });
                            },
                            backgroundColor: Colors.white,
                            selectedColor: _getFilterColor(filter),
                            checkmarkColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color: _selectedFilter == filter
                                    ? _getFilterColor(filter)
                                    : AppColors.lightBrown.withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Список чатов
          Expanded(
            child: chatsAsync.when(
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
                      'Ошибка загрузки чатов',
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
                      onPressed: () => ref.refresh(chatsProvider),
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
              data: (chats) {
                final filteredChats = _filterChats(chats);
                return _buildChatsList(filteredChats);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatsList(List<Chat> chats) {
    if (chats.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 80,
              color: AppColors.mediumBrown.withOpacity(0.3),
            ),
            const SizedBox(height: 20),
            Text(
              _searchQuery.isNotEmpty
                  ? 'Чатов не найдено'
                  : 'Чатов пока нет',
              style: TextStyle(
                fontSize: 20,
                color: AppColors.darkBrown,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _searchQuery.isNotEmpty
                  ? 'Попробуйте изменить запрос'
                  : 'Создайте первый чат или присоединитесь к кампании',
              style: TextStyle(
                color: AppColors.mediumBrown,
              ),
            ),
            const SizedBox(height: 24),
            if (!_searchQuery.isNotEmpty)
              ElevatedButton.icon(
                onPressed: () => _createChat(),
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
                icon: const Icon(Icons.add_comment),
                label: const Text('СОЗДАТЬ ЧАТ'),
              ),
          ],
        ),
      );
    }

    // Разделяем на закрепленные и обычные
    final pinnedChats = chats.where((c) => c.isPinned).toList();
    final regularChats = chats.where((c) => !c.isPinned).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Закрепленные чаты
        if (pinnedChats.isNotEmpty) ...[
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
                  'Закрепленные',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBrown,
                  ),
                ),
              ],
            ),
          ),
          ...pinnedChats.map((chat) => _buildChatCard(chat)),
          const SizedBox(height: 24),
        ],

        // Обычные чаты
        if (regularChats.isNotEmpty) ...[
          if (pinnedChats.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    color: AppColors.primaryBrown,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Все чаты',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkBrown,
                    ),
                  ),
                ],
              ),
            ),
          ...regularChats.map((chat) => _buildChatCard(chat)),
        ],
      ],
    );
  }

  Widget _buildChatCard(Chat chat) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: 2,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _openChat(chat),
          onLongPress: () => _showChatOptions(chat),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Аватар
                _buildChatAvatar(chat),
                const SizedBox(width: 16),

                // Информация о чате
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              chat.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.darkBrown,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (chat.isMuted)
                            Icon(
                              Icons.volume_off,
                              size: 16,
                              color: AppColors.mediumBrown,
                            ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      // Описание или последнее сообщение
                      if (chat.description != null)
                        Text(
                          chat.description!,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.mediumBrown,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      else if (chat.lastMessage != null)
                        Text(
                          '${chat.lastMessage!['senderName']}: ${chat.lastMessage!['text']}',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.darkBrown.withOpacity(0.7),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                      const SizedBox(height: 4),

                      // Участники и время
                      Row(
                        children: [
                          Icon(
                            _getChatTypeIcon(chat.type),
                            size: 12,
                            color: _getChatTypeColor(chat.type),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${chat.participants.length} участников',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.mediumBrown,
                            ),
                          ),

                          const Spacer(),

                          if (chat.lastMessage != null)
                            Text(
                              _formatTime(chat.lastMessage!['timestamp']),
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

                // Непрочитанные сообщения
                if (chat.unreadCount > 0) ...[
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBrown,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      chat.unreadCount > 9 ? '9+' : chat.unreadCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatAvatar(Chat chat) {
    if (chat.avatarUrl != null) {
      return CircleAvatar(
        radius: 28,
        backgroundImage: NetworkImage(chat.avatarUrl!),
      );
    }

    final color = _getChatTypeColor(chat.type);
    final icon = _getChatTypeIcon(chat.type);

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Icon(
        icon,
        size: 28,
        color: color,
      ),
    );
  }

  List<Chat> _filterChats(List<Chat> chats) {
    var filtered = chats;

    // Фильтр по выбранному типу
    if (_selectedFilter != 'all') {
      switch (_selectedFilter) {
        case 'unread':
          filtered = filtered.where((c) => c.unreadCount > 0).toList();
          break;
        case 'pinned':
          filtered = filtered.where((c) => c.isPinned).toList();
          break;
        case 'campaigns':
          filtered = filtered.where((c) => c.type == 'campaign').toList();
          break;
        case 'groups':
          filtered = filtered.where((c) => c.type == 'group').toList();
          break;
        case 'private':
          filtered = filtered.where((c) => c.type == 'private').toList();
          break;
      }
    }

    // Поиск
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((chat) =>
      chat.name.toLowerCase().contains(query) ||
          (chat.description != null && chat.description!.toLowerCase().contains(query)) ||
          chat.participants.any((p) => p['name'].toLowerCase().contains(query))
      ).toList();
    }

    // Сортировка: сначала закрепленные, потом по активности
    filtered.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;

      final aTime = a.lastMessage?['timestamp'] ?? a.lastActivity;
      final bTime = b.lastMessage?['timestamp'] ?? b.lastActivity;

      if (aTime != null && bTime != null) {
        return bTime.compareTo(aTime);
      } else if (aTime != null) {
        return -1;
      } else if (bTime != null) {
        return 1;
      }
      return 0;
    });

    return filtered;
  }

  IconData _getChatTypeIcon(String type) {
    switch (type) {
      case 'campaign':
        return Icons.campaign;
      case 'group':
        return Icons.group;
      case 'private':
        return Icons.person;
      default:
        return Icons.chat_bubble_outline;
    }
  }

  Color _getChatTypeColor(String type) {
    switch (type) {
      case 'campaign':
        return AppColors.primaryBrown;
      case 'group':
        return AppColors.infoBlue;
      case 'private':
        return AppColors.successGreen;
      default:
        return AppColors.mediumBrown;
    }
  }

  String _getFilterText(String filter) {
    switch (filter) {
      case 'all':
        return 'Все';
      case 'unread':
        return 'Непрочитанные';
      case 'pinned':
        return 'Закрепленные';
      case 'campaigns':
        return 'Кампании';
      case 'groups':
        return 'Группы';
      case 'private':
        return 'Приватные';
      default:
        return filter;
    }
  }

  Color _getFilterColor(String filter) {
    switch (filter) {
      case 'unread':
        return AppColors.primaryBrown;
      case 'pinned':
        return AppColors.accentGold;
      case 'campaigns':
        return AppColors.darkBrown;
      case 'groups':
        return AppColors.infoBlue;
      case 'private':
        return AppColors.successGreen;
      default:
        return AppColors.primaryBrown;
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    if (time.isAfter(today)) {
      return DateFormat('HH:mm').format(time);
    } else if (time.isAfter(yesterday)) {
      return 'Вчера';
    } else {
      return DateFormat('dd.MM').format(time);
    }
  }

  void _createChat() {
    // TODO: Реализовать создание чата
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Создание нового чата'),
      ),
    );
  }

  void _createGroupChat() {
    // TODO: Реализовать создание группового чата
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Создание группового чата'),
      ),
    );
  }

  void _openChat(Chat chat) {
    context.go('/home/chats/${chat.id}');
  }

  void _showChatOptions(Chat chat) {
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
              _buildChatAvatar(chat),
              const SizedBox(height: 12),
              Text(
                chat.name,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkBrown,
                ),
                textAlign: TextAlign.center,
              ),

              if (chat.description != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    chat.description!,
                    style: TextStyle(
                      color: AppColors.mediumBrown,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

              const SizedBox(height: 20),

              ListTile(
                leading: Icon(
                  chat.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                  color: AppColors.accentGold,
                ),
                title: Text(chat.isPinned ? 'Открепить' : 'Закрепить'),
                onTap: () {
                  Navigator.pop(context);
                  _togglePinChat(chat);
                },
              ),

              ListTile(
                leading: Icon(
                  chat.isMuted ? Icons.volume_off : Icons.volume_up,
                  color: AppColors.primaryBrown,
                ),
                title: Text(chat.isMuted ? 'Включить уведомления' : 'Отключить уведомления'),
                onTap: () {
                  Navigator.pop(context);
                  _toggleMuteChat(chat);
                },
              ),

              ListTile(
                leading: Icon(
                  Icons.info_outline,
                  color: AppColors.infoBlue,
                ),
                title: const Text('Информация о чате'),
                onTap: () {
                  Navigator.pop(context);
                  _showChatInfo(chat);
                },
              ),

              if (chat.type == 'group' || chat.type == 'campaign')
                ListTile(
                  leading: Icon(
                    Icons.group_add,
                    color: AppColors.successGreen,
                  ),
                  title: const Text('Добавить участников'),
                  onTap: () {
                    Navigator.pop(context);
                    _addParticipants(chat);
                  },
                ),

              if (chat.type == 'private')
                ListTile(
                  leading: Icon(
                    Icons.person_remove,
                    color: AppColors.errorRed,
                  ),
                  title: const Text('Удалить диалог'),
                  onTap: () {
                    Navigator.pop(context);
                    _deleteChat(chat);
                  },
                ),

              if (chat.type == 'group')
                ListTile(
                  leading: Icon(
                    Icons.exit_to_app,
                    color: AppColors.errorRed,
                  ),
                  title: const Text('Покинуть чат'),
                  onTap: () {
                    Navigator.pop(context);
                    _leaveChat(chat);
                  },
                ),

              ListTile(
                leading: Icon(
                  Icons.delete,
                  color: AppColors.errorRed,
                ),
                title: const Text('Удалить историю'),
                onTap: () {
                  Navigator.pop(context);
                  _clearChatHistory(chat);
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

  void _togglePinChat(Chat chat) {
    // TODO: Обновить статус закрепления чата
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(chat.isPinned ? 'Чат откреплен' : 'Чат закреплен'),
        backgroundColor: AppColors.successGreen,
      ),
    );
  }

  void _toggleMuteChat(Chat chat) {
    // TODO: Обновить статус уведомлений чата
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(chat.isMuted ? 'Уведомления включены' : 'Уведомления отключены'),
        backgroundColor: AppColors.successGreen,
      ),
    );
  }

  void _showChatInfo(Chat chat) {
    context.go('/home/chats/${chat.id}/info');
  }

  void _addParticipants(Chat chat) {
    // TODO: Реализовать добавление участников
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Добавление участников в чат "${chat.name}"'),
      ),
    );
  }

  void _deleteChat(Chat chat) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить диалог'),
        content: Text('Вы уверены, что хотите удалить диалог с "${chat.name}"? История сообщений будет удалена.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ОТМЕНА'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Удалить чат из базы данных
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Диалог с "${chat.name}" удален'),
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

  void _leaveChat(Chat chat) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Покинуть чат'),
        content: Text('Вы уверены, что хотите покинуть чат "${chat.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ОТМЕНА'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Выйти из чата
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Вы вышли из чата "${chat.name}"'),
                  backgroundColor: AppColors.successGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorRed,
            ),
            child: const Text('ПОКИНУТЬ'),
          ),
        ],
      ),
    );
  }

  void _clearChatHistory(Chat chat) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Очистить историю'),
        content: Text('Вы уверены, что хотите очистить историю чата "${chat.name}"? Это действие нельзя отменить.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ОТМЕНА'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Очистить историю чата
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('История чата "${chat.name}" очищена'),
                  backgroundColor: AppColors.successGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorRed,
            ),
            child: const Text('ОЧИСТИТЬ'),
          ),
        ],
      ),
    );
  }
}