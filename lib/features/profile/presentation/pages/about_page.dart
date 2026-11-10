
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const String appVersion = '1.0.0';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('About Real Chat'),
        backgroundColor: theme.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App identity card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(25),
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
                  boxShadow: [
                    BoxShadow(
                      color: colors.primary.withValues(alpha: 0.2),
                      blurRadius: 25,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: -65,
                      right: -55,
                      child: Container(
                        height: 170,
                        width: 170,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: colors.onPrimary.withValues(alpha: 0.08),
                            width: 25,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 66,
                          width: 66,
                          decoration: BoxDecoration(
                            color: colors.onPrimary.withValues(alpha: 0.13),
                            borderRadius: BorderRadius.circular(21),
                            border: Border.all(
                              color: colors.onPrimary.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Icon(
                            Icons.forum_rounded,
                            color: colors.onPrimary,
                            size: 34,
                          ),
                        ),
                        const SizedBox(height: 25),
                        Text(
                          'REAL CHAT',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: colors.onPrimary,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'More than messages.\nReal connections.',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colors.onPrimary.withValues(alpha: 0.8),
                            height: 1.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 22),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 13,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: colors.onPrimary.withValues(alpha: 0.13),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            'CONNECT • CHAT • SHARE',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colors.onPrimary,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              // About section
              const _SectionHeading(
                title: 'OUR STORY',
                subtitle: 'What is Real Chat?',
              ),

              const SizedBox(height: 15),

              Text(
                'Real Chat is a real-time messaging application designed '
                'to make connecting with people simple and convenient. '
                'Find people, start conversations and stay connected '
                'through a clean and easy-to-use experience.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                  height: 1.8,
                ),
              ),

              const SizedBox(height: 34),

              // Features
              const _SectionHeading(
                title: 'WHAT WE OFFER',
                subtitle: 'Built for meaningful connections',
              ),

              const SizedBox(height: 16),

              const _FeatureCard(
                icon: Icons.bolt_rounded,
                title: 'Real-time Messaging',
                description:
                    'Send and receive messages with real-time updates.',
              ),

              const SizedBox(height: 12),

              const _FeatureCard(
                icon: Icons.people_alt_rounded,
                title: 'Find People',
                description:
                    'Discover other users and start new conversations.',
              ),

              const SizedBox(height: 12),

              const _FeatureCard(
                icon: Icons.lock_outline_rounded,
                title: 'Secure Authentication',
                description:
                    'Sign in and manage your account with Firebase Authentication.',
              ),

              const SizedBox(height: 34),

              // App information
              const _SectionHeading(
                title: 'APP INFORMATION',
                subtitle: 'A few technical details',
              ),

              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHighest.withValues(
                    alpha: 0.35,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: colors.outlineVariant.withValues(alpha: 0.25),
                  ),
                ),
                child: Column(
                  children: [
                    _InfoRow(
                      icon: Icons.apps_rounded,
                      title: 'Application',
                      value: 'Real Chat',
                    ),
                    const Divider(height: 25),
                    _InfoRow(
                      icon: Icons.new_releases_outlined,
                      title: 'Version',
                      value: appVersion,
                    ),
                    const Divider(height: 25),
                    _InfoRow(
                      icon: Icons.storage_rounded,
                      title: 'Backend',
                      value: 'Firebase',
                    ),
                    const Divider(height: 25),
                    _InfoRow(
                      icon: Icons.phone_android_rounded,
                      title: 'Platform',
                      value: 'Flutter',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 34),

              // Developer section
              const _SectionHeading(
                title: 'DEVELOPER',
                subtitle: 'Made with purpose',
              ),

              const SizedBox(height: 16),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(19),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHighest.withValues(
                    alpha: 0.35,
                  ),
                  borderRadius: BorderRadius.circular(22),
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
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.code_rounded,
                        color: colors.onPrimaryContainer,
                        size: 25,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Developed by',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Mohib Ullah Foysal',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Computer Science & Technology',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 38),

              // Footer
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.forum_rounded,
                      size: 27,
                      color: colors.primary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'REAL CHAT',
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: 3,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      'YOUR SPACE. YOUR CONNECTIONS.',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colors.onSurfaceVariant,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      '© Real Chat',
                      style: theme.textTheme.labelSmall?.copyWith(
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
  const _SectionHeading({
    required this.title,
    required this.subtitle,
  });

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
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

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
            child: Icon(
              icon,
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
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: colors.primary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
