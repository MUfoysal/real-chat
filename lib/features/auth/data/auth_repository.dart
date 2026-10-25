import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthRepository {
  AuthRepository({FirebaseAuth? firebaseAuth})
    : _auth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  // Google Sign-In 7.x: initialize exactly once.
  static final Future<void> _googleInitialization = GoogleSignIn.instance
      .initialize();

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<void> _saveUserProfile(User user) async {
    final userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);

    await FirebaseFirestore.instance.runTransaction<void>((transaction) async {
      final snapshot = await transaction.get(userRef);

      final profile = <String, dynamic>{
        'uid': user.uid,
        'name': user.displayName ?? '',
        'email': user.email ?? '',
        'photoUrl': user.photoURL,
      };

      if (!snapshot.exists) {
        transaction.set(userRef, {
          ...profile,
          'createdAt': FieldValue.serverTimestamp(),
        });
      } else {
        transaction.set(userRef, {
          ...profile,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
    });
  }

  Future<UserCredential> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final user = credential.user;

    if (user == null) {
      throw StateError('Account creation failed.');
    }

    final name = displayName?.trim();

    if (name != null && name.isNotEmpty) {
      await user.updateDisplayName(name);
      await user.reload();
    }

    final currentUser = _auth.currentUser;

    if (currentUser != null) {
      await _saveUserProfile(currentUser);
    }

    return credential;
  }

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    
    if (kIsWeb) {
      final credential = await _auth.signInWithPopup(GoogleAuthProvider());

      final user = credential.user;

      if (user != null) {
        await _saveUserProfile(user);
      }

      return credential;
    }

    
    await _googleInitialization;

    final googleUser = await GoogleSignIn.instance.authenticate();
    final googleAuth = googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);

    final user = userCredential.user;

    if (user != null) {
      await _saveUserProfile(user);
    }

    return userCredential;
  }

  Future<void> sendPasswordResetEmail({required String email}) {
    return _auth.sendPasswordResetEmail(email: email.trim());
  }

  Future<void> signOut() async {
    if (!kIsWeb) {
      await GoogleSignIn.instance.signOut();
    }

    await _auth.signOut();
  }
}
