import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/user.dart';

class FirebaseAuthService {
  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream status login
  Stream<fb.User?> get authStateChanges => _auth.authStateChanges();

  // Ambil UID user saat ini yang sedang login
  String? get currentUid => _auth.currentUser?.uid;

  // Ambil detail data user dari Firestore
  Future<User?> getCurrentUser() async {
    final fb.User? firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return null;

    try {
      final doc = await _firestore.collection('users').doc(firebaseUser.uid).get();
      if (doc.exists) {
        return User.fromJson(doc.data()!);
      } else {
        // Jika dokumen profil belum ada, kembalikan data dasar
        return User(
          id: firebaseUser.uid,
          email: firebaseUser.email,
          firstName: firebaseUser.displayName ?? 'Pengguna',
          lastName: '',
          role: 'COMMUNITY',
          volunteerStatus: 'NONE',
        );
      }
    } catch (e) {
      debugPrint('Error getting current user: $e');
      return null;
    }
  }

  // Fungsi Login
  Future<User> signIn(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw Exception('Gagal melakukan otentikasi login.');
      }

      // Ambil profil dari Firestore
      final userDoc = await _firestore.collection('users').doc(credential.user!.uid).get();
      if (userDoc.exists) {
        return User.fromJson(userDoc.data()!);
      } else {
        // Buat default profil jika belum ada
        final newUser = User(
          id: credential.user!.uid,
          email: email,
          firstName: email.split('@')[0],
          lastName: '',
          role: 'COMMUNITY',
          volunteerStatus: 'NONE',
        );
        await _firestore.collection('users').doc(credential.user!.uid).set(newUser.toJson());
        return newUser;
      }
    } catch (e) {
      debugPrint('Sign in error: $e');
      rethrow;
    }
  }

  // Fungsi Register (Signup)
  Future<void> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String contactNo,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw Exception('Gagal membuat akun baru.');
      }

      // Format ID Lifeline: LF-YYYY-RANDOM (Contoh: LF-2026-894101)
      final year = DateTime.now().year;
      final randomNum = (100000 + (900000 * (DateTime.now().millisecond / 1000))).toInt();
      final lifelineId = 'LF-$year-$randomNum';

      // Simpan data profil ke Firestore
      final newUser = User(
        id: credential.user!.uid,
        email: email,
        lifelineId: lifelineId,
        firstName: firstName,
        lastName: lastName,
        role: 'COMMUNITY', // Default
        volunteerStatus: 'NONE',
        contactNo: contactNo,
        onDuty: true,
      );

      await _firestore.collection('users').doc(credential.user!.uid).set(newUser.toJson());
    } catch (e) {
      debugPrint('Sign up error: $e');
      rethrow;
    }
  }

  // Fungsi Keluar (Sign Out)
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
