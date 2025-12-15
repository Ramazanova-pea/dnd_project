import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '/core/constants/app_colors.dart';

class CreateNpcScreen extends ConsumerStatefulWidget {
  final String settingId;

  const CreateNpcScreen({
    Key? key,
    required this.settingId,
  }) : super(key: key);

  @override
  ConsumerState<CreateNpcScreen> createState() => _CreateNpcScreenState();
}

class _CreateNpcScreenState extends ConsumerState<CreateNpcScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _personalityController = TextEditingController();
  final TextEditingController _appearanceController = TextEditingController();
  final TextEditingController _motivationsController = TextEditingController();
  final TextEditingController _secretsController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // Значения по умолчанию
  String _selectedType = 'Персонаж';
  String _selectedImportance = 'Второстепенный';
  String _selectedAlignment = 'Нейтральное';
  String _selectedRace = 'Человек';
  String _selectedGender = 'Мужской';
  String _selectedStatus = 'Жив';
  int _selectedAge = 30;
  Color _selectedColor = const Color(0xFF795548);

  // Статистика
  int _strength = 10;
  int _dexterity = 10;
  int _constitution = 10;
  int _intelligence = 10;
  int _wisdom = 10;
  int _charisma = 10;

  // Списки выбора
  final List<String> _typeOptions = ['Персонаж', 'Монстр', 'Существо', 'Божество'];
  final List<String> _importanceOptions = ['Ключевой', 'Второстепенный', 'Эпизодический'];
  final List<String> _alignmentOptions = [
    'Законопослушный-добрый',
    'Нейтрально-добрый',
    'Хаотично-добрый',
    'Законопослушный-нейтральный',
    'Нейтральное',
    'Хаотично-нейтральный',
    'Законопослушный-злое',
    'Нейтрально-злое',
    'Хаотично-злое',
  ];
  final List<String> _raceOptions = [
    'Человек', 'Эльф', 'Дварф', 'Халфлинг', 'Гном', 'Тифлинг',
    'Драконорождённый', 'Полуорк', 'Полуэльф', 'Орк', 'Гоблин',
    'Дракон', 'Демон', 'Ангел', 'Дух', 'Нежить', 'Конструкт',
  ];
  final List<String> _genderOptions = ['Мужской', 'Женский', 'Не определено'];
  final List<String> _statusOptions = ['Жив', 'Мёртв', 'Нежить', 'Бессмертный', 'Неизвестно'];

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
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _roleController.dispose();
    _locationController.dispose();
    _personalityController.dispose();
    _appearanceController.dispose();
    _motivationsController.dispose();
    _secretsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _createNpc() {
    if (_formKey.currentState!.validate()) {
      // В реальном приложении здесь будет сохранение в базу данных
      final newNpc = {
        'name': _nameController.text,
        'description': _descriptionController.text,
        'type': _selectedType,
        'importance': _selectedImportance,
        'alignment': _selectedAlignment,
        'race': _selectedRace,
        'gender': _selectedGender,
        'age': _selectedAge,
        'role': _roleController.text,
        'location': _locationController.text,
        'status': _selectedStatus,
        'personality': _personalityController.text.isNotEmpty
            ? _personalityController.text.split('\n')
            : [],
        'appearance': _appearanceController.text.isNotEmpty
            ? _appearanceController.text.split('\n')
            : [],
        'motivations': _motivationsController.text.isNotEmpty
            ? _motivationsController.text.split('\n')
            : [],
        'secrets': _secretsController.text.isNotEmpty
            ? _secretsController.text.split('\n')
            : [],
        'notes': _notesController.text,
        'color': _selectedColor,
        'stats': {
          'strength': _strength,
          'dexterity': _dexterity,
          'constitution': _constitution,
          'intelligence': _intelligence,
          'wisdom': _wisdom,
          'charisma': _charisma,
        },
      };

      // Показать сообщение об успехе
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.successGreen,
          content: Text('Персонаж успешно создан!'),
          duration: Duration(seconds: 2),
        ),
      );

      // Вернуться назад
      Future.delayed(const Duration(milliseconds: 500), () {
        context.pop();
      });
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
                'Выберите цвет персонажа',
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

  Widget _buildStatSlider({
    required String label,
    required String abbreviation,
    required int value,
    required Color color,
    required ValueChanged<double> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: AppColors.lightBrown.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.darkBrown,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6.0),
                ),
                child: Text(
                  '$abbreviation: $value',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Slider(
            value: value.toDouble(),
            min: 1,
            max: 20,
            divisions: 19,
            label: value.toString(),
            activeColor: color,
            inactiveColor: color.withOpacity(0.3),
            onChanged: onChanged,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '1',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.darkBrown.withOpacity(0.5),
                ),
              ),
              Text(
                '10',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.darkBrown.withOpacity(0.5),
                ),
              ),
              Text(
                '20',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.darkBrown.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ],
      ),
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
          'Создание персонажа',
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
            onPressed: _createNpc,
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
                          Icons.person,
                          color: primaryBrownColor,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Создание NPC',
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
                      'Заполните информацию о новом персонаже для вашего мира. '
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

              // Имя
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Имя персонажа *',
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
                    Icons.person,
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
                    return 'Введите имя персонажа';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Описание
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Краткое описание *',
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
                    return 'Введите описание персонажа';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Параметры персонажа
              Text(
                'Параметры персонажа',
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
                childAspectRatio: 2.5,
                children: [
                  // Тип
                  _buildParameterDropdown(
                    label: 'Тип',
                    value: _selectedType,
                    options: _typeOptions,
                    icon: Icons.category,
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value!;
                      });
                    },
                  ),

                  // Важность
                  _buildParameterDropdown(
                    label: 'Важность',
                    value: _selectedImportance,
                    options: _importanceOptions,
                    icon: Icons.star,
                    onChanged: (value) {
                      setState(() {
                        _selectedImportance = value!;
                      });
                    },
                  ),

                  // Раса
                  _buildParameterDropdown(
                    label: 'Раса',
                    value: _selectedRace,
                    options: _raceOptions,
                    icon: Icons.people,
                    onChanged: (value) {
                      setState(() {
                        _selectedRace = value!;
                      });
                    },
                  ),

                  // Пол
                  _buildParameterDropdown(
                    label: 'Пол',
                    value: _selectedGender,
                    options: _genderOptions,
                    icon: Icons.person_outline,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value!;
                      });
                    },
                  ),

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

                  // Цвет
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
                                    'Цвет',
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
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Возраст
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: lightBrownColor.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Возраст: $_selectedAge ${_getAgeWord(_selectedAge)}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: darkBrownColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Slider(
                      value: _selectedAge.toDouble(),
                      min: 0,
                      max: 500,
                      divisions: 50,
                      label: _selectedAge.toString(),
                      activeColor: primaryBrownColor,
                      inactiveColor: primaryBrownColor.withOpacity(0.3),
                      onChanged: (value) {
                        setState(() {
                          _selectedAge = value.round();
                        });
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Мировоззрение
              _buildParameterDropdown(
                label: 'Мировоззрение',
                value: _selectedAlignment,
                options: _alignmentOptions,
                icon: Icons.psychology,
                onChanged: (value) {
                  setState(() {
                    _selectedAlignment = value!;
                  });
                },
              ),

              const SizedBox(height: 20),

              // Роль и локация
              Text(
                'Роль и местоположение',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: darkBrownColor,
                ),
              ),
              const SizedBox(height: 12),

              // Роль
              TextFormField(
                controller: _roleController,
                decoration: InputDecoration(
                  labelText: 'Роль в мире',
                  labelStyle: TextStyle(
                    color: darkBrownColor.withOpacity(0.6),
                  ),
                  hintText: 'Например: король, купец, маг...',
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
                  prefixIcon: Icon(
                    Icons.work,
                    color: primaryBrownColor,
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.9),
                ),
                style: TextStyle(
                  fontSize: 16,
                  color: darkBrownColor,
                ),
              ),

              const SizedBox(height: 16),

              // Локация
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Местоположение',
                  labelStyle: TextStyle(
                    color: darkBrownColor.withOpacity(0.6),
                  ),
                  hintText: 'Где можно встретить этого персонажа',
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
                  prefixIcon: Icon(
                    Icons.location_on,
                    color: primaryBrownColor,
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

              // Характеристики
              Text(
                'Характеристики',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: darkBrownColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Укажите базовые характеристики персонажа (от 1 до 20)',
                style: TextStyle(
                  fontSize: 14,
                  color: darkBrownColor.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 12),

              Column(
                children: [
                  // Сила
                  _buildStatSlider(
                    label: 'Сила',
                    abbreviation: 'СИЛ',
                    value: _strength,
                    color: Colors.red,
                    onChanged: (value) {
                      setState(() {
                        _strength = value.round();
                      });
                    },
                  ),

                  const SizedBox(height: 12),

                  // Ловкость
                  _buildStatSlider(
                    label: 'Ловкость',
                    abbreviation: 'ЛОВ',
                    value: _dexterity,
                    color: Colors.green,
                    onChanged: (value) {
                      setState(() {
                        _dexterity = value.round();
                      });
                    },
                  ),

                  const SizedBox(height: 12),

                  // Телосложение
                  _buildStatSlider(
                    label: 'Телосложение',
                    abbreviation: 'ТЕЛ',
                    value: _constitution,
                    color: Colors.orange,
                    onChanged: (value) {
                      setState(() {
                        _constitution = value.round();
                      });
                    },
                  ),

                  const SizedBox(height: 12),

                  // Интеллект
                  _buildStatSlider(
                    label: 'Интеллект',
                    abbreviation: 'ИНТ',
                    value: _intelligence,
                    color: Colors.blue,
                    onChanged: (value) {
                      setState(() {
                        _intelligence = value.round();
                      });
                    },
                  ),

                  const SizedBox(height: 12),

                  // Мудрость
                  _buildStatSlider(
                    label: 'Мудрость',
                    abbreviation: 'МДР',
                    value: _wisdom,
                    color: Colors.purple,
                    onChanged: (value) {
                      setState(() {
                        _wisdom = value.round();
                      });
                    },
                  ),

                  const SizedBox(height: 12),

                  // Харизма
                  _buildStatSlider(
                    label: 'Харизма',
                    abbreviation: 'ХАР',
                    value: _charisma,
                    color: Colors.pink,
                    onChanged: (value) {
                      setState(() {
                        _charisma = value.round();
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Дополнительная информация
              Text(
                'Дополнительная информация',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: darkBrownColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Заполните по желанию для более детальной проработки персонажа',
                style: TextStyle(
                  fontSize: 14,
                  color: darkBrownColor.withOpacity(0.6),
                ),
              ),

              const SizedBox(height: 12),

              // Личность
              _buildMultilineField(
                controller: _personalityController,
                label: 'Черты личности',
                hint: 'По одной черте на строку\nНапример:\nХрабрый\nЧестный\nСаркастичный',
                icon: Icons.psychology_outlined,
              ),

              const SizedBox(height: 16),

              // Внешность
              _buildMultilineField(
                controller: _appearanceController,
                label: 'Внешний вид',
                hint: 'По одному элементу на строку\nНапример:\nВысокий, стройный\nРыжие волосы\nШрам на щеке',
                icon: Icons.face,
              ),

              const SizedBox(height: 16),

              // Мотивации
              _buildMultilineField(
                controller: _motivationsController,
                label: 'Мотивации и цели',
                hint: 'По одной цели на строку\nНапример:\nЗащитить семью\nСтать королём\nНайти древний артефакт',
                icon: Icons.flag,
              ),

              const SizedBox(height: 16),

              // Секреты
              _buildMultilineField(
                controller: _secretsController,
                label: 'Секреты',
                hint: 'По одному секрету на строку\nНапример:\nТайный член культа\nВнебрачный ребёнок\nУкрал королевскую печать',
                icon: Icons.lock,
              ),

              const SizedBox(height: 20),

              // Заметки мастера
              TextFormField(
                controller: _notesController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Заметки мастера',
                  labelStyle: TextStyle(
                    color: darkBrownColor.withOpacity(0.6),
                  ),
                  hintText: 'Личные заметки, идеи для сюжета, планы взаимодействия с игроками...',
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
                  prefixIcon: Icon(
                    Icons.note,
                    color: primaryBrownColor,
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
                  onPressed: _createNpc,
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
                        'Создать персонажа',
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
                        'Вы всегда сможете добавить отношения, квесты и способности после создания персонажа.',
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

  Widget _buildMultilineField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    final darkBrownColor = AppColors.darkBrown;
    final primaryBrownColor = AppColors.primaryBrown;
    final lightBrownColor = AppColors.lightBrown;

    return TextFormField(
      controller: controller,
      maxLines: 3,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: darkBrownColor.withOpacity(0.6),
        ),
        hintText: hint,
        hintStyle: TextStyle(
          color: darkBrownColor.withOpacity(0.4),
          fontSize: 14,
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
          icon,
          color: primaryBrownColor,
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
      ),
      style: TextStyle(
        fontSize: 16,
        color: darkBrownColor,
      ),
    );
  }

  String _getAgeWord(int age) {
    if (age % 10 == 1 && age % 100 != 11) return 'год';
    if (age % 10 >= 2 && age % 10 <= 4 && (age % 100 < 10 || age % 100 >= 20)) return 'года';
    return 'лет';
  }
}