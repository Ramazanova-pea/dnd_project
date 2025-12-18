import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

// Features imports - структура по фичам
import '/features/auth/presentation/screens/login_screen.dart';
import '/features/auth/presentation/screens/register_screen.dart';
import '/features/auth/presentation/screens/splash_screen.dart';

import '/features/main/presentation/screens/main_screen.dart';
import '/features/main/presentation/screens/home_screen.dart';

import '/features/profile/presentation/screens/profile_screen.dart';
import '/features/profile/presentation/screens/edit_name_screen.dart';
import '/features/profile/presentation/screens/edit_password_screen.dart';
import '/features/profile/presentation/screens/delete_account_screen.dart';

import '/features/characters/presentation/screens/character_list_screen.dart';
import '/features/characters/presentation/screens/character_detail_screen.dart';
import '/features/characters/presentation/screens/edit_character_screen.dart';
import '/features/characters/presentation/screens/create_character_screen.dart';

import '/features/reference/presentation/screens/reference_main_screen.dart';
import '/features/reference/presentation/screens/races_list_screen.dart';
import '/features/reference/presentation/screens/race_detail_screen.dart';
import '/features/reference/presentation/screens/classes_list_screen.dart';
import '/features/reference/presentation/screens/class_detail_screen.dart';
import '/features/reference/presentation/screens/mobs_list_screen.dart';
import '/features/reference/presentation/screens/mob_detail_screen.dart';

import '/features/dice/presentation/screens/dice_selector_screen.dart';
import '/features/dice/presentation/screens/dice_result_screen.dart';

import '/features/settings_game/presentation/screens/settings_list_screen.dart';
import '/features/settings_game/presentation/screens/setting_detail_screen.dart';
import '/features/settings_game/presentation/screens/create_setting_screen.dart';
import '/features/settings_game/presentation/screens/npc_list_screen.dart';
import '/features/settings_game/presentation/screens/npc_detail_screen.dart';
import '/features/settings_game/presentation/screens/create_npc_screen.dart';

import '/features/campaigns/presentation/screens/campaign_list_screen.dart';
import '/features/campaigns/presentation/screens/campaign_detail_screen.dart';
import '/features/campaigns/presentation/screens/create_campaign_screen.dart';
import '/features/campaigns/presentation/screens/sessions_list_screen.dart';
import '/features/campaigns/presentation/screens/create_session_screen.dart';
import '/features/campaigns/presentation/screens/notes_screen.dart';

import '/features/chat/presentation/screens/chat_list_screen.dart';
import '/features/chat/presentation/screens/chat_screen.dart';
import '/features/chat/presentation/screens/chat_info_screen.dart';

// State management provider
import '/core/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

