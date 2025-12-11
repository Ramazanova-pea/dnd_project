import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dnd_project/core/constants/app_colors.dart';
import 'package:dnd_project/features/auth/presentation/providers/auth_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final Map<String, String> _userStats = {
    'Персонажи': '3',
    'Кампании': '2',
    'Сессии': '15',
    'Часы игры': '48',
  };

  final List<Map<String, dynamic>> _recentActivity = [
    {
      'icon': Icons.person_add_rounded,
      'title': 'Создан персонаж "Элрион"',
      'time': '2 часа назад',
      'color': AppColors.primaryBrown,
    },
    {
      'icon': Icons.casino_rounded,
      'title': 'Бросок кубика: 20!',
      'time': 'Вчера',
      'color': AppColors.accentGold,
    },
    {
      'icon': Icons.group_rounded,
      'title': 'Сессия "Потерянный храм"',
      'time': '3 дня назад',
      'color': AppColors.infoBlue,
    },
    {
      'icon': Icons.book_rounded,
      'title': 'Изучена раса "Дварфы"',
      'time': 'Неделю назад',
      'color': AppColors.successGreen,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final username = authState.username ?? 'Искатель приключений';
    final email = authState.email ?? 'email@example.com';
    final isGuest = authState.isGuest;

    return Scaffold(
      backgroundColor: AppColors.parchment.withOpacity(0.97),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.parchment.withOpacity(0.95),
            elevation: 0,
            title: Text(
              'Профиль',
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
                  Icons.settings_rounded,
                  color: AppColors.darkBrown,
                ),
                onPressed: () {
                  // TODO: Настройки приложения
                },
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Карточка профиля
                _buildProfileCard(username, email, isGuest),

                const SizedBox(height: 24),

                // Статистика
                _buildStatsSection(),

                const SizedBox(height: 24),

                // Настройки аккаунта
                _buildAccountSettings(),

                const SizedBox(height: 24),

                // Последняя активность
                _buildRecentActivity(),

                const SizedBox(height: 24),

                // Кнопка выхода
                _buildLogoutButton(),

                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(String username, String email, bool isGuest) {
    return Container(
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
          children: [
            // Аватар
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primaryBrown.withOpacity(0.1),
                borderRadius: BorderRadius.circular(40),
                border: Border.all(
                  color: AppColors.accentGold.withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.person_rounded,
                size: 40,
                color: AppColors.primaryBrown,
              ),
            ),

            const SizedBox(height: 16),

            // Имя и email
            Text(
              username,
              style: GoogleFonts.cinzel(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.darkBrown,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              email,
              style: GoogleFonts.cinzel(
                fontSize: 14,
                color: AppColors.woodBrown,
                fontStyle: FontStyle.italic,
              ),
            ),

            if (isGuest) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.warningOrange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.warningOrange.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.info_rounded,
                      size: 14,
                      color: AppColors.warningOrange,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Гостевой режим',
                      style: GoogleFonts.cinzel(
                        fontSize: 12,
                        color: AppColors.warningOrange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Кнопка редактирования профиля
            ElevatedButton(
              onPressed: () {
                // TODO: Редактирование профиля
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Редактирование профиля'),
                    backgroundColor: AppColors.primaryBrown,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.lightBrown.withOpacity(0.2),
                foregroundColor: AppColors.darkBrown,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
                side: BorderSide(
                  color: AppColors.lightBrown.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.edit_rounded, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Редактировать профиль',
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

  Widget _buildStatsSection() {
    final statsEntries = _userStats.entries.toList();
    final colors = [
      AppColors.primaryBrown,
      AppColors.accentGold,
      AppColors.infoBlue,
      AppColors.successGreen,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Статистика',
          style: GoogleFonts.cinzel(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.darkBrown,
          ),
        ),

        const SizedBox(height: 12),

        Container(
          height: 80, // Минимальная высота
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: statsEntries.length,
            itemBuilder: (context, index) {
              final entry = statsEntries[index];
              final key = entry.key;
              final value = entry.value;
              final color = colors[index];

              return Container(
                width: 100, // Компактная ширина
                margin: EdgeInsets.only(
                  left: index == 0 ? 8 : 0,
                  right: 8,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: color.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          value,
                          style: GoogleFonts.cinzel(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: color,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      key,
                      style: GoogleFonts.cinzel(
                        fontSize: 11,
                        color: AppColors.darkBrown,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAccountSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Настройки аккаунта',
          style: GoogleFonts.cinzel(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.darkBrown,
          ),
        ),

        const SizedBox(height: 12),

        Container(
          decoration: BoxDecoration(
            color: AppColors.parchment.withOpacity(0.8),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.lightBrown.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              // Изменить имя
              _buildSettingItem(
                icon: Icons.person_rounded,
                title: 'Изменить имя',
                subtitle: 'Обновить отображаемое имя',
                color: AppColors.primaryBrown,
                onTap: () => context.go('/home/profile/edit_name'),
              ),

              const Divider(
                height: 1,
                thickness: 1,
                color: AppColors.lightBrown,
                indent: 16,
                endIndent: 16,
              ),

              // Изменить пароль
              _buildSettingItem(
                icon: Icons.lock_rounded,
                title: 'Изменить пароль',
                subtitle: 'Обновить пароль безопасности',
                color: AppColors.accentGold,
                onTap: () => context.go('/home/profile/edit_password'),
              ),

              const Divider(
                height: 1,
                thickness: 1,
                color: AppColors.lightBrown,
                indent: 16,
                endIndent: 16,
              ),

              // Уведомления
              _buildSettingItem(
                icon: Icons.notifications_rounded,
                title: 'Уведомления',
                subtitle: 'Настройка оповещений',
                color: AppColors.infoBlue,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Настройки уведомлений'),
                      backgroundColor: AppColors.primaryBrown,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),

              const Divider(
                height: 1,
                thickness: 1,
                color: AppColors.lightBrown,
                indent: 16,
                endIndent: 16,
              ),

              // Внешний вид
              _buildSettingItem(
                icon: Icons.palette_rounded,
                title: 'Внешний вид',
                subtitle: 'Тема и оформление',
                color: AppColors.successGreen,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Настройки внешнего вида'),
                      backgroundColor: AppColors.primaryBrown,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),

              const Divider(
                height: 1,
                thickness: 1,
                color: AppColors.lightBrown,
                indent: 16,
                endIndent: 16,
              ),

              // Удалить аккаунт
              _buildSettingItem(
                icon: Icons.delete_rounded,
                title: 'Удалить аккаунт',
                subtitle: 'Безвозвратное удаление',
                color: AppColors.errorRed,
                onTap: () => context.go('/home/profile/delete_account'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: color.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Icon(
                icon,
                color: color,
                size: 22,
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.cinzel(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkBrown,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    subtitle,
                    style: GoogleFonts.cinzel(
                      fontSize: 12,
                      color: AppColors.woodBrown,
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.woodBrown.withOpacity(0.5),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Последняя активность',
              style: GoogleFonts.cinzel(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.darkBrown,
              ),
            ),

            TextButton(
              onPressed: () {
                // TODO: Вся активность
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
              ),
              child: Text(
                'Вся активность',
                style: GoogleFonts.cinzel(
                  fontSize: 14,
                  color: AppColors.primaryBrown,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Container(
          decoration: BoxDecoration(
            color: AppColors.parchment.withOpacity(0.8),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.lightBrown.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            children: _recentActivity.map((activity) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: (activity['color'] as Color).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        activity['icon'] as IconData,
                        color: activity['color'] as Color,
                        size: 20,
                      ),
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activity['title'] as String,
                            style: GoogleFonts.cinzel(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.darkBrown,
                            ),
                          ),

                          const SizedBox(height: 2),

                          Text(
                            activity['time'] as String,
                            style: GoogleFonts.cinzel(
                              fontSize: 12,
                              color: AppColors.woodBrown,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton() {
    return ElevatedButton(
      onPressed: () {
        ref.read(authProvider.notifier).logout();
        context.go('/login');
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.errorRed.withOpacity(0.1),
        foregroundColor: AppColors.errorRed,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
        side: BorderSide(
          color: AppColors.errorRed.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.logout_rounded, size: 20),
          const SizedBox(width: 12),
          Text(
            'Выйти из аккаунта',
            style: GoogleFonts.cinzel(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}