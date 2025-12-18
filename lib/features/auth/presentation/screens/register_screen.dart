import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dnd_project/core/constants/app_colors.dart';
import 'package:dnd_project/core/providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _isRegisterError = false;
  String _errorMessage = '';
  bool _agreeToTerms = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _isRegisterError = true;
        _errorMessage = 'Пароли не совпадают';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _isRegisterError = false;
    });

    try {
      final result = await ref
          .read(authProvider.notifier)
          .register(
            username: _usernameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );

      if (result) {
        if (context.mounted) {
          context.go('/home');
        }
      } else {
        setState(() {
          _isRegisterError = true;
          _errorMessage = 'Ошибка регистрации';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isRegisterError = true;
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

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isSmallScreen = mediaQuery.size.height < 750;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(bottom: mediaQuery.viewInsets.bottom),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
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
                        vertical: isSmallScreen ? 16 : 24,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Заголовок
                          if (!isSmallScreen) ...[
                            _buildHeader(),
                            const SizedBox(height: 32),
                          ] else ...[
                            _buildCompactHeader(),
                            const SizedBox(height: 20),
                          ],

                          // Форма регистрации
                          _buildRegisterForm(),

                          // Футер
                          const SizedBox(height: 24),
                          _buildFooter(),

                          // Отступ для безопасности
                          SizedBox(
                            height: mediaQuery.padding.bottom > 0
                                ? mediaQuery.padding.bottom
                                : 16,
                          ),
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
            width: 100,
            height: 100,
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
              Icons.person_add_alt_1_rounded,
              size: 60,
              color: AppColors.accentGold,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'СОЗДАНИЕ\nПЕРСОНАЖА',
            style: GoogleFonts.cinzel(
              fontSize: 28,
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
          const SizedBox(height: 12),
          Text(
            'Начните своё приключение',
            style: GoogleFonts.cinzel(
              fontSize: 15,
              fontStyle: FontStyle.italic,
              color: AppColors.lightBrown,
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
            Icons.person_add_alt_1_rounded,
            size: 60,
            color: AppColors.accentGold,
          ),
          const SizedBox(height: 12),
          Text(
            'СОЗДАНИЕ АККАУНТА',
            style: GoogleFonts.cinzel(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.parchment,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterForm() {
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
                    'Новый искатель приключений',
                    style: GoogleFonts.cinzel(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.parchment,
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
                      labelText: 'Магический адрес',
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
                      labelText: 'Секретное заклинание',
                      labelStyle: GoogleFonts.cinzel(
                        color: AppColors.lightBrown,
                        fontSize: 14,
                      ),
                      hintText: 'Не менее 6 символов',
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

                  const SizedBox(height: 16),

                  // Подтверждение пароля
                  TextFormField(
                    controller: _confirmPasswordController,
                    style: GoogleFonts.cinzel(
                      color: AppColors.parchment,
                      fontSize: 15,
                    ),
                    obscureText: !_isConfirmPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Подтверждение заклинания',
                      labelStyle: GoogleFonts.cinzel(
                        color: AppColors.lightBrown,
                        fontSize: 14,
                      ),
                      hintText: 'Повторите пароль',
                      hintStyle: GoogleFonts.cinzel(
                        color: AppColors.lightBrown.withOpacity(0.6),
                        fontStyle: FontStyle.italic,
                      ),
                      prefixIcon: Icon(
                        Icons.lock_reset_rounded,
                        color: AppColors.accentGold.withOpacity(0.8),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordVisible
                              ? Icons.visibility_rounded
                              : Icons.visibility_off_rounded,
                          color: AppColors.lightBrown,
                          size: 20,
                        ),
                        onPressed: _toggleConfirmPasswordVisibility,
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
                        return 'Подтвердите пароль';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Сообщение об ошибке
                  if (_isRegisterError) ...[
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

                  // Кнопка регистрации
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBrown,
                      foregroundColor: AppColors.parchment,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      side: BorderSide(color: AppColors.accentGold, width: 1),
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
                              Icon(Icons.person_add_alt_1_rounded, size: 20),
                              const SizedBox(width: 10),
                              Text(
                                'Начать приключение',
                                style: GoogleFonts.cinzel(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  ),

                  const SizedBox(height: 16),
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
        // Уже есть аккаунт
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Уже есть персонаж? ',
              style: GoogleFonts.cinzel(
                color: AppColors.lightBrown,
                fontSize: 14,
              ),
            ),
            TextButton(
              onPressed: () => context.pop(),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Войти в систему',
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
