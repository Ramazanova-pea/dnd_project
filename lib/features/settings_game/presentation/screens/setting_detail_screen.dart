import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '/core/constants/app_colors.dart';

class SettingDetailScreen extends ConsumerStatefulWidget {
  final String settingId;

  const SettingDetailScreen({
    Key? key,
    required this.settingId,
  }) : super(key: key);

  @override
  ConsumerState<SettingDetailScreen> createState() => _SettingDetailScreenState();
}

class _SettingDetailScreenState extends ConsumerState<SettingDetailScreen> {
  Map<String, dynamic>? _setting;

  @override
  void initState() {
    super.initState();
    _loadSettingData();
  }

  void _loadSettingData() {
    // Mock данные для демонстрации
    final settingsData = {
      '1': {
        'id': '1',
        'name': 'Королевство Эльдора',
        'title': 'Земля древней магии и вечных противостояний',
        'description': 'Королевство Эльдора - континент, где магия пронизывает каждую частицу бытия. '
            'Здесь древние драконы правят горными вершинами, эльфы охраняют священные рощи, '
            'а в подземных городах дварфов куются легендарные артефакты. '
            'Но тень надвигается с севера - Некросити пробуждает армии нежити.',
        'icon': Icons.castle,
        'color': const Color(0xFF795548),
        'status': 'Активный',
        'genre': 'Фэнтези',
        'era': 'Средневековье',
        'magicLevel': 'Высокий',
        'techLevel': 'Низкий',
        'players': 5,
        'sessions': 12,
        'lastSession': '2024-01-15',
        'nextSession': '2024-01-22',
        'npcs': 8,
        'locations': 15,
        'factions': [
          {
            'name': 'Королевский двор Эльдоры',
            'alignment': 'Законопослушный-добрый',
            'description': 'Правящая династия и её вассалы',
          },
          {
            'name': 'Древесный союз эльфов',
            'alignment': 'Хаотично-добрый',
            'description': 'Хранители древних лесов',
          },
          {
            'name': 'Орден Света',
            'alignment': 'Законопослушный-добрый',
            'description': 'Жрецы и паладины, борющиеся со злом',
          },
          {
            'name': 'Тёмный культ Некросити',
            'alignment': 'Хаотично-злое',
            'description': 'Поклонники смерти и некромантии',
          },
        ],
        'history': [
          {
            'era': 'Древняя эпоха',
            'events': [
              'Создание мира древними драконами',
              'Прибытие первых эльфов через порталы',
              'Основание городов дварфов в глубинах гор',
            ],
          },
          {
            'era': 'Эпоха расцвета',
            'events': [
              'Объединение человеческих племён в королевство',
              'Заключение договора между расами',
              'Расцвет магических академий',
            ],
          },
          {
            'era': 'Современная эпоха',
            'events': [
              'Пробуждение Некросити',
              'Начало Войны Теней',
              'Появление героев судьбы',
            ],
          },
        ],
        'keyLocations': [
          {
            'name': 'Столица Эльдоры',
            'type': 'Город',
            'description': 'Сердце королевства, центр торговли и политики',
          },
          {
            'name': 'Забытые руины Некросити',
            'type': 'Подземелье',
            'description': 'Древний город некромантов, источник зла',
          },
          {
            'name': 'Вечнозелёный лес',
            'type': 'Лес',
            'description': 'Дом эльфов и место древней магии',
          },
          {
            'name': 'Железные горы',
            'type': 'Горы',
            'description': 'Королевство дварфов и богатейшие рудники',
          },
        ],
        'importantNpcs': [
          {
            'id': '1',
            'name': 'Король Альдрик',
            'role': 'Правитель Эльдоры',
            'description': 'Мудрый и справедливый монарх',
          },
          {
            'id': '2',
            'name': 'Архимаг Маликор',
            'role': 'Глава магической академии',
            'description': 'Хранитель древних знаний',
          },
          {
            'id': '3',
            'name': 'Некролорд Мортис',
            'role': 'Лидер культа Некросити',
            'description': 'Древний некромант, жаждущий власти',
          },
        ],
        'plotHooks': [
          'Расследование исчезновения деревенских жителей',
          'Поиск древнего артефакта в забытых руинах',
          'Переговоры между королевством и эльфами',
          'Защита каравана от нападений бандитов',
          'Исследование проклятого храма',
        ],
        'notes': 'Игроки недавно раскрыли заговор при дворе. '
            'Нужно подготовить следующую сессию с фокусом на Некросити.',
      },
      '2': {
        'id': '2',
        'name': 'Кибер-Мегаполис 2077',
        'title': 'Город неоновых огней и цифровых кошмаров',
        'description': 'Мегаполис 2077 - это вертикальный город будущего, где технология '
            'определяет социальный статус. Корпорации правят из своих небоскрёбов, '
            'в то время как на улицах кипит жизнь хакеров, киборгов и синтетиков. '
            'Но под блестящей поверхностью скрываются тёмные тайны и заговоры.',
        'icon': Icons.computer,
        'color': const Color(0xFF2196F3),
        'status': 'В разработке',
        'genre': 'Научная фантастика',
        'era': 'Будущее',
        'magicLevel': 'Отсутствует',
        'techLevel': 'Очень высокий',
        'players': 0,
        'sessions': 0,
        'lastSession': null,
        'nextSession': null,
        'npcs': 3,
        'locations': 8,
        'factions': [
          {
            'name': 'Корпорация Арес',
            'alignment': 'Законопослушный-злое',
            'description': 'Военно-промышленный гигант',
          },
          {
            'name': 'Сеть Анонимов',
            'alignment': 'Хаотично-нейтральное',
            'description': 'Подпольное сообщество хакеров',
          },
        ],
        'history': [
          {
            'era': 'Предкорпоративная эра',
            'events': [
              'Технологическая революция',
              'Объединение мировых правительств',
              'Создание первой ИИ',
            ],
          },
          {
            'era': 'Эпоха корпораций',
            'events': [
              'Падение национальных государств',
              'Восстание синтетиков',
              'Кибервойна 2065',
            ],
          },
        ],
        'keyLocations': [
          {
            'name': 'Деловой центр',
            'type': 'Район',
            'description': 'Сердце корпоративной власти',
          },
          {
            'name': 'Трущобы',
            'type': 'Район',
            'description': 'Нижние уровни города, дом незаконных деятельностей',
          },
        ],
        'importantNpcs': [],
        'plotHooks': [],
        'notes': 'Нужно разработать основную сюжетную линию и ключевых NPC.',
      },
    };

    setState(() {
      _setting = settingsData[widget.settingId];
    });
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Активный':
        return Colors.green;
      case 'Завершенный':
        return Colors.blue;
      case 'В разработке':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_setting == null) {
      return Scaffold(
        backgroundColor: AppColors.getHomeBackground(context),
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryBrown,
          ),
        ),
      );
    }

    final statusColor = _getStatusColor(_setting!['status']);

    return Scaffold(
      backgroundColor: AppColors.getHomeBackground(context),
      body: CustomScrollView(
        slivers: [
          // Заголовок экрана
          SliverAppBar(
            backgroundColor: _setting!['color'],
            expandedHeight: 220.0,
            floating: false,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.pop(),
            ),
            title: Text(
              _setting!['name'],
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 4.0,
                    color: Colors.black.withOpacity(0.5),
                    offset: const Offset(1, 1),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: () {
                  // Навигация к редактированию
                  // context.go('/home/settings_game/${_setting!['id']}/edit');
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _setting!['color'],
                      _setting!['color'].withOpacity(0.8),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 50.0, 16.0, 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Иконка и статус
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _setting!['icon'],
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 6.0,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              _setting!['status'],
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _setting!['title'],
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Кнопки быстрых действий
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.go('/home/settings_game/${_setting!['id']}/npcs');
                      },
                      icon: const Icon(Icons.people, size: 18),
                      label: const Text('NPC'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _setting!['color'],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Навигация к заметкам
                        // context.go('/home/settings_game/${_setting!['id']}/notes');
                      },
                      icon: const Icon(Icons.note_add, size: 18),
                      label: const Text('Заметки'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _setting!['color'].withOpacity(0.8),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Основной контент
          SliverPadding(
            padding: const EdgeInsets.all(12.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Описание мира
                _buildDescriptionSection(),

                const SizedBox(height: 16),

                // Статистика
                _buildStatsSection(),

                const SizedBox(height: 16),

                // Фракции
                if (_setting!['factions'] != null && (_setting!['factions'] as List).isNotEmpty)
                  _buildFactionsSection(),

                const SizedBox(height: 16),

                // История
                if (_setting!['history'] != null && (_setting!['history'] as List).isNotEmpty)
                  _buildHistorySection(),

                const SizedBox(height: 16),

                // Ключевые локации
                if (_setting!['keyLocations'] != null && (_setting!['keyLocations'] as List).isNotEmpty)
                  _buildLocationsSection(),

                const SizedBox(height: 16),

                // Важные NPC
                if (_setting!['importantNpcs'] != null && (_setting!['importantNpcs'] as List).isNotEmpty)
                  _buildNpcsSection(),

                const SizedBox(height: 16),

                // Зацепки для сюжета
                if (_setting!['plotHooks'] != null && (_setting!['plotHooks'] as List).isNotEmpty)
                  _buildPlotHooksSection(),

                const SizedBox(height: 16),

                // Заметки мастера
                if (_setting!['notes'] != null && _setting!['notes'].isNotEmpty)
                  _buildNotesSection(),

                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Card(
      elevation: 1.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Описание мира',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _setting!['color'],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _setting!['description'],
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.darkBrown.withOpacity(0.8),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),
              Divider(
                color: AppColors.lightBrown.withOpacity(0.3),
                height: 1,
              ),
              const SizedBox(height: 12),
              // Основные параметры
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildInfoItem('Жанр', _setting!['genre'], Icons.category),
                  _buildInfoItem('Эпоха', _setting!['era'], Icons.history),
                  _buildInfoItem('Уровень магии', _setting!['magicLevel'], Icons.auto_awesome),
                  _buildInfoItem('Уровень технологий', _setting!['techLevel'], Icons.computer),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String title, String value, IconData icon) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: _setting!['color'].withOpacity(0.05),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: _setting!['color'].withOpacity(0.1),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: _setting!['color'],
            size: 18,
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.darkBrown.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.darkBrown,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Card(
      elevation: 1.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Статистика',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _setting!['color'],
                ),
              ),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 2.2,
                ),
                itemCount: _getStatsItems().length,
                itemBuilder: (context, index) {
                  final item = _getStatsItems()[index];
                  return Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: _setting!['color'].withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: _setting!['color'].withOpacity(0.1),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item['title']!,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.darkBrown.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['value']!,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: _setting!['color'],
                          ),
                        ),
                        if (item['subtitle'] != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            item['subtitle']!,
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.darkBrown.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Map<String, String>> _getStatsItems() {
    final items = <Map<String, String>>[];

    void addItem(String title, String value, [String? subtitle]) {
      items.add({
        'title': title,
        'value': value,
        if (subtitle != null) 'subtitle': subtitle,
      });
    }

    addItem('Игроков', _setting!['players'].toString());
    addItem('Сессий', _setting!['sessions'].toString());
    addItem('NPC', _setting!['npcs'].toString());
    addItem('Локаций', _setting!['locations'].toString());

    if (_setting!['lastSession'] != null) {
      addItem('Последняя сессия', _formatDate(_setting!['lastSession']), 'сессия');
    }

    if (_setting!['nextSession'] != null) {
      addItem('Следующая сессия', _formatDate(_setting!['nextSession']), 'запланирована');
    }

    return items;
  }

  String _formatDate(String date) {
    final parts = date.split('-');
    if (parts.length == 3) {
      return '${parts[2]}.${parts[1]}.${parts[0]}';
    }
    return date;
  }

  Widget _buildFactionsSection() {
    final factions = _setting!['factions'] as List;

    return Card(
      elevation: 1.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Фракции',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _setting!['color'],
                    ),
                  ),
                  Text(
                    '${factions.length}',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.darkBrown.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: factions.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final faction = factions[index];
                  return Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: _setting!['color'].withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: _setting!['color'].withOpacity(0.1),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                faction['name'],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.darkBrown,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 2.0,
                              ),
                              decoration: BoxDecoration(
                                color: _setting!['color'].withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              child: Text(
                                faction['alignment'],
                                style: TextStyle(
                                  fontSize: 11,
                                  color: _setting!['color'],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          faction['description'],
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.darkBrown.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistorySection() {
    final history = _setting!['history'] as List;

    return Card(
      elevation: 1.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'История мира',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _setting!['color'],
                ),
              ),
              const SizedBox(height: 12),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: history.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final era = history[index];
                  return Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: _setting!['color'].withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: _setting!['color'].withOpacity(0.1),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          era['era'],
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: _setting!['color'],
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...(era['events'] as List).map((event) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 4.0),
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: _setting!['color'],
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    event,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: AppColors.darkBrown.withOpacity(0.8),
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationsSection() {
    final locations = _setting!['keyLocations'] as List;

    return Card(
      elevation: 1.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Ключевые локации',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _setting!['color'],
                    ),
                  ),
                  Text(
                    '${locations.length}',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.darkBrown.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: locations.map((location) {
                  return Container(
                    width: 150,
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: _setting!['color'].withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: _setting!['color'].withOpacity(0.1),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: _setting!['color'],
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                location['name'],
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.darkBrown,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6.0,
                            vertical: 2.0,
                          ),
                          decoration: BoxDecoration(
                            color: _setting!['color'].withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Text(
                            location['type'],
                            style: TextStyle(
                              fontSize: 10,
                              color: _setting!['color'],
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          location['description'],
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.darkBrown.withOpacity(0.7),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNpcsSection() {
    final npcs = _setting!['importantNpcs'] as List;

    return Card(
      elevation: 1.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Важные NPC',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _setting!['color'],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.go('/home/settings_game/${_setting!['id']}/npcs');
                    },
                    child: Text(
                      'Все NPC',
                      style: TextStyle(
                        fontSize: 14,
                        color: _setting!['color'],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: npcs.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final npc = npcs[index];
                  return Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: _setting!['color'].withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: _setting!['color'].withOpacity(0.1),
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        context.go('/home/settings_game/${_setting!['id']}/npcs/${npc['id']}');
                      },
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: _setting!['color'].withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.person,
                              color: _setting!['color'],
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  npc['name'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.darkBrown,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  npc['role'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.darkBrown.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: _setting!['color'],
                            size: 14,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlotHooksSection() {
    final plotHooks = _setting!['plotHooks'] as List;

    return Card(
      elevation: 1.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Зацепки для сюжета',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _setting!['color'],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Идеи для приключений в этом мире:',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.darkBrown.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 12),
              ...plotHooks.map((hook) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 4.0),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _setting!['color'],
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          hook,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.darkBrown.withOpacity(0.8),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotesSection() {
    return Card(
      elevation: 1.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.note,
                    color: _setting!['color'],
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Заметки мастера',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _setting!['color'],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: _setting!['color'].withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: _setting!['color'].withOpacity(0.1),
                  ),
                ),
                child: Text(
                  _setting!['notes'],
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.darkBrown.withOpacity(0.8),
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}