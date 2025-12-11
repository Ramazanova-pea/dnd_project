import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dnd_project/core/constants/app_colors.dart';
import 'package:dnd_project/features/auth/presentation/providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _titleFadeAnimation;
  late Animation<double> _subtitleFadeAnimation;
  late Animation<double> _loadingFadeAnimation;

  bool _isInitialized = false;
  bool _showLoading = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // Анимация масштабирования логотипа
    _logoScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.5, end: 1.2),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0),
        weight: 50,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeInOut),
      ),
    );

    // Анимация появления элементов
    _logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );

    _titleFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 0.6, curve: Curves.easeOut),
      ),
    );

    _subtitleFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.5, 0.8, curve: Curves.easeOut),
      ),
    );

    _loadingFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.7, 1.0, curve: Curves.easeIn),
      ),
    );

    // Запускаем анимации
    _animationController.forward().then((_) {
      setState(() {
        _showLoading = true;
      });
      _initializeApp();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(milliseconds: 1500));

    final authState = ref.read(authProvider);

    if (mounted) {
      setState(() {
        _isInitialized = true;
      });

      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        if (authState.isAuthenticated) {
          context.go('/home');
        } else {
          context.go('/login');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.loginGradient,
          ),
        ),
        child: Stack(
          children: [
            // Декоративные элементы фона
            Positioned(
              top: -50,
              left: -30,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accentGold.withOpacity(0.05),
                ),
              ),
            ),
            Positioned(
              bottom: -40,
              right: -40,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.parchment.withOpacity(0.03),
                ),
              ),
            ),
            Positioned(
              top: '30%'.parsePercentage(context),
              right: '10%'.parsePercentage(context),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.lightBrown.withOpacity(0.04),
                ),
              ),
            ),

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Логотип с анимацией
                  ScaleTransition(
                    scale: _logoScaleAnimation,
                    child: FadeTransition(
                      opacity: _logoFadeAnimation,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          color: AppColors.parchment.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: AppColors.accentGold.withOpacity(0.4),
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 2,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.castle_rounded,
                          size: 80,
                          color: AppColors.accentGold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Заголовок
                  FadeTransition(
                    opacity: _titleFadeAnimation,
                    child: Text(
                      'DUNGEONS &\nDRAGONS',
                      style: GoogleFonts.cinzel(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        color: AppColors.parchment,
                        letterSpacing: 2.0,
                        height: 1.2,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 6,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Подзаголовок
                  FadeTransition(
                    opacity: _subtitleFadeAnimation,
                    child: Text(
                      'Мастерская приключений',
                      style: GoogleFonts.cinzel(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        color: AppColors.lightBrown,
                        letterSpacing: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 60),

                  // Индикатор загрузки
                  if (_showLoading)
                    FadeTransition(
                      opacity: _loadingFadeAnimation,
                      child: Column(
                        children: [
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: AppColors.accentGold,
                              backgroundColor: AppColors.accentGold.withOpacity(0.2),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            _isInitialized ? 'Вход в мир...' : 'Подготовка карт...',
                            style: GoogleFonts.cinzel(
                              fontSize: 14,
                              color: AppColors.lightBrown,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // Декоративные элементы внизу
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _subtitleFadeAnimation,
                child: Column(
                  children: [
                    Container(
                      height: 1,
                      margin: const EdgeInsets.symmetric(horizontal: 60),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            AppColors.accentGold.withOpacity(0.3),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Версия 1.0.0',
                      style: GoogleFonts.cinzel(
                        fontSize: 12,
                        color: AppColors.lightBrown.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Расширение для парсинга процентных значений
extension PercentageExtension on String {
  double parsePercentage(BuildContext context) {
    if (contains('%')) {
      final percentage = double.parse(replaceAll('%', '')) / 100;
      final size = MediaQuery.of(context).size;
      if (contains('width')) {
        return size.width * percentage;
      } else {
        return size.height * percentage;
      }
    }
    return double.tryParse(this) ?? 0;
  }
}