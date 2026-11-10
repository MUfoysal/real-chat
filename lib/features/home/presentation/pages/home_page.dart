import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.currentUser,
    required this.onFindPeople,
  });

  final User currentUser;
  final VoidCallback onFindPeople;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final displayName = currentUser.displayName?.trim();
    final userName = displayName != null && displayName.isNotEmpty
        ? displayName
        : 'there';

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 20, 22, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: colors.primaryContainer,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      Icons.forum_rounded,
                      color: colors.onPrimaryContainer,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'REAL CHAT',
                          style: TextStyle(
                            color: colors.onSurface,
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.5,
                          ),
                        ),
                        Text(
                          'Connect. Communicate.',
                          style: TextStyle(
                            color: colors.onSurfaceVariant,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    radius: 23,
                    backgroundColor: colors.primaryContainer,
                    backgroundImage: currentUser.photoURL != null
                        ? NetworkImage(currentUser.photoURL!)
                        : null,
                    child: currentUser.photoURL == null
                        ? Icon(
                            Icons.person_rounded,
                            color: colors.onPrimaryContainer,
                          )
                        : null,
                  ),
                ],
              ),

              const SizedBox(height: 45),

              // Welcome section
              Text(
                'WELCOME BACK',
                style: TextStyle(
                  color: colors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),

              const SizedBox(height: 13),

              Text(
                'Hello, $userName!',
                style: TextStyle(
                  color: colors.onSurface,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                'Welcome to Real Chat!',
                style: TextStyle(
                  color: colors.onSurface,
                  fontSize: 21,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'A place to connect with people, share your '
                'thoughts, and start meaningful conversations.',
                style: TextStyle(
                  color: colors.onSurfaceVariant,
                  fontSize: 14,
                  height: 1.7,
                ),
              ),

              const SizedBox(height: 35),

              // Find People Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(23),
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 52,
                      width: 52,
                      decoration: BoxDecoration(
                        color: colors.surface.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.people_alt_rounded,
                        color: colors.onPrimaryContainer,
                        size: 28,
                      ),
                    ),

                    const SizedBox(height: 22),

                    Text(
                      'Find Your People',
                      style: TextStyle(
                        color: colors.onPrimaryContainer,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 9),

                    Text(
                      'Discover new people and start a conversation. '
                      'Your next connection is just one tap away.',
                      style: TextStyle(
                        color: colors.onPrimaryContainer.withValues(alpha: 0.8),
                        fontSize: 13,
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 22),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: FilledButton(
                        onPressed: onFindPeople,
                        style: FilledButton.styleFrom(
                          backgroundColor: colors.primary,
                          foregroundColor: colors.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Find People',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 9),
                            Icon(Icons.arrow_forward_rounded, size: 19),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              // Introduction
              Text(
                'WHY REAL CHAT?',
                style: TextStyle(
                  color: colors.onSurface,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),

              const SizedBox(height: 18),

              _FeatureItem(
                icon: Icons.bolt_rounded,
                title: 'Real-time Messaging',
                description: 'Stay connected through instant conversations.',
                colors: colors,
              ),

              const SizedBox(height: 17),

              _FeatureItem(
                icon: Icons.people_outline_rounded,
                title: 'Connect with People',
                description: 'Discover people and make new connections.',
                colors: colors,
              ),

              const SizedBox(height: 17),

              _FeatureItem(
                icon: Icons.lock_outline_rounded,
                title: 'Personal Account',
                description: 'Access your account and your conversations.',
                colors: colors,
              ),

              const SizedBox(height: 35),

              Center(
                child: Text(
                  'MADE FOR MEANINGFUL CONNECTIONS',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colors.onSurfaceVariant.withValues(alpha: 0.7),
                    fontSize: 10,
                    letterSpacing: 1.3,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.colors,
  });

  final IconData icon;
  final String title;
  final String description;
  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 46,
          width: 46,
          decoration: BoxDecoration(
            color: colors.primaryContainer,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: colors.onPrimaryContainer, size: 23),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: colors.onSurface,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                description,
                style: TextStyle(
                  color: colors.onSurfaceVariant,
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
