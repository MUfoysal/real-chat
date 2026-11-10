
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
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final displayName = currentUser.displayName?.trim();
    final userName = displayName != null && displayName.isNotEmpty
        ? displayName
        : 'there';

    final photoUrl = currentUser.photoURL;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
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
                      borderRadius: BorderRadius.circular(16),
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
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Connect. Communicate.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colors.onSurfaceVariant,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colors.primary.withValues(alpha: 0.6),
                        width: 1.5,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 21,
                      backgroundColor: colors.primaryContainer,
                      backgroundImage:
                          photoUrl != null && photoUrl.isNotEmpty
                              ? NetworkImage(photoUrl)
                              : null,
                      child: photoUrl == null || photoUrl.isEmpty
                          ? Icon(
                              Icons.person_rounded,
                              color: colors.onPrimaryContainer,
                            )
                          : null,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 42),

              // Welcome section
              Text(
                'WELCOME BACK',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2.5,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Hello, $userName',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.2,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Good conversations begin with a simple hello. '
                'Find your people and make meaningful connections.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                  height: 1.7,
                ),
              ),

              const SizedBox(height: 30),

              // Find People hero card
              ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            colors.primary,
                            colors.primaryContainer,
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 54,
                                width: 54,
                                decoration: BoxDecoration(
                                  color: colors.onPrimary.withValues(
                                    alpha: 0.12,
                                  ),
                                  borderRadius: BorderRadius.circular(17),
                                  border: Border.all(
                                    color: colors.onPrimary.withValues(
                                      alpha: 0.15,
                                    ),
                                  ),
                                ),
                                child: Icon(
                                  Icons.people_alt_rounded,
                                  color: colors.onPrimary,
                                  size: 29,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 11,
                                  vertical: 7,
                                ),
                                decoration: BoxDecoration(
                                  color: colors.onPrimary.withValues(
                                    alpha: 0.12,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  'EXPLORE',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: colors.onPrimary,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 28),
                          Text(
                            'Find Your People',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: colors.onPrimary,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Discover new people, build connections, '
                            'and start conversations that matter.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colors.onPrimary.withValues(alpha: 0.82),
                              height: 1.65,
                            ),
                          ),
                          const SizedBox(height: 25),
                          SizedBox(
                            height: 53,
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: onFindPeople,
                              style: FilledButton.styleFrom(
                                backgroundColor: colors.onPrimary,
                                foregroundColor: colors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Explore People',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Decorative background shapes
                    Positioned(
                      right: -55,
                      top: -65,
                      child: Container(
                        height: 180,
                        width: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: colors.onPrimary.withValues(alpha: 0.07),
                            width: 25,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 25,
                      bottom: 80,
                      child: Icon(
                        Icons.forum_rounded,
                        size: 85,
                        color: colors.onPrimary.withValues(alpha: 0.045),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 36),

              // Features section heading
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'WHAT MAKES US DIFFERENT',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.3,
                      ),
                    ),
                  ),
                  Container(
                    height: 1,
                    width: 35,
                    color: colors.outlineVariant.withValues(alpha: 0.5),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // Feature cards
              _FeatureCard(
                icon: Icons.bolt_rounded,
                title: 'Real-time Messaging',
                description:
                    'Stay connected through instant conversations.',
                colors: colors,
              ),
              const SizedBox(height: 12),
              _FeatureCard(
                icon: Icons.people_outline_rounded,
                title: 'Connect with People',
                description:
                    'Discover people and make new connections.',
                colors: colors,
              ),
              const SizedBox(height: 12),
              _FeatureCard(
                icon: Icons.lock_outline_rounded,
                title: 'Personal Account',
                description:
                    'Your account and conversations stay personal.',
                colors: colors,
              ),

              const SizedBox(height: 35),

              // Footer
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.favorite_rounded,
                      color: colors.primary.withValues(alpha: 0.8),
                      size: 19,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'MADE FOR MEANINGFUL CONNECTIONS',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colors.onSurfaceVariant.withValues(
                          alpha: 0.7,
                        ),
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
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
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colors.outlineVariant.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              icon,
              color: colors.onPrimaryContainer,
              size: 24,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.arrow_outward_rounded,
            size: 18,
            color: colors.onSurfaceVariant.withValues(alpha: 0.6),
          ),
        ],
      ),
    );
  }
}
