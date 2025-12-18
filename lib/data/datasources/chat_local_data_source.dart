import 'package:dnd_project/domain/models/chat.dart' as domain;
import 'package:dnd_project/domain/models/message.dart';

/// Локальный (демо) источник данных для чатов.
class ChatLocalDataSource {
  Future<List<domain.Chat>> getChats() async {
    // TODO: заменить на реальное хранилище/сетевой источник.
    return <domain.Chat>[
      domain.Chat(
        id: '1',
        name: 'Поход за Граалем',
        description: 'Основной чат кампании',
        type: 'campaign',
        campaignId: '1',
        unreadCount: 3,
        isPinned: true,
        isMuted: false,
        lastActivity: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
    ];
  }

  Future<List<Message>> getMessages(String chatId) async {
    // TODO: заменить на реальную историю сообщений.
    return <Message>[
      Message(
        id: 'm1',
        chatId: chatId,
        senderId: '2',
        senderName: 'Мария',
        text: 'Я нашла карту храма!',
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
        isRead: false,
      ),
    ];
  }

  Future<Message> sendMessage({
    required String chatId,
    required String text,
  }) async {
    // TODO: заменить на реальную отправку сообщения.
    final message = Message(
      id: 'local_${DateTime.now().millisecondsSinceEpoch}',
      chatId: chatId,
      senderId: 'currentUserId',
      senderName: 'Вы',
      text: text,
      timestamp: DateTime.now(),
      isRead: true,
    );
    return message;
  }
}


