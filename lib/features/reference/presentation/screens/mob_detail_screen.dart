import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '/core/constants/app_colors.dart';

class MobDetailScreen extends ConsumerStatefulWidget {
  final String mobId;

  const MobDetailScreen({
    Key? key,
    required this.mobId,
  }) : super(key: key);

  @override
  ConsumerState<MobDetailScreen> createState() => _MobDetailScreenState();
}

class _MobDetailScreenState extends ConsumerState<MobDetailScreen> {
  Map<String, dynamic>? _mob;

  @override
  void initState() {
    super.initState();
    _loadMobData();
  }

  void _loadMobData() {
    // Mock данные для демонстрации
    final mobsData = {
      '1': {
        'id': '1',
        'name': 'Красный Дракон',
        'title': 'Древний Красный Дракон',
        'description': 'Красные драконы - самые жадные и злобные из всех драконов. '
            'Они собирают огромные сокровища и безжалостно уничтожают любого, '
            'кто осмелится приблизиться к их логову.',
        'icon': Icons.pets,
        'color': AppColors.errorRed,
        'type': 'Дракон',
        'subtype': 'Змей',
        'challenge': '24 (62,000 опыта)',
        'cr': 24,
        'alignment': 'Хаотично-злое',
        'size': 'Огромный',
        'speed': '40 фт., полёт 80 фт.',
        'hp': 546,
        'ac': 22,
        'stats': {
          'str': 30,
          'dex': 10,
          'con': 29,
          'int': 18,
          'wis': 15,
          'cha': 23,
        },
        'savingThrows': 'Лов+7, Тел+16, Муд+9, Хар+13',
        'skills': 'Восприятие +16, Запугивание +13',
        'damageResistances': 'Урон некротической энергией',
        'damageImmunities': 'Огонь',
        'conditionImmunities': 'Оглушение',
        'senses': 'Слепое зрение 60 фт., тёмное зрение 120 фт.',
        'languages': 'Общий, Драконий',
        'actions': [
          {
            'name': 'Мультиатака',
            'description': 'Дракон совершает три атаки: одну своим укусом и две своими когтями.',
          },
          {
            'name': 'Укус',
            'description': 'Ближняя атака оружием: +17 к попаданию, дистанция 15 фт., одна цель. Урон: 21 (2к10 + 10) колющего урона плюс 14 (4к6) урона огнём.',
          },
          {
            'name': 'Дыхание огня',
            'description': 'Дракон выдыхает огонь конусом 90 футов. Каждое существо в этой области должно совершить спасбросок Ловкости Сл 24, получая 91 (26к6) урона огнём при провале или половину этого урона при успехе.',
          },
        ],
        'legendaryActions': [
          {
            'name': 'Обнаружение',
            'description': 'Дракон совершает проверку Мудрости (Восприятие).',
          },
          {
            'name': 'Атака хвостом',
            'description': 'Дракон совершает атаку хвостом.',
          },
          {
            'name': 'Атака крыльями',
            'description': 'Дракон бьёт своими крыльями.',
          },
        ],
        'specialAbilities': [
          {
            'name': 'Легендарное сопротивление (3/день)',
            'description': 'Если дракон проваливает спасбросок, он может вместо этого выбрать успех.',
          },
          {
            'name': 'Магическое оружие',
            'description': 'Атаки дракона считаются магическими.',
          },
          {
            'name': 'Восприимчивость к холоду',
            'description': 'Получает дополнительный урон холодом.',
          },
        ],
        'environment': ['Горы', 'Подземелья', 'Вулканы'],
        'treasure': 'Огромное сокровище, артефакты, магические предметы',
      },
      '2': {
        'id': '2',
        'name': 'Лич',
        'title': 'Древний Лич',
        'description': 'Личи - могущественные волшебники, которые обрели бессмертие через запретные ритуалы некромантии. '
            'Они правят армиями нежити и собирают древние знания.',
        'icon': Icons.auto_awesome,
        'color': const Color(0xFF673AB7),
        'type': 'Нежить',
        'subtype': 'Заклинатель',
        'challenge': '21 (33,000 опыта)',
        'cr': 21,
        'alignment': 'Злое',
        'size': 'Средний',
        'speed': '30 фт.',
        'hp': 135,
        'ac': 17,
        'stats': {
          'str': 11,
          'dex': 16,
          'con': 16,
          'int': 20,
          'wis': 14,
          'cha': 16,
        },
        'savingThrows': 'Тел+10, Муд+9, Хар+9',
        'skills': 'История +12, Магия +17, Религия +12',
        'damageResistances': 'Холод, молния, некротическая энергия',
        'damageImmunities': 'Яд, психологический; дробящий, колющий и рубящий урон от немагического оружия',
        'conditionImmunities': 'Очарование, истощение, испуг, паралич, отравление',
        'senses': 'Истинное зрение 120 фт.',
        'languages': 'Общий плюс до пяти других языков',
        'spellcasting': {
          'level': 'Заклинатель 18 уровня',
          'ability': 'Интеллект',
          'dc': 20,
          'attack': '+12',
          'spells': [
            'Защита от добра и зла',
            'Определение магии',
            'Магическая стрела',
            'Поднять мертвеца',
            'Конус холода',
            'Оживить мертвеца',
            'Управление погодой',
            'Могучее заклинание',
          ],
        },
        'actions': [
          {
            'name': 'Парализующее прикосновение',
            'description': 'Ближняя атака заклинанием: +12 к попаданию, дистанция 5 фт., одно существо. Цель должна совершить спасбросок Телосложения Сл 18 или быть парализованной на 1 минуту.',
          },
        ],
        'legendaryActions': [
          {
            'name': 'Заклинание',
            'description': 'Лич произносит заклинание затратой 1-3 пунктов заклинаний.',
          },
          {
            'name': 'Парализующий взгляд',
            'description': 'Лич направляет свой взгляд на одно существо, которое он может видеть в пределах 10 футов от себя.',
          },
        ],
        'specialAbilities': [
          {
            'name': 'Перевоплощение',
            'description': 'Если у лича есть филактерия, он возрождается через 1к10 дней возле неё.',
          },
          {
            'name': 'Устойчивость к магии',
            'description': 'Лич совершает с преимуществом спасброски против заклинаний и других магических эффектов.',
          },
          {
            'name': 'Повелитель нежити',
            'description': 'Любая нежить в пределах 120 футов от лича совершает с преимуществом спасброски Мудрости.',
          },
        ],
        'environment': ['Подземелья', 'Гробницы', 'Древние руины'],
        'treasure': 'Филактерия, древние гримуары, магические компоненты',
      },
      '3': {
        'id': '3',
        'name': 'Гоблин',
        'title': 'Гоблин-воин',
        'description': 'Гоблины - маленькие, хитрые гуманоиды, живущие в пещерах и развалинах. '
            'Они охотятся стаями и используют ловушки и численное преимущество.',
        'icon': Icons.person,
        'color': AppColors.successGreen,
        'type': 'Гуманоид',
        'subtype': 'Гоблиноид',
        'challenge': '1/4 (50 опыта)',
        'cr': 0.25,
        'alignment': 'Злое',
        'size': 'Маленький',
        'speed': '30 фт.',
        'hp': 7,
        'ac': 13,
        'stats': {
          'str': 8,
          'dex': 14,
          'con': 10,
          'int': 10,
          'wis': 8,
          'cha': 8,
        },
        'savingThrows': '',
        'skills': 'Скрытность +6',
        'damageResistances': '',
        'damageImmunities': '',
        'conditionImmunities': '',
        'senses': 'Тёмное зрение 60 фт.',
        'languages': 'Общий, Гоблинский',
        'actions': [
          {
            'name': 'Скимитар',
            'description': 'Ближняя атака оружием: +4 к попаданию, дистанция 5 фт., одна цель. Урон: 5 (1к6 + 2) рубящего урона.',
          },
          {
            'name': 'Короткий лук',
            'description': 'Дальнобойная атака оружием: +4 к попаданию, дистанция 80/320 фт., одна цель. Урон: 5 (1к6 + 2) колющего урона.',
          },
        ],
        'specialAbilities': [
          {
            'name': 'Подлый удар',
            'description': 'Раз в ход гоблин может нанести дополнительно 7 (2к6) урона существу, если попадает по нему атакой оружием и имеет преимущество на бросок атаки, или если другой враг существа находится в пределах 5 футов от него, и он не имеет помехи на бросок атаки.',
          },
          {
            'name': 'Нимбродвигание',
            'description': 'Гоблин может предпринять Отход или Уклонение бонусным действием.',
          },
        ],
        'environment': ['Пещеры', 'Подземелья', 'Леса'],
        'treasure': 'Медные монеты, простые драгоценности',
      },
    };

    setState(() {
      _mob = mobsData[widget.mobId];
    });
  }

