// lib/features/characters/presentation/screens/create_character_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '/core/constants/app_colors.dart';

class CreateCharacterScreen extends StatefulWidget {
  const CreateCharacterScreen({super.key});

  @override
  State<CreateCharacterScreen> createState() => _CreateCharacterScreenState();
}

class _CreateCharacterScreenState extends State<CreateCharacterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _playerNameController = TextEditingController();
  final _backstoryController = TextEditingController();

  String _selectedRace = 'Человек';
  String _selectedClass = 'Воин';
  String _selectedCampaign = 'Новая кампания';
  int _level = 1;
  int _selectedColorIndex = 0;

  final List<String> _races = [
    'Человек',
    'Эльф',
    'Дварф',
    'Халфлинг',
    'Гном',
    'Полуэльф',
    'Полуорк',
    'Тифлинг',
    'Драконорожденный',
    'Эльдар',
    'Аасимар',
  ];

  final List<String> _classes = [
    'Воин',
    'Волшебник',
    'Жрец',
    'Плут',
    'Варвар',
    'Бард',
    'Друид',
    'Паладин',
    'Следопыт',
    'Чародей',
    'Колдун',
    'Монах',
    'Изобретатель',
  ];

  final List<String> _campaigns = [
    'Новая кампания',
    'Проклятие Страда',
    'Королевство Под Горой',
    'Тени Недер-Рада',
    'Свет и Тьма',
    'Дыхание Дракона',
    'Механические Тайны',
  ];

  final List<Color> _avatarColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.purple,
    Colors.orange,
    Colors.teal,
    Colors.pink,
    Colors.brown,
    Colors.indigo,
    Colors.cyan,
  ];

  final Map<String, String> _raceDescriptions = {
    'Человек': 'Адаптирующиеся и амбициозные, люди быстро учатся и стремятся к величию.',
    'Эльф': 'Грациозные и долгоживущие, эльфы имеют острые чувства и магическую природу.',
    'Дварф': 'Выносливые и искусные в ремесле, дворфы известны своей стойкостью в битве.',
    'Халфлинг': 'Маленькие и проворные, халфлинги удачливы и склонны к приключениям.',
    'Гном': 'Любознательные и изобретательные, гномы мастера иллюзий и механизмов.',
    'Полуэльф': 'Сочетают лучшие черты людей и эльфов, адаптируясь к любым обстоятельствам.',
    'Полуорк': 'Сильные и выносливые, полуорки часто сталкиваются с предрассудками.',
    'Тифлинг': 'Потомки демонов, тифлинги обладают врожденными магическими способностями.',
    'Драконорожденный': 'Потомки драконов, они сильны, харизматичны и могут дышать огнем.',
    'Эльдар': 'Древние и мудрые эльфы с глубокой связью с магией природы.',
    'Аасимар': 'Благословленные небесами, они несут в себе божественную искру.',
  };

  final Map<String, String> _classDescriptions = {
    'Воин': 'Мастер оружия и доспеха, боец, который полагается на силу и тактику.',
    'Волшебник': 'Ученый магии, изучающий свитки и заклинания через интеллект.',
    'Жрец': 'Посредник между миром смертных и божественным, исцеляющий и защищающий.',
    'Плут': 'Ловкий и хитрый, мастер скрытности, ловушек и точных ударов.',
    'Варвар': 'Неистовый воин, черпающий силу из ярости и природной энергии.',
    'Бард': 'Мастер искусства и магии, вдохновляющий союзников и контролирующий врагов.',
    'Друид': 'Хранитель природы, способный принимать формы животных и управлять стихиями.',
    'Паладин': 'Святой воин, клянущийся защищать добро и уничтожать зло божественной силой.',
    'Следопыт': 'Охотник и следопыт, мастер выживания в дикой природе и боя на дистанции.',
    'Чародей': 'Носитель врожденной магической силы, которая течет в их крови.',
    'Колдун': 'Заключивший пакт с могущественным существом, получающий магию через договор.',
    'Монах': 'Мастер боевых искусств, использующий внутреннюю энергию ки для сверхчеловеческих подвигов.',
    'Изобретатель': 'Гений, создающий механические устройства и алхимические смеси.',
  };

  @override
  void dispose() {
    _nameController.dispose();
    _playerNameController.dispose();
    _backstoryController.dispose();
    super.dispose();
  }

  void _createCharacter() {
    if (_formKey.currentState!.validate()) {
      // TODO: Реализовать сохранение персонажа в базу данных
      final newCharacter = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'name': _nameController.text,
        'playerName': _playerNameController.text,
        'race': _selectedRace,
        'class': _selectedClass,
        'level': _level,
        'campaign': _selectedCampaign,
        'backstory': _backstoryController.text,
        'avatarColor': _avatarColors[_selectedColorIndex],
        'createdAt': DateTime.now().toIso8601String(),
        'lastPlayed': DateTime.now().toIso8601String(),
      };

      // Показать уведомление об успехе
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Персонаж "${_nameController.text}" создан!',
            style: GoogleFonts.cinzel(),
          ),
          backgroundColor: AppColors.successGreen,
          duration: const Duration(seconds: 2),
        ),
      );

      // Вернуться на экран списка персонажей
      context.pop();
    }
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required String? Function(String?) validator,
    int maxLines = 1,
    bool required = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: GoogleFonts.cinzel(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.darkBrown,
              ),
            ),
            if (required)
              Text(
                ' *',
                style: GoogleFonts.cinzel(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.errorRed,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          maxLines: maxLines,
          style: GoogleFonts.cinzel(
            fontSize: 16,
            color: AppColors.darkBrown,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.parchment.withOpacity(0.7),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.lightBrown.withOpacity(0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.lightBrown.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primaryBrown),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            hintStyle: GoogleFonts.cinzel(
              color: AppColors.woodBrown.withOpacity(0.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectionCard({
    required String title,
    required String value,
    required String description,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.lightBrown.withOpacity(0.2)),
      ),
      color: AppColors.parchment.withOpacity(0.8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.cinzel(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkBrown,
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down_rounded,
                    color: AppColors.darkBrown,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: GoogleFonts.cinzel(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryBrown,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: GoogleFonts.cinzel(
                  fontSize: 14,
                  color: AppColors.woodBrown,
                  fontStyle: FontStyle.italic,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRaceSelection() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.parchment.withOpacity(0.98),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Выберите расу',
                  style: GoogleFonts.cinzel(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkBrown,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _races.length,
                  itemBuilder: (context, index) {
                    final race = _races[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      color: _selectedRace == race
                          ? AppColors.primaryBrown.withOpacity(0.1)
                          : AppColors.parchment.withOpacity(0.9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: _selectedRace == race
                              ? AppColors.primaryBrown
                              : AppColors.lightBrown.withOpacity(0.2),
                          width: _selectedRace == race ? 2 : 1,
                        ),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          setState(() {
                            _selectedRace = race;
                          });
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                race,
                                style: GoogleFonts.cinzel(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.darkBrown,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _raceDescriptions[race] ?? '',
                                style: GoogleFonts.cinzel(
                                  fontSize: 14,
                                  color: AppColors.woodBrown,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showClassSelection() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.parchment.withOpacity(0.98),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Выберите класс',
                  style: GoogleFonts.cinzel(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkBrown,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _classes.length,
                  itemBuilder: (context, index) {
                    final charClass = _classes[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      color: _selectedClass == charClass
                          ? AppColors.accentGold.withOpacity(0.1)
                          : AppColors.parchment.withOpacity(0.9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: _selectedClass == charClass
                              ? AppColors.accentGold
                              : AppColors.lightBrown.withOpacity(0.2),
                          width: _selectedClass == charClass ? 2 : 1,
                        ),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          setState(() {
                            _selectedClass = charClass;
                          });
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                charClass,
                                style: GoogleFonts.cinzel(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.darkBrown,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _classDescriptions[charClass] ?? '',
                                style: GoogleFonts.cinzel(
                                  fontSize: 14,
                                  color: AppColors.woodBrown,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showCampaignSelection() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.parchment.withOpacity(0.98),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Выберите кампанию',
                  style: GoogleFonts.cinzel(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkBrown,
                  ),
                ),
              ),
              ..._campaigns.map((campaign) {
                return ListTile(
                  title: Text(
                    campaign,
                    style: GoogleFonts.cinzel(
                      fontSize: 16,
                      color: AppColors.darkBrown,
                    ),
                  ),
                  trailing: _selectedCampaign == campaign
                      ? Icon(Icons.check_rounded, color: AppColors.accentGold)
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedCampaign = campaign;
                    });
                    Navigator.pop(context);
                  },
                );
              }),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLevelSelector() {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.lightBrown.withOpacity(0.2)),
      ),
      color: AppColors.parchment.withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Уровень',
              style: GoogleFonts.cinzel(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.darkBrown,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: _level > 1
                      ? () {
                    setState(() {
                      _level--;
                    });
                  }
                      : null,
                  icon: Icon(
                    Icons.remove_circle_outline_rounded,
                    color: _level > 1 ? AppColors.primaryBrown : AppColors.lightBrown,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.accentGold.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.accentGold.withOpacity(0.3)),
                  ),
                  child: Text(
                    'Уровень $_level',
                    style: GoogleFonts.cinzel(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.accentGold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _level < 20
                      ? () {
                    setState(() {
                      _level++;
                    });
                  }
                      : null,
                  icon: Icon(
                    Icons.add_circle_outline_rounded,
                    color: _level < 20 ? AppColors.primaryBrown : AppColors.lightBrown,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Стандартный уровень для начала игры - 1',
              style: GoogleFonts.cinzel(
                fontSize: 14,
                color: AppColors.woodBrown,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarColorSelector() {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.lightBrown.withOpacity(0.2)),
      ),
      color: AppColors.parchment.withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Цвет аватара',
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
              children: List.generate(_avatarColors.length, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColorIndex = index;
                    });
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: _avatarColors[index].withOpacity(0.2),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: _selectedColorIndex == index
                            ? _avatarColors[index]
                            : _avatarColors[index].withOpacity(0.3),
                        width: _selectedColorIndex == index ? 3 : 2,
                      ),
                      boxShadow: _selectedColorIndex == index
                          ? [
                        BoxShadow(
                          color: _avatarColors[index].withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ]
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        _nameController.text.isNotEmpty
                            ? _nameController.text[0].toUpperCase()
                            : '?',
                        style: GoogleFonts.cinzel(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: _avatarColors[index],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          'Создание персонажа',
          style: GoogleFonts.cinzel(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.darkBrown,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Сохранить как черновик
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Черновик сохранен',
                    style: GoogleFonts.cinzel(),
                  ),
                  backgroundColor: AppColors.infoBlue,
                ),
              );
            },
            icon: Icon(Icons.save_rounded, color: AppColors.darkBrown),
            tooltip: 'Сохранить черновик',
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Заголовок
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: _avatarColors[_selectedColorIndex].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(60),
                    border: Border.all(
                      color: _avatarColors[_selectedColorIndex],
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _avatarColors[_selectedColorIndex].withOpacity(0.2),
                        blurRadius: 15,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      _nameController.text.isNotEmpty
                          ? _nameController.text[0].toUpperCase()
                          : '?',
                      style: GoogleFonts.cinzel(
                        fontSize: 48,
                        fontWeight: FontWeight.w800,
                        color: _avatarColors[_selectedColorIndex],
                      ),
                    ),
                  ),
                ),
              ),

              // Имя персонажа
              _buildFormField(
                label: 'Имя персонажа',
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите имя персонажа';
                  }
                  if (value.length < 2) {
                    return 'Имя должно быть не короче 2 символов';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Имя игрока
              _buildFormField(
                label: 'Имя игрока',
                controller: _playerNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите имя игрока';
                  }
                  return null;
                },
                required: false,
              ),

              const SizedBox(height: 20),

              // Раса и класс
              _buildSelectionCard(
                title: 'Раса',
                value: _selectedRace,
                description: _raceDescriptions[_selectedRace] ?? '',
                onTap: _showRaceSelection,
              ),

              _buildSelectionCard(
                title: 'Класс',
                value: _selectedClass,
                description: _classDescriptions[_selectedClass] ?? '',
                onTap: _showClassSelection,
              ),

              // Уровень
              _buildLevelSelector(),

              // Кампания
              Card(
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: AppColors.lightBrown.withOpacity(0.2)),
                ),
                color: AppColors.parchment.withOpacity(0.8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: _showCampaignSelection,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Кампания',
                          style: GoogleFonts.cinzel(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkBrown,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedCampaign,
                              style: GoogleFonts.cinzel(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryBrown,
                              ),
                            ),
                            Icon(
                              Icons.arrow_drop_down_rounded,
                              color: AppColors.darkBrown,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Цвет аватара
              _buildAvatarColorSelector(),

              // Предыстория
              _buildFormField(
                label: 'Предыстория',
                controller: _backstoryController,
                validator: (value) => null, // Необязательное поле
                maxLines: 4,
                required: false,
              ),

              const SizedBox(height: 32),

              // Кнопки
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: AppColors.primaryBrown),
                      ),
                      child: Text(
                        'Отмена',
                        style: GoogleFonts.cinzel(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryBrown,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _createCharacter,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentGold,
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
                          const Icon(Icons.check_rounded, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Создать',
                            style: GoogleFonts.cinzel(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}