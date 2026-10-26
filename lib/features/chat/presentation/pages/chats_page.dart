
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../data/chat_repository.dart';
import 'chat_page.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({
    super.key,
    required this.currentUser,
    required this.onFindPeople,
  });

  final User currentUser;
  final VoidCallback onFindPeople;

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final ChatRepository _chatRepository = ChatRepository();

  String _displayName(Map<String, dynamic> data) {
    final name = (data['name'] as String? ?? '').trim();
    final email = (data['email'] as String? ?? '').trim();

    if (name.isNotEmpty) return name;
    if (email.isNotEmpty) return email;
    return 'Unknown user';
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));

    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();

    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  DateTime _activityTime(Map<String, dynamic> data) {
    final value = data['lastMessageAt'] ?? data['createdAt'];

    if (value is Timestamp) return value.toDate();
    return DateTime.fromMillisecondsSinceEpoch(0);
  }

  String _formatTime(DateTime? date) {
    if (date == null) return '';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(date.year, date.month, date.day);

    if (day == today) {
      final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
      final minute = date.minute.toString().padLeft(2, '0');
      final period = date.hour >= 12 ? 'PM' : 'AM';
      return '$hour:$minute $period';
    }

    if (now.difference(day).inDays == 1) return 'Yesterday';

    if (date.year == now.year) {
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ];
      return '${date.day} ${months[date.month - 1]}';
    }

    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final currentName = (widget.currentUser.displayName ?? '').trim();
    final greetingName = currentName.isNotEmpty
        ? currentName.split(RegExp(r'\s+')).first
        : 'there';

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Real Chat',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 19,
              backgroundColor: colors.primaryContainer,
              backgroundImage: widget.currentUser.photoURL != null
                  ? NetworkImage(widget.currentUser.photoURL!)
                  : null,
              child: widget.currentUser.photoURL == null
                  ? Icon(
                      Icons.person_rounded,
                      color: colors.onPrimaryContainer,
                    )
                  : null,
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, $greetingName 👋',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Your conversations',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Pick up where you left off.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    'RECENT CHATS',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.forum_outlined,
                    size: 19,
                    color: colors.primary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _chatRepository.conversationsStream(
                  widget.currentUser.uid,
                ),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return _ChatsStatus(
                      icon: Icons.cloud_off_rounded,
                      title: 'Could not load your chats',
                      message:
                          'Check your connection and Firestore security rules, then try again.',
                      actionLabel: 'Find People',
                      onAction: widget.onFindPeople,
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final conversations =
                      List<QueryDocumentSnapshot<Map<String, dynamic>>>.from(
                        snapshot.data?.docs ?? [],
                      );

                  conversations.sort((a, b) {
                    return _activityTime(b.data()).compareTo(
                      _activityTime(a.data()),
                    );
                  });

                  if (conversations.isEmpty) {
                    return _ChatsStatus(
                      icon: Icons.forum_rounded,
                      title: 'Your conversations start here',
                      message:
                          'Find people, say hello, and your conversations will appear here automatically.',
                      actionLabel: 'Find People',
                      onAction: widget.onFindPeople,
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                    itemCount: conversations.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final conversation = conversations[index];
                      final data = conversation.data();
                      final participants = (data['participants'] as List?)
                              ?.whereType<String>()
                              .toList() ??
                          [];

                      final otherUid = participants.firstWhere(
                        (uid) => uid != widget.currentUser.uid,
                        orElse: () => '',
                      );

                      if (otherUid.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      return FutureBuilder<
                          DocumentSnapshot<Map<String, dynamic>>>(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .doc(otherUid)
                            .get(),
                        builder: (context, userSnapshot) {
                          final userData = userSnapshot.data?.data() ?? {};
                          final name = _displayName(userData);
                          final email =
                              (userData['email'] as String? ?? '').trim();
                          final photoUrl =
                              (userData['photoUrl'] as String? ?? '').trim();
                          final lastMessage =
                              (data['lastMessage'] as String? ?? '').trim();
                          final activityTime = _activityTime(data);
                          final hasActivity = activityTime
                              .isAfter(DateTime.fromMillisecondsSinceEpoch(0));

                          return Card(
                            margin: EdgeInsets.zero,
                            elevation: 0,
                            color: colors.surfaceContainerLow,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 9,
                              ),
                              leading: CircleAvatar(
                                radius: 27,
                                backgroundColor: colors.primaryContainer,
                                foregroundColor: colors.onPrimaryContainer,
                                backgroundImage: photoUrl.isNotEmpty
                                    ? NetworkImage(photoUrl)
                                    : null,
                                child: photoUrl.isEmpty
                                    ? Text(
                                        _initials(name),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : null,
                              ),
                              title: Text(
                                name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  lastMessage.isNotEmpty
                                      ? lastMessage
                                      : 'Start a conversation',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: colors.onSurfaceVariant,
                                  ),
                                ),
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  if (hasActivity)
                                    Text(
                                      _formatTime(activityTime),
                                      style: theme.textTheme.labelSmall
                                          ?.copyWith(
                                        color: colors.onSurfaceVariant,
                                      ),
                                    ),
                                  const SizedBox(height: 6),
                                  Icon(
                                    Icons.chevron_right_rounded,
                                    color: colors.onSurfaceVariant,
                                    size: 20,
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => ChatPage(
                                      currentUser: widget.currentUser,
                                      otherUid: otherUid,
                                      otherName: name,
                                      otherEmail: email,
                                      otherPhotoUrl: photoUrl,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatsStatus extends StatelessWidget {
  const _ChatsStatus({
    required this.icon,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(32, 16, 32, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 116,
              height: 116,
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 54,
                color: colors.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 26),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onAction,
              icon: const Icon(Icons.people_alt_rounded),
              label: Text(actionLabel),
            ),
          ],
        ),
      ),
    );
  }
}
