import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '/core/constants/app_colors.dart';

// Временные провайдеры (замените на реальные)
final chatInfoProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, chatId) async {
  await Future.delayed(const Duration(seconds: 1));
  return {
    'id': chatId,
    'name': 'Поход за Граалем',
    'description': 'Основной чат кампании',
    'type': 'campaign',
    'campaignId': '1',
    'campaignName': 'Поход за Священным Граалем',
    'createdAt': DateTime(2023, 12, 1),
    'createdBy': 'Алексей',
    'settings': {
      'allowDiceRolls': true,
      'allowAttachments': true,
      'allowVoiceMessages': true,
      'pinnedMessagesAllowed': true,
      'newMembersCanViewHistory': true,
    },
    'participants': [
      {
        'id': '1',
        'name': 'Алексей',
        'role': 'master',
        'isOnline': true,
        'joinedAt': DateTime(2023, 12, 1),
        'lastSeen': DateTime.now(),
        'characterName': null,
      },
      {
        'id': '2',
        'name': 'Мария',
        'role': 'player',
        'isOnline': true,
        'joinedAt': DateTime(2023, 12, 1),
        'lastSeen': DateTime.now().subtract(const Duration(minutes: 5)),
        'characterName': 'Эльвира, эльфийская лучница',
      },
      {
        'id': '3',
        'name': 'Дмитрий',
        'role': 'player',
        'isOnline': false,
        'joinedAt': DateTime(2023, 12, 2),
        'lastSeen': DateTime.now().subtract(const Duration(hours: 3)),
        'characterName': 'Громхард, дварф-воин',
      },
      {
        'id': '4',
        'name': 'Ольга',
        'role': 'player',
        'isOnline': false,
        'joinedAt': DateTime(2023, 12, 2),
        'lastSeen': DateTime.now().subtract(const Duration(days: 1)),
        'characterName': 'Мерил, волшебница',
      },
      {
        'id': '5',
        'name': 'Иван',
        'role': 'player',
        'isOnline': true,
        'joinedAt': DateTime(2023, 12, 5),
        'lastSeen': DateTime.now(),
        'characterName': 'Брандон, паладин',
      },
    ],
    'stats': {
      'totalMessages': 245,
      'messagesToday': 12,
      'activeParticipants': 4,
      'filesShared': 8,
      'diceRolls': 45,
    },
    'pinnedMessages': [
      {
        'id': '1',
        'senderName': 'Алексей',
        'text': 'Важно: сессии проходят по субботам в 19:00',
        'timestamp': DateTime(2023, 12, 3),
      },
      {
        'id': '2',
        'senderName': 'Мария',
        'text': 'Ссылка на карту храма: https://example.com/map',
        'timestamp': DateTime(2023, 12, 10),
      },
    ],
  };
});

class ChatInfoScreen extends ConsumerStatefulWidget {
  final String chatId;

  const ChatInfoScreen({
    Key? key,
    required this.chatId,
  }) : super(key: key);

  @override
  ConsumerState<ChatInfoScreen> createState() => _ChatInfoScreenState();
}

class _ChatInfoScreenState extends ConsumerState<ChatInfoScreen> {
  @override
  Widget build(BuildContext context) {
    final chatAsync = ref.watch(chatInfoProvider(widget.chatId));

    return Scaffold(
      backgroundColor: AppColors.lightParchment,
      body: chatAsync.when(
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
                'Ошибка загрузки информации о чате',
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
                onPressed: () => ref.refresh(chatInfoProvider(widget.chatId)),
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
        data: (chatInfo) {
          return _buildChatInfo(chatInfo);
        },
      ),
    );
  }

  Widget _buildChatInfo(Map<String, dynamic> chatInfo) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Шапка с информацией о чате
          _buildChatHeader(chatInfo),

          // Статистика
          _buildChatStats(chatInfo['stats']),

          // Участники
          _buildParticipantsSection(chatInfo['participants']),

          // Закрепленные сообщения
          _buildPinnedMessages(chatInfo['pinnedMessages']),

          // Настройки чата
          _buildChatSettings(chatInfo['settings']),

