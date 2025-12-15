import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '/core/constants/app_colors.dart';

// Временные провайдеры (замените на реальные)
final settingsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  await Future.delayed(const Duration(milliseconds: 500));
  return [
    {'id': '1', 'name': 'Forgotten Realms', 'description': 'Классический мир Dungeons & Dragons'},
    {'id': '2', 'name': 'Eberron', 'description': 'Магический стимпанк мир'},
    {'id': '3', 'name': 'Ravnica', 'description': 'Мир по мотивам Magic: The Gathering'},
    {'id': '4', 'name': 'Custom World', 'description': 'Пользовательский сеттинг'},
  ];
});

class CreateCampaignScreen extends ConsumerStatefulWidget {
  const CreateCampaignScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateCampaignScreen> createState() => _CreateCampaignScreenState();
}

class _CreateCampaignScreenState extends ConsumerState<CreateCampaignScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _notesController = TextEditingController();

  String? _selectedSettingId;
  DateTime? _startDate;
  String? _frequency;
  String? _privacy;

  final List<String> _frequencyOptions = [
    'Еженедельно',
    'Раз в две недели',
    'Ежемесячно',
    'По мере возможности',
    'Интенсивно (несколько раз в неделю)',
    'Однократно',
  ];

  final List<String> _privacyOptions = [
    'Открытая (любой может присоединиться)',
    'Закрытая (только по приглашению)',
    'Приватная (только создатель)',
  ];

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsProvider);

    return Scaffold(
      backgroundColor: AppColors.lightParchment,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.darkBrown,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Создание кампании',
          style: TextStyle(
            color: AppColors.darkBrown,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primaryBrown,
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),

              // Название кампании
              _buildFormField(
                label: 'Название кампании *',
                hintText: 'Например: "Поход за Священным Граалем"',
                controller: _nameController,
                maxLines: 1,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите название кампании';
                  }
                  if (value.length < 3) {
                    return 'Название должно быть не менее 3 символов';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Описание
              _buildFormField(
                label: 'Описание кампании *',
                hintText: 'Опишите сюжет, цели, особенности вашей кампании...',
                controller: _descriptionController,
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите описание кампании';
                  }
                  if (value.length < 10) {
                    return 'Описание должно быть более подробным';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Выбор сеттинга
              _buildSettingSelector(settingsAsync),
              const SizedBox(height: 20),

              // Дополнительные настройки
              _buildAdditionalSettings(),
              const SizedBox(height: 30),

              // Кнопка создания
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _createCampaign,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBrown,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    shadowColor: AppColors.shadowBrown,
                  ),
                  child: Text(
                    'СОЗДАТЬ КАМПАНИЮ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Информация
              _buildInfoCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryBrown.withOpacity(0.1),
            AppColors.accentGold.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryBrown.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.campaign,
            size: 48,
            color: AppColors.primaryBrown,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Новая кампания',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBrown,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Создайте эпическое приключение для вас и ваших друзей',
                  style: TextStyle(
                    color: AppColors.mediumBrown,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    required int maxLines,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.darkBrown,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: TextStyle(
            color: AppColors.darkBrown,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: AppColors.mediumBrown.withOpacity(0.6),
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.lightBrown.withOpacity(0.5),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.lightBrown.withOpacity(0.5),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.primaryBrown,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
          validator: validator,
          textInputAction: maxLines == 1 ? TextInputAction.next : TextInputAction.newline,
        ),
      ],
    );
  }

  Widget _buildSettingSelector(AsyncValue<List<Map<String, dynamic>>> settingsAsync) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Игровой мир (сеттинг)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.darkBrown,
          ),
        ),
        const SizedBox(height: 8),

        settingsAsync.when(
          loading: () => Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.lightBrown.withOpacity(0.5),
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primaryBrown,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Загрузка сеттингов...',
                  style: TextStyle(
                    color: AppColors.mediumBrown,
                  ),
                ),
              ],
            ),
          ),

          error: (error, stackTrace) => Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.errorRed.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  color: AppColors.errorRed,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Ошибка загрузки: $error',
                    style: TextStyle(
                      color: AppColors.darkBrown,
                    ),
                  ),
                ),
              ],
            ),
          ),

          data: (settings) => Column(
            children: [
              ...settings.map((setting) => InkWell(
                onTap: () {
                  setState(() {
                    _selectedSettingId = _selectedSettingId == setting['id'] ? null : setting['id'];
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _selectedSettingId == setting['id']
                        ? AppColors.primaryBrown.withOpacity(0.1)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _selectedSettingId == setting['id']
                          ? AppColors.primaryBrown
                          : AppColors.lightBrown.withOpacity(0.5),
                      width: _selectedSettingId == setting['id'] ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _selectedSettingId == setting['id']
                              ? AppColors.primaryBrown
                              : AppColors.lightBrown.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.public,
                          color: _selectedSettingId == setting['id']
                              ? Colors.white
                              : AppColors.darkBrown,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              setting['name'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: _selectedSettingId == setting['id']
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                color: AppColors.darkBrown,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              setting['description'],
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.mediumBrown,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_selectedSettingId == setting['id'])
                        Icon(
                          Icons.check_circle,
                          color: AppColors.primaryBrown,
                        ),
                    ],
                  ),
                ),
              )).toList(),

              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: AppColors.lightBrown.withOpacity(0.5),
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'или',
                      style: TextStyle(
                        color: AppColors.mediumBrown,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: AppColors.lightBrown.withOpacity(0.5),
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Кнопка создания своего мира
              InkWell(
                onTap: () {
                  _createCustomSetting();
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.accentGold,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_circle_outline,
                        color: AppColors.accentGold,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Создать свой игровой мир',
                        style: TextStyle(
                          color: AppColors.accentGold,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Дополнительные настройки',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.darkBrown,
          ),
        ),
        const SizedBox(height: 12),

        // Дата начала
        _buildSettingOption(
          icon: Icons.calendar_today,
          label: 'Дата начала',
          value: _startDate != null
              ? DateFormat('dd.MM.yyyy').format(_startDate!)
              : 'Выбрать дату',
          onTap: () => _selectStartDate(),
        ),

        // Частота игр
        _buildSettingOption(
          icon: Icons.access_time,
          label: 'Частота игр',
          value: _frequency ?? 'Выбрать частоту',
          onTap: () => _selectFrequency(),
        ),

        // Приватность
        _buildSettingOption(
          icon: Icons.lock,
          label: 'Приватность',
          value: _privacy ?? 'Выбрать тип доступа',
          onTap: () => _selectPrivacy(),
        ),

        // Примечания
        _buildFormField(
          label: 'Дополнительные заметки',
          hintText: 'Здесь можно добавить любую дополнительную информацию...',
          controller: _notesController,
          maxLines: 3,
          validator: (_) => null, // Необязательное поле
        ),
      ],
    );
  }

  Widget _buildSettingOption({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.lightBrown.withOpacity(0.5),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.primaryBrown,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.mediumBrown,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.darkBrown,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.mediumBrown,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.infoBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.infoBlue.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: AppColors.infoBlue,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'После создания кампании вы сможете пригласить игроков, '
                  'создавать сессии и добавлять заметки.',
              style: TextStyle(
                color: AppColors.darkBrown.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectStartDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryBrown,
              onPrimary: Colors.white,
              surface: AppColors.lightParchment,
              onSurface: AppColors.darkBrown,
            ),
            dialogBackgroundColor: AppColors.lightParchment,
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      setState(() {
        _startDate = selectedDate;
      });
    }
  }

  Future<void> _selectFrequency() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.lightParchment,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Выберите частоту игр',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkBrown,
                ),
              ),
              const SizedBox(height: 20),
              ..._frequencyOptions.map((option) => ListTile(
                title: Text(
                  option,
                  style: TextStyle(
                    color: AppColors.darkBrown,
                  ),
                ),
                trailing: _frequency == option
                    ? Icon(
                  Icons.check,
                  color: AppColors.primaryBrown,
                )
                    : null,
                onTap: () {
                  Navigator.pop(context, option);
                },
              )).toList(),
            ],
          ),
        );
      },
    );

    if (selected != null) {
      setState(() {
        _frequency = selected;
      });
    }
  }

  Future<void> _selectPrivacy() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.lightParchment,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Выберите тип доступа',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkBrown,
                ),
              ),
              const SizedBox(height: 20),
              ..._privacyOptions.map((option) => ListTile(
                title: Text(
                  option,
                  style: TextStyle(
                    color: AppColors.darkBrown,
                  ),
                ),
                trailing: _privacy == option
                    ? Icon(
                  Icons.check,
                  color: AppColors.primaryBrown,
                )
                    : null,
                onTap: () {
                  Navigator.pop(context, option);
                },
              )).toList(),
            ],
          ),
        );
      },
    );

    if (selected != null) {
      setState(() {
        _privacy = selected;
      });
    }
  }

  Future<void> _createCustomSetting() async {
    // TODO: Реализовать создание пользовательского сеттинга
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Создание пользовательского мира'),
        action: SnackBarAction(
          label: 'Создать',
          onPressed: () {
            context.go('/home/settings_game/create');
          },
        ),
      ),
    );
  }

  Future<void> _createCampaign() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedSettingId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Выберите игровой мир (сеттинг)'),
          backgroundColor: AppColors.errorRed,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Реализовать создание кампании в базе данных
      await Future.delayed(const Duration(seconds: 2));

      // Формируем данные кампании
      final campaignData = {
        'name': _nameController.text,
        'description': _descriptionController.text,
        'settingId': _selectedSettingId,
        'startDate': _startDate?.toIso8601String(),
        'frequency': _frequency,
        'privacy': _privacy,
        'notes': _notesController.text,
        'createdAt': DateTime.now().toIso8601String(),
      };

      // TODO: Отправить данные на сервер
      print('Создана кампания: $campaignData');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Кампания "${_nameController.text}" создана!'),
          backgroundColor: AppColors.successGreen,
        ),
      );

      // Возвращаемся назад с результатом
      if (context.mounted) {
        context.pop({'success': true, 'campaign': campaignData});
      }

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка создания: $e'),
          backgroundColor: AppColors.errorRed,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}