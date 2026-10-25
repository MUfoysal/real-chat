
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../data/auth_repository.dart';
import 'pages/login_page.dart';
import '../../chat/presentation/pages/users_page.dart';

class AuthGate extends StatelessWidget {
  AuthGate({super.key});

  final AuthRepository _authRepository = AuthRepository();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _authRepository.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final user = snapshot.data;

        if (user != null) {
          return UsersPage(currentUser: user);
        }

        return const LoginPage();
      },
    );
  }
}
