import 'package:dnd_project/domain/models/chat.dart';
import 'package:dnd_project/domain/models/message.dart';

abstract class ChatRepository {
  Future<List<Chat>> getChats();

  Future<List<Message>> getMessages(String chatId);

  Future<Message> sendMessage({
    required String chatId,
    required String text,
    required String senderId,
    required String senderName,
  });
}


