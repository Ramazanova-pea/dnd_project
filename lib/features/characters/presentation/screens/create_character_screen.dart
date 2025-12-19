// lib/features/characters/presentation/screens/create_character_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

import '/core/constants/app_colors.dart';
import '/core/providers/character_providers.dart';
import '/core/providers/campaign_providers.dart';
import '/core/providers/reference_providers.dart';
import '/domain/models/character.dart';
import 'dart:math';

class CreateCharacterScreen extends ConsumerStatefulWidget {
  const CreateCharacterScreen({super.key});

  @override
  ConsumerState<CreateCharacterScreen> createState() => _CreateCharacterScreenState();
}

class _CreateCharacterScreenState extends ConsumerState<CreateCharacterScreen> {
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

  // Список кампаний будет загружаться из провайдера

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

  /// Генерация случайного персонажа с использованием Random User API
  Future<void> _generateRandomCharacter() async {
    bool isDialogOpen = false;
    try {
      // Показываем индикатор загрузки
      if (!mounted) return;
      
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    'Генерация персонажа...\nПервый запрос может занять время',
                    style: GoogleFonts.cinzel(),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      isDialogOpen = true;

      // Получаем случайного пользователя напрямую через API клиент
      // Retry логика встроена в API клиент
      final apiClient = ref.read(randomUserApiClientProvider);
      final randomUser = await apiClient.getRandomUser();
      
      // Получаем списки рас и классов из API
      final races = await ref.read(racesProvider.future);
      final classes = await ref.read(classesProvider.future);

      if (!mounted) {
        if (isDialogOpen) {
          try {
            Navigator.of(context, rootNavigator: false).pop();
          } catch (e) {
            // Игнорируем ошибки
          }
          isDialogOpen = false;
        }
        return;
      }

      // Извлекаем данные из ответа API
      final userData = randomUser['results'][0] as Map<String, dynamic>;
      final nameData = userData['name'] as Map<String, dynamic>;
      final firstName = nameData['first'] as String;
      final lastName = nameData['last'] as String;
      final fullName = '$firstName $lastName';
      
      // Случайно выбираем расу и класс
      final random = Random();
      
      // Маппинг имен из API на локальные имена
      String mapRaceName(String apiName) {
        final raceMap = {
          'human': 'Человек',
          'elf': 'Эльф',
          'dwarf': 'Дварф',
          'halfling': 'Халфлинг',
          'gnome': 'Гном',
          'half-elf': 'Полуэльф',
          'half-orc': 'Полуорк',
          'tiefling': 'Тифлинг',
          'dragonborn': 'Драконорожденный',
        };
        return raceMap[apiName.toLowerCase()] ?? apiName;
      }
      
      String mapClassName(String apiName) {
        final classMap = {
          'fighter': 'Воин',
          'wizard': 'Волшебник',
          'cleric': 'Жрец',
          'rogue': 'Плут',
          'barbarian': 'Варвар',
          'bard': 'Бард',
          'druid': 'Друид',
          'paladin': 'Паладин',
          'ranger': 'Следопыт',
          'sorcerer': 'Чародей',
          'warlock': 'Колдун',
          'monk': 'Монах',
        };
        return classMap[apiName.toLowerCase()] ?? apiName;
      }

      // Выбираем расу и класс
      String selectedRace;
      String selectedClass;
      
      if (races.isNotEmpty) {
        final randomRace = races[random.nextInt(races.length)];
        // Используем index для маппинга, так как в API это ключ
        final mappedRace = mapRaceName(randomRace.index);
        // Проверяем, есть ли такая раса в локальном списке
        selectedRace = _races.contains(mappedRace) 
            ? mappedRace 
            : _races[random.nextInt(_races.length)];
      } else {
        selectedRace = _races[random.nextInt(_races.length)];
      }
      
      if (classes.isNotEmpty) {
        final randomClass = classes[random.nextInt(classes.length)];
        // Используем index для маппинга, так как в API это ключ
        final mappedClass = mapClassName(randomClass.index);
        // Проверяем, есть ли такой класс в локальном списке
        selectedClass = _classes.contains(mappedClass)
            ? mappedClass
            : _classes[random.nextInt(_classes.length)];
      } else {
        selectedClass = _classes[random.nextInt(_classes.length)];
      }

      if (!mounted) {
        if (isDialogOpen) {
          try {
            Navigator.of(context, rootNavigator: false).pop();
          } catch (e) {
            // Игнорируем ошибки
          }
          isDialogOpen = false;
        }
        return;
      }

      // Генерируем случайную предысторию на основе данных пользователя
      final location = userData['location'] as Map<String, dynamic>?;
      final city = location?['city'] as String? ?? 'неизвестном городе';
      final country = location?['country'] as String? ?? 'далеких землях';
      final age = userData['dob']?['age'] as int? ?? 25;
      
      final backstory = 
          '$fullName родился в $city, в $country. '
          'В возрасте $age лет $fullName решил стать искателем приключений. '
          'С детства проявлял интерес к приключениям и магии. '
          'Теперь готов отправиться в опасное путешествие.';

      // Заполняем форму
      setState(() {
        _nameController.text = fullName;
        _playerNameController.text = firstName;
        _selectedRace = selectedRace;
        _selectedClass = selectedClass;
        _level = 1 + random.nextInt(5); // Уровень от 1 до 5
        _selectedColorIndex = random.nextInt(_avatarColors.length);
        _backstoryController.text = backstory;
      });

      if (!mounted) {
        if (isDialogOpen) {
          Navigator.pop(context);
          isDialogOpen = false;
        }
        return;
      }

      // Создаем и сохраняем персонажа в локальное хранилище
      try {
        final character = Character(
          id: const Uuid().v4(),
          name: fullName,
          race: selectedRace,
          characterClass: selectedClass,
          level: _level,
          campaign: _selectedCampaign == 'Новая кампания' ? null : _selectedCampaign,
          lastPlayed: DateTime.now(),
        );

        // Сохраняем в Hive
        await ref.read(createCharacterProvider(character).future);

        // Закрываем диалог загрузки после успешного сохранения
        if (isDialogOpen && mounted) {
          try {
            Navigator.of(context, rootNavigator: false).pop();
          } catch (e) {
            // Игнорируем ошибки
          }
          isDialogOpen = false;
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Случайный персонаж "${character.name}" создан и сохранен!',
                style: GoogleFonts.cinzel(),
              ),
              backgroundColor: AppColors.successGreen,
              duration: const Duration(seconds: 3),
            ),
          );
          // Закрываем экран создания и возвращаемся к списку персонажей
          context.pop();
        }
      } catch (saveError) {
        // Закрываем диалог даже при ошибке сохранения
        if (isDialogOpen && mounted) {
          try {
            Navigator.of(context, rootNavigator: false).pop();
          } catch (e) {
            // Игнорируем ошибки
          }
          isDialogOpen = false;
        }
        
        // Если сохранение не удалось, все равно показываем заполненную форму
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Персонаж создан, но не сохранен: $saveError',
                style: GoogleFonts.cinzel(),
              ),
              backgroundColor: AppColors.errorRed,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      // Ошибка обрабатывается в finally блоке
      if (mounted) {
        String errorMessage = 'Ошибка генерации персонажа';
        final errorString = e.toString();
        
        // Более понятные сообщения для пользователя
        if (errorString.contains('Network Error') || 
            errorString.contains('connection') ||
            errorString.contains('XMLHttpRequest')) {
          errorMessage = 'Ошибка сети. Проверьте интернет-соединение и попробуйте снова.';
        } else if (errorString.contains('timeout') || errorString.contains('Таймаут')) {
          errorMessage = 'Превышено время ожидания. Проверьте интернет-соединение.';
        } else if (errorString.contains('API Error')) {
          errorMessage = 'Ошибка API. Сервис временно недоступен.';
        } else {
          errorMessage = 'Ошибка: ${e.toString()}';
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              errorMessage,
              style: GoogleFonts.cinzel(),
            ),
            backgroundColor: AppColors.errorRed,
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: 'Повторить',
              textColor: Colors.white,
              onPressed: () => _generateRandomCharacter(),
            ),
          ),
        );
      }
    } finally {
      // Гарантируем закрытие диалога в любом случае
      // Проверяем, открыт ли диалог, и закрываем его
      if (mounted) {
        try {
          // Пытаемся закрыть диалог, если он открыт
          if (isDialogOpen) {
            Navigator.of(context, rootNavigator: false).pop();
            isDialogOpen = false;
          }
        } catch (e) {
          // Игнорируем ошибки при закрытии диалога
          // (например, если диалог уже был закрыт)
        }
      }
    }
  }

  Future<void> _createCharacter() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      // Создаем персонажа
      final character = Character(
        id: const Uuid().v4(),
        name: _nameController.text,
        race: _selectedRace,
        characterClass: _selectedClass,
        level: _level,
        campaign: _selectedCampaign == 'Новая кампания' ? null : _selectedCampaign,
        lastPlayed: DateTime.now(),
      );

      // Сохраняем в Hive
      await ref.read(createCharacterProvider(character).future);

      if (mounted) {
        // Показать уведомление об успехе
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Персонаж "${character.name}" создан!',
              style: GoogleFonts.cinzel(),
            ),
            backgroundColor: AppColors.successGreen,
            duration: const Duration(seconds: 2),
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Ошибка создания персонажа: $e',
              style: GoogleFonts.cinzel(),
            ),
            backgroundColor: AppColors.errorRed,
          ),
        );
      }
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
    final campaignsAsync = ref.read(campaignsProvider);
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.parchment.withOpacity(0.98),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: campaignsAsync.when(
            data: (campaigns) {
              final campaignNames = ['Новая кампания', ...campaigns.map((c) => c.name)];
              return Column(
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
                  ...campaignNames.map((campaign) {
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
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            ),
            error: (error, stack) => Padding(
              padding: const EdgeInsets.all(20),
              child: Text('Ошибка загрузки кампаний: $error'),
            ),
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
            onPressed: _generateRandomCharacter,
            icon: Icon(Icons.auto_awesome_rounded, color: AppColors.darkBrown),
            tooltip: 'Создать случайного персонажа',
          ),
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

              // Кнопка генерации случайного персонажа
              Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  child: ElevatedButton.icon(
                    onPressed: _generateRandomCharacter,
                    icon: const Icon(Icons.auto_awesome_rounded),
                    label: Text(
                      'Создать случайного персонажа',
                      style: GoogleFonts.cinzel(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.infoBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
              ),

              // Разделитель
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: AppColors.lightBrown.withOpacity(0.3),
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'или заполните вручную',
                        style: GoogleFonts.cinzel(
                          fontSize: 14,
                          color: AppColors.woodBrown,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: AppColors.lightBrown.withOpacity(0.3),
                        thickness: 1,
                      ),
                    ),
                  ],
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