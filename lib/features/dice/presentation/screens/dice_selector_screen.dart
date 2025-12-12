import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dnd_project/core/constants/app_colors.dart';

class DiceSelectorScreen extends StatefulWidget {
  const DiceSelectorScreen({super.key});

  @override
  State<DiceSelectorScreen> createState() => _DiceSelectorScreenState();
}

class _DiceSelectorScreenState extends State<DiceSelectorScreen> {
  final List<Map<String, dynamic>> _diceTypes = [
    {'type': 'd4', 'sides': 4, 'icon': Icons.looks_4_rounded, 'color': AppColors.primaryBrown},
    {'type': 'd6', 'sides': 6, 'icon': Icons.casino_rounded, 'color': AppColors.accentGold},
    {'type': 'd8', 'sides': 8, 'icon': Icons.exposure_plus_1, 'color': AppColors.infoBlue},
    {'type': 'd10', 'sides': 10, 'icon': Icons.exposure_plus_2, 'color': AppColors.successGreen},
    {'type': 'd12', 'sides': 12, 'icon': Icons.hexagon_rounded, 'color': AppColors.warningOrange},
    {'type': 'd20', 'sides': 20, 'icon': Icons.auto_awesome_rounded, 'color': AppColors.errorRed},
    {'type': 'd100', 'sides': 100, 'icon': Icons.all_inclusive_rounded, 'color': AppColors.darkBrown},
  ];

  int _selectedDiceCount = 1;
  int _selectedModifier = 0;
  String? _selectedDiceType;
  final List<Map<String, dynamic>> _recentRolls = [];
  final List<Map<String, dynamic>> _favoriteRolls = [
    {'name': 'Атака мечом', 'formula': '1d20+5', 'color': AppColors.primaryBrown},
    {'name': 'Урон огнем', 'formula': '2d6+3', 'color': AppColors.accentGold},
    {'name': 'Спасбросок', 'formula': '1d20+2', 'color': AppColors.infoBlue},
    {'name': 'Инициатива', 'formula': '1d20+1', 'color': AppColors.successGreen},
  ];

