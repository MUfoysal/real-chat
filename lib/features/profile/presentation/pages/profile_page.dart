import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    super.key,
    required this.currentUser,
    required this.onLogout,
  });

  final User currentUser;
  final VoidCallback onLogout;

  Future<void> _confirmLogout(BuildContext context) async {
    final colors = Theme.of(context).colorScheme;

    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: colors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          icon: Icon(Icons.logout_rounded, color: colors.error, size: 32),
          title: const Text('Log out?'),
          content: const Text(
            'Are you sure you want to log out of your account?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: colors.error,
                foregroundColor: colors.onError,
              ),
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Log out'),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true && context.mounted) {
      onLogout();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final displayName = currentUser.displayName?.trim();
    final userName = displayName != null && displayName.isNotEmpty
        ? displayName
        : 'User';

    final email = currentUser.email ?? 'No email available';
    final photoUrl = currentUser.photoURL;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(22, 26, 22, 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Page heading
              Row(
                children: [
                  Container(
                    height: 43,
                    width: 43,
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(Icons.person_rounded, color: colors.primary),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'YOUR SPACE',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colors.primary,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'My Profile',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.7,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: colors.surfaceContainerHighest.withValues(
                        alpha: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.circle, size: 8, color: colors.primary),
                        const SizedBox(width: 6),
                        Text(
                          'ONLINE',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              

              // Premium split profile card
              Container(
                width: double.infinity,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colors.primary,
                      Color.lerp(colors.primary, Colors.black, 0.35)!,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: colors.primary.withValues(alpha: 0.5),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colors.primary.withValues(alpha: 0.22),
                      blurRadius: 28,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Background decoration
                    Positioned(
                      top: -85,
                      right: -65,
                      child: Container(
                        height: 210,
                        width: 210,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: colors.onPrimary.withValues(alpha: 0.08),
                            width: 28,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -90,
                      left: 80,
                      child: Container(
                        height: 170,
                        width: 170,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colors.onPrimary.withValues(alpha: 0.035),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(21),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top label
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'MEMBER PROFILE',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: colors.onPrimary.withValues(
                                    alpha: 0.75,
                                  ),
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 2,
                                ),
                              ),
                              Icon(
                                Icons.auto_awesome_rounded,
                                color: colors.onPrimary.withValues(alpha: 0.8),
                                size: 19,
                              ),
                            ],
                          ),

                          const SizedBox(height: 25),

                          // Main split layout
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Left: User identity
                              Expanded(
                                flex: 6,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: colors.onPrimary.withValues(
                                            alpha: 0.65,
                                          ),
                                          width: 2,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: colors.onPrimary.withValues(
                                              alpha: 0.12,
                                            ),
                                            blurRadius: 15,
                                          ),
                                        ],
                                      ),
                                      child: CircleAvatar(
                                        radius: 34,
                                        backgroundColor: colors.onPrimary
                                            .withValues(alpha: 0.13),
                                        backgroundImage:
                                            photoUrl != null &&
                                                photoUrl.isNotEmpty
                                            ? NetworkImage(photoUrl)
                                            : null,
                                        child:
                                            photoUrl == null || photoUrl.isEmpty
                                            ? Icon(
                                                Icons.person_rounded,
                                                color: colors.onPrimary,
                                                size: 35,
                                              )
                                            : null,
                                      ),
                                    ),

                                    const SizedBox(height: 17),

                                    Text(
                                      userName,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            color: colors.onPrimary,
                                            fontWeight: FontWeight.w900,
                                            height: 1.2,
                                          ),
                                    ),

                                    const SizedBox(height: 6),

                                    Text(
                                      email,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.labelSmall
                                          ?.copyWith(
                                            color: colors.onPrimary.withValues(
                                              alpha: 0.7,
                                            ),
                                            height: 1.4,
                                          ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 12),

                              // Right: Brand identity
                              Expanded(
                                flex: 5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      height: 2,
                                      width: 38,
                                      decoration: BoxDecoration(
                                        color: colors.onPrimary,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),

                                    const SizedBox(height: 17),

                                    Text(
                                      'REAL',
                                      textAlign: TextAlign.right,
                                      style: theme.textTheme.headlineMedium
                                          ?.copyWith(
                                            color: colors.onPrimary,
                                            fontWeight: FontWeight.w900,
                                            height: 0.95,
                                            letterSpacing: -1.5,
                                          ),
                                    ),

                                    Text(
                                      'CONNECTIONS.',
                                      textAlign: TextAlign.right,
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            color: colors.onPrimary.withValues(
                                              alpha: 0.85,
                                            ),
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: -0.5,
                                          ),
                                    ),

                                    const SizedBox(height: 13),

                                    Text(
                                      'Every conversation begins with a connection.',
                                      textAlign: TextAlign.right,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: colors.onPrimary.withValues(
                                              alpha: 0.68,
                                            ),
                                            height: 1.5,
                                          ),
                                    ),

                                    const SizedBox(height: 19),

                                    Icon(
                                      Icons.forum_rounded,
                                      color: colors.onPrimary.withValues(
                                        alpha: 0.75,
                                      ),
                                      size: 30,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 25),

                          // Bottom identity strip
                          Container(
                            height: 1,
                            color: colors.onPrimary.withValues(alpha: 0.18),
                          ),

                          const SizedBox(height: 15),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 7,
                                    width: 7,
                                    decoration: BoxDecoration(
                                      color: colors.onPrimary,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'REAL CHAT MEMBER',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: colors.onPrimary.withValues(
                                        alpha: 0.8,
                                      ),
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'YOUR SPACE',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: colors.onPrimary.withValues(
                                    alpha: 0.65,
                                  ),
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 34),

              // Account information
              const _SectionHeading(
                title: 'PERSONAL DETAILS',
                subtitle: 'Your account information',
              ),

              const SizedBox(height: 16),

              _InfoCard(
                icon: Icons.person_outline_rounded,
                title: 'Full Name',
                value: userName,
                colors: colors,
              ),

              const SizedBox(height: 12),

              _InfoCard(
                icon: Icons.alternate_email_rounded,
                title: 'Email Address',
                value: email,
                colors: colors,
              ),

              const SizedBox(height: 34),

              // About section
              const _SectionHeading(
                title: 'MORE',
                subtitle: 'A little about your space',
              ),

              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(17),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHighest.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: colors.outlineVariant.withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 49,
                      width: 49,
                      decoration: BoxDecoration(
                        color: colors.primaryContainer,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.forum_rounded,
                        color: colors.onPrimaryContainer,
                        size: 23,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'About Real Chat',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Your space for meaningful connections.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 15,
                      color: colors.onSurfaceVariant,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 34),

              // Logout section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colors.error.withValues(alpha: 0.055),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: colors.error.withValues(alpha: 0.15),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.logout_rounded,
                          color: colors.error,
                          size: 19,
                        ),
                        const SizedBox(width: 9),
                        Text(
                          'SESSION',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: colors.error,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Leaving so soon?',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'You can always come back and reconnect.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 19),
                    SizedBox(
                      height: 52,
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () => _confirmLogout(context),
                        icon: const Icon(Icons.logout_rounded, size: 19),
                        label: const Text(
                          'Log Out',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: colors.error,
                          foregroundColor: colors.onError,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.forum_rounded,
                      color: colors.primary.withValues(alpha: 0.7),
                      size: 22,
                    ),
                    const SizedBox(height: 9),
                    Text(
                      'REAL CHAT',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.5,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'YOUR SPACE. YOUR CONNECTIONS.',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontSize: 9,
                        letterSpacing: 1.1,
                        color: colors.onSurfaceVariant.withValues(alpha: 0.6),
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



class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.labelMedium?.copyWith(
            color: colors.primary,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.colors,
  });

  final IconData icon;
  final String title;
  final String value;
  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
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
            height: 47,
            width: 47,
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: colors.onPrimaryContainer, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
