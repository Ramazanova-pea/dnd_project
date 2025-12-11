import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dnd_project/core/constants/app_colors.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  // Данные для карточек
  final List<Map<String, dynamic>> _recentCharacters = [
    {
      'name': 'Элрион Гринлиф',
      'class': 'Рейнджер',
      'level': 5,
      'race': 'Эльф',
      'color': AppColors.successGreen,
    },
    {
      'name': 'Торгрим Камнемолот',
      'class': 'Воин',
      'level': 7,
      'race': 'Дварф',
      'color': AppColors.primaryBrown,
    },
    {
      'name': 'Зораб',
      'class': 'Волшебник',
      'level': 4,
      'race': 'Человек',
      'color': AppColors.infoBlue,
    },
  ];

  final List<Map<String, dynamic>> _recentCampaigns = [
    {
      'name': 'Потерянный храм',
      'dm': 'Алексей',
      'sessions': 8,
      'nextSession': 'Завтра, 20:00',
    },
    {
      'name': 'Трон дракона',
      'dm': 'Мария',
      'sessions': 12,
      'nextSession': 'Чт, 19:30',
    },
  ];

  final List<Map<String, dynamic>> _quickActions = [
    {
      'icon': Icons.person_add_rounded,
      'title': 'Создать персонажа',
      'color': AppColors.primaryBrown,
      'route': '/home/characters/create',
    },
    {
      'icon': Icons.casino_rounded,
      'title': 'Бросок кубика',
      'color': AppColors.accentGold,
      'route': '/home/dice',
    },
    {
      'icon': Icons.group_add_rounded,
      'title': 'Создать кампанию',
      'color': AppColors.woodBrown,
      'route': '/home/campaigns/create',
    },
    {
      'icon': Icons.menu_book_rounded,
      'title': 'Справочник',
      'color': AppColors.darkBrown,
      'route': '/home/reference',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.parchment.withOpacity(0.9),
            AppColors.parchment.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.woodBrown.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: AppColors.lightBrown.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.wb_sunny_rounded,
                  color: AppColors.accentGold,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  'Добро пожаловать, искатель приключений!',
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
              'Готовы к новым подвигам? Проверьте своих персонажей, '
                  'планируйте сессии и изучайте древние манускрипты.',
              style: GoogleFonts.cinzel(
                fontSize: 14,
                color: AppColors.woodBrown,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/home/campaigns'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBrown,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.explore_rounded, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Начать приключение',
                    style: GoogleFonts.cinzel(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Быстрые действия',
              style: GoogleFonts.cinzel(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.darkBrown,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.parchment.withOpacity(0.6),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.lightBrown.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _quickActions.map((action) {
                return Expanded(
                  child: GestureDetector(
                    onTap: () => context.go(action['route'] as String),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          margin: const EdgeInsets.only(bottom: 6),
                          decoration: BoxDecoration(
                            color: (action['color'] as Color).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: (action['color'] as Color).withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            action['icon'] as IconData,
                            color: action['color'] as Color,
                            size: 22,
                          ),
                        ),
                        Text(
                          action['title'] as String,
                          style: GoogleFonts.cinzel(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkBrown,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentCharacters() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Недавние персонажи',
                  style: GoogleFonts.cinzel(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkBrown,
                  ),
                ),
                TextButton(
                  onPressed: () => context.go('/home/characters'),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                  ),
                  child: Text(
                    'Все',
                    style: GoogleFonts.cinzel(
                      fontSize: 14,
                      color: AppColors.primaryBrown,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _recentCharacters.length,
              itemBuilder: (context, index) {
                final character = _recentCharacters[index];
                return Container(
                  width: 140,
                  margin: EdgeInsets.only(
                    left: index == 0 ? 8 : 0,
                    right: 12,
                  ),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: AppColors.parchment.withOpacity(0.9),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => context.go('/home/characters/1'), // TODO: Заменить на реальный ID
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: character['color'],
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    character['name'],
                                    style: GoogleFonts.cinzel(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.darkBrown,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              character['class'],
                              style: GoogleFonts.cinzel(
                                fontSize: 12,
                                color: AppColors.woodBrown,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Ур. ${character['level']} • ${character['race']}',
                              style: GoogleFonts.cinzel(
                                fontSize: 11,
                                color: AppColors.woodBrown.withOpacity(0.7),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.lightBrown.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Изменить',
                                style: GoogleFonts.cinzel(
                                  fontSize: 12,
                                  color: AppColors.darkBrown,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
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
      ),
    );
  }

  Widget _buildRecentCampaigns() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Активные кампании',
                  style: GoogleFonts.cinzel(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkBrown,
                  ),
                ),
                TextButton(
                  onPressed: () => context.go('/home/campaigns'),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                  ),
                  child: Text(
                    'Все',
                    style: GoogleFonts.cinzel(
                      fontSize: 14,
                      color: AppColors.primaryBrown,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ..._recentCampaigns.map((campaign) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: AppColors.parchment.withOpacity(0.9),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => context.go('/home/campaigns/1'), // TODO: Заменить на реальный ID
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.flag_rounded,
                            color: AppColors.primaryBrown,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              campaign['name'],
                              style: GoogleFonts.cinzel(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.darkBrown,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.person_rounded,
                            size: 14,
                            color: AppColors.woodBrown,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'ДМ: ${campaign['dm']}',
                            style: GoogleFonts.cinzel(
                              fontSize: 13,
                              color: AppColors.woodBrown,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.event_available_rounded,
                            size: 14,
                            color: AppColors.woodBrown,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Сессий: ${campaign['sessions']}',
                            style: GoogleFonts.cinzel(
                              fontSize: 13,
                              color: AppColors.woodBrown,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accentGold.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.accentGold.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.schedule_rounded,
                              size: 14,
                              color: AppColors.accentGold,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Следующая: ${campaign['nextSession']}',
                              style: GoogleFonts.cinzel(
                                fontSize: 12,
                                color: AppColors.darkBrown,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }




  Widget _buildReferencePage() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: AppColors.parchment.withOpacity(0.95),
          elevation: 0,
          title: Text(
            'Справочник',
            style: GoogleFonts.cinzel(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.darkBrown,
            ),
          ),
          centerTitle: false,
          floating: true,
          actions: [
            IconButton(
              icon: Icon(Icons.search_rounded, color: AppColors.darkBrown),
              onPressed: () {},
            ),
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
            ),
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final categories = [
                  {
                    'icon': Icons.people_alt_rounded,
                    'title': 'Расы',
                    'color': AppColors.primaryBrown,
                    'route': '/home/reference/races',
                  },
                  {
                    'icon': Icons.military_tech_rounded,
                    'title': 'Классы',
                    'color': AppColors.accentGold,
                    'route': '/home/reference/classes',
                  },
                  {
                    'icon': Icons.pets_rounded,
                    'title': 'Существа',
                    'color': AppColors.woodBrown,
                    'route': '/home/reference/mobs',
                  },
                  {
                    'icon': Icons.auto_awesome_rounded,
                    'title': 'Заклинания',
                    'color': AppColors.infoBlue,
                    'route': '/home/reference/spells',
                  },
                  {
                    'icon': Icons.workspace_premium_rounded,
                    'title': 'Предметы',
                    'color': AppColors.successGreen,
                    'route': '/home/reference/items',
                  },
                  {
                    'icon': Icons.travel_explore_rounded,
                    'title': 'Миры',
                    'color': AppColors.errorRed,
                    'route': '/home/reference/worlds',
                  },
                ];

                if (index < categories.length) {
                  final category = categories[index];
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: AppColors.parchment.withOpacity(0.9),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => context.go(category['route'] as String),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: (category['color'] as Color).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: (category['color'] as Color).withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Icon(
                                category['icon'] as IconData,
                                color: category['color'] as Color,
                                size: 32,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              category['title'] as String,
                              style: GoogleFonts.cinzel(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.darkBrown,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return null;
              },
              childCount: 6,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDicePage() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: AppColors.parchment.withOpacity(0.95),
          elevation: 0,
          title: Text(
            'Кубики',
            style: GoogleFonts.cinzel(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.darkBrown,
            ),
          ),
          centerTitle: false,
          floating: true,
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                if (index == 0) {
                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.parchment.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.lightBrown.withOpacity(0.3),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.woodBrown.withOpacity(0.1),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Бросок кубика',
                              style: GoogleFonts.cinzel(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: AppColors.darkBrown,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Выберите тип кубика или создайте сложный бросок',
                              style: GoogleFonts.cinzel(
                                fontSize: 14,
                                color: AppColors.woodBrown,
                              ),
                            ),
                            const SizedBox(height: 32),
                            ElevatedButton(
                              onPressed: () => context.go('/home/dice'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryBrown,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 3,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.casino_rounded, size: 24),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Бросить кубик',
                                    style: GoogleFonts.cinzel(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Недавние броски',
                        style: GoogleFonts.cinzel(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkBrown,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // TODO: Добавить список последних бросков
                    ],
                  );
                }
                return null;
              },
              childCount: 1,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.parchment.withOpacity(0.97),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          // Главная страница
          CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: AppColors.parchment.withOpacity(0.95),
                elevation: 0,
                title: Text(
                  'D&D Companion',
                  style: GoogleFonts.cinzel(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkBrown,
                  ),
                ),
                centerTitle: false,
                floating: true,
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.notifications_none_rounded,
                      color: AppColors.darkBrown,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.person_rounded,
                      color: AppColors.darkBrown,
                    ),
                    onPressed: () => context.go('/home/profile'),
                  ),
                ],
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    if (index == 0) {
                      return Column(
                        children: [
                          _buildWelcomeCard(),
                          const SizedBox(height: 24),
                          _buildQuickActions(),
                          const SizedBox(height: 24),
                          _buildRecentCharacters(),
                          const SizedBox(height: 24),
                          _buildRecentCampaigns(),
                          const SizedBox(height: 32),
                        ],
                      );
                    }
                    return null;
                  },
                  childCount: 1,
                ),
              ),
            ],
          ),

        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.parchment,
          border: Border(
            top: BorderSide(
              color: AppColors.lightBrown.withOpacity(0.3),
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: GoogleFonts.cinzel(
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: GoogleFonts.cinzel(
            fontSize: 11,
          ),
          selectedItemColor: AppColors.primaryBrown,
          unselectedItemColor: AppColors.woodBrown.withOpacity(0.7),
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home_rounded,
                size: 24,
              ),
              label: 'Главная',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person_rounded,
                size: 24,
              ),
              label: 'Персонажи',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.menu_book_rounded,
                size: 24,
              ),
              label: 'Справочник',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.casino_rounded,
                size: 24,
              ),
              label: 'Кубики',
            ),
          ],
        ),
      ),
    );
  }
}