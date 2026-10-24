
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../data/auth_repository.dart';
import 'pages/login_page.dart';

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

        if (snapshot.hasData) {
          return const Scaffold(
            body: Center(
              child: Text('Welcome! Chat Home is coming next.'),
            ),
          );
        }

        return const LoginPage();
      },
    );
  }
}