/// Главный GoRouter конфигуратор для приложения
GoRouter createRouter(WidgetRef ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    initialLocation: '/splash',

    // // Редиректы для защиты маршрутов
    // redirect: (context, state) {
    //   final isLoggedIn = ref.read(authProvider).isAuthenticated;
    //   final location = state.uri.toString();
    //   final isAuthPath = _isAuthPath(location);
    //
    //   // Если пользователь не авторизован и пытается попасть на защищенный маршрут
    //   if (!isLoggedIn && !isAuthPath) {
    //     return '/login';
    //   }
    //
    //   // Если пользователь авторизован и пытается попасть на auth-маршруты
    //   if (isLoggedIn && isAuthPath) {
    //     return '/home';
    //   }
    //
    //   return null;
    // },

    routes: [
      // ========== PUBLIC ROUTES (без авторизации) ==========
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),

      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // ========== PROTECTED ROUTES (требуют авторизации) ==========
      // Shell для основного приложения с навигационной панелью
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainScreen(child: child),
        routes: [
          // Главный экран (Dashboard) - корневой для shell
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
            routes: [
              // ========== ПРОФИЛЬ ПОЛЬЗОВАТЕЛЯ ==========
              GoRoute(
                path: 'profile',
                name: 'profile',
                builder: (context, state) => const ProfileScreen(),
                routes: [
                  GoRoute(
                    path: 'edit_name',
                    name: 'edit_name',
                    builder: (context, state) => const EditNameScreen(),
                  ),
                  GoRoute(
                    path: 'edit_password',
                    name: 'edit_password',
                    builder: (context, state) => const EditPasswordScreen(),
                  ),
                  GoRoute(
                    path: 'delete_account',
                    name: 'delete_account',
                    builder: (context, state) => const DeleteAccountScreen(),
                  ),
                ],
              ),

              // ========== ПЕРСОНАЖИ ==========
              GoRoute(
                path: 'characters',
                name: 'characters',
                builder: (context, state) => const CharacterListScreen(),
                routes: [
                  GoRoute(
                    path: 'create',
                    name: 'create_character',
                    builder: (context, state) => const CreateCharacterScreen(),
                  ),
                  GoRoute(
                    path: ':characterId',
                    name: 'character_detail',
                    builder: (context, state) {
                      final characterId = state.pathParameters['characterId']!;
                      return CharacterDetailScreen(characterId: characterId);
                    },
                    routes: [
                      GoRoute(
                        path: 'edit',
                        name: 'edit_character',
                        builder: (context, state) {
                          final characterId = state.pathParameters['characterId']!;
                          return EditCharacterScreen(characterId: characterId);
                        },
                      ),
                    ],
                  ),
                ],
              ),

              // ========== СПРАВОЧНИК ==========
              GoRoute(
                path: 'reference',
                name: 'reference',
                builder: (context, state) => const ReferenceMainScreen(),
                routes: [
                  // Расы
                  GoRoute(
                    path: 'races',
                    name: 'races',
                    builder: (context, state) => const RacesListScreen(),
                    routes: [
                      GoRoute(
                        path: ':raceId',
                        name: 'race_detail',
                        builder: (context, state) {
                          final raceId = state.pathParameters['raceId']!;
                          return RaceDetailScreen(raceId: raceId);
                        },
                      ),
                    ],
                  ),

                  // Классы
                  GoRoute(
                    path: 'classes',
                    name: 'classes',
                    builder: (context, state) => const ClassesListScreen(),
                    routes: [
                      GoRoute(
                        path: ':classId',
                        name: 'class_detail',
                        builder: (context, state) {
                          final classId = state.pathParameters['classId']!;
                          return ClassDetailScreen(classId: classId);
                        },
                      ),
                    ],
                  ),

                  // Мобы
                  GoRoute(
                    path: 'mobs',
                    name: 'mobs',
                    builder: (context, state) => const MobsListScreen(),
                    routes: [
                      GoRoute(
                        path: ':mobId',
                        name: 'mob_detail',
                        builder: (context, state) {
                          final mobId = state.pathParameters['mobId']!;
                          return MobDetailScreen(mobId: mobId);
                        },
                      ),
                    ],
                  ),
                ],
              ),

              // ========== КУБИКИ ==========
              GoRoute(
                path: 'dice',
                name: 'dice',
                builder: (context, state) => const DiceSelectorScreen(),
                routes: [
                  GoRoute(
                    path: 'result',
                    name: 'dice_result',
                    builder: (context, state) {
                      // Получаем параметры из extra
                      final diceResult = state.extra as Map<String, dynamic>?;
                      return DiceResultScreen(diceResult: diceResult);
                    },
                  ),
                ],
              ),

              // ========== СЕТТИНГИ (Игровые миры) ==========
              GoRoute(
                path: 'settings_game',
                name: 'settings_game',
                builder: (context, state) => const SettingsListScreen(),
                routes: [
                  GoRoute(
                    path: 'create',
                    name: 'create_setting',
                    builder: (context, state) => const CreateSettingScreen(),
                  ),
                  GoRoute(
                    path: ':settingId',
                    name: 'setting_detail',
                    builder: (context, state) {
                      final settingId = state.pathParameters['settingId']!;
                      return SettingDetailScreen(settingId: settingId);
                    },
                    routes: [
                      // NPC для конкретного сеттинга
                      GoRoute(
                        path: 'npcs',
                        name: 'npc_list',
                        builder: (context, state) {
                          final settingId = state.pathParameters['settingId']!;
                          return NpcListScreen(settingId: settingId);
                        },
                        routes: [
                          GoRoute(
                            path: 'create',
                            name: 'create_npc',
                            builder: (context, state) {
                              final settingId = state.pathParameters['settingId']!;
                              return CreateNpcScreen(settingId: settingId);
                            },
                          ),
                          GoRoute(
                            path: ':npcId',
                            name: 'npc_detail',
                            builder: (context, state) {
                              final settingId = state.pathParameters['settingId']!;
                              final npcId = state.pathParameters['npcId']!;
                              return NpcDetailScreen(
                                settingId: settingId,
                                npcId: npcId,
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              // ========== КАМПАНИИ ==========
              GoRoute(
                path: 'campaigns',
                name: 'campaigns',
                builder: (context, state) => const CampaignListScreen(),
                routes: [
                  GoRoute(
                    path: 'create',
                    name: 'create_campaign',
                    builder: (context, state) => const CreateCampaignScreen(),
                  ),
                  GoRoute(
                    path: ':campaignId',
                    name: 'campaign_detail',
                    builder: (context, state) {
                      final campaignId = state.pathParameters['campaignId']!;
                      return CampaignDetailScreen(campaignId: campaignId);
                    },
                    routes: [
                      // Сессии кампании
                      GoRoute(
                        path: 'sessions',
                        name: 'sessions_list',
                        builder: (context, state) {
                          final campaignId = state.pathParameters['campaignId']!;
                          return SessionsListScreen(campaignId: campaignId);
                        },
                        routes: [
                          GoRoute(
                            path: 'create',
                            name: 'create_session',
                            builder: (context, state) {
                              final campaignId = state.pathParameters['campaignId']!;
                              return CreateSessionScreen(campaignId: campaignId);
                            },
                          ),
                        ],
                      ),

                      // Заметки кампании
                      GoRoute(
                        path: 'notes',
                        name: 'notes',
                        builder: (context, state) {
                          final campaignId = state.pathParameters['campaignId']!;
                          return NotesScreen(campaignId: campaignId);
                        },
                      ),
                    ],
                  ),
                ],
              ),

              // ========== ЧАТЫ ==========
              GoRoute(
                path: 'chats',
                name: 'chats',
                builder: (context, state) => const ChatListScreen(),
                routes: [
                  GoRoute(
                    path: ':chatId',
                    name: 'chat',
                    builder: (context, state) {
                      final chatId = state.pathParameters['chatId']!;
                      return ChatScreen(chatId: chatId);
                    },
                    routes: [
                      GoRoute(
                        path: 'info',
                        name: 'chat_info',
                        builder: (context, state) {
                          final chatId = state.pathParameters['chatId']!;
                          return ChatInfoScreen(chatId: chatId);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

/// Проверяет, является ли путь auth-маршрутом
bool _isAuthPath(String location) {
  return location.startsWith('/login') ||
      location.startsWith('/register') ||
      location == '/splash';
}

/// Утилиты для навигации (можно вынести в отдельный файл)
class AppRouter {
  static void goToHome(BuildContext context) {
    context.go('/home');
  }

  static void goToProfile(BuildContext context) {
    context.go('/home/profile');
  }

  static void goToCharacters(BuildContext context) {
    context.go('/home/characters');
  }

  static void goToCharacterDetail(BuildContext context, String characterId) {
    context.go('/home/characters/$characterId');
  }

  static void goToReference(BuildContext context) {
    context.go('/home/reference');
  }

  static void goToDice(BuildContext context) {
    context.go('/home/dice');
  }

  static void goToDiceResult(BuildContext context, Map<String, dynamic> result) {
    context.go('/home/dice/result', extra: result);
  }

  static void goToCampaigns(BuildContext context) {
    context.go('/home/campaigns');
  }

  static void goToChats(BuildContext context) {
    context.go('/home/chats');
  }

  static void goToLogin(BuildContext context) {
    context.go('/login');
  }

  static void goToRegister(BuildContext context) {
    context.go('/register');
  }
}