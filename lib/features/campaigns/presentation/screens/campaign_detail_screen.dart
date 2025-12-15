import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '/core/constants/app_colors.dart';

// Временные модели и провайдеры (замените на реальные)
class Campaign {
  final String id;
  final String name;
  final String description;
  final String? settingName;
  final List<Map<String, dynamic>> players;
  final List<Map<String, dynamic>> sessions;
  final List<Map<String, dynamic>> notesList;
  final String notes;
  final int sessionCount;
  final int noteCount;
  final String inviteCode;

  Campaign({
    required this.id,
    required this.name,
    required this.description,
    this.settingName,
    required this.players,
    required this.sessions,
    required this.notesList,
    required this.notes,
    required this.sessionCount,
    required this.noteCount,
    required this.inviteCode,
  });
}

// Временный провайдер (замените на реальный)
final campaignProvider = FutureProvider.family<Campaign, String>((ref, campaignId) async {
  await Future.delayed(const Duration(seconds: 1));
  return Campaign(
    id: campaignId,
    name: 'Поход за Священным Граалем',
    description: 'Эпическая кампания в мире Фаэруна, где группа авантюристов ищет легендарный Священный Грааль. На пути их ждут древние храмы, коварные ловушки и могущественные враги.',
    settingName: 'Forgotten Realms',
    players: [
      {'name': 'Алексей', 'role': 'master', 'characterName': null},
      {'name': 'Мария', 'role': 'player', 'characterName': 'Эльвира, эльфийская лучница'},
      {'name': 'Дмитрий', 'role': 'player', 'characterName': 'Громхард, дварф-воин'},
      {'name': 'Ольга', 'role': 'player', 'characterName': 'Мерил, волшебница'},
    ],
    sessions: [
      {'id': '1', 'title': 'Начало пути', 'date': '15.12.2023', 'time': '19:00', 'status': 'completed', 'description': 'Знакомство персонажей в таверне "Усталый дракон"'},
      {'id': '2', 'title': 'Темный лес', 'date': '22.12.2023', 'time': '20:00', 'status': 'completed', 'description': 'Поиски древнего храма в глубинах леса'},
      {'id': '3', 'title': 'Храм испытаний', 'date': '05.01.2024', 'time': '19:30', 'status': 'planned', 'description': 'Испытания внутри древнего храма'},
    ],
    notesList: [
      {'id': '1', 'authorName': 'Алексей', 'createdAt': '15.12.2023', 'title': 'Важная NPC', 'content': 'Встретить старую пророчицу у входа в лес', 'type': 'plot', 'sessionId': '1'},
      {'id': '2', 'authorName': 'Мария', 'createdAt': '16.12.2023', 'title': 'Слабость гоблинов', 'content': 'Гоблины боятся яркого света и серебра', 'type': 'character', 'sessionId': '1'},
      {'id': '3', 'authorName': 'Дмитрий', 'createdAt': '23.12.2023', 'title': 'Сокровище в пещере', 'content': 'В северной части леса есть скрытая пещера с сундуком', 'type': 'location', 'sessionId': '2'},
    ],
    notes: 'Важные моменты: персонажи получили древнюю карту от загадочного незнакомца.',
    sessionCount: 3,
    noteCount: 3,
    inviteCode: 'xyz123',
  );
});

class CampaignDetailScreen extends ConsumerStatefulWidget {
  final String campaignId;

  const CampaignDetailScreen({
    Key? key,
    required this.campaignId,
  }) : super(key: key);

  @override
  ConsumerState<CampaignDetailScreen> createState() => _CampaignDetailScreenState();
}

