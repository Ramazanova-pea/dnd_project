// lib/main.dart
import 'package:dnd_project/features/auth/presentation/screens/register_screen.dart';
import 'package:dnd_project/features/auth/presentation/screens/splash_screen.dart';
import 'package:dnd_project/features/main/presentation/screens/home_screen.dart';
import 'package:dnd_project/features/profile/presentation/screens/delete_account_screen.dart';
import 'package:dnd_project/features/profile/presentation/screens/edit_name_screen.dart';
import 'package:dnd_project/features/profile/presentation/screens/edit_password_screen.dart';
import 'package:dnd_project/features/profile/presentation/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dnd_project/features/auth/presentation/screens/login_screen.dart';

void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        home: DeleteAccountScreen(), // Прямой запуск нужного экрана
      ),
    ),
  );
}