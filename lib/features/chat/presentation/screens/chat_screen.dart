import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '/core/constants/app_colors.dart';

// Временные модели и провайдеры (замените на реальные)
class Message {
  final String id;
  final String chatId;
  final String senderId;
  final String senderName;
  final String text;
  final DateTime timestamp;
  final bool isRead;
  final bool isEdited;
  final bool isDeleted;
  final List<String>? attachments;
  final Map<String, dynamic>? diceRoll;

  Message({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.senderName,
    required this.text,
    required this.timestamp,
    required this.isRead,
    this.isEdited = false,
    this.isDeleted = false,
    this.attachments,
    this.diceRoll,
  });
}

final chatProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, chatId) async {
  await Future.delayed(const Duration(milliseconds: 500));
  return {
    'id': chatId,
    'name': 'Поход за Граалем',
    'description': 'Основной чат кампании',
    'type': 'campaign',
    'campaignId': '1',
    'participants': [
      {'id': '1', 'name': 'Алексей', 'role': 'master', 'isOnline': true},
      {'id': '2', 'name': 'Мария', 'role': 'player', 'isOnline': true},
      {'id': '3', 'name': 'Дмитрий', 'role': 'player', 'isOnline': false},
      {'id': '4', 'name': 'Ольга', 'role': 'player', 'isOnline': false},
    ],
    'unreadCount': 3,
    'isPinned': true,
    'isMuted': false,
  };
});

final messagesProvider = FutureProvider.family<List<Message>, String>((ref, chatId) async {
  await Future.delayed(const Duration(seconds: 1));
  return [
    Message(
      id: '1',
      chatId: chatId,
      senderId: '1',
      senderName: 'Алексей',
      text: 'Добро пожаловать в кампанию "Поход за Священным Граалем"!',
      timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 5)),
      isRead: true,
    ),
    Message(
      id: '2',
      chatId: chatId,
      senderId: '2',
      senderName: 'Мария',
      text: 'Привет всем! Готовлюсь к первой сессии.',
      timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 4)),
      isRead: true,
    ),
    Message(
      id: '3',
      chatId: chatId,
      senderId: '3',
      senderName: 'Дмитрий',
      text: 'Я тоже готов. Мой дварф жаждет приключений!',
      timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 3)),
      isRead: true,
    ),
    Message(
      id: '4',
      chatId: chatId,
      senderId: '1',
      senderName: 'Алексей',
      text: 'Напоминаю: первая сессия в субботу в 19:00 в Discord.',
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 12)),
      isRead: true,
    ),
    Message(
      id: '5',
      chatId: chatId,
      senderId: '4',
      senderName: 'Ольга',
      text: 'Отлично! Буду там со своей волшебницей.',
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 10)),
      isRead: true,
    ),
    Message(
      id: '6',
      chatId: chatId,
      senderId: '2',
      senderName: 'Мария',
      text: 'Я нашла карту храма в старых записях!',
      timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
      isRead: true,
      attachments: ['map_image_url'],
    ),
    Message(
      id: '7',
      chatId: chatId,
      senderId: '3',
      senderName: 'Дмитрий',
      text: 'Круто! А что за испытания в храме?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      isRead: true,
    ),
    Message(
      id: '8',
      chatId: chatId,
      senderId: '1',
      senderName: 'Алексей',
      text: 'Это сюрприз! Но могу сказать, что там будут загадки и боевые сцены.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
      isRead: true,
    ),
    Message(
      id: '9',
      chatId: chatId,
      senderId: '2',
      senderName: 'Мария',
      text: 'Надо подготовить заклинания на разгадывание загадок.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      isRead: true,
    ),
    Message(
      id: '10',
      chatId: chatId,
      senderId: '1',
      senderName: 'Алексей',
      text: 'Кстати, проверьте свои кости на атаку: /roll 1d20+5',
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
      isRead: false,
      diceRoll: {'expression': '1d20+5', 'result': 18, 'details': '12+5'},
    ),
    Message(
      id: '11',
      chatId: chatId,
      senderId: '2',
      senderName: 'Мария',
      text: '/roll 1d20+3',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      isRead: false,
      diceRoll: {'expression': '1d20+3', 'result': 15, 'details': '12+3'},
    ),
    Message(
      id: '12',
      chatId: chatId,
      senderId: '3',
      senderName: 'Дмитрий',
      text: '/roll 2d6+4',
      timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
      isRead: false,
      diceRoll: {'expression': '2d6+4', 'result': 11, 'details': '3+4+4'},
    ),
  ];
});

