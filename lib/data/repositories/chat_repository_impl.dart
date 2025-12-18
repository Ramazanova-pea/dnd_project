import 'package:dnd_project/data/datasources/local/hive_data_source.dart';
import 'package:dnd_project/domain/models/chat.dart';
import 'package:dnd_project/domain/models/message.dart';
import 'package:dnd_project/domain/repositories/chat_repository.dart';
import 'package:uuid/uuid.dart';

/// Реализация [ChatRepository] с использованием Hive для локального хранения.
class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl({
    required HiveDataSource hiveDataSource,
  }) : _hiveDataSource = hiveDataSource;

  final HiveDataSource _hiveDataSource;
  final _uuid = const Uuid();

  @override
  Future<List<Chat>> getChats() async {
    return await _hiveDataSource.getChats();
  }

  @override
  Future<List<Message>> getMessages(String chatId) async {
    return await _hiveDataSource.getMessages(chatId);
  }

  @override
  Future<Message> sendMessage({
    required String chatId,
    required String text,
    required String senderId,
    required String senderName,
  }) async {
    final message = Message(
      id: _uuid.v4(),
      chatId: chatId,
      senderId: senderId,
      senderName: senderName,
      text: text,
      timestamp: DateTime.now(),
      isRead: false,
    );

    await _hiveDataSource.addMessage(chatId, message);
    return message;
  }

  /// Сохранение чата в локальное хранилище
  Future<void> saveChat(Chat chat) async {
    await _hiveDataSource.saveChat(chat);
  }

  /// Удаление чата из локального хранилища
  Future<void> deleteChat(String chatId) async {
    await _hiveDataSource.deleteChat(chatId);
  }
}


