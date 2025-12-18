import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:dnd_project/domain/models/campaign.dart';
import 'package:dnd_project/domain/models/character.dart';
import 'package:dnd_project/domain/models/setting.dart';
import 'package:dnd_project/domain/models/chat.dart';
import 'package:dnd_project/domain/models/message.dart';

/// DataSource для работы с Hive (NoSQL база данных).
/// Используется для хранения сложных объектов: кампаний, персонажей, сеттингов, чатов.
/// 
/// Согласно методичке "Практическая работа 12.pdf", Hive подходит для:
/// - Хранения сложных объектов и структур данных
/// - Высокой производительности операций чтения/записи
/// - Работы с неструктурированными или полуструктурированными данными
class HiveDataSource {
  static const String _boxCampaigns = 'campaigns_box';
  static const String _boxCharacters = 'characters_box';
  static const String _boxSettings = 'settings_box';
  static const String _boxChats = 'chats_box';
  static const String _boxMessages = 'messages_box';

  bool _isInitialized = false;

  /// Инициализация Hive и открытие всех необходимых боксов
  Future<void> init() async {
    if (_isInitialized) return;

    await Hive.initFlutter();

    // Открываем все боксы для хранения данных
    await Future.wait([
      Hive.openBox(_boxCampaigns),
      Hive.openBox(_boxCharacters),
      Hive.openBox(_boxSettings),
      Hive.openBox(_boxChats),
      Hive.openBox(_boxMessages),
    ]);

    _isInitialized = true;
  }

  /// Получение бокса для кампаний
  Box get _campaignsBox => Hive.box(_boxCampaigns);

  /// Получение бокса для персонажей
  Box get _charactersBox => Hive.box(_boxCharacters);

  /// Получение бокса для сеттингов
  Box get _settingsBox => Hive.box(_boxSettings);

  /// Получение бокса для чатов
  Box get _chatsBox => Hive.box(_boxChats);

  /// Получение бокса для сообщений
  Box get _messagesBox => Hive.box(_boxMessages);

  // ========== Работа с кампаниями ==========

  /// Сохранение списка кампаний
  Future<void> saveCampaigns(List<Campaign> campaigns) async {
    final campaignsJson = campaigns.map((c) => _campaignToJson(c)).toList();
    await _campaignsBox.put('all', campaignsJson);
  }

