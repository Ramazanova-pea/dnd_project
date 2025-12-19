import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '/core/constants/app_colors.dart';
import '/core/providers/reference_providers.dart';
import '/domain/models/reference/monster_model.dart';

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
  // Маппинг типов монстров на иконки и цвета для UI
  Map<String, dynamic> _getMonsterStyle(String? type) {
    final typeLower = type?.toLowerCase() ?? '';
    if (typeLower.contains('dragon')) {
      return {
        'icon': Icons.pets,
        'color': AppColors.errorRed,
      };
    } else if (typeLower.contains('undead') || typeLower.contains('lich')) {
      return {
        'icon': Icons.auto_awesome,
        'color': const Color(0xFF673AB7),
      };
    } else if (typeLower.contains('giant')) {
      return {
        'icon': Icons.whatshot,
        'color': AppColors.warningOrange,
      };
    } else if (typeLower.contains('beast')) {
      return {
        'icon': Icons.pets,
        'color': AppColors.primaryBrown,
      };
    } else if (typeLower.contains('humanoid')) {
      return {
        'icon': Icons.person,
        'color': AppColors.successGreen,
      };
    } else if (typeLower.contains('fey')) {
      return {
        'icon': Icons.forest,
        'color': const Color(0xFF4CAF50),
      };
    } else if (typeLower.contains('elemental')) {
      return {
        'icon': Icons.fireplace,
        'color': const Color(0xFFFF5722),
      };
    }
    return {
      'icon': Icons.pets,
      'color': AppColors.primaryBrown,
    };
  }

  // Получение цвета сложности
  Color _getChallengeColor(double? cr) {
    if (cr == null) return AppColors.successGreen;
    if (cr <= 4) return AppColors.successGreen;
    if (cr <= 10) return AppColors.warningOrange;
    return AppColors.errorRed;
  }

  @override
  Widget build(BuildContext context) {
    final monsterAsync = ref.watch(monsterByIdProvider(widget.mobId));

    return monsterAsync.when(
      data: (monsterModel) {
        final style = _getMonsterStyle(monsterModel.type);
        final monsterColor = style['color'] as Color;
        final monsterIcon = style['icon'] as IconData;
        final challengeColor = _getChallengeColor(monsterModel.challengeRating);
        return _buildMonsterDetail(monsterModel, monsterColor, monsterIcon, challengeColor);
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
                'Ошибка загрузки монстра',
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

  Widget _buildMonsterDetail(
    MonsterModel monsterModel,
    Color monsterColor,
    IconData monsterIcon,
    Color challengeColor,
  ) {
    return Scaffold(
      backgroundColor: AppColors.getHomeBackground(context),
      body: CustomScrollView(
        slivers: [
          // Заголовок экрана
          SliverAppBar(
            backgroundColor: monsterColor,
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.pop(),
            ),
            title: Text(
              monsterModel.name,
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
                      monsterColor,
                      monsterColor.withOpacity(0.8),
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
                              monsterIcon,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 12),
                          if (monsterModel.challengeRating != null)
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
                                'CR ${monsterModel.challengeRating}',
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
                        '${monsterModel.type ?? 'Существо'}${monsterModel.size != null ? ' • ${monsterModel.size}' : ''}',
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
                _buildInfoSection(monsterModel, monsterColor),

                const SizedBox(height: 16),

                // Характеристики
                if (monsterModel.stats != null && monsterModel.stats!.isNotEmpty)
                  _buildStatsSection(monsterModel, monsterColor),

                const SizedBox(height: 16),

                // Особые способности
                if (monsterModel.specialAbilities != null && monsterModel.specialAbilities!.isNotEmpty)
                  _buildAbilitiesSection('Особые способности', monsterModel.specialAbilities!, monsterColor),

                const SizedBox(height: 16),

                // Действия
                if (monsterModel.actions != null && monsterModel.actions!.isNotEmpty)
                  _buildAbilitiesSection('Действия', monsterModel.actions!, monsterColor),

                const SizedBox(height: 16),

                // Легендарные действия
                if (monsterModel.legendaryActions != null && monsterModel.legendaryActions!.isNotEmpty)
                  _buildAbilitiesSection('Легендарные действия', monsterModel.legendaryActions!, monsterColor),

                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(MonsterModel monsterModel, Color monsterColor) {
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
                  color: monsterColor,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  if (monsterModel.type != null)
                    _buildInfoItem('Тип', monsterModel.type!, Icons.category, monsterColor),
                  if (monsterModel.alignment != null)
                    _buildInfoItem('Мировоззрение', monsterModel.alignment!, Icons.psychology, monsterColor),
                  if (monsterModel.size != null)
                    _buildInfoItem('Размер', monsterModel.size!, Icons.height, monsterColor),
                  if (monsterModel.hitPoints != null)
                    _buildInfoItem('Очки жизни', '${monsterModel.hitPoints}', Icons.favorite, monsterColor),
                  if (monsterModel.armorClass != null)
                    _buildInfoItem('Класс брони', '${monsterModel.armorClass}', Icons.shield, monsterColor),
                  if (monsterModel.challengeRating != null)
                    _buildInfoItem('Сложность', 'CR ${monsterModel.challengeRating}', Icons.bar_chart, monsterColor),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String title, String value, IconData icon, Color color) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: color.withOpacity(0.1),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
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
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(MonsterModel monsterModel, Color monsterColor) {
    final stats = monsterModel.stats!;
    final statNames = {
      'strength': 'СИЛ',
      'dexterity': 'ЛОВ',
      'constitution': 'ТЕЛ',
      'intelligence': 'ИНТ',
      'wisdom': 'МДР',
      'charisma': 'ХАР',
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
                  color: monsterColor,
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
                  final value = stats[key]!;
                  final modifier = ((value - 10) / 2).floor();

                  return Container(
                    decoration: BoxDecoration(
                      color: monsterColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: monsterColor.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          statNames[key] ?? key.toUpperCase(),
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
                            color: monsterColor,
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
                  if (monsterModel.damageResistances != null && monsterModel.damageResistances!.isNotEmpty)
                    _buildStatItem('Сопротивления', monsterModel.damageResistances!.join(', '), monsterColor),
                  if (monsterModel.damageImmunities != null && monsterModel.damageImmunities!.isNotEmpty)
                    _buildStatItem('Иммунитеты', monsterModel.damageImmunities!.join(', '), monsterColor),
                  if (monsterModel.conditionImmunities != null && monsterModel.conditionImmunities!.isNotEmpty)
                    _buildStatItem('Им. к состояниям', monsterModel.conditionImmunities!.join(', '), monsterColor),
                  if (monsterModel.languages != null && monsterModel.languages!.isNotEmpty)
                    _buildStatItem('Языки', monsterModel.languages!, monsterColor),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(6.0),
        border: Border.all(
          color: color.withOpacity(0.1),
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

  Widget _buildAbilitiesSection(String title, List<Map<String, dynamic>> abilities, Color color) {
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
                  color: color,
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
                  final abilityName = ability['name'] as String? ?? '';
                  final abilityDesc = ability['desc'] != null
                      ? (ability['desc'] is String
                          ? ability['desc'] as String
                          : (ability['desc'] as List).join('\n'))
                      : '';
                  return Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: color.withOpacity(0.1),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          abilityName,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: color,
                          ),
                        ),
                        if (abilityDesc.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            abilityDesc,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.darkBrown.withOpacity(0.8),
                              height: 1.4,
                            ),
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
}
