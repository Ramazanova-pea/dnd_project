import 'package:flutter/material.dart';

class AppColors {
  // Основные цвета коричневой темы для D&D
  static const Color primaryBrown = Color(0xFF8B4513);     // Коричневое седло
  static const Color darkBrown = Color(0xFF5D4037);        // Темный коричневый
  static const Color lightBrown = Color(0xFFD7CCC8);       // Светлый коричневый
  static const Color parchment = Color(0xFFF5E6CA);        // Пергамент
  static const Color accentGold = Color(0xFFD4AF37);       // Золотой акцент
  static const Color woodBrown = Color(0xFF795548);        // Древесный коричневый

  // Дополнительные цвета
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color errorRed = Color(0xFFF44336);
  static const Color warningOrange = Color(0xFFFF9800);
  static const Color infoBlue = Color(0xFF2196F3);

  // Тени и прозрачные версии
  static const Color shadowBrown = Color(0x332D1B69);
  static const Color transparentGold = Color(0x1AD4AF37);
  static const Color transparentParchment = Color(0x26F5E6CA);

  // Градиенты
  static const List<Color> loginGradient = [
    darkBrown,
    primaryBrown,
    woodBrown,
  ];

  static const List<Color> cardGradient = [
    Color(0x26F5E6CA),  // 15% прозрачности
    Color(0x1AF5E6CA),  // 10% прозрачности
  ];

  // Методы для удобства
  static Color getTextFieldFillColor(BuildContext context) {
    return darkBrown.withOpacity(0.3);
  }

  static Color getBackgroundShade(double opacity) {
    return darkBrown.withOpacity(opacity);
  }

  // Светлая тема для главного экрана
  static const Color lightParchment = Color(0xFFF9F5F0); // Очень светлый бежевый
  static const Color lightBeige = Color(0xFFF2E8DA);     // Светлый бежевый
  static const Color cream = Color(0xFFFAF3E0);          // Кремовый

  // Акцентные цвета для светлой темы
  static const Color lightBrownAccent = Color(0xFFA1887F); // Светло-коричневый
  static const Color mediumBrown = Color(0xFF8D6E63);     // Средний коричневый

  // Обновим градиенты для светлой темы
  static List<Color> get homeBackgroundGradient => [
    lightParchment,
    cream,
    lightBeige,
  ];

  static List<Color> get cardGradientLight => [
    Colors.white.withOpacity(0.9),
    Colors.white.withOpacity(0.7),
  ];

  // Методы для удобства
  static Color getHomeBackground(BuildContext context) {
    return lightParchment;
  }

  static Color getCardColor() {
    return Colors.white.withOpacity(0.85);
  }

  static Color getBorderColor() {
    return lightBrown.withOpacity(0.2);
  }
}