class ChatScreen extends ConsumerStatefulWidget {
  final String chatId;

  const ChatScreen({
    Key? key,
    required this.chatId,
  }) : super(key: key);

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _messageFocusNode = FocusNode();

  bool _isSending = false;
  bool _showDicePanel = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _messageFocusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatAsync = ref.watch(chatProvider(widget.chatId));
    final messagesAsync = ref.watch(messagesProvider(widget.chatId));

    return Scaffold(
      backgroundColor: AppColors.lightParchment,
      body: SafeArea(
        child: Column(
          children: [
            // Аппбар чата
            _buildChatAppBar(chatAsync),

            // Список сообщений
            Expanded(
              child: messagesAsync.when(
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
                        'Ошибка загрузки сообщений',
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
                        onPressed: () => ref.refresh(messagesProvider(widget.chatId)),
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
                data: (messages) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToBottom();
                  });
                  return _buildMessagesList(messages, chatAsync);
                },
              ),
            ),

            // Панель кубиков (если активна)
            if (_showDicePanel) _buildDicePanel(),

            // Поле ввода сообщения
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildChatAppBar(AsyncValue<Map<String, dynamic>> chatAsync) {
    return Container(
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
              child: chatAsync.when(
                loading: () => _buildLoadingAppBar(),
                error: (error, stackTrace) => _buildErrorAppBar(),
                data: (chat) => _buildChatInfo(chat),
              ),
            ),

            IconButton(
              icon: const Icon(
                Icons.info_outline,
                color: AppColors.primaryBrown,
              ),
              onPressed: () => _showChatInfo(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingAppBar() {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.lightBrown.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 100,
                height: 16,
                decoration: BoxDecoration(
                  color: AppColors.lightBrown.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                width: 60,
                height: 12,
                decoration: BoxDecoration(
                  color: AppColors.lightBrown.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildErrorAppBar() {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.errorRed.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.error_outline,
            color: AppColors.errorRed,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ошибка загрузки',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkBrown,
                ),
              ),
              Text(
                'Чата не существует',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.mediumBrown,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChatInfo(Map<String, dynamic> chat) {
    final participants = List<Map<String, dynamic>>.from(chat['participants'] ?? []);
    final onlineCount = participants.where((p) => p['isOnline'] == true).length;

    return Row(
      children: [
        // Аватар чата
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primaryBrown.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primaryBrown.withOpacity(0.3),
            ),
          ),
          child: Icon(
            _getChatTypeIcon(chat['type']),
            color: AppColors.primaryBrown,
          ),
        ),
        const SizedBox(width: 12),

        // Информация о чате
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                chat['name'] ?? 'Чат',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkBrown,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                children: [
                  Text(
                    '$onlineCount из ${participants.length} онлайн',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.mediumBrown,
                    ),
                  ),
                  if (chat['unreadCount'] > 0) ...[
                    const SizedBox(width: 8),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppColors.primaryBrown,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMessagesList(List<Message> messages, AsyncValue<Map<String, dynamic>> chatAsync) {
    if (messages.isEmpty) {
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
              'Сообщений пока нет',
              style: TextStyle(
                fontSize: 20,
                color: AppColors.darkBrown,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Начните общение первым!',
              style: TextStyle(
                color: AppColors.mediumBrown,
              ),
            ),
          ],
        ),
      );
    }

    // Группируем сообщения по дням
    final Map<String, List<Message>> groupedMessages = {};

    for (final message in messages) {
      final dateKey = DateFormat('dd.MM.yyyy').format(message.timestamp);
      if (!groupedMessages.containsKey(dateKey)) {
        groupedMessages[dateKey] = [];
      }
      groupedMessages[dateKey]!.add(message);
    }

    // Создаем плоский список для ListView
    final List<Widget> messageWidgets = [];

    // Добавляем верхний отступ
    messageWidgets.add(const SizedBox(height: 8));

    for (final dateKey in groupedMessages.keys) {
      // Добавляем разделитель даты
      messageWidgets.add(_buildDateSeparator(dateKey));

      // Добавляем все сообщения за этот день
      final dayMessages = groupedMessages[dateKey]!;
      for (int i = 0; i < dayMessages.length; i++) {
        final message = dayMessages[i];
        final isPreviousSameSender = i > 0 && dayMessages[i - 1].senderId == message.senderId;

        messageWidgets.add(_buildMessageBubble(
          message,
          isPreviousSameSender,
          chatAsync,
        ));
      }
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: messageWidgets.length,
      itemBuilder: (context, index) {
        return messageWidgets[index];
      },
    );
  }

  Widget _buildDateSeparator(String date) {
    final now = DateTime.now();
    final today = DateFormat('dd.MM.yyyy').format(now);
    final yesterday = DateFormat('dd.MM.yyyy').format(now.subtract(const Duration(days: 1)));

    String displayDate;
    if (date == today) {
      displayDate = 'Сегодня';
    } else if (date == yesterday) {
      displayDate = 'Вчера';
    } else {
      displayDate = date;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: AppColors.lightBrown.withOpacity(0.3),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              displayDate,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.mediumBrown,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Divider(
              color: AppColors.lightBrown.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(
      Message message,
      bool isPreviousSameSender,
      AsyncValue<Map<String, dynamic>> chatAsync,
      ) {
    final isCurrentUser = message.senderId == 'currentUserId'; // TODO: Заменить на реальный ID

    return Container(
      margin: EdgeInsets.only(
        bottom: 8,
        top: isPreviousSameSender ? 2 : 8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Аватар отправителя (только если новый отправитель)
          if (!isPreviousSameSender && !isCurrentUser)
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.accentGold.withOpacity(0.2),
                child: Text(
                  message.senderName[0],
                  style: TextStyle(
                    color: AppColors.accentGold,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          else if (!isCurrentUser)
            const SizedBox(width: 40), // Отступ для выравнивания

          Expanded(
            child: Column(
              crossAxisAlignment: isCurrentUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                // Имя отправителя (только если новый отправитель)
                if (!isPreviousSameSender && !isCurrentUser)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4, left: 8),
                    child: Text(
                      message.senderName,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.darkBrown,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                // Пузырек с сообщением
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isCurrentUser
                        ? AppColors.primaryBrown.withOpacity(0.1)
                        : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: isCurrentUser
                          ? const Radius.circular(16)
                          : const Radius.circular(4),
                      bottomRight: isCurrentUser
                          ? const Radius.circular(4)
                          : const Radius.circular(16),
                    ),
                    border: Border.all(
                      color: isCurrentUser
                          ? AppColors.primaryBrown.withOpacity(0.2)
                          : AppColors.lightBrown.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Текст сообщения
                      if (!message.isDeleted)
                        Text(
                          message.text,
                          style: TextStyle(
                            color: isCurrentUser
                                ? AppColors.darkBrown
                                : AppColors.darkBrown,
                            fontSize: 14,
                          ),
                        )
                      else
                        Text(
                          'Сообщение удалено',
                          style: TextStyle(
                            color: AppColors.mediumBrown.withOpacity(0.6),
                            fontStyle: FontStyle.italic,
                          ),
                        ),

                      // Вложения
                      if (message.attachments != null && message.attachments!.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Container(
                              width: 150,
                              height: 100,
                              decoration: BoxDecoration(
                                color: AppColors.lightBrown.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.lightBrown.withOpacity(0.3),
                                ),
                              ),
                              child: const Icon(
                                Icons.image,
                                color: AppColors.mediumBrown,
                              ),
                            ),
                          ],
                        ),

                      // Бросок кубиков
                      if (message.diceRoll != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            _buildDiceRoll(message.diceRoll!),
                          ],
                        ),

                      // Время и статус
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: isCurrentUser
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat('HH:mm').format(message.timestamp),
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.mediumBrown,
                            ),
                          ),
                          if (message.isEdited)
                            Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Text(
                                'ред.',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.mediumBrown,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          if (isCurrentUser)
                            Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Icon(
                                message.isRead ? Icons.done_all : Icons.done,
                                size: 12,
                                color: message.isRead
                                    ? AppColors.primaryBrown
                                    : AppColors.mediumBrown,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiceRoll(Map<String, dynamic> diceRoll) {
    final expression = diceRoll['expression'] as String;
    final result = diceRoll['result'] as int;
    final details = diceRoll['details'] as String?;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.accentGold.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.accentGold.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.casino,
                size: 16,
                color: AppColors.accentGold,
              ),
              const SizedBox(width: 8),
              Text(
                expression,
                style: TextStyle(
                  color: AppColors.darkBrown,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.accentGold,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  result.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              if (details != null) ...[
                const SizedBox(width: 8),
                Text(
                  details,
                  style: TextStyle(
                    color: AppColors.mediumBrown,
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDicePanel() {
    final commonDice = [
      {'label': '1d4', 'value': '1d4'},
      {'label': '1d6', 'value': '1d6'},
      {'label': '1d8', 'value': '1d8'},
      {'label': '1d10', 'value': '1d10'},
      {'label': '1d12', 'value': '1d12'},
      {'label': '1d20', 'value': '1d20'},
      {'label': '1d100', 'value': '1d100'},
    ];

    final dndRolls = [
      {'label': 'Атака', 'value': '1d20+5'},
      {'label': 'Урон меча', 'value': '1d8+3'},
      {'label': 'Проверка навыка', 'value': '1d20+2'},
      {'label': 'Спасбросок', 'value': '1d20+4'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: AppColors.lightBrown.withOpacity(0.3),
          ),
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Быстрые броски',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkBrown,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: () {
                  setState(() {
                    _showDicePanel = false;
                  });
                },
                color: AppColors.mediumBrown,
              ),
            ],
          ),

          // Обычные кубики
          const SizedBox(height: 8),
          Text(
            'Базовые кубики',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.mediumBrown,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: commonDice.map((dice) {
              return ActionChip(
                label: Text(dice['label']!),
                onPressed: () => _rollDice(dice['value']!),
                backgroundColor: AppColors.lightBrown.withOpacity(0.1),
                labelStyle: TextStyle(
                  color: AppColors.darkBrown,
                  fontWeight: FontWeight.bold,
                ),
              );
            }).toList(),
          ),

          // D&D броски
          const SizedBox(height: 16),
          Text(
            'D&D броски',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.mediumBrown,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: dndRolls.map((roll) {
              return ActionChip(
                label: Text(roll['label']!),
                onPressed: () => _rollDice(roll['value']!),
                backgroundColor: AppColors.primaryBrown.withOpacity(0.1),
                labelStyle: TextStyle(
                  color: AppColors.primaryBrown,
                  fontWeight: FontWeight.bold,
                ),
              );
            }).toList(),
          ),

          // Пользовательский ввод
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: TextEditingController(text: '/roll '),
                  decoration: InputDecoration(
                    hintText: '/roll 2d6+3',
                    hintStyle: TextStyle(
                      color: AppColors.mediumBrown.withOpacity(0.6),
                    ),
                    filled: true,
                    fillColor: AppColors.lightParchment,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  onSubmitted: (value) {
                    if (value.startsWith('/roll ')) {
                      final diceExpression = value.substring(6);
                      _rollDice(diceExpression);
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  final value = _messageController.text;
                  if (value.startsWith('/roll ')) {
                    final diceExpression = value.substring(6);
                    _rollDice(diceExpression);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBrown,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Бросить'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: AppColors.lightBrown.withOpacity(0.3),
          ),
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Кнопка кубиков
          IconButton(
            icon: Icon(
              Icons.casino,
              color: _showDicePanel
                  ? AppColors.primaryBrown
                  : AppColors.mediumBrown,
            ),
            onPressed: () {
              setState(() {
                _showDicePanel = !_showDicePanel;
              });
            },
          ),

          // Кнопка вложений
          IconButton(
            icon: const Icon(
              Icons.attach_file,
              color: AppColors.mediumBrown,
            ),
            onPressed: _attachFile,
          ),

          // Поле ввода
          Expanded(
            child: TextField(
              controller: _messageController,
              focusNode: _messageFocusNode,
              decoration: InputDecoration(
                hintText: 'Сообщение...',
                hintStyle: TextStyle(
                  color: AppColors.mediumBrown.withOpacity(0.6),
                ),
                filled: true,
                fillColor: AppColors.lightParchment,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: (value) {
                // Автоматическое разворачивание панели кубиков при /roll
                if (value.startsWith('/roll ') && !_showDicePanel) {
                  setState(() {
                    _showDicePanel = true;
                  });
                }
              },
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  _sendMessage(value);
                }
              },
            ),
          ),

          // Кнопка отправки
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: AppColors.primaryBrown,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: _isSending
                  ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
                  : const Icon(
                Icons.send,
                color: Colors.white,
              ),
              onPressed: _isSending ? null : () {
                final text = _messageController.text.trim();
                if (text.isNotEmpty) {
                  _sendMessage(text);
                }
              },
            ),
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

  void _showChatInfo() {
    context.go('/home/chats/${widget.chatId}/info');
  }

  void _sendMessage(String text) async {
    if (_isSending) return;

    setState(() {
      _isSending = true;
    });

    try {
      // TODO: Отправить сообщение на сервер
      await Future.delayed(const Duration(milliseconds: 500));

      // Очищаем поле ввода
      _messageController.clear();

      // Если это команда /roll, обрабатываем как бросок кубиков
      if (text.startsWith('/roll ')) {
        final diceExpression = text.substring(6);
        _simulateDiceRoll(diceExpression);
      }

      // Прокручиваем к новому сообщению
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка отправки: $e'),
          backgroundColor: AppColors.errorRed,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  void _attachFile() {
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
                'Прикрепить файл',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkBrown,
                ),
              ),
              const SizedBox(height: 20),

              ListTile(
                leading: Icon(
                  Icons.image,
                  color: AppColors.successGreen,
                ),
                title: const Text('Фотография'),
                subtitle: const Text('Из галереи или камеры'),
                onTap: () {
                  Navigator.pop(context);
                  _attachPhoto();
                },
              ),

              ListTile(
                leading: Icon(
                  Icons.description,
                  color: AppColors.infoBlue,
                ),
                title: const Text('Документ'),
                subtitle: const Text('PDF, Word, Excel'),
                onTap: () {
                  Navigator.pop(context);
                  _attachDocument();
                },
              ),

              ListTile(
                leading: Icon(
                  Icons.map,
                  color: AppColors.accentGold,
                ),
                title: const Text('Карта'),
                subtitle: const Text('Игровая карта или схема'),
                onTap: () {
                  Navigator.pop(context);
                  _attachMap();
                },
              ),

              ListTile(
                leading: Icon(
                  Icons.audiotrack,
                  color: AppColors.primaryBrown,
                ),
                title: const Text('Аудио'),
                subtitle: const Text('Голосовое сообщение или звук'),
                onTap: () {
                  Navigator.pop(context);
                  _attachAudio();
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
                child: const Text('ОТМЕНА'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _attachPhoto() {
    // TODO: Реализовать прикрепление фото
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Прикрепление фотографии'),
      ),
    );
  }

  void _attachDocument() {
    // TODO: Реализовать прикрепление документа
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Прикрепление документа'),
      ),
    );
  }

  void _attachMap() {
    // TODO: Реализовать прикрепление карты
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Прикрепление карты'),
      ),
    );
  }

  void _attachAudio() {
    // TODO: Реализовать прикрепление аудио
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Прикрепление аудио'),
      ),
    );
  }

  void _rollDice(String expression) {
    // Скрываем панель кубиков
    setState(() {
      _showDicePanel = false;
    });

    // Добавляем команду в поле ввода
    _messageController.text = '/roll $expression';
    _messageFocusNode.requestFocus();
  }

  void _simulateDiceRoll(String expression) {
    // TODO: Реализовать реальную логику броска кубиков
    // Здесь просто имитация для демонстрации

    final random = expression.hashCode % 20 + 1; // Простая "случайность"

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Бросок $expression: $random'),
        backgroundColor: AppColors.successGreen,
      ),
    );
  }
}