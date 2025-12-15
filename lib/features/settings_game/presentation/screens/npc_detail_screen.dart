import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '/core/constants/app_colors.dart';

class NpcDetailScreen extends ConsumerStatefulWidget {
  final String settingId;
  final String npcId;

  const NpcDetailScreen({
    Key? key,
    required this.settingId,
    required this.npcId,
  }) : super(key: key);

  @override
  ConsumerState<NpcDetailScreen> createState() => _NpcDetailScreenState();
}

class _NpcDetailScreenState extends ConsumerState<NpcDetailScreen> {
  Map<String, dynamic>? _npc;

  @override
  void initState() {
    super.initState();
    _loadNpcData();
  }

  void _loadNpcData() {
    // Mock данные для демонстрации
    final npcsData = {
      '1': {
        'id': '1',
        'name': 'Король Альдрик III',
        'title': 'Мудрый правитель Королевства Эльдора',
        'description': 'Король Альдрик III - 45-летний монарх, правящий Королевством Эльдора '
            'уже 20 лет. Известен своей мудростью, справедливостью и заботой о подданных. '
            'После смерти жены 5 лет назад воспитывает единственную дочь принцессу Элеонору.',
        'icon': Icons.emoji_people,
        'color': const Color(0xFF795548),
        'type': 'Персонаж',
        'importance': 'Ключевой',
        'alignment': 'Законопослушный-добрый',
        'race': 'Человек',
        'gender': 'Мужской',
        'age': 45,
        'role': 'Правитель королевства',
        'occupation': 'Монарх',
        'location': 'Столица Эльдора, Королевский дворец',
        'status': 'Жив',
        'personality': [
          'Мудрый и рассудительный',
          'Справедливый, но строгий',
          'Заботится о благополучии подданных',
          'Носит грусть по умершей жене',
          'Стремится оставить достойное наследие',
        ],
        'appearance': [
          'Высокий, статный мужчина',
          'Седые волосы и борода',
          'Проницательные голубые глаза',
          'Носит королевские одежды и корону',
          'Шрам на левой щеке от дуэли в молодости',
        ],
        'motivations': [
          'Защита королевства от внешних угроз',
          'Подготовка дочери к правлению',
          'Восстановление торговых путей',
          'Борьба с коррупцией при дворе',
          'Укрепление союзов с другими королевствами',
        ],
        'secrets': [
          'Таинственно исчез брат-близнец в детстве',
          'Имеет внебрачного сына среди дворян',
          'Знает о существовании древнего пророчества',
          'Хранит артефакт, дающий право на престол',
        ],
        'relationships': [
          {
            'name': 'Принцесса Элеонора',
            'relation': 'Дочь',
            'description': 'Единственная наследница, 18 лет',
            'status': 'Хорошие',
          },
          {
            'name': 'Лорд Бейлиш',
            'relation': 'Советник',
            'description': 'Доверенное лицо, возможный предатель',
            'status': 'Сложные',
          },
          {
            'name': 'Сэр Годрик',
            'relation': 'Капитан стражи',
            'description': 'Преданный рыцарь, спасал жизнь королю',
            'status': 'Отличные',
          },
        ],
        'quests': [
          {
            'title': 'Наследник престола',
            'description': 'Король ищет достойного мужа для дочери',
            'status': 'Активный',
          },
          {
            'title': 'Заговор при дворе',
            'description': 'Расследование возможного предательства',
            'status': 'Скрытый',
          },
        ],
        'stats': {
          'strength': 12,
          'dexterity': 10,
          'constitution': 14,
          'intelligence': 16,
          'wisdom': 18,
          'charisma': 17,
        },
        'skills': ['История', 'Убеждение', 'Проницательность', 'Политика'],
        'languages': ['Общий', 'Эльфийский', 'Дварфский'],
        'equipment': [
          'Королевский меч "Справедливость"',
          'Корона Эльдоры',
          'Кольцо печати',
          'Доспехи церемониальные',
        ],
        'abilities': [
          {
            'name': 'Королевское присутствие',
            'description': '+5 к проверкам Убеждения при взаимодействии с подданными',
          },
          {
            'name': 'Тактический гений',
            'description': 'Преимущество на проверки Интеллекта при планировании сражений',
          },
          {
            'name': 'Наследие королей',
            'description': 'Иммунитет к страху от сверхъестественных источников',
          },
        ],
        'notes': 'Король подозревает заговор среди дворян. '
            'Нужно подготовить встречу с послом эльфов на следующей сессии.',
        'created': '2024-01-10',
        'updated': '2024-01-15',
      },
      '2': {
        'id': '2',
        'name': 'Архимаг Маликор',
        'title': 'Хранитель древних магических знаний',
        'description': 'Маликор - 300-летний архимаг, глава Магической Академии Эльдоры. '
            'Изучает магию с детства и является одним из сильнейших магов королевства. '
            'Хранит запретные знания и артефакты в своей башне.',
        'icon': Icons.auto_awesome,
        'color': const Color(0xFF673AB7),
        'type': 'Персонаж',
        'importance': 'Ключевой',
        'alignment': 'Нейтральное',
        'race': 'Человек',
        'gender': 'Мужской',
        'age': 300,
        'role': 'Глава магической академии',
        'occupation': 'Маг, исследователь',
        'location': 'Башня Арканы, окраина столицы',
        'status': 'Жив (долголетие от магии)',
        'personality': [
          'Холодный и расчётливый',
          'Одержим знаниями',
          'Не доверяет политикам',
          'Защищает учеников',
          'Имеет странное чувство юмора',
        ],
        'appearance': [
          'Длинная седая борода',
          'Проницательные фиолетовые глаза',
          'Носит фиолетовые мантии',
          'Ходит с магическим посохом',
          'На лице следы магических экспериментов',
        ],
        'motivations': [
          'Сохранение магических знаний',
          'Защита мира от запретной магии',
          'Обучение новых магов',
          'Исследование древних артефактов',
          'Поиск источника вечной магии',
        ],
        'secrets': [
          'Изучает некромантию втайне',
          'Знает пророчество о конце мира',
          'Хранит душу демона в кристалле',
          'Был учеником древнего лича',
        ],
        'relationships': [
          {
            'name': 'Король Альдрик',
            'relation': 'Советник',
            'description': 'Официальный магический советник короля',
            'status': 'Уважительные',
          },
          {
            'name': 'Ученики академии',
            'relation': 'Учитель',
            'description': 'Обучает молодых магов',
            'status': 'Строгие',
          },
        ],
        'quests': [
          {
            'title': 'Запретный гримуар',
            'description': 'Поиск древней книги заклинаний',
            'status': 'Предложен',
          },
        ],
        'stats': {
          'strength': 8,
          'dexterity': 12,
          'constitution': 14,
          'intelligence': 20,
          'wisdom': 18,
          'charisma': 14,
        },
        'skills': ['Магия', 'История', 'Расследование', 'Религия'],
        'languages': ['Общий', 'Драконий', 'Демонический', 'Древний'],
        'equipment': [
          'Посох Вечного Пламени',
          'Мантия архимага',
          'Кольцо телепортации',
          'Свитки заклинаний',
        ],
        'abilities': [
          {
            'name': 'Мастер заклинаний',
            'description': 'Может накладывать заклинания 9-го уровня',
          },
          {
            'name': 'Магическое зрение',
            'description': 'Видит магические ауры и следы',
          },
          {
            'name': 'Защита от магии',
            'description': 'Сопротивление магическому урону',
          },
        ],
        'notes': 'Маликор может стать либо союзником, либо врагом в зависимости '
            'от действий игроков. Важно не дать ему заполучить запретные артефакты.',
        'created': '2024-01-12',
        'updated': '2024-01-18',
      },
      '3': {
        'id': '3',
        'name': 'Некролорд Мортис',
        'title': 'Древний владыка нежити',
        'description': 'Мортис - древний некромант, превратившийся в лича 500 лет назад. '
            'Правит Руинами Некросити и собирает армию нежити. Ищет способ вернуть '
            'себе смертную форму и отомстить тем, кто предал его при жизни.',
        'icon': Icons.sentiment_very_dissatisfied,
        'color': const Color(0xFF212121),
        'type': 'Персонаж',
        'importance': 'Ключевой',
        'alignment': 'Хаотично-злое',
        'race': 'Лич',
        'gender': 'Мужской',
        'age': 500,
        'role': 'Лидер культа Некросити',
        'occupation': 'Некромант',
        'location': 'Руины Некросити',
        'status': 'Нежить',
        'personality': [
          'Холодный и расчётливый',
          'Одержим местью',
          'Презирает живых',
          'Терпеливый стратег',
          'Имеет искру прежней человечности',
        ],
        'appearance': [
          'Скелет в чёрных мантиях',
          'Горящие синим пламенем глазницы',
          'Держит магический посох',
          'Носит древнюю корону',
          'От него исходит холод',
        ],
        'motivations': [
          'Возвращение смертной формы',
          'Месть бывшим союзникам',
          'Завоевание королевства',
          'Создание империи нежити',
          'Поиск своей филактерии',
        ],
        'secrets': [
          'Филактерия спрятана в гробнице предков',
          'Был предан собственным учеником',
          'Знает слабость королевской династии',
          'Имеет союзника при дворе',
        ],
        'relationships': [
          {
            'name': 'Архимаг Маликор',
            'relation': 'Бывший учитель',
            'description': 'Обучал Мортиса в молодости',
            'status': 'Враждебные',
          },
          {
            'name': 'Культисты Некросити',
            'relation': 'Поклонники',
            'description': 'Слуги и последователи',
            'status': 'Покорные',
          },
        ],
        'quests': [
          {
            'title': 'Филактерия',
            'description': 'Уничтожение источника бессмертия лича',
            'status': 'Основной',
          },
        ],
        'stats': {
          'strength': 18,
          'dexterity': 16,
          'constitution': 20,
          'intelligence': 19,
          'wisdom': 17,
          'charisma': 18,
        },
        'skills': ['Некромантия', 'Запугивание', 'Обман', 'Тактика'],
        'languages': ['Общий', 'Демонический', 'Мёртвые языки'],
        'equipment': [
          'Посох Могущества',
          'Филактерия',
          'Мантия теней',
          'Кольцо душевной связи',
        ],
        'abilities': [
          {
            'name': 'Парализующее прикосновение',
            'description': 'Прикосновение может парализовать цель',
          },
          {
            'name': 'Сотворение нежити',
            'description': 'Может создавать и контролировать нежить',
          },
          {
            'name': 'Сопротивление магии',
            'description': 'Преимущество против заклинаний',
          },
        ],
        'notes': 'Главный антагонист текущей кампании. '
            'Игроки должны найти его филактерию, чтобы победить окончательно.',
        'created': '2024-01-05',
        'updated': '2024-01-20',
      },
    };

    setState(() {
      _npc = npcsData[widget.npcId];
    });
  }