  void _rollDice() {
    if (_selectedDiceType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Выберите тип кубика'),
          backgroundColor: AppColors.primaryBrown,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final dice = _diceTypes.firstWhere((d) => d['type'] == _selectedDiceType);
    final sides = dice['sides'] as int;

    // Генерируем случайные броски
    final individualRolls = List.generate(
        _selectedDiceCount,
            (index) => math.Random().nextInt(sides) + 1
    );

    // Считаем сумму бросков
    final sum = individualRolls.fold(0, (prev, element) => prev + element);
    final total = sum + _selectedModifier;

    final result = {
      'formula': '${_selectedDiceCount}d$sides${_selectedModifier > 0 ? '+$_selectedModifier' : _selectedModifier < 0 ? '$_selectedModifier' : ''}',
      'result': total,
      'individual': individualRolls,
      'modifier': _selectedModifier,
      'timestamp': DateTime.now(),
      'type': _selectedDiceType,
    };

    setState(() {
      _recentRolls.insert(0, result);
      if (_recentRolls.length > 5) _recentRolls.removeLast();
    });

    // Переход на экран результата
    context.go('/home/dice/result', extra: result);
  }

  void _rollWithFormula(String formula) {
    // Парсинг формулы (простая реализация)
    final parts = formula.split('d');
    final count = int.tryParse(parts[0]) ?? 1;
    final sides = int.tryParse(parts[1]) ?? 20;

    setState(() {
      _selectedDiceCount = count;
      _selectedDiceType = 'd$sides';
    });

    _rollDice();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.parchment.withOpacity(0.97),
      appBar: AppBar(
        backgroundColor: AppColors.parchment,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: AppColors.darkBrown),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Бросок кубика',
          style: GoogleFonts.cinzel(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.darkBrown,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.history_rounded, color: AppColors.darkBrown),
            onPressed: () {
              // TODO: История бросков
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Основной селектор кубиков
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: AppColors.parchment.withOpacity(0.9),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        'Выберите кубик',
                        style: GoogleFonts.cinzel(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkBrown,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Выбор типа кубика
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: _diceTypes.map((dice) {
                          final isSelected = _selectedDiceType == dice['type'];
                          return ChoiceChip(
                            label: Text(
                              dice['type'],
                              style: GoogleFonts.cinzel(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? Colors.white : dice['color'] as Color,
                              ),
                            ),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                _selectedDiceType = selected ? dice['type'] as String : null;
                              });
                            },
                            backgroundColor: AppColors.parchment,
                            selectedColor: dice['color'] as Color,
                            side: BorderSide(
                              color: (dice['color'] as Color).withOpacity(0.3),
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            avatar: Icon(
                              dice['icon'] as IconData,
                              color: isSelected ? Colors.white : dice['color'] as Color,
                              size: 20,
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 24),

                      // Количество кубиков
                      Text(
                        'Количество: $_selectedDiceCount',
                        style: GoogleFonts.cinzel(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkBrown,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Slider(
                        value: _selectedDiceCount.toDouble(),
                        min: 1,
                        max: 10,
                        divisions: 9,
                        onChanged: (value) {
                          setState(() {
                            _selectedDiceCount = value.toInt();
                          });
                        },
                        activeColor: AppColors.primaryBrown,
                        inactiveColor: AppColors.lightBrown,
                      ),

                      const SizedBox(height: 24),

                      // Модификатор
                      Text(
                        'Модификатор: ${_selectedModifier >= 0 ? '+' : ''}$_selectedModifier',
                        style: GoogleFonts.cinzel(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkBrown,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove_rounded, color: AppColors.darkBrown),
                            onPressed: () {
                              setState(() {
                                _selectedModifier--;
                              });
                            },
                          ),

                          Expanded(
                            child: Slider(
                              value: _selectedModifier.toDouble(),
                              min: -10,
                              max: 10,
                              divisions: 20,
                              onChanged: (value) {
                                setState(() {
                                  _selectedModifier = value.toInt();
                                });
                              },
                              activeColor: AppColors.accentGold,
                              inactiveColor: AppColors.lightBrown,
                            ),
                          ),

                          IconButton(
                            icon: Icon(Icons.add_rounded, color: AppColors.darkBrown),
                            onPressed: () {
                              setState(() {
                                _selectedModifier++;
                              });
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // Кнопка броска
                      ElevatedButton(
                        onPressed: _rollDice,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBrown,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.casino_rounded, size: 28),
                            const SizedBox(width: 12),
                            Text(
                              'Бросить кубик',
                              style: GoogleFonts.cinzel(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Быстрые броски
              if (_favoriteRolls.isNotEmpty) ...[
                _buildFavoriteRolls(),
                const SizedBox(height: 24),
              ],

              // Недавние броски
              if (_recentRolls.isNotEmpty) ...[
                _buildRecentRolls(),
                const SizedBox(height: 24),
              ],

              // Информация
              _buildInfoCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteRolls() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Быстрые броски',
          style: GoogleFonts.cinzel(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.darkBrown,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120, // Немного увеличиваем высоту для запаса
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: _favoriteRolls.length,
            itemBuilder: (context, index) {
              final roll = _favoriteRolls[index];
              return Container(
                width: 140,
                margin: EdgeInsets.only(
                  left: index == 0 ? 8 : 0,
                  right: 12,
                ),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: AppColors.parchment.withOpacity(0.9),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => _rollWithFormula(roll['formula'] as String),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min, // важно!
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: (roll['color'] as Color).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: (roll['color'] as Color).withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Icon(
                              Icons.star_rounded,
                              color: roll['color'] as Color,
                              size: 20,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            roll['name'] as String,
                            style: GoogleFonts.cinzel(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.darkBrown,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            roll['formula'] as String,
                            style: GoogleFonts.cinzel(
                              fontSize: 12,
                              color: AppColors.woodBrown,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecentRolls() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Недавние броски',
          style: GoogleFonts.cinzel(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.darkBrown,
          ),
        ),

        const SizedBox(height: 12),

        ..._recentRolls.take(3).map((roll) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: AppColors.parchment.withOpacity(0.8),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primaryBrown.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.casino_rounded,
                  color: AppColors.primaryBrown,
                ),
              ),
              title: Text(
                roll['formula'] as String,
                style: GoogleFonts.cinzel(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkBrown,
                ),
              ),
              subtitle: Text(
                'Результат: ${roll['result']}',
                style: GoogleFonts.cinzel(
                  fontSize: 14,
                  color: AppColors.woodBrown,
                ),
              ),
              trailing: TextButton(
                onPressed: () => context.go('/home/dice/result', extra: roll),
                child: Text(
                  'Повторить',
                  style: GoogleFonts.cinzel(
                    fontSize: 12,
                    color: AppColors.primaryBrown,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: AppColors.parchment.withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_rounded,
                  color: AppColors.infoBlue,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'О кубиках D&D',
                  style: GoogleFonts.cinzel(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkBrown,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Text(
              '• d4 - четырёхгранный (пирамида)\n'
                  '• d6 - шестигранный (стандартный)\n'
                  '• d8 - восьмигранный\n'
                  '• d10 - десятигранный\n'
                  '• d12 - двенадцатигранный\n'
                  '• d20 - двадцатигранный\n'
                  '• d100 - сотенный (обычно 2d10)',
              style: GoogleFonts.cinzel(
                fontSize: 14,
                color: AppColors.woodBrown,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

