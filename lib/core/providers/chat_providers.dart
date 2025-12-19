import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dnd_project/core/providers/storage_providers.dart';
import 'package:dnd_project/data/repositories/chat_repository_impl.dart';
import 'package:dnd_project/domain/models/chat.dart';
import 'package:uuid/uuid.dart';

/// Провайдер для получения списка чатов из Hive
final chatsProvider = FutureProvider<List<Chat>>((ref) async {
  final repository = await ref.watch(chatRepositoryProvider.future);
  return await repository.getChats();
});

/// Провайдер для создания чата
final createChatProvider = FutureProvider.family<Chat, Chat>((ref, chat) async {
  final repository = await ref.watch(chatRepositoryProvider.future);
  if (repository is ChatRepositoryImpl) {
    await repository.saveChat(chat);
  }
  // Обновляем список чатов
  ref.invalidate(chatsProvider);
  return chat;
});

/// Провайдер для удаления чата
final deleteChatProvider = FutureProvider.family<void, String>((ref, chatId) async {
  final repository = await ref.watch(chatRepositoryProvider.future);
  if (repository is ChatRepositoryImpl) {
    await repository.deleteChat(chatId);
  }
  // Обновляем список чатов
  ref.invalidate(chatsProvider);
});

/// Провайдер для получения чата по ID
final chatByIdProvider = FutureProvider.family<Chat?, String>((ref, chatId) async {
  final chats = await ref.watch(chatsProvider.future);
  try {
    return chats.firstWhere((c) => c.id == chatId);
  } catch (_) {
    return null;
  }
});