  // Получение цвета сложности
  Color _getChallengeColor(double cr) {
    if (cr <= 4) return AppColors.successGreen;
    if (cr <= 10) return AppColors.warningOrange;
    return AppColors.errorRed;
  }

  @override
  Widget build(BuildContext context) {
    if (_mob == null) {
      return Scaffold(
        backgroundColor: AppColors.getHomeBackground(context),
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryBrown,
          ),
        ),
      );
    }

    final challengeColor = _getChallengeColor(_mob!['cr'] ?? 0);

    return Scaffold(
      backgroundColor: AppColors.getHomeBackground(context),
      body: CustomScrollView(
        slivers: [
          // Заголовок экрана
          SliverAppBar(
            backgroundColor: _mob!['color'],
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.pop(),
            ),
            title: Text(
              _mob!['name'],
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
                      _mob!['color'],
                      _mob!['color'].withOpacity(0.8),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 50.0, 16.0, 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Иконка существа и сложность
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _mob!['icon'],
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
                              color: challengeColor.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              'CR ${_mob!['cr']}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _mob!['title'],
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
                // Блок с основной информацией
                _buildInfoSection(),

                const SizedBox(height: 16),

                // Характеристики
                _buildStatsSection(),

                const SizedBox(height: 16),

                // Особые способности
                if (_mob!['specialAbilities'] != null && (_mob!['specialAbilities'] as List).isNotEmpty)
                  _buildAbilitiesSection('Особые способности', _mob!['specialAbilities']),

                const SizedBox(height: 16),

                // Действия
                if (_mob!['actions'] != null && (_mob!['actions'] as List).isNotEmpty)
                  _buildAbilitiesSection('Действия', _mob!['actions']),

                const SizedBox(height: 16),

                // Легендарные действия
                if (_mob!['legendaryActions'] != null && (_mob!['legendaryActions'] as List).isNotEmpty)
                  _buildAbilitiesSection('Легендарные действия', _mob!['legendaryActions']),

                const SizedBox(height: 16),

                // Заклинания (если есть)
                if (_mob!['spellcasting'] != null)
                  _buildSpellcastingSection(),

                const SizedBox(height: 16),

                // Дополнительная информация
                _buildAdditionalInfoSection(),

                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
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
                  color: _mob!['color'],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _mob!['description'],
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
                  _buildInfoItem('Тип', '${_mob!['type']} (${_mob!['subtype']})', Icons.category),
                  _buildInfoItem('Мировоззрение', _mob!['alignment'], Icons.psychology),
                  _buildInfoItem('Размер', _mob!['size'], Icons.height),
                  _buildInfoItem('Скорость', _mob!['speed'], Icons.directions_run),
                  _buildInfoItem('Очки жизни', '${_mob!['hp']}', Icons.favorite),
                  _buildInfoItem('Класс брони', '${_mob!['ac']}', Icons.shield),
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
      width: 110,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: _mob!['color'].withOpacity(0.05),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: _mob!['color'].withOpacity(0.1),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: _mob!['color'],
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
              fontSize: 12,
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
    final stats = _mob!['stats'] as Map<String, dynamic>;
    final statNames = {'str': 'СИЛ', 'dex': 'ЛОВ', 'con': 'ТЕЛ', 'int': 'ИНТ', 'wis': 'МДР', 'cha': 'ХАР'};

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
                  color: _mob!['color'],
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
                      color: _mob!['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: _mob!['color'].withOpacity(0.2),
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
                            color: _mob!['color'],
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
              const SizedBox(height: 12),
              // Дополнительная статистика
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  if (_mob!['savingThrows'] != null && _mob!['savingThrows'].isNotEmpty)
                    _buildStatItem('Спасброски', _mob!['savingThrows']),
                  if (_mob!['skills'] != null && _mob!['skills'].isNotEmpty)
                    _buildStatItem('Навыки', _mob!['skills']),
                  if (_mob!['damageResistances'] != null && _mob!['damageResistances'].isNotEmpty)
                    _buildStatItem('Сопротивления', _mob!['damageResistances']),
                  if (_mob!['damageImmunities'] != null && _mob!['damageImmunities'].isNotEmpty)
                    _buildStatItem('Иммунитеты', _mob!['damageImmunities']),
                  if (_mob!['conditionImmunities'] != null && _mob!['conditionImmunities'].isNotEmpty)
                    _buildStatItem('Им. к состояниям', _mob!['conditionImmunities']),
                  if (_mob!['senses'] != null && _mob!['senses'].isNotEmpty)
                    _buildStatItem('Чувства', _mob!['senses']),
                  if (_mob!['languages'] != null && _mob!['languages'].isNotEmpty)
                    _buildStatItem('Языки', _mob!['languages']),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: _mob!['color'].withOpacity(0.05),
        borderRadius: BorderRadius.circular(6.0),
        border: Border.all(
          color: _mob!['color'].withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              color: AppColors.darkBrown.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.darkBrown,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAbilitiesSection(String title, List<dynamic> abilities) {
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
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _mob!['color'],
                ),
              ),
              const SizedBox(height: 12),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: abilities.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final ability = abilities[index];
                  return Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: _mob!['color'].withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: _mob!['color'].withOpacity(0.1),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ability['name'],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _mob!['color'],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          ability['description'],
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

  Widget _buildSpellcastingSection() {
    final spellcasting = _mob!['spellcasting'] as Map<String, dynamic>;

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
                'Заклинания',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _mob!['color'],
                ),
              ),
              const SizedBox(height: 12),
              // Основная информация о заклинаниях
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: _mob!['color'].withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Уровень: ${spellcasting['level']}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.darkBrown,
                          ),
                        ),
                        Text(
                          'Характеристика: ${spellcasting['ability']}',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.darkBrown.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Сл спасброска: ${spellcasting['dc']}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.darkBrown,
                          ),
                        ),
                        Text(
                          'Бонус атаки: ${spellcasting['attack']}',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.darkBrown.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Список заклинаний
              if (spellcasting['spells'] != null && (spellcasting['spells'] as List).isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Известные заклинания:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.darkBrown,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: (spellcasting['spells'] as List).map((spell) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          decoration: BoxDecoration(
                            color: _mob!['color'].withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: Text(
                            spell,
                            style: TextStyle(
                              fontSize: 12,
                              color: _mob!['color'],
                            ),
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

  Widget _buildAdditionalInfoSection() {
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
                'Дополнительная информация',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _mob!['color'],
                ),
              ),
              const SizedBox(height: 12),

              // Среда обитания
              if (_mob!['environment'] != null && (_mob!['environment'] as List).isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: _mob!['color'],
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Среда обитания:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.darkBrown,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: (_mob!['environment'] as List).map((env) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          decoration: BoxDecoration(
                            color: _mob!['color'].withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: Text(
                            env,
                            style: TextStyle(
                              fontSize: 12,
                              color: _mob!['color'],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),

              // Сокровища
              if (_mob!['treasure'] != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.attach_money,
                          color: _mob!['color'],
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Сокровища:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.darkBrown,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _mob!['treasure'],
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.darkBrown.withOpacity(0.8),
                        height: 1.4,
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