  Color _getImportanceColor(String importance) {
    switch (importance) {
      case 'Ключевой':
        return Colors.red;
      case 'Второстепенный':
        return Colors.orange;
      case 'Эпизодический':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Жив':
        return Colors.green;
      case 'Нежить':
        return Colors.purple;
      case 'Бессмертный':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Color _getAlignmentColor(String alignment) {
    if (alignment.contains('добр')) return Colors.green;
    if (alignment.contains('зл')) return Colors.red;
    if (alignment.contains('нейтр')) return Colors.blue;
    if (alignment.contains('хаот')) return Colors.orange;
    if (alignment.contains('закон')) return Colors.purple;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    if (_npc == null) {
      return Scaffold(
        backgroundColor: AppColors.getHomeBackground(context),
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryBrown,
          ),
        ),
      );
    }

    final importanceColor = _getImportanceColor(_npc!['importance']);
    final statusColor = _getStatusColor(_npc!['status']);
    final alignmentColor = _getAlignmentColor(_npc!['alignment']);

    return Scaffold(
      backgroundColor: AppColors.getHomeBackground(context),
      body: CustomScrollView(
        slivers: [
          // Заголовок экрана
          SliverAppBar(
            backgroundColor: _npc!['color'],
            expandedHeight: 220.0,
            floating: false,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.pop(),
            ),
            title: Text(
              _npc!['name'],
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
                  // context.go('/home/settings_game/${widget.settingId}/npcs/${_npc!['id']}/edit');
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
                      _npc!['color'],
                      _npc!['color'].withOpacity(0.8),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 50.0, 16.0, 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Иконка и бейджи
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _npc!['icon'],
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                  vertical: 6.0,
                                ),
                                decoration: BoxDecoration(
                                  color: importanceColor.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(20.0),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                ),
                                child: Text(
                                  _npc!['importance'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                  vertical: 4.0,
                                ),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(20.0),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                ),
                                child: Text(
                                  _npc!['status'],
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _npc!['title'],
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

          // Основной контент
          SliverPadding(
            padding: const EdgeInsets.all(12.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Описание
                _buildDescriptionSection(),

                const SizedBox(height: 16),

                // Основная информация
                _buildBasicInfoSection(),

                const SizedBox(height: 16),

                // Характеристики
                _buildStatsSection(),

                const SizedBox(height: 16),

                // Личность и внешность
                _buildPersonalitySection(),

                const SizedBox(height: 16),

                // Мотивации и секреты
                _buildMotivationsSection(),

                const SizedBox(height: 16),

                // Отношения
                if (_npc!['relationships'] != null && (_npc!['relationships'] as List).isNotEmpty)
                  _buildRelationshipsSection(),

                const SizedBox(height: 16),

                // Квесты
                if (_npc!['quests'] != null && (_npc!['quests'] as List).isNotEmpty)
                  _buildQuestsSection(),

                const SizedBox(height: 16),

                // Способности и снаряжение
                _buildAbilitiesSection(),

                const SizedBox(height: 16),

                // Заметки мастера
                if (_npc!['notes'] != null && _npc!['notes'].isNotEmpty)
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
                'Описание',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _npc!['color'],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _npc!['description'],
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.darkBrown.withOpacity(0.8),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
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
                'Основная информация',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _npc!['color'],
                ),
              ),
              const SizedBox(height: 12),

              // Сетка с основной информацией
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 2.2,
                ),
                itemCount: _getBasicInfoItems().length,
                itemBuilder: (context, index) {
                  final item = _getBasicInfoItems()[index];
                  return Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: _npc!['color'].withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: _npc!['color'].withOpacity(0.1),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item['title']!,
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.darkBrown.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item['value']!,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkBrown,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 12),

              // Мировоззрение
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: _getAlignmentColor(_npc!['alignment']).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: _getAlignmentColor(_npc!['alignment']).withOpacity(0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.psychology,
                      color: _getAlignmentColor(_npc!['alignment']),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Мировоззрение',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.darkBrown.withOpacity(0.6),
                            ),
                          ),
                          Text(
                            _npc!['alignment'],
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: _getAlignmentColor(_npc!['alignment']),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Навыки и языки
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (_npc!['skills'] != null && (_npc!['skills'] as List).isNotEmpty)
                    _buildSkillItem('Навыки', _npc!['skills']),
                  if (_npc!['languages'] != null && (_npc!['languages'] as List).isNotEmpty)
                    _buildSkillItem('Языки', _npc!['languages']),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Map<String, String>> _getBasicInfoItems() {
    final items = <Map<String, String>>[];

    void addItem(String title, String value) {
      items.add({
        'title': title,
        'value': value,
      });
    }

    addItem('Раса', _npc!['race']);
    addItem('Пол', _npc!['gender']);
    addItem('Возраст', '${_npc!['age']} лет');
    addItem('Тип', _npc!['type']);
    addItem('Роль', _npc!['role']);
    addItem('Занятие', _npc!['occupation']);
    addItem('Локация', _npc!['location']);

    return items;
  }

  Widget _buildSkillItem(String title, List<dynamic> items) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: _npc!['color'].withOpacity(0.05),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: _npc!['color'].withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _npc!['color'],
            ),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: items.map((item) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                decoration: BoxDecoration(
                  color: _npc!['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6.0),
                ),
                child: Text(
                  item.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    color: _npc!['color'],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    final stats = _npc!['stats'] as Map<String, dynamic>;
    final statNames = {
      'strength': 'СИЛ',
      'dexterity': 'ЛОВ',
      'constitution': 'ТЕЛ',
      'intelligence': 'ИНТ',
      'wisdom': 'МДР',
      'charisma': 'ХАР'
    };

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
                'Характеристики',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _npc!['color'],
                ),
              ),
              const SizedBox(height: 12),
              // Сетка характеристик
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 1.2,
                ),
                itemCount: stats.length,
                itemBuilder: (context, index) {
                  final key = stats.keys.elementAt(index);
                  final value = stats[key];
                  final modifier = ((value - 10) / 2).floor();

                  return Container(
                    decoration: BoxDecoration(
                      color: _npc!['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: _npc!['color'].withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          statNames[key]!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.darkBrown,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$value',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: _npc!['color'],
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '(${modifier >= 0 ? '+' : ''}$modifier)',
                          style: TextStyle(
                            fontSize: 12,
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

  Widget _buildPersonalitySection() {
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
                'Личность и внешность',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _npc!['color'],
                ),
              ),
              const SizedBox(height: 12),

              // Личность
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Черты личности:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.darkBrown,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...(_npc!['personality'] as List).map((trait) {
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
                              color: _npc!['color'],
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              trait,
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

              const SizedBox(height: 12),

              // Внешность
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Внешний вид:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.darkBrown,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...(_npc!['appearance'] as List).map((appearance) {
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
                              color: _npc!['color'],
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              appearance,
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMotivationsSection() {
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
                'Мотивации и секреты',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _npc!['color'],
                ),
              ),
              const SizedBox(height: 12),

              // Мотивации
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Мотивации:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.darkBrown,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...(_npc!['motivations'] as List).map((motivation) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.flag,
                            color: _npc!['color'],
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              motivation,
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

              const SizedBox(height: 12),

              // Секреты
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Секреты:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.darkBrown,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...(_npc!['secrets'] as List).map((secret) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.lock,
                            color: _npc!['color'],
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              secret,
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRelationshipsSection() {
    final relationships = _npc!['relationships'] as List;

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
                    'Отношения',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _npc!['color'],
                    ),
                  ),
                  Text(
                    '${relationships.length}',
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
                itemCount: relationships.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final relation = relationships[index];
                  return Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: _npc!['color'].withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: _npc!['color'].withOpacity(0.1),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                relation['name'],
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
                                color: _getRelationStatusColor(relation['status']).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              child: Text(
                                relation['status'],
                                style: TextStyle(
                                  fontSize: 11,
                                  color: _getRelationStatusColor(relation['status']),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6.0,
                                vertical: 2.0,
                              ),
                              decoration: BoxDecoration(
                                color: _npc!['color'].withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Text(
                                relation['relation'],
                                style: TextStyle(
                                  fontSize: 11,
                                  color: _npc!['color'],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          relation['description'],
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

  Color _getRelationStatusColor(String status) {
    switch (status) {
      case 'Хорошие':
      case 'Отличные':
        return Colors.green;
      case 'Сложные':
        return Colors.orange;
      case 'Враждебные':
        return Colors.red;
      case 'Покорные':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  Widget _buildQuestsSection() {
    final quests = _npc!['quests'] as List;

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
                'Квесты',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _npc!['color'],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Задания, связанные с этим персонажем:',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.darkBrown.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 12),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: quests.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final quest = quests[index];
                  return Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: _npc!['color'].withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: _npc!['color'].withOpacity(0.1),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                quest['title'],
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
                                color: _getQuestStatusColor(quest['status']).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              child: Text(
                                quest['status'],
                                style: TextStyle(
                                  fontSize: 11,
                                  color: _getQuestStatusColor(quest['status']),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          quest['description'],
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.darkBrown.withOpacity(0.8),
                            height: 1.4,
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

  Color _getQuestStatusColor(String status) {
    switch (status) {
      case 'Активный':
        return Colors.green;
      case 'Скрытый':
        return Colors.orange;
      case 'Основной':
        return Colors.red;
      case 'Предложен':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Widget _buildAbilitiesSection() {
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
                'Способности и снаряжение',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _npc!['color'],
                ),
              ),
              const SizedBox(height: 12),

              // Способности
              if (_npc!['abilities'] != null && (_npc!['abilities'] as List).isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Особые способности:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.darkBrown,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...(_npc!['abilities'] as List).map((ability) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: _npc!['color'].withOpacity(0.05),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ability['name'],
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: _npc!['color'],
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                ability['description'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.darkBrown.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),

              const SizedBox(height: 12),

              // Снаряжение
              if (_npc!['equipment'] != null && (_npc!['equipment'] as List).isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Снаряжение:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.darkBrown,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: (_npc!['equipment'] as List).map((item) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 6.0,
                          ),
                          decoration: BoxDecoration(
                            color: _npc!['color'].withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check,
                                color: _npc!['color'],
                                size: 14,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                item,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.darkBrown,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
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
                    color: _npc!['color'],
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Заметки мастера',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _npc!['color'],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: _npc!['color'].withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: _npc!['color'].withOpacity(0.1),
                  ),
                ),
                child: Text(
                  _npc!['notes'],
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.darkBrown.withOpacity(0.8),
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Создан: ${_npc!['created']}',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.darkBrown.withOpacity(0.5),
                    ),
                  ),
                  Text(
                    'Обновлён: ${_npc!['updated']}',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.darkBrown.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}