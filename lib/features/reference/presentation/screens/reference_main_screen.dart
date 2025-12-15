import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '/core/constants/app_colors.dart';

class ReferenceMainScreen extends ConsumerStatefulWidget {
  const ReferenceMainScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ReferenceMainScreen> createState() => _ReferenceMainScreenState();
}

class _ReferenceMainScreenState extends ConsumerState<ReferenceMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getHomeBackground(context),
      body: CustomScrollView(
        slivers: [
          // Заголовок экрана
          SliverAppBar(
            backgroundColor: AppColors.primaryBrown,
            expandedHeight: 140.0, // Уменьшил высоту
            floating: false,
            pinned: true,
            title: Text(
              'Справочник существ',
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
                    colors: AppColors.loginGradient,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 50.0, 16.0, 12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'База знаний по вселенной',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.parchment,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Расы, классы, существа',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.lightBrown,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Основной контент - ОДИН СТОЛБЕЦ
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildCompactCategoryCard(index),
              childCount: _categories.length,
            ),
          ),

          // Дополнительная информация
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
            sliver: SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: AppColors.parchment.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: AppColors.lightBrown.withOpacity(0.15),
                    width: 0.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppColors.primaryBrown,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Справочная информация',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.darkBrown,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Здесь собраны все расы, классы и существа вселенной.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.darkBrown.withOpacity(0.7),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Данные категорий справочника
  final List<Map<String, dynamic>> _categories = [
    {
      'title': 'Расы',
      'description': 'Народы и происхождения',
      'icon': Icons.people,
      'route': 'races',
      'color': AppColors.infoBlue,
      'count': 15,
    },
    {
      'title': 'Классы',
      'description': 'Профессии и специализации',
      'icon': Icons.emoji_events,
      'route': 'classes',
      'color': AppColors.successGreen,
      'count': 12,
    },
    {
      'title': 'Существа',
      'description': 'Монстры и NPC',
      'icon': Icons.pets,
      'route': 'mobs',
      'color': AppColors.errorRed,
      'count': 245,
    },
    {
      'title': 'Архетипы',
      'description': 'Подклассы и пути',
      'icon': Icons.category,
      'route': '',
      'color': AppColors.warningOrange,
      'count': 36,
    },
    {
      'title': 'Боги и силы',
      'description': 'Божества и пантеоны',
      'icon': Icons.wb_sunny,
      'route': '',
      'color': AppColors.accentGold,
      'count': 20,
    },
    {
      'title': 'Фракции',
      'description': 'Организации и гильдии',
      'icon': Icons.account_balance,
      'route': '',
      'color': AppColors.primaryBrown,
      'count': 8,
    },
  ];

  // Компактная карточка категории для одного столбца
  Widget _buildCompactCategoryCard(int index) {
    final category = _categories[index];
    final isAvailable = category['route'] != null && (category['route'] as String).isNotEmpty;

    return Container(
      height: 70.0, // Фиксированная высота карточки
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: Card(
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(10.0),
          onTap: isAvailable
              ? () {
            switch (category['route']) {
              case 'races':
                context.go('/home/reference/races');
                break;
              case 'classes':
                context.go('/home/reference/classes');
                break;
              case 'mobs':
                context.go('/home/reference/mobs');
                break;
            }
          }
              : null,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  category['color'].withOpacity(0.08),
                  category['color'].withOpacity(0.03),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Row(
                children: [
                  // Иконка категории
                  Container(
                    padding: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      color: category['color'].withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      category['icon'],
                      color: category['color'],
                      size: 18,
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Текстовая информация
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category['title'],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkBrown,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          category['description'],
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.darkBrown.withOpacity(0.6),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // Правая часть - количество и иконка/статус
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6.0,
                          vertical: 2.0,
                        ),
                        decoration: BoxDecoration(
                          color: category['color'].withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        child: Text(
                          '${category['count']}',
                          style: TextStyle(
                            fontSize: 10,
                            color: category['color'],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      if (isAvailable)
                        Icon(
                          Icons.arrow_forward_ios,
                          color: category['color'],
                          size: 12,
                        )
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6.0,
                            vertical: 2.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: Text(
                            'скоро',
                            style: TextStyle(
                              fontSize: 9,
                              color: Colors.grey,
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
    );
  }
}