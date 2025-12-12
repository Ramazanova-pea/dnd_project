import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dnd_project/core/constants/app_colors.dart';

class DiceResultScreen extends StatefulWidget {
  final Map<String, dynamic>? diceResult;

  const DiceResultScreen({
    super.key,
    required this.diceResult,
  });

  @override
  State<DiceResultScreen> createState() => _DiceResultScreenState();
}

class _DiceResultScreenState extends State<DiceResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  bool _showDetails = false;
  final List<Map<String, dynamic>> _criticalMessages = [
    {'min': 1, 'max': 1, 'message': 'Критический провал!', 'color': AppColors.errorRed},
    {'min': 20, 'max': 20, 'message': 'Критический успех!', 'color': AppColors.successGreen},
    {'min': 18, 'max': 19, 'message': 'Отличный бросок!', 'color': AppColors.successGreen.withOpacity(0.8)},
    {'min': 15, 'max': 17, 'message': 'Хороший результат', 'color': AppColors.infoBlue},
    {'min': 10, 'max': 14, 'message': 'Средне', 'color': AppColors.accentGold},
    {'min': 5, 'max': 9, 'message': 'Могло быть лучше', 'color': AppColors.warningOrange},
    {'min': 2, 'max': 4, 'message': 'Плохой бросок', 'color': AppColors.errorRed.withOpacity(0.7)},
  ];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.1, end: 1.2),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0),
        weight: 50,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String _getCriticalMessage(int result) {
    for (final msg in _criticalMessages) {
      if (result >= msg['min'] && result <= msg['max']) {
        return msg['message'] as String;
      }
    }
    return 'Стандартный бросок';
  }

  Color _getCriticalColor(int result) {
    for (final msg in _criticalMessages) {
      if (result >= msg['min'] && result <= msg['max']) {
        return msg['color'] as Color;
      }
    }
    return AppColors.primaryBrown;
  }

  void _rollAgain() {
    context.pop();
  }

  void _shareResult() {
    // TODO: Поделиться результатом
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Результат скопирован'),
        backgroundColor: AppColors.primaryBrown,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _saveToHistory() {
    // TODO: Сохранить в историю
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Бросок сохранен в историю'),
        backgroundColor: AppColors.successGreen,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final result = widget.diceResult;
    if (result == null) {
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
            'Результат броска',
            style: GoogleFonts.cinzel(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.darkBrown,
            ),
          ),
        ),
        body: Center(
          child: Text(
            'Нет данных о броске',
            style: GoogleFonts.cinzel(
              fontSize: 18,
              color: AppColors.darkBrown,
            ),
          ),
        ),
      );
    }

    final formula = result['formula'] as String;
    final total = result['result'] as int;
    final individual = (result['individual'] as List<dynamic>).cast<int>();
    final modifier = result['modifier'] as int;
    final diceType = result['type'] as String;

    final criticalMessage = _getCriticalMessage(total);
    final criticalColor = _getCriticalColor(total);

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
          'Результат броска',
          style: GoogleFonts.cinzel(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.darkBrown,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share_rounded, color: AppColors.darkBrown),
            onPressed: _shareResult,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Основной результат с анимацией
              ScaleTransition(
                scale: _scaleAnimation,
                child: FadeTransition(
                  opacity: _opacityAnimation,
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    color: AppColors.parchment.withOpacity(0.9),
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Text(
                            formula,
                            style: GoogleFonts.cinzel(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: AppColors.darkBrown,
                            ),
                          ),

                          const SizedBox(height: 20),

                          Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              color: criticalColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(80),
                              border: Border.all(
                                color: criticalColor.withOpacity(0.3),
                                width: 4,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: criticalColor.withOpacity(0.2),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                total.toString(),
                                style: GoogleFonts.cinzel(
                                  fontSize: 64,
                                  fontWeight: FontWeight.w800,
                                  color: criticalColor,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          Text(
                            criticalMessage,
                            style: GoogleFonts.cinzel(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: criticalColor,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            '${DateTime.now().formatTime()}',
                            style: GoogleFonts.cinzel(
                              fontSize: 14,
                              color: AppColors.woodBrown,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Детали броска
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Детали броска',
                            style: GoogleFonts.cinzel(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: AppColors.darkBrown,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              _showDetails
                                  ? Icons.expand_less_rounded
                                  : Icons.expand_more_rounded,
                              color: AppColors.darkBrown,
                            ),
                            onPressed: () {
                              setState(() {
                                _showDetails = !_showDetails;
                              });
                            },
                          ),
                        ],
                      ),

                      if (_showDetails) ...[
                        const SizedBox(height: 16),

                        // Индивидуальные броски
                        if (individual.length > 1) ...[
                          Text(
                            'Индивидуальные броски:',
                            style: GoogleFonts.cinzel(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.darkBrown,
                            ),
                          ),

                          const SizedBox(height: 12),

                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: individual.asMap().entries.map((entry) {
                              final index = entry.key;
                              final value = entry.value;
                              return Chip(
                                label: Text(
                                  '${index + 1}: $value',
                                  style: GoogleFonts.cinzel(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.darkBrown,
                                  ),
                                ),
                                backgroundColor: AppColors.primaryBrown.withOpacity(0.1),
                                side: BorderSide(
                                  color: AppColors.primaryBrown.withOpacity(0.3),
                                ),
                              );
                            }).toList(),
                          ),

                          const SizedBox(height: 16),
                        ],

                        // Модификатор
                        if (modifier != 0) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Броски: ${individual.join(' + ')}',
                                style: GoogleFonts.cinzel(
                                  fontSize: 16,
                                  color: AppColors.woodBrown,
                                ),
                              ),

                              Text(
                                ' ${modifier > 0 ? '+' : ''}$modifier',
                                style: GoogleFonts.cinzel(
                                  fontSize: 16,
                                  color: AppColors.accentGold,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              Text(
                                ' = $total',
                                style: GoogleFonts.cinzel(
                                  fontSize: 16,
                                  color: AppColors.primaryBrown,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ] else if (individual.length > 1) ...[
                          Text(
                            '${individual.join(' + ')} = $total',
                            style: GoogleFonts.cinzel(
                              fontSize: 16,
                              color: AppColors.woodBrown,
                            ),
                          ),
                        ],

                        const SizedBox(height: 16),

                        // Тип кубика
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.casino_rounded,
                              color: AppColors.primaryBrown,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Тип: $diceType',
                              style: GoogleFonts.cinzel(
                                fontSize: 16,
                                color: AppColors.woodBrown,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Кнопки действий
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _rollAgain,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBrown,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.casino_rounded, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Бросить снова',
                            style: GoogleFonts.cinzel(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  ElevatedButton(
                    onPressed: _saveToHistory,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.successGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: Icon(Icons.bookmark_rounded, size: 24),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Статистика
              Card(
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
                      Text(
                        'Интересные факты:',
                        style: GoogleFonts.cinzel(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkBrown,
                        ),
                      ),

                      const SizedBox(height: 12),

                      _buildStatFact(
                        'Средний бросок d20',
                        '10.5',
                        Icons.trending_up_rounded,
                        AppColors.infoBlue,
                      ),

                      _buildStatFact(
                        'Шанс критического успеха',
                        '5%',
                        Icons.star_rounded,
                        AppColors.accentGold,
                      ),

                      _buildStatFact(
                        'Шанс провала',
                        '5%',
                        Icons.warning_rounded,
                        AppColors.errorRed,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatFact(String title, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: color.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Icon(icon, color: color, size: 20),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.cinzel(
                    fontSize: 14,
                    color: AppColors.darkBrown,
                  ),
                ),

                Text(
                  value,
                  style: GoogleFonts.cinzel(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Расширение для форматирования времени
extension DateTimeExtension on DateTime {
  String formatTime() {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
}