          // Действия с чатом
          _buildChatActions(chatInfo),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildChatHeader(Map<String, dynamic> chatInfo) {
    final participants = List<Map<String, dynamic>>.from(chatInfo['participants'] ?? []);
    final onlineCount = participants.where((p) => p['isOnline'] == true).length;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryBrown.withOpacity(0.9),
            AppColors.darkBrown.withOpacity(0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Кнопка назад и заголовок
            Row(
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
                    'Информация о чате',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 48), // Для выравнивания
              ],
            ),

            const SizedBox(height: 24),

            // Аватар и название чата
            Center(
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      _getChatTypeIcon(chatInfo['type']),
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    chatInfo['name'] ?? 'Чат',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (chatInfo['description'] != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      chatInfo['description']!,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Основная информация
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildInfoRow(
                    icon: Icons.group,
                    label: 'Участники',
                    value: '${onlineCount} онлайн из ${participants.length}',
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    icon: Icons.calendar_today,
                    label: 'Создан',
                    value: _formatDate(chatInfo['createdAt']),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    icon: Icons.person,
                    label: 'Создатель',
                    value: chatInfo['createdBy'] ?? 'Неизвестно',
                  ),
                  if (chatInfo['type'] == 'campaign' && chatInfo['campaignName'] != null) ...[
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      icon: Icons.campaign,
                      label: 'Кампания',
                      value: chatInfo['campaignName']!,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatStats(Map<String, dynamic> stats) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Статистика чата',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.darkBrown,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _buildStatCard(
                icon: Icons.chat_bubble,
                value: stats['totalMessages']?.toString() ?? '0',
                label: 'Сообщений',
                color: AppColors.primaryBrown,
              ),
              _buildStatCard(
                icon: Icons.today,
                value: stats['messagesToday']?.toString() ?? '0',
                label: 'Сегодня',
                color: AppColors.infoBlue,
              ),
              _buildStatCard(
                icon: Icons.people,
                value: stats['activeParticipants']?.toString() ?? '0',
                label: 'Активных',
                color: AppColors.successGreen,
              ),
              _buildStatCard(
                icon: Icons.attach_file,
                value: stats['filesShared']?.toString() ?? '0',
                label: 'Файлов',
                color: AppColors.accentGold,
              ),
              _buildStatCard(
                icon: Icons.casino,
                value: stats['diceRolls']?.toString() ?? '0',
                label: 'Бросков',
                color: AppColors.warningOrange,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildParticipantsSection(List<dynamic> participants) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Участники (${participants.length})',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkBrown,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.person_add),
                color: AppColors.primaryBrown,
                onPressed: () => _addParticipants(),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Список участников
          ...participants.map((participant) {
            final p = Map<String, dynamic>.from(participant);
            return _buildParticipantCard(p);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildPinnedMessages(List<dynamic> pinnedMessages) {
    if (pinnedMessages.isEmpty) {
      return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.push_pin,
                  color: AppColors.accentGold,
                ),
                const SizedBox(width: 8),
                Text(
                  'Закрепленные сообщения',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBrown,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Нет закрепленных сообщений',
              style: TextStyle(
                color: AppColors.mediumBrown,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Row(
              children: [
                Icon(
                  Icons.push_pin,
                  color: AppColors.accentGold,
                ),
                const SizedBox(width: 8),
                Text(
                  'Закрепленные сообщения (${pinnedMessages.length})',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBrown,
                  ),
                ),
              ],
            ),
          ),

          // Список закрепленных сообщений
          ...pinnedMessages.map((message) {
            final msg = Map<String, dynamic>.from(message);
            return _buildPinnedMessageCard(msg);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildChatSettings(Map<String, dynamic> settings) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Настройки чата',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.darkBrown,
            ),
          ),
          const SizedBox(height: 16),

          Column(
            children: [
              _buildSettingSwitch(
                label: 'Разрешить броски кубиков',
                value: settings['allowDiceRolls'] ?? true,
                onChanged: (value) => _toggleSetting('allowDiceRolls', value),
                icon: Icons.casino,
              ),
              _buildSettingSwitch(
                label: 'Разрешить вложения',
                value: settings['allowAttachments'] ?? true,
                onChanged: (value) => _toggleSetting('allowAttachments', value),
                icon: Icons.attach_file,
              ),
              _buildSettingSwitch(
                label: 'Разрешить голосовые сообщения',
                value: settings['allowVoiceMessages'] ?? true,
                onChanged: (value) => _toggleSetting('allowVoiceMessages', value),
                icon: Icons.mic,
              ),
              _buildSettingSwitch(
                label: 'Разрешить закрепление сообщений',
                value: settings['pinnedMessagesAllowed'] ?? true,
                onChanged: (value) => _toggleSetting('pinnedMessagesAllowed', value),
                icon: Icons.push_pin,
              ),
              _buildSettingSwitch(
                label: 'Новые участники видят историю',
                value: settings['newMembersCanViewHistory'] ?? true,
                onChanged: (value) => _toggleSetting('newMembersCanViewHistory', value),
                icon: Icons.history,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChatActions(Map<String, dynamic> chatInfo) {
    final isCampaignChat = chatInfo['type'] == 'campaign';
    final isGroupChat = chatInfo['type'] == 'group';
    final isPrivateChat = chatInfo['type'] == 'private';

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Действия с чатом',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.darkBrown,
            ),
          ),
          const SizedBox(height: 16),

          if (isGroupChat || isCampaignChat)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _addParticipants(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBrown.withOpacity(0.1),
                  foregroundColor: AppColors.primaryBrown,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                icon: const Icon(Icons.person_add),
                label: const Text('ДОБАВИТЬ УЧАСТНИКОВ'),
              ),
            ),

          if (isGroupChat || isCampaignChat) const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _exportChatHistory(),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.darkBrown,
                side: BorderSide(color: AppColors.darkBrown.withOpacity(0.3)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              icon: const Icon(Icons.download),
              label: const Text('ЭКСПОРТИРОВАТЬ ИСТОРИЮ'),
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _clearChatHistory(),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.warningOrange,
                side: BorderSide(color: AppColors.warningOrange.withOpacity(0.3)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              icon: const Icon(Icons.delete_sweep),
              label: const Text('ОЧИСТИТЬ ИСТОРИЮ'),
            ),
          ),

          if (isGroupChat) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _leaveChat(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.errorRed,
                  side: BorderSide(color: AppColors.errorRed.withOpacity(0.3)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                icon: const Icon(Icons.exit_to_app),
                label: const Text('ПОКИНУТЬ ЧАТ'),
              ),
            ),
          ],

          if (isPrivateChat) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _blockUser(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.errorRed,
                  side: BorderSide(color: AppColors.errorRed.withOpacity(0.3)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                icon: const Icon(Icons.block),
                label: const Text('ЗАБЛОКИРОВАТЬ ПОЛЬЗОВАТЕЛЯ'),
              ),
            ),
          ],

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _reportChat(),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.errorRed,
                side: BorderSide(color: AppColors.errorRed.withOpacity(0.3)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              icon: const Icon(Icons.flag),
              label: const Text('ПОЖАЛОВАТЬСЯ НА ЧАТ'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white.withOpacity(0.8),
          size: 20,
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
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 8),
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
            style: TextStyle(
              fontSize: 12,
              color: AppColors.mediumBrown,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParticipantCard(Map<String, dynamic> participant) {
    final isOnline = participant['isOnline'] == true;
    final role = participant['role'];
    final characterName = participant['characterName'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.lightParchment,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.lightBrown.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          // Аватар
          Stack(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: isOnline
                    ? AppColors.successGreen.withOpacity(0.2)
                    : AppColors.mediumBrown.withOpacity(0.2),
                child: Text(
                  participant['name'][0],
                  style: TextStyle(
                    color: isOnline ? AppColors.successGreen : AppColors.mediumBrown,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (isOnline)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppColors.successGreen,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(width: 12),

          // Информация
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  participant['name'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.darkBrown,
                  ),
                ),
                if (characterName != null)
                  Text(
                    characterName,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.mediumBrown,
                    ),
                  ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getRoleColor(role).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _getRoleColor(role).withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        _getRoleText(role),
                        style: TextStyle(
                          fontSize: 10,
                          color: _getRoleColor(role),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      isOnline ? 'Онлайн' : _formatLastSeen(participant['lastSeen']),
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

          // Действия
          if (role != 'master') // Нельзя исключить мастера
            IconButton(
              icon: const Icon(
                Icons.more_vert,
                color: AppColors.mediumBrown,
              ),
              onPressed: () => _showParticipantOptions(participant),
            ),
        ],
      ),
    );
  }

  Widget _buildPinnedMessageCard(Map<String, dynamic> message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.lightBrown.withOpacity(0.3),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: AppColors.accentGold.withOpacity(0.2),
                child: Text(
                  message['senderName'][0],
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.accentGold,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                message['senderName'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkBrown,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(
                  Icons.push_pin,
                  size: 16,
                  color: AppColors.accentGold,
                ),
                onPressed: () => _unpinMessage(message),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            message['text'],
            style: TextStyle(
              color: AppColors.darkBrown.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _formatDate(message['timestamp']),
            style: TextStyle(
              fontSize: 12,
              color: AppColors.mediumBrown,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingSwitch({
    required String label,
    required bool value,
    required Function(bool) onChanged,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.primaryBrown,
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
            activeColor: AppColors.primaryBrown,
          ),
        ],
      ),
    );
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

  Color _getRoleColor(String role) {
    switch (role) {
      case 'master':
        return AppColors.accentGold;
      case 'player':
        return AppColors.infoBlue;
      default:
        return AppColors.mediumBrown;
    }
  }

  String _getRoleText(String role) {
    switch (role) {
      case 'master':
        return 'Мастер';
      case 'player':
        return 'Игрок';
      default:
        return role;
    }
  }

  String _formatDate(dynamic date) {
    if (date is DateTime) {
      return DateFormat('dd.MM.yyyy').format(date);
    }
    return 'Неизвестно';
  }

  String _formatLastSeen(dynamic lastSeen) {
    if (lastSeen is! DateTime) {
      return 'Давно';
    }

    final now = DateTime.now();
    final difference = now.difference(lastSeen);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} мин. назад';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ч. назад';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} дн. назад';
    } else {
      return DateFormat('dd.MM').format(lastSeen);
    }
  }

  void _addParticipants() {
    // TODO: Реализовать добавление участников
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Добавление участников в чат'),
      ),
    );
  }

  void _showParticipantOptions(Map<String, dynamic> participant) {
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
                participant['name'],
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkBrown,
                ),
                textAlign: TextAlign.center,
              ),

              if (participant['characterName'] != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    participant['characterName']!,
                    style: TextStyle(
                      color: AppColors.mediumBrown,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

              const SizedBox(height: 20),

              ListTile(
                leading: Icon(
                  Icons.person,
                  color: AppColors.infoBlue,
                ),
                title: const Text('Профиль пользователя'),
                onTap: () {
                  Navigator.pop(context);
                  _viewUserProfile(participant);
                },
              ),

              ListTile(
                leading: Icon(
                  Icons.chat,
                  color: AppColors.primaryBrown,
                ),
                title: const Text('Написать лично'),
                onTap: () {
                  Navigator.pop(context);
                  _startPrivateChat(participant);
                },
              ),

              ListTile(
                leading: Icon(
                  Icons.admin_panel_settings,
                  color: AppColors.accentGold,
                ),
                title: const Text('Назначить администратором'),
                onTap: () {
                  Navigator.pop(context);
                  _makeAdmin(participant);
                },
              ),

              ListTile(
                leading: Icon(
                  Icons.remove_circle,
                  color: AppColors.warningOrange,
                ),
                title: const Text('Исключить из чата'),
                onTap: () {
                  Navigator.pop(context);
                  _removeParticipant(participant);
                },
              ),

              ListTile(
                leading: Icon(
                  Icons.block,
                  color: AppColors.errorRed,
                ),
                title: const Text('Заблокировать'),
                onTap: () {
                  Navigator.pop(context);
                  _blockParticipant(participant);
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

  void _unpinMessage(Map<String, dynamic> message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Открепить сообщение'),
        content: const Text('Вы уверены, что хотите открепить это сообщение?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ОТМЕНА'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Открепить сообщение
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Сообщение откреплено'),
                  backgroundColor: AppColors.successGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBrown,
            ),
            child: const Text('ОТКРЕПИТЬ'),
          ),
        ],
      ),
    );
  }

  void _toggleSetting(String setting, bool value) {
    // TODO: Обновить настройку на сервере
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Настройка "$setting" изменена на ${value ? "включено" : "выключено"}'),
        backgroundColor: AppColors.successGreen,
      ),
    );
  }

  void _exportChatHistory() {
    // TODO: Реализовать экспорт истории
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Экспорт истории чата'),
      ),
    );
  }

  void _clearChatHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Очистить историю'),
        content: const Text('Вы уверены, что хотите очистить историю чата? Это действие нельзя отменить.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ОТМЕНА'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Очистить историю
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('История чата очищена'),
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

  void _leaveChat() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Покинуть чат'),
        content: const Text('Вы уверены, что хотите покинуть этот чат?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ОТМЕНА'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Покинуть чат
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Вы покинули чат'),
                  backgroundColor: AppColors.successGreen,
                ),
              );
              context.pop(); // Вернуться к списку чатов
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

  void _blockUser() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Заблокировать пользователя'),
        content: const Text('Вы уверены, что хотите заблокировать этого пользователя?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ОТМЕНА'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Заблокировать пользователя
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Пользователь заблокирован'),
                  backgroundColor: AppColors.successGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorRed,
            ),
            child: const Text('ЗАБЛОКИРОВАТЬ'),
          ),
        ],
      ),
    );
  }

  void _reportChat() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Пожаловаться на чат'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Выберите причину жалобы:'),
            const SizedBox(height: 16),
            ...['Спам', 'Оскорбления', 'Нарушение правил', 'Другое'].map((reason) {
              return ListTile(
                title: Text(reason),
                leading: Radio(
                  value: reason,
                  groupValue: null,
                  onChanged: (value) {},
                ),
              );
            }).toList(),
            const SizedBox(height: 8),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Дополнительные комментарии...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ОТМЕНА'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Жалоба отправлена'),
                  backgroundColor: AppColors.successGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBrown,
            ),
            child: const Text('ОТПРАВИТЬ'),
          ),
        ],
      ),
    );
  }

  void _viewUserProfile(Map<String, dynamic> participant) {
    // TODO: Реализовать просмотр профиля пользователя
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Просмотр профиля ${participant['name']}'),
      ),
    );
  }

  void _startPrivateChat(Map<String, dynamic> participant) {
    // TODO: Реализовать создание приватного чата
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Создание приватного чата с ${participant['name']}'),
      ),
    );
  }

  void _makeAdmin(Map<String, dynamic> participant) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Назначить администратором'),
        content: Text('Назначить ${participant['name']} администратором чата?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ОТМЕНА'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Назначить администратором
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${participant['name']} назначен администратором'),
                  backgroundColor: AppColors.successGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentGold,
            ),
            child: const Text('НАЗНАЧИТЬ'),
          ),
        ],
      ),
    );
  }

  void _removeParticipant(Map<String, dynamic> participant) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Исключить из чата'),
        content: Text('Вы уверены, что хотите исключить ${participant['name']} из чата?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ОТМЕНА'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Исключить участника
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${participant['name']} исключен из чата'),
                  backgroundColor: AppColors.successGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorRed,
            ),
            child: const Text('ИСКЛЮЧИТЬ'),
          ),
        ],
      ),
    );
  }

  void _blockParticipant(Map<String, dynamic> participant) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Заблокировать участника'),
        content: Text('Заблокировать ${participant['name']} в этом чате?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ОТМЕНА'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Заблокировать участника
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${participant['name']} заблокирован в чате'),
                  backgroundColor: AppColors.successGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorRed,
            ),
            child: const Text('ЗАБЛОКИРОВАТЬ'),
          ),
        ],
      ),
    );
  }
}