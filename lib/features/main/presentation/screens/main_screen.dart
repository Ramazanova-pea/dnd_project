import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatelessWidget {
  final Widget child;

  const MainScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: _buildBottomNavigation(context),
      drawer: _buildDrawer(context),
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _getCurrentIndex(context),
      onTap: (index) => _onItemTapped(index, context),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Персонажи',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu_book),
          label: 'Справочник',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.casino),
          label: 'Кубики',
        ),
      ],
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            child: Text('D&D App'),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Главная'),
            onTap: () => _goToHome(context),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Профиль'),
            onTap: () => _goToProfile(context),
          ),
          ListTile(
            leading: const Icon(Icons.flag),
            title: const Text('Кампании'),
            onTap: () => _goToCampaigns(context),
          ),
          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text('Чаты'),
            onTap: () => _goToChats(context),
          ),
          ListTile(
            leading: const Icon(Icons.public),
            title: const Text('Сеттинги'),
            onTap: () => _goToSettings(context),
          ),
        ],
      ),
    );
  }

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    if (location.contains('/home/characters')) return 0;
    if (location.contains('/home/reference')) return 1;
    if (location.contains('/home/dice')) return 2;

    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        _goToCharacters(context);
        break;
      case 1:
        _goToReference(context);
        break;
      case 2:
        _goToDice(context);
        break;
    }
  }

  void _goToHome(BuildContext context) => context.go('/home');
  void _goToProfile(BuildContext context) => context.go('/home/profile');
  void _goToCharacters(BuildContext context) => context.go('/home/characters');
  void _goToReference(BuildContext context) => context.go('/home/reference');
  void _goToDice(BuildContext context) => context.go('/home/dice');
  void _goToCampaigns(BuildContext context) => context.go('/home/campaigns');
  void _goToChats(BuildContext context) => context.go('/home/chats');
  void _goToSettings(BuildContext context) => context.go('/home/settings_game');
}