import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '/core/constants/app_colors.dart';

// Временные модели и провайдеры (замените на реальные)
class Session {
  final String id;
  final String campaignId;
  final String title;
  final String? description;
  final DateTime date;
  final String? time;
  final String status;
  final String? location;
  final List<String> participants;
  final Map<String, dynamic>? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Session({
    required this.id,
    required this.campaignId,
    required this.title,
    this.description,
    required this.date,
    this.time,
    required this.status,
    this.location,
    required this.participants,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });
}

final sessionsProvider = FutureProvider.family<List<Session>, String>((ref, campaignId) async {
  await Future.delayed(const Duration(seconds: 1));
  return [
    Session(
      id: '1',
      campaignId: campaignId,
      title: 'Начало пути',
      description: 'Знакомство персонажей в таверне "Усталый дракон"',
      date: DateTime(2023, 12, 15),
      time: '19:00',
      status: 'completed',
      location: 'Таверна "Усталый дракон"',
      participants: ['Мастер', 'Эльвира', 'Громхард', 'Мерил'],
      notes: {
        'summary': 'Персонажи встретились в таверне и получили квест',
        'achievements': ['Получена карта храма', 'Найден проводник'],
      },
      createdAt: DateTime(2023, 12, 14),
      updatedAt: DateTime(2023, 12, 16),
    ),
    Session(
      id: '2',
      campaignId: campaignId,
      title: 'Темный лес',
      description: 'Поиски древнего храма в глубинах леса',
      date: DateTime(2023, 12, 22),
      time: '20:00',
      status: 'completed',
      location: 'Лес Вечного Мрака',
      participants: ['Мастер', 'Эльвира', 'Громхард', 'Мерил'],
      notes: {
        'summary': 'Сражение с гоблинами, нахождение входа в храм',
        'achievements': ['Победа над гоблинами', 'Обнаружен вход в храм'],
      },
      createdAt: DateTime(2023, 12, 21),
      updatedAt: DateTime(2023, 12, 23),
    ),
    Session(
      id: '3',
      campaignId: campaignId,
      title: 'Храм испытаний',
      description: 'Испытания внутри древнего храма',
      date: DateTime(2024, 1, 5),
      time: '19:30',
      status: 'planned',
      location: 'Древний храм',
      participants: ['Мастер', 'Эльвира', 'Громхард', 'Мерил'],
      notes: null,
      createdAt: DateTime(2024, 1, 4),
    ),
    Session(
      id: '4',
      campaignId: campaignId,
      title: 'Загадки дракона',
      date: DateTime(2024, 1, 12),
      time: '20:00',
      status: 'planned',
      participants: ['Мастер', 'Эльвира', 'Громхард', 'Мерил'],
    ),
  ];
});

final campaignProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, campaignId) async {
  await Future.delayed(const Duration(milliseconds: 500));
  return {
    'id': campaignId,
    'name': 'Поход за Священным Граалем',
    'description': 'Эпическая кампания в мире Фаэруна',
  };
});

class SessionsListScreen extends ConsumerStatefulWidget {
  final String campaignId;

  const SessionsListScreen({
    Key? key,
    required this.campaignId,
  }) : super(key: key);

  @override
  ConsumerState<SessionsListScreen> createState() => _SessionsListScreenState();
}

class _SessionsListScreenState extends ConsumerState<SessionsListScreen> {
  String _filterStatus = 'all';
  final List<String> _statusFilters = [
    'all',
    'planned',
    'in_progress',
    'completed',
    'cancelled',
  ];

  @override
  Widget build(BuildContext context) {
    final campaignAsync = ref.watch(campaignProvider(widget.campaignId));
    final sessionsAsync = ref.watch(sessionsProvider(widget.campaignId));

    return Scaffold(
      backgroundColor: AppColors.lightParchment,
      body: Column(
        children: [
          // Заголовок и фильтры
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
                              'Сессии',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.darkBrown,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            error: (error, stackTrace) => Text(
                              'Сессии',
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
                                  'Сессии',
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
                            Icons.add,
                            color: AppColors.primaryBrown,
                          ),
                          onPressed: () => _createSession(),
                        ),
                      ],
                    ),
                  ),

