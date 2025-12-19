import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '/core/constants/app_colors.dart';
import '/core/providers/setting_providers.dart';
import '/domain/models/setting.dart';

class CreateSettingScreen extends ConsumerStatefulWidget {
  const CreateSettingScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateSettingScreen> createState() => _CreateSettingScreenState();
}

class _CreateSettingScreenState extends ConsumerState<CreateSettingScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _historyController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // Значения по умолчанию
  String _selectedStatus = 'В разработке';
  String _selectedGenre = 'Фэнтези';
  String _selectedEra = 'Средневековье';
  String _selectedMagicLevel = 'Средний';
  String _selectedTechLevel = 'Низкий';
  Color _selectedColor = const Color(0xFF795548);

  // Списки выбора
  final List<String> _statusOptions = ['В разработке', 'Активный', 'Завершенный'];
  final List<String> _genreOptions = ['Фэнтези', 'Научная фантастика', 'Стимпанк', 'Постапокалипсис', 'Исторический', 'Ужасы', 'Мистика'];
  final List<String> _eraOptions = ['Древность', 'Средневековье', 'Эпоха Возрождения', 'Промышленная революция', 'Современность', 'Будущее'];
  final List<String> _magicLevelOptions = ['Отсутствует', 'Низкий', 'Средний', 'Высокий', 'Очень высокий'];
  final List<String> _techLevelOptions = ['Примитивный', 'Низкий', 'Средний', 'Высокий', 'Очень высокий'];

  final List<Color> _colorOptions = [
    const Color(0xFF795548), // Коричневый
    const Color(0xFF673AB7), // Фиолетовый
    const Color(0xFF2196F3), // Синий
    const Color(0xFFFF9800), // Оранжевый
    const Color(0xFF4CAF50), // Зеленый
    const Color(0xFFF44336), // Красный
    const Color(0xFF9C27B0), // Пурпурный
    const Color(0xFF00BCD4), // Бирюзовый
    const Color(0xFF607D8B), // Серо-голубой
    const Color(0xFF795548), // Коричневый
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _historyController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _createSetting() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      // Создаем сеттинг
      final setting = Setting(
        id: const Uuid().v4(),
        name: _nameController.text,
        description: _descriptionController.text,
        status: _selectedStatus,
        genre: _selectedGenre,
        players: 0,
        sessions: 0,
        lastSession: null,
        npcs: 0,
        locations: 0,
      );

      // Сохраняем в Hive
      await ref.read(createSettingProvider(setting).future);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.successGreen,
            content: Text('Игровой мир "${setting.name}" успешно создан!'),
            duration: const Duration(seconds: 2),
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.errorRed,
            content: Text('Ошибка создания: $e'),
          ),
        );
      }
    }
  }

  void _showColorPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Выберите цвет мира',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 12.0,
                  mainAxisSpacing: 12.0,
                  childAspectRatio: 1.0,
                ),
                itemCount: _colorOptions.length,
                itemBuilder: (context, index) {
                  final color = _colorOptions[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedColor = color;
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _selectedColor == color ? Colors.black : Colors.transparent,
                          width: 2.0,
                        ),
                      ),
                      child: _selectedColor == color
                          ? const Center(
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 20,
                        ),
                      )
                          : null,
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Отмена'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final darkBrownColor = AppColors.darkBrown;
    final primaryBrownColor = AppColors.primaryBrown;
    final lightBrownColor = AppColors.lightBrown;
    final parchmentColor = AppColors.parchment;

    return Scaffold(
      backgroundColor: AppColors.getHomeBackground(context),
      appBar: AppBar(
        backgroundColor: primaryBrownColor,
        title: const Text(
          'Создание нового мира',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.white),
            onPressed: _createSetting,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Заголовок
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: parchmentColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: lightBrownColor.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.public,
                          color: primaryBrownColor,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Создание игрового мира',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: darkBrownColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Заполните информацию о новом мире для вашей кампании. '
                          'Вы всегда сможете отредактировать её позже.',
                      style: TextStyle(
                        fontSize: 14,
                        color: darkBrownColor.withOpacity(0.7),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Основная информация
              Text(
                'Основная информация',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: darkBrownColor,
                ),
              ),
              const SizedBox(height: 12),

              // Название мира
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Название мира *',
                  labelStyle: TextStyle(
                    color: darkBrownColor.withOpacity(0.6),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: lightBrownColor.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: primaryBrownColor,
                      width: 2.0,
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.title,
                    color: primaryBrownColor,
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.9),
                ),
                style: TextStyle(
                  fontSize: 16,
                  color: darkBrownColor,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите название мира';
                  }
                  if (value.length < 3) {
                    return 'Название должно содержать минимум 3 символа';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Описание мира
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Краткое описание мира *',
                  labelStyle: TextStyle(
                    color: darkBrownColor.withOpacity(0.6),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: lightBrownColor.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: primaryBrownColor,
                      width: 2.0,
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.description,
                    color: primaryBrownColor,
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.9),
                ),
                style: TextStyle(
                  fontSize: 16,
                  color: darkBrownColor,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите описание мира';
                  }
                  if (value.length < 10) {
                    return 'Описание должно содержать минимум 10 символов';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Параметры мира
              Text(
                'Параметры мира',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: darkBrownColor,
                ),
              ),
              const SizedBox(height: 12),

              // Сетка параметров
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                childAspectRatio: 3.0,
                children: [
                  // Статус
                  _buildParameterDropdown(
                    label: 'Статус',
                    value: _selectedStatus,
                    options: _statusOptions,
                    icon: Icons.circle,
                    onChanged: (value) {
                      setState(() {
                        _selectedStatus = value!;
                      });
                    },
                  ),

                  // Жанр
                  _buildParameterDropdown(
                    label: 'Жанр',
                    value: _selectedGenre,
                    options: _genreOptions,
                    icon: Icons.category,
                    onChanged: (value) {
                      setState(() {
                        _selectedGenre = value!;
                      });
                    },
                  ),

                  // Эпоха
                  _buildParameterDropdown(
                    label: 'Эпоха',
                    value: _selectedEra,
                    options: _eraOptions,
                    icon: Icons.history,
                    onChanged: (value) {
                      setState(() {
                        _selectedEra = value!;
                      });
                    },
                  ),

                  // Уровень магии
                  _buildParameterDropdown(
                    label: 'Уровень магии',
                    value: _selectedMagicLevel,
                    options: _magicLevelOptions,
                    icon: Icons.auto_awesome,
                    onChanged: (value) {
                      setState(() {
                        _selectedMagicLevel = value!;
                      });
                    },
                  ),

                  // Уровень технологий
                  _buildParameterDropdown(
                    label: 'Уровень технологий',
                    value: _selectedTechLevel,
                    options: _techLevelOptions,
                    icon: Icons.computer,
                    onChanged: (value) {
                      setState(() {
                        _selectedTechLevel = value!;
                      });
                    },
                  ),

                  // Цвет мира
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: lightBrownColor.withOpacity(0.3),
                      ),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8.0),
                      onTap: _showColorPicker,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.color_lens,
                              color: primaryBrownColor,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Цвет мира',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: darkBrownColor.withOpacity(0.6),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      Container(
                                        width: 16,
                                        height: 16,
                                        decoration: BoxDecoration(
                                          color: _selectedColor,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: darkBrownColor.withOpacity(0.3),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          _getColorName(_selectedColor),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: darkBrownColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              color: darkBrownColor.withOpacity(0.5),
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // История мира
              Text(
                'История мира',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: darkBrownColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Основные события, эпохи, важные даты (необязательно)',
                style: TextStyle(
                  fontSize: 14,
                  color: darkBrownColor.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _historyController,
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: 'Опишите историю вашего мира...',
                  hintStyle: TextStyle(
                    color: darkBrownColor.withOpacity(0.4),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: lightBrownColor.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: primaryBrownColor,
                      width: 2.0,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.9),
                ),
                style: TextStyle(
                  fontSize: 16,
                  color: darkBrownColor,
                ),
              ),

              const SizedBox(height: 20),

              // Заметки мастера
              Text(
                'Заметки мастера',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: darkBrownColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Личные заметки, идеи для сюжета, планы (необязательно)',
                style: TextStyle(
                  fontSize: 14,
                  color: darkBrownColor.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _notesController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Добавьте заметки для себя...',
                  hintStyle: TextStyle(
                    color: darkBrownColor.withOpacity(0.4),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: lightBrownColor.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: primaryBrownColor,
                      width: 2.0,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.9),
                ),
                style: TextStyle(
                  fontSize: 16,
                  color: darkBrownColor,
                ),
              ),

              const SizedBox(height: 24),

              // Кнопка создания
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _createSetting,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBrownColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 2,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Создать мир',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Подсказка
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: parchmentColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: lightBrownColor.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: primaryBrownColor,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Вы всегда сможете добавить NPC, локации и детали после создания мира.',
                        style: TextStyle(
                          fontSize: 13,
                          color: darkBrownColor.withOpacity(0.7),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParameterDropdown({
    required String label,
    required String value,
    required List<String> options,
    required IconData icon,
    required ValueChanged<String?> onChanged,
  }) {
    final darkBrownColor = AppColors.darkBrown;
    final primaryBrownColor = AppColors.primaryBrown;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: AppColors.lightBrown.withOpacity(0.3),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: primaryBrownColor,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: darkBrownColor.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 2),
                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: value,
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: darkBrownColor.withOpacity(0.5),
                        size: 24,
                      ),
                      iconSize: 16,
                      elevation: 8,
                      style: TextStyle(
                        fontSize: 14,
                        color: darkBrownColor,
                        fontWeight: FontWeight.w500,
                      ),
                      dropdownColor: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      onChanged: onChanged,
                      items: options.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(
                              fontSize: 14,
                              color: darkBrownColor,
                            ),
                          ),
                        );
                      }).toList(),
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

  String _getColorName(Color color) {
    if (color.value == const Color(0xFF795548).value) return 'Коричневый';
    if (color.value == const Color(0xFF673AB7).value) return 'Фиолетовый';
    if (color.value == const Color(0xFF2196F3).value) return 'Синий';
    if (color.value == const Color(0xFFFF9800).value) return 'Оранжевый';
    if (color.value == const Color(0xFF4CAF50).value) return 'Зеленый';
    if (color.value == const Color(0xFFF44336).value) return 'Красный';
    if (color.value == const Color(0xFF9C27B0).value) return 'Пурпурный';
    if (color.value == const Color(0xFF00BCD4).value) return 'Бирюзовый';
    if (color.value == const Color(0xFF607D8B).value) return 'Серо-голубой';
    return 'Пользовательский';
  }
}