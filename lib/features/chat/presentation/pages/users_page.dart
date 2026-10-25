
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../auth/data/auth_repository.dart';

class UsersPage extends StatelessWidget {
  UsersPage({
    super.key,
    required this.currentUser,
  });

  final User currentUser;
  final AuthRepository _authRepository = AuthRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        actions: [
          IconButton(
            tooltip: 'Logout',
            onPressed: () async {
              try {
                await _authRepository.signOut();
              } catch (error) {
                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Logout failed. Please try again.'),
                  ),
                );
              }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Unable to load users. Check Firestore rules.'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final users = snapshot.data?.docs
                  .where((doc) => doc.id != currentUser.uid)
                  .toList() ??
              [];

          if (users.isEmpty) {
            return const Center(
              child: Text('No other users found yet.'),
            );
          }

          return ListView.separated(
            itemCount: users.length,
            separatorBuilder: (context, index) =>
                const Divider(height: 1),
            itemBuilder: (context, index) {
              final userData = users[index].data();

              final name = (userData['name'] as String?)?.trim();
              final email = userData['email'] as String? ?? '';
              final photoUrl = userData['photoUrl'] as String?;

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage:
                      photoUrl != null && photoUrl.isNotEmpty
                          ? NetworkImage(photoUrl)
                          : null,
                  child: photoUrl == null || photoUrl.isEmpty
                      ? const Icon(Icons.person)
                      : null,
                ),
                title: Text(
                  name == null || name.isEmpty ? email : name,
                ),
                subtitle: Text(email),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Selected ${name?.isNotEmpty == true ? name : email}. '
                        'Chat screen is coming next.',
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
