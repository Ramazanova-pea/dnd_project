import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '/core/constants/app_colors.dart';

class ClassDetailScreen extends ConsumerStatefulWidget {
  final String classId;

  const ClassDetailScreen({
    Key? key,
    required this.classId,
  }) : super(key: key);

  @override
  ConsumerState<ClassDetailScreen> createState() => _ClassDetailScreenState();
}

class _ClassDetailScreenState extends ConsumerState<ClassDetailScreen> {
  Map<String, dynamic>? _classData;

  @override
  void initState() {
    super.initState();
    _loadClassData();
  }

  void _loadClassData() {
    // Mock данные для демонстрации
    final classesData = {
      '1': {
        'id': '1',
        'name': 'Воин',
        'title': 'Мастер оружия и доспехов',
        'description': 'Воин - эксперт в боевых искусствах, владеющий всеми видами оружия и доспехов. '
            'Воин сочетает мастерское владение оружием с выдающейся стойкостью и тактическим мышлением.',
        'icon': Icons.sports_martial_arts,
        'color': const Color(0xFFC62828),
        'role': 'Защитник',
        'powerSource': 'Марсиальная',
        'primaryAbility': 'Сила или Ловкость',
        'secondaryAbilities': ['Телосложение'],
        'hitDie': 'd10',
        'armor': 'Все доспехи, щиты',
        'weapons': 'Простое и воинское оружие',
        'tools': '',
        'savingThrows': ['Сила', 'Телосложение'],
        'skills': {
          'choose': 2,
          'from': ['Атлетика', 'Внимательность', 'Выживание', 'Запугивание', 'История', 'Проницательность', 'Уход за животными'],
        },
        'features': [
          {
            'level': 1,
            'name': 'Боевой стиль',
            'description': 'Вы выбираете один боевой стиль, соответствующий вашей специализации.',
          },
          {
            'level': 1,
            'name': 'Вторая ветка',
            'description': 'Вы получаете преимущество, когда используете действие Ветка.',
          },
          {
            'level': 2,
            'name': 'Порыв ярости',
            'description': 'Вы можете использовать бонусное действие в свой ход для совершения дополнительной атаки.',
          },
          {
            'level': 5,
            'name': 'Дополнительная атака',
            'description': 'Вы можете совершить две атаки вместо одной, когда используете действие Атака.',
          },
          {
            'level': 9,
            'name': 'Индукция',
            'description': 'Вы можете перебросить проваленный спасбросок один раз в день.',
          },
          {
            'level': 11,
            'name': 'Третья атака',
            'description': 'Вы можете совершить три атаки вместо одной, когда используете действие Атака.',
          },
          {
            'level': 20,
            'name': 'Четвёртая атака',
            'description': 'Вы можете совершить четыре атаки вместо одной, когда используете действие Атака.',
          },
        ],
        'subclasses': [
          {
            'name': 'Воин-чемпион',
            'description': 'Улучшает базовые способности воина',
            'features': ['Улучшенная критика', 'Дополнительный боевой стиль'],
          },
          {
            'name': 'Воин-мастер боя',
            'description': 'Тактик, использующий манёвры',
            'features': ['Манёвры', 'Знание боевых уловок'],
          },
          {
            'name': 'Защитник',
            'description': 'Непробиваемый щит группы',
            'features': ['Защитная реакция', 'Непробиваемая защита'],
          },
        ],
        'spellcasting': false,
        'progression': 'Быстрая',
        'startingEquipment': [
          'Кольчуга или кожаный доспех, длинный лук и 20 стрел',
          'Воинское оружие и щит или два воинских оружия',
          'Лёгкий арбалет и 20 болтов или два ручных топора',
          'Набор искателя приключений и мешок',
        ],
        'proficiencies': {
          'armor': ['Все доспехи', 'Щиты'],
          'weapons': ['Простое оружие', 'Воинское оружие'],
          'tools': [],
        },
        'typicalCharacters': [
          'Рыцарь на службе у короля',
          'Наёмник, сражающийся за золото',
          'Защитник деревни от монстров',
          'Гладиатор на арене',
        ],
      },
      '2': {
        'id': '2',
        'name': 'Волшебник',
        'title': 'Мастер арканной магии',
        'description': 'Волшебник - учёный магии, изучающий заклинания по книгам и свиткам. '
            'Интеллект волшебника позволяет ему понимать и изменять саму структуру реальности.',
        'icon': Icons.auto_awesome,
        'color': const Color(0xFF1565C0),
        'role': 'Контроллер',
        'powerSource': 'Аркана',
        'primaryAbility': 'Интеллект',
        'secondaryAbilities': ['Мудрость', 'Ловкость'],
        'hitDie': 'd6',
        'armor': 'Нет',
        'weapons': 'Кинжалы, дротики, пращи, посохи, лёгкие арбалеты',
        'tools': '',
        'savingThrows': ['Интеллект', 'Мудрость'],
        'skills': {
          'choose': 2,
          'from': ['История', 'Магия', 'Проницательность', 'Религия', 'Расследование'],
        },
        'features': [
          {
            'level': 1,
            'name': 'Магическое восстановление',
            'description': 'Вы можете восстановить часть использованных ячеек заклинаний после короткого отдыха.',
          },
          {
            'level': 2,
            'name': 'Школа магии',
            'description': 'Вы выбираете школу магии, в которой специализируетесь.',
          },
          {
            'level': 18,
            'name': 'Мастер заклинаний',
            'description': 'Вы можете подготовить два заклинания 1-го или 2-го уровня без затраты ячеек.',
          },
        ],
        'subclasses': [
          {
            'name': 'Школа иллюзий',
            'description': 'Мастер обмана и иллюзий',
            'features': ['Улучшенные иллюзии', 'Изменение иллюзий'],
          },
          {
            'name': 'Школа вызова',
            'description': 'Призывает существ и создаёт объекты',
            'features': ['Улучшенное создание', 'Потенциал призыва'],
          },
          {
            'name': 'Школа некромантии',
            'description': 'Мастер смерти и нежити',
            'features': ['Сопротивление некротическому урону', 'Усиленная нежить'],
          },
        ],
        'spellcasting': true,
        'spellcastingInfo': {
          'ability': 'Интеллект',
          'preparation': 'Ежедневная',
          'rituals': 'Да',
          'spellbook': 'Требуется',
        },
        'progression': 'Медленная',
        'startingEquipment': [
          'Посох или кинжал',
          'Компонентная сумка или магический фокус',
          'Книга заклинаний',
          'Набор учёного',
        ],
        'proficiencies': {
          'armor': [],
          'weapons': ['Кинжалы', 'Дротики', 'Пращи', 'Посохи', 'Лёгкие арбалеты'],
          'tools': [],
        },
        'typicalCharacters': [
          'Учёный, изучающий древние тексты',
          'Придворный маг королевства',
          'Искатель запретных знаний',
          'Учитель в магической академии',
        ],
      },
      '3': {
        'id': '3',
        'name': 'Жрец',
        'title': 'Посредник между смертными и божествами',
        'description': 'Жрец - служитель божества, получающий магические силы через молитвы и обеты. '
            'Жрецы исцеляют раненых, защищают невинных и сражаются с силами тьмы.',
        'icon': Icons.emoji_people,
        'color': const Color(0xFFF9A825),
        'role': 'Лидер',
        'powerSource': 'Божественная',
        'primaryAbility': 'Мудрость',
        'secondaryAbilities': ['Телосложение', 'Харизма'],
        'hitDie': 'd8',
        'armor': 'Лёгкие и средние доспехи, щиты',
        'weapons': 'Простое оружие',
        'tools': '',
        'savingThrows': ['Мудрость', 'Харизма'],
        'skills': {
          'choose': 2,
          'from': ['История', 'Медицина', 'Проницательность', 'Религия', 'Убеждение'],
        },
        'features': [
          {
            'level': 1,
            'name': 'Божественный домен',
            'description': 'Вы выбираете домен, связанный с вашим божеством.',
          },
          {
            'level': 2,
            'name': 'Канал божественности',
            'description': 'Вы можете использовать канал божественности для получения особых способностей.',
          },
          {
            'level': 8,
            'name': 'Божественный удар',
            'description': 'Вы добавляете бонус к урону от заклинаний.',
          },
        ],
        'subclasses': [
          {
            'name': 'Домен жизни',
            'description': 'Исцеление и защита',
            'features': ['Усиленное исцеление', 'Предчувствие смерти'],
          },
          {
            'name': 'Домен войны',
            'description': 'Божественный воин',
            'features': ['Божественная ярость', 'Направленный удар'],
          },
          {
            'name': 'Домен знаний',
            'description': 'Мудрость и знания',
            'features': ['Благословение знаний', 'Потенциал знаний'],
          },
        ],
        'spellcasting': true,
        'spellcastingInfo': {
          'ability': 'Мудрость',
          'preparation': 'Ежедневная',
          'rituals': 'Да',
          'spellbook': 'Нет',
        },
        'progression': 'Средняя',
        'startingEquipment': [
          'Щит и священный символ',
          'Булава или боевой молот',
          'Кожаный доспех, посох или любое простое оружие',
          'Набор священника',
        ],
        'proficiencies': {
          'armor': ['Лёгкие доспехи', 'Средние доспехи', 'Щиты'],
          'weapons': ['Простое оружие'],
          'tools': [],
        },
        'typicalCharacters': [
          'Деревенский священник',
          'Инквизитор, охотящийся на еретиков',
          'Миссионер, несущий веру',
          'Оракул, предсказывающий будущее',
        ],
      },
    };

    setState(() {
      _classData = classesData[widget.classId];
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_classData == null) {
      return Scaffold(
        backgroundColor: AppColors.getHomeBackground(context),
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryBrown,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.getHomeBackground(context),
      body: CustomScrollView(
        slivers: [
          // Заголовок экрана
          SliverAppBar(
            backgroundColor: _classData!['color'],
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.pop(),
            ),
            title: Text(
              _classData!['name'],
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
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _classData!['color'],
                      _classData!['color'].withOpacity(0.8),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 50.0, 16.0, 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Иконка класса
                      Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _classData!['icon'],
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _classData!['title'],
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 4.0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Text(
                              _classData!['role'],
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 4.0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Text(
                              _classData!['powerSource'],
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
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
                // Блок с описанием
                _buildDescriptionSection(),

                const SizedBox(height: 16),

                // Основная информация
                _buildBasicInfoSection(),

                const SizedBox(height: 16),

                // Умения класса
                _buildFeaturesSection(),

                const SizedBox(height: 16),

                // Подклассы
                if (_classData!['subclasses'] != null && (_classData!['subclasses'] as List).isNotEmpty)
                  _buildSubclassesSection(),

                const SizedBox(height: 16),

                // Начальное снаряжение
                if (_classData!['startingEquipment'] != null && (_classData!['startingEquipment'] as List).isNotEmpty)
                  _buildEquipmentSection(),

                const SizedBox(height: 16),

                // Типичные персонажи
                if (_classData!['typicalCharacters'] != null && (_classData!['typicalCharacters'] as List).isNotEmpty)
                  _buildCharactersSection(),

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
                  color: _classData!['color'],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _classData!['description'],
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
                  color: _classData!['color'],
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
                  childAspectRatio: 2.5,
                ),
                itemCount: _getBasicInfoItems().length,
                itemBuilder: (context, index) {
                  final item = _getBasicInfoItems()[index];
                  final value = item['value']!;
                  return Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: _classData!['color'].withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: _classData!['color'].withOpacity(0.1),
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
                          value,
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

              // Спасброски
              if (_classData!['savingThrows'] != null && (_classData!['savingThrows'] as List).isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Спасброски:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.darkBrown,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: (_classData!['savingThrows'] as List).map((save) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          decoration: BoxDecoration(
                            color: _classData!['color'].withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: Text(
                            save,
                            style: TextStyle(
                              fontSize: 12,
                              color: _classData!['color'],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),

              const SizedBox(height: 12),

              // Навыки
              if (_classData!['skills'] != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Навыки:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.darkBrown,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Выберите ${_classData!['skills']['choose']} из:',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.darkBrown.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: (_classData!['skills']['from'] as List).map((skill) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          decoration: BoxDecoration(
                            color: _classData!['color'].withOpacity(0.05),
                            borderRadius: BorderRadius.circular(6.0),
                            border: Border.all(
                              color: _classData!['color'].withOpacity(0.1),
                            ),
                          ),
                          child: Text(
                            skill,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.darkBrown,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),

              // Информация о заклинаниях
              if (_classData!['spellcasting'] == true && _classData!['spellcastingInfo'] != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    Divider(
                      color: AppColors.lightBrown.withOpacity(0.3),
                      height: 1,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Заклинания',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _classData!['color'],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: _classData!['color'].withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSpellInfoItem('Характеристика:', _classData!['spellcastingInfo']['ability']),
                          _buildSpellInfoItem('Подготовка:', _classData!['spellcastingInfo']['preparation']),
                          _buildSpellInfoItem('Ритуалы:', _classData!['spellcastingInfo']['rituals']),
                          _buildSpellInfoItem('Книга заклинаний:', _classData!['spellcastingInfo']['spellbook']),
                        ],
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

  List<Map<String, String>> _getBasicInfoItems() {
    return [
      {'title': 'Кость хитов', 'value': _classData!['hitDie']?.toString() ?? ''},
      {'title': 'Основная характеристика', 'value': _classData!['primaryAbility']?.toString() ?? ''},
      {'title': 'Броня', 'value': _classData!['armor']?.toString() ?? ''},
      {'title': 'Оружие', 'value': _classData!['weapons']?.toString() ?? ''},
      if (_classData!['tools'] != null && (_classData!['tools'] as String).isNotEmpty)
        {'title': 'Инструменты', 'value': _classData!['tools']!.toString()},
      if (_classData!['progression'] != null)
        {'title': 'Прогрессия', 'value': _classData!['progression']!.toString()},
    ].where((item) => item['value'] != null && (item['value'] as String).isNotEmpty).toList();
  }

  Widget _buildSpellInfoItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.darkBrown,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.darkBrown.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection() {
    final features = _classData!['features'] as List;

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
                'Умения класса',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _classData!['color'],
                ),
              ),
              const SizedBox(height: 12),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: features.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final feature = features[index];
                  return Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: _classData!['color'].withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: _classData!['color'].withOpacity(0.1),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Уровень
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          decoration: BoxDecoration(
                            color: _classData!['color'].withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: Text(
                            '${feature['level']}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                feature['name'],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.darkBrown,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                feature['description'],
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.darkBrown.withOpacity(0.8),
                                  height: 1.4,
                                ),
                              ),
                            ],
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

  Widget _buildSubclassesSection() {
    final subclasses = _classData!['subclasses'] as List;

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
                'Подклассы',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _classData!['color'],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'На более высоких уровнях вы можете выбрать специализацию:',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.darkBrown.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 12),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: subclasses.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final subclass = subclasses[index];
                  return Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: _classData!['color'].withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: _classData!['color'].withOpacity(0.1),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subclass['name'],
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: _classData!['color'],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subclass['description'],
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.darkBrown.withOpacity(0.8),
                          ),
                        ),
                        if (subclass['features'] != null && (subclass['features'] as List).isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: (subclass['features'] as List).map((feature) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 4.0,
                                ),
                                decoration: BoxDecoration(
                                  color: _classData!['color'].withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                child: Text(
                                  feature,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: _classData!['color'],
                                  ),
                                ),
                              );
                            }).toList(),
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

  Widget _buildEquipmentSection() {
    final equipment = _classData!['startingEquipment'] as List;

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
                'Начальное снаряжение',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _classData!['color'],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Вы начинаете со следующим снаряжением:',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.darkBrown.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 12),
              ...equipment.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color: _classData!['color'].withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check,
                          color: _classData!['color'],
                          size: 12,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '${index + 1}. $item',
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

  Widget _buildCharactersSection() {
    final characters = _classData!['typicalCharacters'] as List;

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
                'Типичные персонажи',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _classData!['color'],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Примеры персонажей этого класса:',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.darkBrown.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: characters.map((character) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 8.0,
                    ),
                    decoration: BoxDecoration(
                      color: _classData!['color'].withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: _classData!['color'].withOpacity(0.1),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.person,
                          color: _classData!['color'],
                          size: 14,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          character,
                          style: TextStyle(
                            fontSize: 13,
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
        ),
      ),
    );
  }
}