import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  AuthRepository({FirebaseAuth? firebaseAuth, FirebaseFirestore? firestore})
    : _auth = firebaseAuth ?? FirebaseAuth.instance,
      _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<void> _saveUserProfile(User user) async {
    final userRef = _firestore.collection('users').doc(user.uid);

    await _firestore.runTransaction<void>((transaction) async {
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

  Future<void> sendPasswordResetEmail({required String email}) {
    return _auth.sendPasswordResetEmail(email: email.trim());
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
