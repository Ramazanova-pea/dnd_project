import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '/core/constants/app_colors.dart';

// Временные провайдеры (замените на реальные)
final campaignProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, campaignId) async {
  await Future.delayed(const Duration(milliseconds: 500));
  return {
    'id': campaignId,
    'name': 'Поход за Священным Граалем',
    'description': 'Эпическая кампания в мире Фаэруна',
    'players': [
      {'id': '1', 'name': 'Мария', 'characterName': 'Эльвира, эльфийская лучница'},
      {'id': '2', 'name': 'Дмитрий', 'characterName': 'Громхард, дварф-воин'},
      {'id': '3', 'name': 'Ольга', 'characterName': 'Мерил, волшебница'},
    ],
    'master': {'id': '4', 'name': 'Алексей'},
  };
});

class CreateSessionScreen extends ConsumerStatefulWidget {
  final String campaignId;

  const CreateSessionScreen({
    Key? key,
    required this.campaignId,
  }) : super(key: key);

  @override
  ConsumerState<CreateSessionScreen> createState() => _CreateSessionScreenState();
}

class _CreateSessionScreenState extends ConsumerState<CreateSessionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  List<String> _selectedPlayers = [];
  bool _notifyPlayers = true;
  bool _isRecurring = false;
  String? _recurrenceType;
  int? _recurrenceCount;

  bool _isLoading = false;

  final List<String> _recurrenceOptions = [
    'Не повторять',
    'Еженедельно',
    'Раз в две недели',
    'Ежемесячно',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final campaignAsync = ref.watch(campaignProvider(widget.campaignId));

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
        title: campaignAsync.when(
          loading: () => Text(
            'Новая сессия',
            style: TextStyle(
              color: AppColors.darkBrown,
              fontWeight: FontWeight.bold,
            ),
          ),
          error: (error, stackTrace) => Text(
            'Новая сессия',
            style: TextStyle(
              color: AppColors.darkBrown,
              fontWeight: FontWeight.bold,
            ),
          ),
          data: (campaign) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                campaign['name'] ?? 'Кампания',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.mediumBrown,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'Новая сессия',
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.darkBrown,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
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
      body: campaignAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryBrown,
          ),
        ),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.errorRed,
              ),
              const SizedBox(height: 16),
              Text(
                'Ошибка загрузки кампании',
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.darkBrown,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.mediumBrown,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => ref.refresh(campaignProvider(widget.campaignId)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBrown,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('ПОВТОРИТЬ ПОПЫТКУ'),
              ),
            ],
          ),
        ),
        data: (campaign) {
          return _buildForm(campaign);
        },
      ),
    );
  }

  Widget _buildForm(Map<String, dynamic> campaign) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),

            // Название сессии
            _buildFormField(
              label: 'Название сессии *',
              hintText: 'Например: "Храм испытаний" или "Схватка с драконом"',
              controller: _titleController,
              maxLines: 1,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите название сессии';
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
              label: 'Описание сессии',
              hintText: 'Опишите план сессии, цели, возможные события...',
              controller: _descriptionController,
              maxLines: 4,
              validator: (value) => null,
            ),
            const SizedBox(height: 20),

            // Дата и время
            _buildDateTimeSection(),
            const SizedBox(height: 20),

            // Локация
            _buildFormField(
              label: 'Место проведения',
              hintText: 'Онлайн (Discord, Roll20) или физическое место',
              controller: _locationController,
              maxLines: 1,
              validator: (value) => null,
            ),
            const SizedBox(height: 20),

            // Участники
            _buildPlayersSection(campaign),
            const SizedBox(height: 20),

            // Повторение
            _buildRecurrenceSection(),
            const SizedBox(height: 20),

            // Дополнительные заметки
            _buildFormField(
              label: 'Подготовительные заметки',
              hintText: 'Подготовка для мастера, важные NPC, сокровища...',
              controller: _notesController,
              maxLines: 3,
              validator: (value) => null,
            ),
            const SizedBox(height: 20),

            // Уведомление игроков
            _buildNotificationSection(),
            const SizedBox(height: 30),

            // Кнопки
            _buildActionButtons(),
          ],
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
            AppColors.infoBlue.withOpacity(0.1),
            AppColors.accentGold.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.infoBlue.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.event,
            size: 48,
            color: AppColors.infoBlue,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Планирование сессии',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBrown,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Запланируйте следующую игровую сессию для вашей кампании',
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

  Widget _buildDateTimeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Дата и время *',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.darkBrown,
          ),
        ),
        const SizedBox(height: 8),

        Row(
          children: [
            Expanded(
              child: _buildDateTimeButton(
                icon: Icons.calendar_today,
                label: _selectedDate != null
                    ? DateFormat('dd.MM.yyyy').format(_selectedDate!)
                    : 'Выбрать дату',
                onPressed: _selectDate,
                color: AppColors.primaryBrown,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDateTimeButton(
                icon: Icons.access_time,
                label: _selectedTime != null
                    ? _selectedTime!.format(context)
                    : 'Выбрать время',
                onPressed: _selectTime,
                color: AppColors.infoBlue,
              ),
            ),
          ],
        ),

        if (_selectedDate != null && _selectedTime != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.successGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.successGreen.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: AppColors.successGreen,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Сессия запланирована на ${DateFormat('dd.MM.yyyy').format(_selectedDate!)} в ${_selectedTime!.format(context)}',
                    style: TextStyle(
                      color: AppColors.darkBrown,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDateTimeButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.lightBrown.withOpacity(0.5),
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: color,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: AppColors.darkBrown,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayersSection(Map<String, dynamic> campaign) {
    final List<Map<String, dynamic>> players = List.from(campaign['players'] ?? []);
    final Map<String, dynamic> master = campaign['master'] ?? {};

    // Мастер всегда участвует
    if (!_selectedPlayers.contains(master['id'])) {
      _selectedPlayers.add(master['id']);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Участники сессии',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.darkBrown,
          ),
        ),
        const SizedBox(height: 8),

        // Мастер (обязательный участник)
        _buildPlayerCard(
          id: master['id'],
          name: master['name'] ?? 'Мастер',
          role: 'Мастер кампании',
          characterName: null,
          isSelected: true,
          isRequired: true,
          onChanged: null,
        ),

        const SizedBox(height: 12),

        // Игроки
        Text(
          'Игроки (${players.length})',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.mediumBrown,
          ),
        ),
        const SizedBox(height: 8),

        ...players.map((player) => _buildPlayerCard(
          id: player['id'],
          name: player['name'],
          role: 'Игрок',
          characterName: player['characterName'],
          isSelected: _selectedPlayers.contains(player['id']),
          isRequired: false,
          onChanged: (selected) {
            setState(() {
              if (selected) {
                _selectedPlayers.add(player['id']);
              } else {
                _selectedPlayers.remove(player['id']);
              }
            });
          },
        )).toList(),

        const SizedBox(height: 8),

        // Кнопка пригласить дополнительно
        OutlinedButton.icon(
          onPressed: () => _inviteAdditionalPlayer(),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.infoBlue,
            side: BorderSide(color: AppColors.infoBlue),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            minimumSize: const Size(double.infinity, 48),
          ),
          icon: const Icon(Icons.person_add),
          label: const Text('ПРИГЛАСИТЬ ДОПОЛНИТЕЛЬНОГО ИГРОКА'),
        ),
      ],
    );
  }

  Widget _buildPlayerCard({
    required String id,
    required String name,
    required String role,
    required String? characterName,
    required bool isSelected,
    required bool isRequired,
    required Function(bool)? onChanged,
  }) {
    return Material(
      color: isSelected
          ? AppColors.primaryBrown.withOpacity(0.1)
          : Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onChanged != null ? () => onChanged(!isSelected) : null,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? AppColors.primaryBrown
                  : AppColors.lightBrown.withOpacity(0.5),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              // Аватар
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: role == 'Мастер кампании'
                      ? AppColors.accentGold.withOpacity(0.2)
                      : AppColors.infoBlue.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  role == 'Мастер кампании' ? Icons.campaign : Icons.person,
                  color: role == 'Мастер кампании'
                      ? AppColors.accentGold
                      : AppColors.infoBlue,
                  size: 24,
                ),
              ),

              const SizedBox(width: 12),

              // Информация
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.darkBrown,
                      ),
                    ),
                    if (characterName != null)
                      Text(
                        characterName,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.mediumBrown,
                        ),
                      ),
                  ],
                ),
              ),

              // Чекбокс или иконка обязательного
              if (isRequired)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accentGold.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Мастер',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.accentGold,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              else
                Checkbox(
                  value: isSelected,
                  onChanged: (value) => onChanged?.call(value ?? false),
                  activeColor: AppColors.primaryBrown,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecurrenceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Checkbox(
              value: _isRecurring,
              onChanged: (value) {
                setState(() {
                  _isRecurring = value ?? false;
                  if (!_isRecurring) {
                    _recurrenceType = null;
                    _recurrenceCount = null;
                  }
                });
              },
              activeColor: AppColors.primaryBrown,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Повторяющаяся сессия',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkBrown,
                ),
              ),
            ),
          ],
        ),

        if (_isRecurring) ...[
          const SizedBox(height: 12),

          // Тип повторения
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Повторять',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.mediumBrown,
                ),
              ),
              const SizedBox(height: 8),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _recurrenceOptions.map((option) {
                  final isSelected = _recurrenceType == option;
                  return ChoiceChip(
                    label: Text(option),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _recurrenceType = selected ? option : null;
                      });
                    },
                    selectedColor: AppColors.primaryBrown.withOpacity(0.2),
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? AppColors.primaryBrown
                          : AppColors.darkBrown,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.primaryBrown
                            : AppColors.lightBrown.withOpacity(0.5),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),

          if (_recurrenceType != null && _recurrenceType != 'Не повторять') ...[
            const SizedBox(height: 16),

            // Количество повторений
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Количество сессий',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.mediumBrown,
                  ),
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Например: 4',
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
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        onChanged: (value) {
                          _recurrenceCount = int.tryParse(value);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.lightBrown.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _recurrenceCount != null
                            ? '${_getTotalSessionsCount()} всего'
                            : 'Всего',
                        style: TextStyle(
                          color: AppColors.darkBrown,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ],
      ],
    );
  }

  Widget _buildNotificationSection() {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.lightBrown.withOpacity(0.5),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.notifications_active,
              color: AppColors.accentGold,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Уведомить игроков',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.darkBrown,
                    ),
                  ),
                  Text(
                    'Отправить приглашение выбранным участникам',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.mediumBrown,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: _notifyPlayers,
              onChanged: (value) {
                setState(() {
                  _notifyPlayers = value;
                });
              },
              activeColor: AppColors.primaryBrown,
              inactiveTrackColor: AppColors.lightBrown.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Кнопка создания
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _createSession,
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
              _isRecurring && _recurrenceCount != null && _recurrenceCount! > 1
                  ? 'СОЗДАТЬ ${_getTotalSessionsCount()} СЕССИЙ'
                  : 'СОЗДАТЬ СЕССИЮ',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Кнопка отмены
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton(
            onPressed: () => context.pop(),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.darkBrown,
              side: BorderSide(
                color: AppColors.darkBrown.withOpacity(0.3),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'ОТМЕНА',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  int _getTotalSessionsCount() {
    return (_recurrenceCount ?? 0) + 1; // Исходная + повторения
  }

  Future<void> _selectDate() async {
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
        _selectedDate = selectedDate;
      });
    }
  }

  Future<void> _selectTime() async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
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

    if (selectedTime != null) {
      setState(() {
        _selectedTime = selectedTime;
      });
    }
  }

  void _inviteAdditionalPlayer() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Пригласить игрока'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Введите имя игрока или email для приглашения:'),
            const SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Имя или email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ОТМЕНА'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Отправить приглашение
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Приглашение отправлено'),
                  backgroundColor: AppColors.successGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBrown,
            ),
            child: const Text('ПРИГЛАСИТЬ'),
          ),
        ],
      ),
    );
  }

  Future<void> _createSession() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Выберите дату и время сессии'),
          backgroundColor: AppColors.errorRed,
        ),
      );
      return;
    }

    if (_selectedPlayers.length < 2) { // Мастер + минимум 1 игрок
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Выберите хотя бы одного игрока'),
          backgroundColor: AppColors.errorRed,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Реализовать создание сессии в базе данных
      await Future.delayed(const Duration(seconds: 2));

      // Формируем данные сессии
      final sessionData = {
        'campaignId': widget.campaignId,
        'title': _titleController.text,
        'description': _descriptionController.text.isNotEmpty
            ? _descriptionController.text
            : null,
        'date': _selectedDate!.toIso8601String(),
        'time': _selectedTime!.format(context),
        'location': _locationController.text.isNotEmpty
            ? _locationController.text
            : null,
        'participants': _selectedPlayers,
        'notes': _notesController.text.isNotEmpty
            ? _notesController.text
            : null,
        'status': 'planned',
        'notifyPlayers': _notifyPlayers,
        'isRecurring': _isRecurring,
        'recurrenceType': _recurrenceType,
        'recurrenceCount': _recurrenceCount,
        'createdAt': DateTime.now().toIso8601String(),
      };

      // TODO: Отправить данные на сервер
      print('Создана сессия: $sessionData');

      // Если нужно повторение, создаем дополнительные сессии
      if (_isRecurring && _recurrenceCount != null && _recurrenceCount! > 0) {
        // TODO: Создать повторяющиеся сессии
        print('Создано ${_recurrenceCount} повторяющихся сессий');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isRecurring && _recurrenceCount != null && _recurrenceCount! > 0
                ? 'Создано ${_getTotalSessionsCount()} сессий!'
                : 'Сессия "${_titleController.text}" создана!',
          ),
          backgroundColor: AppColors.successGreen,
        ),
      );

      // Возвращаемся назад с результатом
      if (context.mounted) {
        context.pop({'success': true, 'session': sessionData});
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