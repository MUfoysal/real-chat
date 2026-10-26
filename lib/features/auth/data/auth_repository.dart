import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  AuthRepository({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _auth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<void> _saveUserProfile(User user) async {
    final userRef = _firestore.collection('users').doc(user.uid);

    await userRef.set(
      {
        'uid': user.uid,
        'name': user.displayName ?? '',
        'email': user.email ?? '',
        'photoUrl': user.photoURL,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<UserCredential> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final user = credential.user;

    if (user == null) {
      throw StateError('Account creation failed.');
    }

    final trimmedName = name.trim();

    if (trimmedName.isNotEmpty) {
      await user.updateDisplayName(trimmedName);
      await user.reload();
    }

    final updatedUser = _auth.currentUser;

    if (updatedUser != null) {
      await _saveUserProfile(updatedUser);
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

  Future<void> sendPasswordResetEmail({
    required String email,
  }) {
    return _auth.sendPasswordResetEmail(
      email: email.trim(),
    );
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}