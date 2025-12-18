import 'package:dnd_project/data/datasources/chat_local_data_source.dart';
import 'package:dnd_project/domain/models/chat.dart';
import 'package:dnd_project/domain/models/message.dart';
import 'package:dnd_project/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl(this._local);

  final ChatLocalDataSource _local;

  @override
  Future<List<Chat>> getChats() {
    return _local.getChats();
  }

  @override
  Future<List<Message>> getMessages(String chatId) {
    return _local.getMessages(chatId);
  }

  @override
  Future<Message> sendMessage({required String chatId, required String text}) {
    return _local.sendMessage(chatId: chatId, text: text);
  }
}