class _CampaignDetailScreenState extends ConsumerState<CampaignDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final campaignAsync = ref.watch(campaignProvider(widget.campaignId));

    return Scaffold(
      backgroundColor: AppColors.lightParchment,
      body: campaignAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryBrown,
          ),
        ),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.errorRed,
              ),
              const SizedBox(height: 16),
              Text(
                'Ошибка загрузки',
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
                onPressed: () => ref.refresh(campaignProvider(widget.campaignId)),
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
                child: const Text('ПОВТОРИТЬ ПОПЫТКУ'),
              ),
            ],
          ),
        ),
        data: (campaign) {
          return _buildCampaignDetail(campaign);
        },
      ),
    );
  }

  Widget _buildCampaignDetail(Campaign campaign) {
    return Column(
      children: [
        // Аппбар с градиентным фоном
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryBrown.withOpacity(0.9),
                AppColors.darkBrown.withOpacity(0.9),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowBrown,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Кнопка назад и действия
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
                          color: Colors.white,
                        ),
                        onPressed: () => context.pop(),
                      ),
                      Expanded(
                        child: Text(
                          'Кампания',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      PopupMenuButton<String>(
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.white,
                        ),
                        onSelected: (value) {
                          _handleMenuAction(value, campaign);
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit, color: AppColors.darkBrown),
                                SizedBox(width: 8),
                                Text('Редактировать'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'share',
                            child: Row(
                              children: [
                                Icon(Icons.share, color: AppColors.darkBrown),
                                SizedBox(width: 8),
                                Text('Поделиться'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, color: AppColors.errorRed),
                                SizedBox(width: 8),
                                Text('Удалить'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Основная информация о кампании
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        campaign.name,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),

                      if (campaign.settingName != null)
                        Row(
                          children: [
                            Icon(
                              Icons.public,
                              color: AppColors.parchment,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              campaign.settingName!,
                              style: TextStyle(
                                color: AppColors.parchment,
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),

                      const SizedBox(height: 12),

                      // Быстрая статистика
                      Row(
                        children: [
                          _buildStatItem(
                            icon: Icons.group,
                            label: 'Игроки',
                            value: campaign.players.length.toString(),
                            color: AppColors.accentGold,
                          ),
                          const SizedBox(width: 20),
                          _buildStatItem(
                            icon: Icons.event,
                            label: 'Сессии',
                            value: campaign.sessionCount.toString(),
                            color: AppColors.infoBlue,
                          ),
                          const SizedBox(width: 20),
                          _buildStatItem(
                            icon: Icons.note,
                            label: 'Заметки',
                            value: campaign.noteCount.toString(),
                            color: AppColors.successGreen,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Вкладки
                Container(
                  color: Colors.white,
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: AppColors.primaryBrown,
                    labelColor: AppColors.primaryBrown,
                    unselectedLabelColor: AppColors.mediumBrown,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    tabs: const [
                      Tab(text: 'ОПИСАНИЕ'),
                      Tab(text: 'СЕССИИ'),
                      Tab(text: 'ЗАМЕТКИ'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Контент вкладок
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildDescriptionTab(campaign),
              _buildSessionsTab(campaign),
              _buildNotesTab(campaign),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionTab(Campaign campaign) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Описание кампании
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.description,
                        color: AppColors.primaryBrown,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Описание',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkBrown,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    campaign.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.darkBrown.withOpacity(0.8),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (campaign.notes.isNotEmpty)
                    Text(
                      campaign.notes,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.darkBrown.withOpacity(0.6),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Игроки кампании
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.group,
                        color: AppColors.primaryBrown,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Участники кампании',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkBrown,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  ...campaign.players.map((player) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.accentGold.withOpacity(0.2),
                          child: Icon(
                            Icons.person,
                            color: AppColors.accentGold,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                player['name'] ?? 'Без имени',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.darkBrown,
                                ),
                              ),
                              if (player['characterName'] != null)
                                Text(
                                  'Персонаж: ${player['characterName']}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.mediumBrown,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: player['role'] == 'master'
                                ? AppColors.primaryBrown.withOpacity(0.1)
                                : AppColors.infoBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: player['role'] == 'master'
                                  ? AppColors.primaryBrown.withOpacity(0.3)
                                  : AppColors.infoBlue.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            player['role'] == 'master' ? 'Мастер' : 'Игрок',
                            style: TextStyle(
                              fontSize: 12,
                              color: player['role'] == 'master'
                                  ? AppColors.primaryBrown
                                  : AppColors.infoBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )).toList(),

                  const SizedBox(height: 16),

                  // Кнопка пригласить
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _invitePlayer(campaign),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.successGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      icon: const Icon(Icons.person_add),
                      label: const Text('ПРИГЛАСИТЬ ИГРОКА'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionsTab(Campaign campaign) {
    return Column(
      children: [
        // Заголовок и кнопка создания сессии
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Сессии кампании',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkBrown,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _createSession(campaign),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBrown,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.add),
                label: const Text('НОВАЯ СЕССИЯ'),
              ),
            ],
          ),
        ),

        // Список сессий
        Expanded(
          child: campaign.sessions.isEmpty
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.event_note,
                  size: 64,
                  color: AppColors.mediumBrown.withOpacity(0.3),
                ),
                const SizedBox(height: 16),
                Text(
                  'Сессий пока нет',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.mediumBrown,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Создайте первую сессию для этой кампании',
                  style: TextStyle(
                    color: AppColors.mediumBrown.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          )
              : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: campaign.sessions.length,
            itemBuilder: (context, index) {
              final session = campaign.sessions[index];
              return _buildSessionCard(session);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSessionCard(Map<String, dynamic> session) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _viewSession(session),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      session['title'] ?? 'Без названия',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkBrown,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getSessionStatusColor(session['status'])
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _getSessionStatusColor(session['status'])
                            .withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      _getSessionStatusText(session['status']),
                      style: TextStyle(
                        fontSize: 12,
                        color: _getSessionStatusColor(session['status']),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: AppColors.mediumBrown,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    session['date'] ?? 'Дата не указана',
                    style: TextStyle(
                      color: AppColors.mediumBrown,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: AppColors.mediumBrown,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    session['time'] ?? 'Время не указано',
                    style: TextStyle(
                      color: AppColors.mediumBrown,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (session['description'] != null)
                Text(
                  session['description'],
                  style: TextStyle(
                    color: AppColors.darkBrown.withOpacity(0.7),
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotesTab(Campaign campaign) {
    return Column(
      children: [
        // Заголовок и кнопка создания заметки
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Заметки кампании',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkBrown,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _createNote(campaign),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentGold,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.note_add),
                label: const Text('НОВАЯ ЗАМЕТКА'),
              ),
            ],
          ),
        ),

        // Список заметок
        Expanded(
          child: campaign.notesList.isEmpty
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.note,
                  size: 64,
                  color: AppColors.mediumBrown.withOpacity(0.3),
                ),
                const SizedBox(height: 16),
                Text(
                  'Заметок пока нет',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.mediumBrown,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Добавьте первую заметку о ходе кампании',
                  style: TextStyle(
                    color: AppColors.mediumBrown.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          )
              : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: campaign.notesList.length,
            itemBuilder: (context, index) {
              final note = campaign.notesList[index];
              return _buildNoteCard(note);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNoteCard(Map<String, dynamic> note) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.accentGold.withOpacity(0.2),
                  child: Icon(
                    Icons.person,
                    color: AppColors.accentGold,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        note['authorName'] ?? 'Автор',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkBrown,
                        ),
                      ),
                      Text(
                        note['createdAt'] ?? '',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.mediumBrown,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    color: AppColors.mediumBrown,
                  ),
                  onSelected: (value) => _handleNoteAction(value, note),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 20),
                          SizedBox(width: 8),
                          Text('Редактировать'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: AppColors.errorRed, size: 20),
                          SizedBox(width: 8),
                          Text('Удалить'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              note['title'] ?? 'Без названия',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.darkBrown,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              note['content'] ?? '',
              style: TextStyle(
                color: AppColors.darkBrown.withOpacity(0.8),
                fontSize: 14,
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  _getNoteTypeIcon(note['type']),
                  size: 16,
                  color: _getNoteTypeColor(note['type']),
                ),
                const SizedBox(width: 6),
                Text(
                  _getNoteTypeText(note['type']),
                  style: TextStyle(
                    fontSize: 12,
                    color: _getNoteTypeColor(note['type']),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (note['sessionId'] != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.infoBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Сессия #${note['sessionId']}',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.infoBlue,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Методы для получения цветов и иконок
  Color _getSessionStatusColor(String status) {
    switch (status) {
      case 'planned':
        return AppColors.infoBlue;
      case 'in_progress':
        return AppColors.warningOrange;
      case 'completed':
        return AppColors.successGreen;
      case 'cancelled':
        return AppColors.errorRed;
      default:
        return AppColors.mediumBrown;
    }
  }

  String _getSessionStatusText(String status) {
    switch (status) {
      case 'planned':
        return 'Запланирована';
      case 'in_progress':
        return 'В процессе';
      case 'completed':
        return 'Завершена';
      case 'cancelled':
        return 'Отменена';
      default:
        return 'Неизвестно';
    }
  }

  IconData _getNoteTypeIcon(String type) {
    switch (type) {
      case 'session':
        return Icons.event;
      case 'character':
        return Icons.person;
      case 'location':
        return Icons.location_on;
      case 'plot':
        return Icons.auto_stories;
      case 'item':
        return Icons.inventory;
      default:
        return Icons.note;
    }
  }

  Color _getNoteTypeColor(String type) {
    switch (type) {
      case 'session':
        return AppColors.infoBlue;
      case 'character':
        return AppColors.accentGold;
      case 'location':
        return AppColors.successGreen;
      case 'plot':
        return AppColors.primaryBrown;
      case 'item':
        return AppColors.warningOrange;
      default:
        return AppColors.mediumBrown;
    }
  }

  String _getNoteTypeText(String type) {
    switch (type) {
      case 'session':
        return 'Сессия';
      case 'character':
        return 'Персонаж';
      case 'location':
        return 'Локация';
      case 'plot':
        return 'Сюжет';
      case 'item':
        return 'Предмет';
      default:
        return 'Заметка';
    }
  }

  // Обработчики действий
  void _handleMenuAction(String value, Campaign campaign) {
    switch (value) {
      case 'edit':
        context.go('/home/campaigns/${widget.campaignId}/edit');
        break;
      case 'share':
        _shareCampaign(campaign);
        break;
      case 'delete':
        _deleteCampaign(campaign);
        break;
    }
  }

  void _handleNoteAction(String value, Map<String, dynamic> note) {
    switch (value) {
      case 'edit':
        _editNote(note);
        break;
      case 'delete':
        _deleteNote(note);
        break;
    }
  }

  void _invitePlayer(Campaign campaign) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Пригласить игрока'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Отправьте ссылку-приглашение игроку:'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.lightParchment,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.lightBrown),
              ),
              child: SelectableText(
                'https://app.dnd/campaign/${campaign.id}/invite/${campaign.inviteCode}',
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ЗАКРЫТЬ'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Копировать ссылку в буфер обмена
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Ссылка скопирована в буфер обмена'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBrown,
            ),
            child: const Text(
              'СКОПИРОВАТЬ',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _createSession(Campaign campaign) {
    context.go('/home/campaigns/${campaign.id}/sessions/create');
  }

  void _viewSession(Map<String, dynamic> session) {
    // TODO: Реализовать просмотр сессии
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Просмотр сессии: ${session['title']}'),
      ),
    );
  }

  void _createNote(Campaign campaign) {
    context.go('/home/campaigns/${campaign.id}/notes');
  }

  void _editNote(Map<String, dynamic> note) {
    // TODO: Реализовать редактирование заметки
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Редактирование заметки: ${note['title']}'),
      ),
    );
  }

  void _deleteNote(Map<String, dynamic> note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить заметку'),
        content: Text('Вы уверены, что хотите удалить заметку "${note['title']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ОТМЕНА'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Удалить заметку из базы данных
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Заметка "${note['title']}" удалена'),
                  backgroundColor: AppColors.successGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorRed,
            ),
            child: const Text(
              'УДАЛИТЬ',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _shareCampaign(Campaign campaign) {
    // TODO: Реализовать шеринг кампании
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Функция "Поделиться" в разработке'),
      ),
    );
  }

  void _deleteCampaign(Campaign campaign) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить кампанию'),
        content: Text(
          'Вы уверены, что хотите удалить кампанию "${campaign.name}"? '
              'Это действие нельзя отменить.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ОТМЕНА'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                // TODO: Удалить кампанию из базы данных
                Navigator.pop(context);
                context.pop(); // Вернуться к списку кампаний
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Кампания "${campaign.name}" удалена'),
                    backgroundColor: AppColors.successGreen,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Ошибка: $e'),
                    backgroundColor: AppColors.errorRed,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorRed,
            ),
            child: const Text(
              'УДАЛИТЬ',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}