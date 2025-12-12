// lib/features/characters/presentation/screens/character_detail_screen.dart
import 'package:flutter/material.dart';
import '/core/constants/app_colors.dart';


class CharacterDetailScreen extends StatelessWidget {
  final String characterId;

  CharacterDetailScreen({
    super.key,
    required this.characterId,
  });

  // Тестовые данные персонажа
  final Map<String, dynamic> _characterData = {
    'id': '1',
    'name': 'Арвен Веледа',
    'playerName': 'Алексей',
    'race': 'Лесной эльф',
    'class': 'Рейнджер',
    'level': 5,
    'campaign': 'Проклятие Страда',
    'backstory': 'Дочь лесного эльфа, поклявшаяся защищать природу от сил тьмы. '
        'С детства обучалась стрельбе из лука и выживанию в дикой природе.',
    'avatarColor': Colors.green,
    'createdAt': '2024-01-15',
    'lastPlayed': '2024-02-15',
    'stats': {
      'Сила': 12,
      'Ловкость': 18,
      'Телосложение': 14,
      'Интеллект': 16,
      'Мудрость': 15,
      'Харизма': 13,
    },
    'equipment': [
      'Длинный лук',
      '20 стрел',
      'Кинжал',
      'Кожаный доспех',
      'Рюкзак с припасами',
      'Компас',
    ],
    'spells': [
      'Обнаружение магии',
      'Опутывание',
      'Общение с животными',
      'Паутина',
    ],
    'skills': [
      'Скрытность +7',
      'Восприятие +6',
      'Выживание +5',
      'Природа +4',
    ],
    'hp': {
      'current': 38,
      'max': 42,
    },
    'armorClass': 16,
    'proficiencyBonus': '+3',
  };


  Widget _buildSection(String title, List<String> items) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white.withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.darkBrown,
              ),
            ),
            const SizedBox(height: 8),
            ...items.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  const Icon(Icons.circle, size: 8, color: AppColors.primaryBrown),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.woodBrown,
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildHpBar() {
    final currentHp = _characterData['hp']['current'] as int;
    final maxHp = _characterData['hp']['max'] as int;
    final percentage = currentHp / maxHp;

    Color getHpColor() {
      if (percentage > 0.5) return Colors.green;
      if (percentage > 0.25) return Colors.orange;
      return Colors.red;
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white.withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Здоровье',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.darkBrown,
              ),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: percentage,
              backgroundColor: Colors.grey[200],
              color: getHpColor(),
              borderRadius: BorderRadius.circular(4),
              minHeight: 20,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$currentHp / $maxHp HP',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBrown,
                  ),
                ),
                Text(
                  '${(percentage * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 16,
                    color: getHpColor(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final avatarColor = _characterData['avatarColor'] as Color;

    return Scaffold(
      backgroundColor: AppColors.parchment.withOpacity(0.97),
      appBar: AppBar(
        backgroundColor: AppColors.parchment,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.darkBrown),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _characterData['name'] as String,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.darkBrown,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded, color: AppColors.darkBrown),
            onPressed: () {
              // В реальном приложении: переход на экран редактирования
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                    appBar: AppBar(title: const Text('Редактирование')),
                    body: const Center(child: Text('Экран редактирования')),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Аватар и основная информация
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.white.withOpacity(0.9),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: avatarColor.withOpacity(0.2),
                      foregroundColor: avatarColor,
                      child: Text(
                        (_characterData['name'] as String)[0],
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _characterData['name'] as String,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkBrown,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_characterData['race']} • ${_characterData['class']}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.woodBrown,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.accentGold.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.accentGold),
                      ),
                      child: Text(
                        'Уровень ${_characterData['level']}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.accentGold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Кампания: ${_characterData['campaign']}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.woodBrown,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Игрок: ${_characterData['playerName']}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.woodBrown,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Полоска здоровья
            _buildHpBar(),


            const SizedBox(height: 20),

            // Характеристики
            Card(
              elevation: 1,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.white.withOpacity(0.8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Характеристики',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkBrown,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: (_characterData['stats'] as Map<String, dynamic>)
                          .entries
                          .map((entry) {
                        final value = entry.value as int;
                        final modifier = ((value - 10) / 2).floor();
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryBrown.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.primaryBrown.withOpacity(0.3)),
                          ),
                          child: Column(
                            children: [
                              Text(
                                entry.key,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.woodBrown,
                                ),
                              ),
                              Text(
                                value.toString(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryBrown,
                                ),
                              ),
                              Text(
                                modifier >= 0 ? '+$modifier' : '$modifier',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: modifier >= 0 ? Colors.green : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        );
                      })
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),

            // Навыки
            _buildSection('Навыки', _characterData['skills'] as List<String>),

            // Снаряжение
            _buildSection('Снаряжение', _characterData['equipment'] as List<String>),

            // Заклинания
            _buildSection('Заклинания', _characterData['spells'] as List<String>),

            // Предыстория
            Card(
              elevation: 1,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.white.withOpacity(0.8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Предыстория',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkBrown,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _characterData['backstory'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.woodBrown,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Кнопки действий
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Бросок кубика
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Бросок кубика...'),
                          backgroundColor: AppColors.accentGold,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBrown,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.casino_rounded),
                    label: const Text('Бросить кубик'),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Поделиться
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Результат скопирован'),
                        backgroundColor: AppColors.infoBlue,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.infoBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.share_rounded),
                  label: const Text(''),
                ),
              ],
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}