  /// Получение всех кампаний
  Future<List<Campaign>> getCampaigns() async {
    final campaignsJson = _campaignsBox.get('all') as List<dynamic>?;
    if (campaignsJson == null) return [];

    return campaignsJson
        .map((json) => _campaignFromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Сохранение одной кампании
  Future<void> saveCampaign(Campaign campaign) async {
    final campaigns = await getCampaigns();
    final index = campaigns.indexWhere((c) => c.id == campaign.id);
    if (index >= 0) {
      campaigns[index] = campaign;
    } else {
      campaigns.add(campaign);
    }
    await saveCampaigns(campaigns);
  }

  /// Удаление кампании
  Future<void> deleteCampaign(String campaignId) async {
    final campaigns = await getCampaigns();
    campaigns.removeWhere((c) => c.id == campaignId);
    await saveCampaigns(campaigns);
  }

  // ========== Работа с персонажами ==========

  /// Сохранение списка персонажей
  Future<void> saveCharacters(List<Character> characters) async {
    final charactersJson = characters.map((c) => _characterToJson(c)).toList();
    await _charactersBox.put('all', charactersJson);
  }

  /// Получение всех персонажей
  Future<List<Character>> getCharacters() async {
    final charactersJson = _charactersBox.get('all') as List<dynamic>?;
    if (charactersJson == null) return [];

    return charactersJson
        .map((json) => _characterFromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Сохранение одного персонажа
  Future<void> saveCharacter(Character character) async {
    final characters = await getCharacters();
    final index = characters.indexWhere((c) => c.id == character.id);
    if (index >= 0) {
      characters[index] = character;
    } else {
      characters.add(character);
    }
    await saveCharacters(characters);
  }

  /// Удаление персонажа
  Future<void> deleteCharacter(String characterId) async {
    final characters = await getCharacters();
    characters.removeWhere((c) => c.id == characterId);
    await saveCharacters(characters);
  }

  // ========== Работа с сеттингами ==========

  /// Сохранение списка сеттингов
  Future<void> saveSettings(List<Setting> settings) async {
    final settingsJson = settings.map((s) => _settingToJson(s)).toList();
    await _settingsBox.put('all', settingsJson);
  }

  /// Получение всех сеттингов
  Future<List<Setting>> getSettings() async {
    final settingsJson = _settingsBox.get('all') as List<dynamic>?;
    if (settingsJson == null) return [];

    return settingsJson
        .map((json) => _settingFromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Сохранение одного сеттинга
  Future<void> saveSetting(Setting setting) async {
    final settings = await getSettings();
    final index = settings.indexWhere((s) => s.id == setting.id);
    if (index >= 0) {
      settings[index] = setting;
    } else {
      settings.add(setting);
    }
    await saveSettings(settings);
  }

  /// Удаление сеттинга
  Future<void> deleteSetting(String settingId) async {
    final settings = await getSettings();
    settings.removeWhere((s) => s.id == settingId);
    await saveSettings(settings);
  }

  // ========== Работа с чатами ==========

  /// Сохранение списка чатов
  Future<void> saveChats(List<Chat> chats) async {
    final chatsJson = chats.map((c) => _chatToJson(c)).toList();
    await _chatsBox.put('all', chatsJson);
  }

  /// Получение всех чатов
  Future<List<Chat>> getChats() async {
    final chatsJson = _chatsBox.get('all') as List<dynamic>?;
    if (chatsJson == null) return [];

    return chatsJson
        .map((json) => _chatFromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Сохранение одного чата
  Future<void> saveChat(Chat chat) async {
    final chats = await getChats();
    final index = chats.indexWhere((c) => c.id == chat.id);
    if (index >= 0) {
      chats[index] = chat;
    } else {
      chats.add(chat);
    }
    await saveChats(chats);
  }

  /// Удаление чата
  Future<void> deleteChat(String chatId) async {
    final chats = await getChats();
    chats.removeWhere((c) => c.id == chatId);
    await saveChats(chats);
  }

  // ========== Работа с сообщениями ==========

  /// Сохранение сообщений для чата
  Future<void> saveMessages(String chatId, List<Message> messages) async {
    final messagesJson = messages.map((m) => _messageToJson(m)).toList();
    await _messagesBox.put(chatId, messagesJson);
  }

  /// Получение сообщений чата
  Future<List<Message>> getMessages(String chatId) async {
    final messagesJson = _messagesBox.get(chatId) as List<dynamic>?;
    if (messagesJson == null) return [];

    return messagesJson
        .map((json) => _messageFromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Добавление сообщения в чат
  Future<void> addMessage(String chatId, Message message) async {
    final messages = await getMessages(chatId);
    messages.add(message);
    await saveMessages(chatId, messages);
  }

  // ========== Вспомогательные методы для сериализации ==========

  Map<String, dynamic> _campaignToJson(Campaign campaign) {
    return {
      'id': campaign.id,
      'name': campaign.name,
      'description': campaign.description,
      'status': campaign.status,
      'system': campaign.system,
      'master': campaign.master,
      'setting': campaign.setting,
      'players': campaign.players,
      'sessions': campaign.sessions,
      'nextSession': campaign.nextSession?.toIso8601String(),
      'lastSession': campaign.lastSession?.toIso8601String(),
    };
  }

  Campaign _campaignFromJson(Map<String, dynamic> json) {
    return Campaign(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      system: json['system'] as String,
      master: json['master'] as String,
      setting: json['setting'] as String,
      players: json['players'] as int,
      sessions: json['sessions'] as int,
      nextSession: json['nextSession'] != null
          ? DateTime.parse(json['nextSession'] as String)
          : null,
      lastSession: json['lastSession'] != null
          ? DateTime.parse(json['lastSession'] as String)
          : null,
    );
  }

  Map<String, dynamic> _characterToJson(Character character) {
    return {
      'id': character.id,
      'name': character.name,
      'race': character.race,
      'characterClass': character.characterClass,
      'level': character.level,
      'campaign': character.campaign,
      'lastPlayed': character.lastPlayed?.toIso8601String(),
    };
  }

  Character _characterFromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'] as String,
      name: json['name'] as String,
      race: json['race'] as String,
      characterClass: json['characterClass'] as String,
      level: json['level'] as int,
      campaign: json['campaign'] as String?,
      lastPlayed: json['lastPlayed'] != null
          ? DateTime.parse(json['lastPlayed'] as String)
          : null,
    );
  }

  Map<String, dynamic> _settingToJson(Setting setting) {
    return {
      'id': setting.id,
      'name': setting.name,
      'description': setting.description,
      'status': setting.status,
      'genre': setting.genre,
      'players': setting.players,
      'sessions': setting.sessions,
      'lastSession': setting.lastSession?.toIso8601String(),
      'npcs': setting.npcs,
      'locations': setting.locations,
    };
  }

  Setting _settingFromJson(Map<String, dynamic> json) {
    return Setting(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      genre: json['genre'] as String,
      players: json['players'] as int,
      sessions: json['sessions'] as int,
      lastSession: json['lastSession'] != null
          ? DateTime.parse(json['lastSession'] as String)
          : null,
      npcs: json['npcs'] as int,
      locations: json['locations'] as int,
    );
  }

  Map<String, dynamic> _chatToJson(Chat chat) {
    return {
      'id': chat.id,
      'name': chat.name,
      'description': chat.description,
      'type': chat.type,
      'campaignId': chat.campaignId,
      'unreadCount': chat.unreadCount,
      'isPinned': chat.isPinned,
      'isMuted': chat.isMuted,
      'lastActivity': chat.lastActivity?.toIso8601String(),
    };
  }

  Chat _chatFromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      type: json['type'] as String,
      campaignId: json['campaignId'] as String?,
      unreadCount: json['unreadCount'] as int,
      isPinned: json['isPinned'] as bool,
      isMuted: json['isMuted'] as bool,
      lastActivity: json['lastActivity'] != null
          ? DateTime.parse(json['lastActivity'] as String)
          : null,
    );
  }

  Map<String, dynamic> _messageToJson(Message message) {
    return {
      'id': message.id,
      'chatId': message.chatId,
      'senderId': message.senderId,
      'senderName': message.senderName,
      'text': message.text,
      'timestamp': message.timestamp.toIso8601String(),
      'isRead': message.isRead,
    };
  }

  Message _messageFromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      chatId: json['chatId'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String,
      text: json['text'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isRead: json['isRead'] as bool,
    );
  }

  /// Очистка всех данных (для тестирования или сброса)
  Future<void> clearAll() async {
    await Future.wait([
      _campaignsBox.clear(),
      _charactersBox.clear(),
      _settingsBox.clear(),
      _chatsBox.clear(),
      _messagesBox.clear(),
    ]);
  }
}

