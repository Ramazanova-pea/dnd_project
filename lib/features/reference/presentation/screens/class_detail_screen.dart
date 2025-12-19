import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '/core/constants/app_colors.dart';
import '/core/providers/reference_providers.dart';
import '/domain/models/reference/class_model.dart';

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
  // Маппинг имен классов на иконки и цвета для UI
  Map<String, dynamic> _getClassStyle(String className) {
    final styles = <String, Map<String, dynamic>>{
      'barbarian': {
        'icon': Icons.fitness_center,
        'color': const Color(0xFF795548),
      },
      'bard': {
        'icon': Icons.music_note,
        'color': const Color(0xFF9C27B0),
      },
      'cleric': {
        'icon': Icons.emoji_people,
        'color': const Color(0xFFF9A825),
      },
      'druid': {
        'icon': Icons.forest,
        'color': const Color(0xFF2E7D32),
      },
      'fighter': {
        'icon': Icons.sports_martial_arts,
        'color': const Color(0xFFC62828),
      },
      'monk': {
        'icon': Icons.sports_kabaddi,
        'color': const Color(0xFFEF6C00),
      },
      'paladin': {
        'icon': Icons.shield,
        'color': const Color(0xFFD32F2F),
      },
      'ranger': {
        'icon': Icons.travel_explore,
        'color': const Color(0xFF689F38),
      },
      'rogue': {
        'icon': Icons.directions_run,
        'color': const Color(0xFF4CAF50),
      },
      'sorcerer': {
        'icon': Icons.flash_on,
        'color': const Color(0xFF0277BD),
      },
      'warlock': {
        'icon': Icons.auto_fix_high,
        'color': const Color(0xFF512DA8),
      },
      'wizard': {
        'icon': Icons.auto_awesome,
        'color': const Color(0xFF1565C0),
      },
    };
    return styles[className.toLowerCase()] ?? {
      'icon': Icons.person,
      'color': AppColors.primaryBrown,
    };
  }

  @override
  Widget build(BuildContext context) {
    final classAsync = ref.watch(classByIdProvider(widget.classId));

    return classAsync.when(
      data: (classModel) {
        final style = _getClassStyle(classModel.index);
        final classColor = style['color'] as Color;
        final classIcon = style['icon'] as IconData;
        return _buildClassDetail(classModel, classColor, classIcon);
      },
      loading: () => Scaffold(
        backgroundColor: AppColors.getHomeBackground(context),
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryBrown,
          ),
        ),
      ),
      error: (error, stack) => Scaffold(
        backgroundColor: AppColors.getHomeBackground(context),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: AppColors.errorRed,
                size: 60,
              ),
              const SizedBox(height: 16),
              Text(
                'Ошибка загрузки класса',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.darkBrown,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.darkBrown.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClassDetail(ClassModel classModel, Color classColor, IconData classIcon) {
    return Scaffold(
      backgroundColor: AppColors.getHomeBackground(context),
      body: CustomScrollView(
        slivers: [
          // Заголовок экрана
          SliverAppBar(
            backgroundColor: classColor,
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.pop(),
            ),
            title: Text(
              classModel.name,
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
                      classColor,
                      classColor.withOpacity(0.8),
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
                          classIcon,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Класс персонажа',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (classModel.hitDie != null) ...[
                        const SizedBox(height: 4),
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
                            'Кость хитов: d${classModel.hitDie}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
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
                _buildDescriptionSection(classModel, classColor),

                const SizedBox(height: 16),

                // Основная информация
                _buildBasicInfoSection(classModel, classColor),

                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(ClassModel classModel, Color classColor) {
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
                  color: classColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Класс ${classModel.name} из D&D 5e',
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

  Widget _buildBasicInfoSection(ClassModel classModel, Color classColor) {
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
                  color: classColor,
                ),
              ),
              const SizedBox(height: 12),
              if (classModel.hitDie != null)
                _buildInfoItem('Кость хитов', 'd${classModel.hitDie}', classColor),
              if (classModel.savingThrows != null && classModel.savingThrows!.isNotEmpty) ...[
                const SizedBox(height: 8),
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
                  children: classModel.savingThrows!.map((save) {
                    final saveName = save['name'] as String? ?? '';
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        color: classColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: Text(
                        saveName,
                        style: TextStyle(
                          fontSize: 12,
                          color: classColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String title, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title: ',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.darkBrown,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.darkBrown.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
