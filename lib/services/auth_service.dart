import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_user.dart';

class AuthService {
  // Singleton instance
  static final AuthService _instance = AuthService._internal();

  // Private constructor
  AuthService._internal();

  // Factory constructor to return the same instance
  factory AuthService() => _instance;

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get current authenticated user
  User? get currentUser => _auth.currentUser;

  // Register a new user and save data to Firestore
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // 1) Create user in Firebase Auth
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2) Save user profile and Firestore document if creation succeeded
      if (credential.user != null) {
        await credential.user!.updateDisplayName(name);

        AppUser appUser = AppUser(
          uid: credential.user!.uid,
          name: name,
          email: email,
        );

        await _db
            .collection('users')
            .doc(credential.user!.uid)
            .set(appUser.toMap());
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  // Sign in with email and password
  Future<void> login({
    required String email,
    required String password,
  }) async {
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Sign out current user
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Fetch user data from Firestore by UID
  Future<AppUser?> getUserData(String uid) async {
    DocumentSnapshot doc = await _db.collection('users').doc(uid).get();
    if (doc.exists) {
      return AppUser.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }
}