                  // Фильтры по статусу
                  SizedBox(
                    height: 60,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: _statusFilters.map((status) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(
                              _getStatusText(status),
                              style: TextStyle(
                                color: _filterStatus == status
                                    ? Colors.white
                                    : AppColors.darkBrown,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            selected: _filterStatus == status,
                            onSelected: (selected) {
                              setState(() {
                                _filterStatus = selected ? status : 'all';
                              });
                            },
                            backgroundColor: Colors.white,
                            selectedColor: _getStatusColor(status),
                            checkmarkColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color: _filterStatus == status
                                    ? _getStatusColor(status)
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

          // Статистика
          _buildStatistics(sessionsAsync),

          // Список сессий
          Expanded(
            child: sessionsAsync.when(
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
                      'Ошибка загрузки сессий',
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
                      onPressed: () => ref.refresh(sessionsProvider(widget.campaignId)),
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
              data: (sessions) {
                final filteredSessions = _filterStatus == 'all'
                    ? sessions
                    : sessions.where((s) => s.status == _filterStatus).toList();

                return _buildSessionsList(filteredSessions);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatistics(AsyncValue<List<Session>> sessionsAsync) {
    return sessionsAsync.when(
      loading: () => Container(),
      error: (error, stackTrace) => Container(),
      data: (sessions) {
        final planned = sessions.where((s) => s.status == 'planned').length;
        final completed = sessions.where((s) => s.status == 'completed').length;
        final total = sessions.length;

        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryBrown.withOpacity(0.1),
                AppColors.accentGold.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.primaryBrown.withOpacity(0.2),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                value: total.toString(),
                label: 'Всего',
                icon: Icons.list,
                color: AppColors.darkBrown,
              ),
              _buildStatItem(
                value: planned.toString(),
                label: 'Запланировано',
                icon: Icons.event,
                color: AppColors.infoBlue,
              ),
              _buildStatItem(
                value: completed.toString(),
                label: 'Завершено',
                icon: Icons.check_circle,
                color: AppColors.successGreen,
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

  Widget _buildSessionsList(List<Session> sessions) {
    if (sessions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_note,
              size: 80,
              color: AppColors.mediumBrown.withOpacity(0.3),
            ),
            const SizedBox(height: 20),
            Text(
              _filterStatus == 'all'
                  ? 'Сессий пока нет'
                  : 'Нет сессий с выбранным статусом',
              style: TextStyle(
                fontSize: 20,
                color: AppColors.darkBrown,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _filterStatus == 'all'
                  ? 'Создайте первую сессию для этой кампании'
                  : 'Попробуйте выбрать другой фильтр',
              style: TextStyle(
                color: AppColors.mediumBrown,
              ),
            ),
            const SizedBox(height: 24),
            if (_filterStatus == 'all')
              ElevatedButton.icon(
                onPressed: () => _createSession(),
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
                icon: const Icon(Icons.add),
                label: const Text('СОЗДАТЬ СЕССИЮ'),
              ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final session = sessions[index];
        return _buildSessionCard(session);
      },
    );
  }

  Widget _buildSessionCard(Session session) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: 2,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _viewSession(session),
          onLongPress: () => _showSessionOptions(session),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Заголовок и статус
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        session.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkBrown,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(session.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _getStatusColor(session.status).withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        _getStatusText(session.status),
                        style: TextStyle(
                          fontSize: 12,
                          color: _getStatusColor(session.status),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Дата и время
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: AppColors.mediumBrown,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      DateFormat('dd.MM.yyyy').format(session.date),
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
                      session.time ?? 'Время не указано',
                      style: TextStyle(
                        color: AppColors.mediumBrown,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),

                // Локация
                if (session.location != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: AppColors.mediumBrown,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          session.location!,
                          style: TextStyle(
                            color: AppColors.mediumBrown,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],

                // Описание
                if (session.description != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    session.description!,
                    style: TextStyle(
                      color: AppColors.darkBrown.withOpacity(0.8),
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],

                // Участники
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.group,
                      size: 16,
                      color: AppColors.mediumBrown,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '${session.participants.length} участников',
                        style: TextStyle(
                          color: AppColors.mediumBrown,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    if (session.notes != null)
                      Row(
                        children: [
                          Icon(
                            Icons.note,
                            size: 16,
                            color: AppColors.accentGold,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Есть заметки',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.accentGold,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),

                // Действия
                if (session.status == 'planned') ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _startSession(session),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.successGreen,
                            side: BorderSide(
                              color: AppColors.successGreen,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(Icons.play_arrow, size: 18),
                          label: const Text('НАЧАТЬ'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _editSession(session),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primaryBrown,
                            side: BorderSide(
                              color: AppColors.primaryBrown,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(Icons.edit, size: 18),
                          label: const Text('РЕДАКТИРОВАТЬ'),
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

  Color _getStatusColor(String status) {
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

  String _getStatusText(String status) {
    switch (status) {
      case 'all':
        return 'Все';
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

  void _createSession() {
    context.go('/home/campaigns/${widget.campaignId}/sessions/create');
  }

  void _viewSession(Session session) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.lightParchment,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return _buildSessionDetails(session);
      },
    );
  }

  Widget _buildSessionDetails(Session session) {
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

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  session.title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBrown,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(session.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _getStatusColor(session.status).withOpacity(0.3),
                  ),
                ),
                child: Text(
                  _getStatusText(session.status),
                  style: TextStyle(
                    fontSize: 14,
                    color: _getStatusColor(session.status),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Информация о сессии
          _buildDetailRow(
            icon: Icons.calendar_today,
            label: 'Дата',
            value: DateFormat('dd.MM.yyyy').format(session.date),
          ),

          if (session.time != null)
            _buildDetailRow(
              icon: Icons.access_time,
              label: 'Время',
              value: session.time!,
            ),

          if (session.location != null)
            _buildDetailRow(
              icon: Icons.location_on,
              label: 'Локация',
              value: session.location!,
            ),

          const SizedBox(height: 20),

          // Участники
          Text(
            'Участники (${session.participants.length})',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.darkBrown,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: session.participants.map((participant) {
              return Chip(
                label: Text(participant),
                backgroundColor: AppColors.lightBrown.withOpacity(0.2),
                labelStyle: TextStyle(
                  color: AppColors.darkBrown,
                ),
              );
            }).toList(),
          ),

          // Описание
          if (session.description != null) ...[
            const SizedBox(height: 20),
            Text(
              'Описание',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.darkBrown,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              session.description!,
              style: TextStyle(
                color: AppColors.darkBrown.withOpacity(0.8),
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ],

          // Заметки
          if (session.notes != null) ...[
            const SizedBox(height: 20),
            Text(
              'Заметки сессии',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.darkBrown,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.accentGold.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.accentGold.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (session.notes!['summary'] != null)
                    Text(
                      session.notes!['summary'],
                      style: TextStyle(
                        color: AppColors.darkBrown,
                        fontSize: 16,
                      ),
                    ),
                  if (session.notes!['achievements'] != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      'Достижения:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkBrown,
                      ),
                    ),
                    ...session.notes!['achievements'].map<Widget>((achievement) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 16,
                              color: AppColors.successGreen,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                achievement,
                                style: TextStyle(
                                  color: AppColors.darkBrown.withOpacity(0.8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ],
              ),
            ),
          ],

          const SizedBox(height: 32),

          // Кнопки действий
          Row(
            children: [
              if (session.status == 'planned')
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _startSession(session);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.successGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('НАЧАТЬ СЕССИЮ'),
                  ),
                ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _editSession(session);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryBrown,
                    side: BorderSide(
                      color: AppColors.primaryBrown,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('РЕДАКТИРОВАТЬ'),
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
            color: AppColors.mediumBrown,
            size: 20,
          ),
          const SizedBox(width: 12),
          Column(
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
                  fontSize: 16,
                  color: AppColors.darkBrown,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _startSession(Session session) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Начать сессию'),
        content: const Text('Вы уверены, что хотите начать эту сессию?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ОТМЕНА'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Обновить статус сессии на "in_progress"
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Сессия "${session.title}" начата'),
                  backgroundColor: AppColors.successGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.successGreen,
            ),
            child: const Text('НАЧАТЬ'),
          ),
        ],
      ),
    );
  }

  void _editSession(Session session) {
    // TODO: Реализовать редактирование сессии
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Редактирование сессии: ${session.title}'),
      ),
    );
  }

  void _showSessionOptions(Session session) {
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
                session.title,
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
                  _editSession(session);
                },
              ),

              ListTile(
                leading: Icon(
                  Icons.note_add,
                  color: AppColors.accentGold,
                ),
                title: const Text('Добавить заметки'),
                onTap: () {
                  Navigator.pop(context);
                  _addNotes(session);
                },
              ),

              if (session.status == 'planned') ...[
                ListTile(
                  leading: Icon(
                    Icons.play_arrow,
                    color: AppColors.successGreen,
                  ),
                  title: const Text('Начать сессию'),
                  onTap: () {
                    Navigator.pop(context);
                    _startSession(session);
                  },
                ),

                ListTile(
                  leading: Icon(
                    Icons.cancel,
                    color: AppColors.errorRed,
                  ),
                  title: const Text('Отменить сессию'),
                  onTap: () {
                    Navigator.pop(context);
                    _cancelSession(session);
                  },
                ),
              ],

              if (session.status == 'in_progress')
                ListTile(
                  leading: Icon(
                    Icons.stop,
                    color: AppColors.warningOrange,
                  ),
                  title: const Text('Завершить сессию'),
                  onTap: () {
                    Navigator.pop(context);
                    _completeSession(session);
                  },
                ),

              ListTile(
                leading: Icon(
                  Icons.delete,
                  color: AppColors.errorRed,
                ),
                title: const Text('Удалить сессию'),
                onTap: () {
                  Navigator.pop(context);
                  _deleteSession(session);
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

  void _addNotes(Session session) {
    // TODO: Реализовать добавление заметок к сессии
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Добавление заметок к сессии: ${session.title}'),
      ),
    );
  }

  void _cancelSession(Session session) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Отменить сессию'),
        content: Text('Вы уверены, что хотите отменить сессию "${session.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ОТМЕНА'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Обновить статус сессии на "cancelled"
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Сессия "${session.title}" отменена'),
                  backgroundColor: AppColors.successGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorRed,
            ),
            child: const Text('ОТМЕНИТЬ СЕССИЮ'),
          ),
        ],
      ),
    );
  }

  void _completeSession(Session session) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Завершить сессию'),
        content: const Text('Вы уверены, что хотите завершить эту сессию?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ОТМЕНА'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Обновить статус сессии на "completed"
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Сессия "${session.title}" завершена'),
                  backgroundColor: AppColors.successGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.successGreen,
            ),
            child: const Text('ЗАВЕРШИТЬ'),
          ),
        ],
      ),
    );
  }

  void _deleteSession(Session session) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить сессию'),
        content: Text('Вы уверены, что хотите удалить сессию "${session.title}"? Это действие нельзя отменить.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ОТМЕНА'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Удалить сессию из базы данных
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Сессия "${session.title}" удалена'),
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