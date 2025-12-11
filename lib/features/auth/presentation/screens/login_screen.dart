import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dnd_project/core/constants/app_colors.dart';
import 'package:dnd_project/features/auth/presentation/providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _isLoginError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _isLoginError = false;
    });

    try {
      final result = await ref.read(authProvider.notifier).login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (result.success) {
        if (context.mounted) {
          context.go('/home');
        }
      } else {
        setState(() {
          _isLoginError = true;
          _errorMessage = result.message ?? 'Ошибка авторизации';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoginError = true;
        _errorMessage = 'Произошла ошибка. Проверьте подключение к интернету';
        _isLoading = false;
      });
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isSmallScreen = mediaQuery.size.height < 700;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(
                bottom: mediaQuery.viewInsets.bottom,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: AppColors.loginGradient,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: isSmallScreen ? 20 : 32,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Заголовок
                          if (!isSmallScreen) ...[
                            _buildHeader(),
                            const SizedBox(height: 40),
                          ] else ...[
                            _buildCompactHeader(),
                            const SizedBox(height: 24),
                          ],

                          // Форма авторизации
                          _buildLoginForm(),

                          // Футер с дополнительными опциями
                          const SizedBox(height: 32),
                          _buildFooter(),

                          // Отступ для безопасности
                          SizedBox(height: mediaQuery.padding.bottom > 0
                              ? mediaQuery.padding.bottom
                              : 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.parchment.withOpacity(0.15),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppColors.accentGold.withOpacity(0.4),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.castle_rounded,
              size: 70,
              color: AppColors.accentGold,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'DUNGEONS & DRAGONS',
            style: GoogleFonts.cinzel(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: AppColors.parchment,
              letterSpacing: 1.5,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Container(
            height: 2,
            width: 140,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.accentGold.withOpacity(0),
                  AppColors.accentGold,
                  AppColors.accentGold.withOpacity(0),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildCompactHeader() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.castle_rounded,
            size: 70,
            color: AppColors.accentGold,
          ),
          const SizedBox(height: 16),
          Text(
            'D&D',
            style: GoogleFonts.cinzel(
              fontSize: 36,
              fontWeight: FontWeight.w700,
              color: AppColors.parchment,
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Card(
          margin: EdgeInsets.zero,
          color: AppColors.parchment.withOpacity(0.12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: AppColors.lightBrown.withOpacity(0.25),
              width: 1,
            ),
          ),
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Доступ к знаниям',
                    style: GoogleFonts.cinzel(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.parchment,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Введите данные для входа',
                    style: GoogleFonts.cinzel(
                      fontSize: 13,
                      color: AppColors.lightBrown,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 24),

                  // Поле email
                  TextFormField(
                    controller: _emailController,
                    style: GoogleFonts.cinzel(
                      color: AppColors.parchment,
                      fontSize: 15,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Электронная почта',
                      labelStyle: GoogleFonts.cinzel(
                        color: AppColors.lightBrown,
                        fontSize: 14,
                      ),
                      hintText: 'маг@замок.мир',
                      hintStyle: GoogleFonts.cinzel(
                        color: AppColors.lightBrown.withOpacity(0.6),
                        fontStyle: FontStyle.italic,
                      ),
                      prefixIcon: Icon(
                        Icons.email_rounded,
                        color: AppColors.accentGold.withOpacity(0.8),
                      ),
                      filled: true,
                      fillColor: AppColors.darkBrown.withOpacity(0.25),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.accentGold,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Введите email';
                      }
                      if (!value.contains('@')) {
                        return 'Введите корректный email';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Поле пароля
                  TextFormField(
                    controller: _passwordController,
                    style: GoogleFonts.cinzel(
                      color: AppColors.parchment,
                      fontSize: 15,
                    ),
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Пароль',
                      labelStyle: GoogleFonts.cinzel(
                        color: AppColors.lightBrown,
                        fontSize: 14,
                      ),
                      hintText: 'Введите пароль',
                      hintStyle: GoogleFonts.cinzel(
                        color: AppColors.lightBrown.withOpacity(0.6),
                        fontStyle: FontStyle.italic,
                      ),
                      prefixIcon: Icon(
                        Icons.lock_rounded,
                        color: AppColors.accentGold.withOpacity(0.8),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility_rounded
                              : Icons.visibility_off_rounded,
                          color: AppColors.lightBrown,
                          size: 20,
                        ),
                        onPressed: _togglePasswordVisibility,
                      ),
                      filled: true,
                      fillColor: AppColors.darkBrown.withOpacity(0.25),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.accentGold,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Введите пароль';
                      }
                      if (value.length < 6) {
                        return 'Пароль должен быть не менее 6 символов';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 8),

                  // Забыли пароль
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              'Восстановление пароля временно недоступно',
                            ),
                            backgroundColor: AppColors.primaryBrown,
                            behavior: SnackBarBehavior.floating,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Забыли пароль?',
                        style: GoogleFonts.cinzel(
                          fontSize: 12,
                          color: AppColors.accentGold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),

                  // Сообщение об ошибке
                  if (_isLoginError) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.redAccent.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            color: Colors.redAccent,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _errorMessage,
                              style: GoogleFonts.cinzel(
                                color: AppColors.parchment,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Кнопка входа
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBrown,
                      foregroundColor: AppColors.parchment,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      side: BorderSide(
                        color: AppColors.accentGold,
                        width: 1,
                      ),
                    ),
                    child: _isLoading
                        ? SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        color: AppColors.parchment,
                        strokeWidth: 2.5,
                      ),
                    )
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.login_rounded,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Войти в библиотеку',
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
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Регистрация
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Нет учётной записи? ',
              style: GoogleFonts.cinzel(
                color: AppColors.lightBrown,
                fontSize: 14,
              ),
            ),
            TextButton(
              onPressed: () => context.push('/register'),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Зарегистрироваться',
                style: GoogleFonts.cinzel(
                  color: AppColors.accentGold,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.accentGold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}