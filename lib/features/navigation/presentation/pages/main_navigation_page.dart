
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:real_chat/features/chat/presentation/pages/users_page.dart';



class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({
    super.key,
    required this.currentUser,
  });

  final User currentUser;

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 1;

  static const List<IconData> _icons = [
    Icons.chat_bubble_outline_rounded,
    Icons.people_outline_rounded,
    Icons.person_outline_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final pages = [
      const _PlaceholderPage(
        icon: Icons.chat_bubble_outline_rounded,
        title: 'Chats',
        message: 'Your conversations will appear here.',
      ),
      UsersPage(currentUser: widget.currentUser),
      const _PlaceholderPage(
        icon: Icons.person_outline_rounded,
        title: 'Profile',
        message: 'Your profile will appear here.',
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: _icons,
        activeIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        gapLocation: GapLocation.none,
        notchSmoothness: NotchSmoothness.softEdge,
        leftCornerRadius: 24,
        rightCornerRadius: 24,
        backgroundColor: colors.surface,
        activeColor: colors.primary,
        inactiveColor: colors.onSurfaceVariant,
        elevation: 8,
      ),
    );
  }
}

class _PlaceholderPage extends StatelessWidget {
  const _PlaceholderPage({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 64, color: colors.primary),
              const SizedBox(height: 16),
              Text(
                title,
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(color: colors.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
