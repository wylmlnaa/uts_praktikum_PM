import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../services/firebase_auth_service.dart';
import '../services/firestore_service.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final FirestoreService _firestoreService = FirestoreService();

  User? _currentUser;
  bool _isLoading = true;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;

  // Menyimpan data signup sementara sebelum verifikasi OTP
  Map<String, String>? _tempSignupData;

  AuthProvider() {
    _init();
  }

  // Inisialisasi: Dengarkan perubahan status login dari Firebase Auth
  void _init() {
    _authService.authStateChanges.listen((fb.User? firebaseUser) async {
      _isLoading = true;
      notifyListeners();

      if (firebaseUser != null) {
        _currentUser = await _authService.getCurrentUser();
      } else {
        _currentUser = null;
      }

      _isLoading = false;
      notifyListeners();
    });
  }

  // Cek ulang status login
  Future<void> checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();
    _currentUser = await _authService.getCurrentUser();
    _isLoading = false;
    notifyListeners();
  }

  // Fungsi Login Firebase
  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentUser = await _authService.signIn(email, password);
    } catch (e) {
      debugPrint('Login provider error: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fungsi Mulai Signup (Menyimpan data pendaftaran sementara & simulasi kirim OTP)
  Future<void> signup({
    required String firstName,
    required String lastName,
    required String email,
    required String contactNo,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Menyimpan data registrasi sementara
      _tempSignupData = {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'contactNo': contactNo,
        'password': password,
      };
      
      // Simulasi berhasil mengirim OTP
      await Future.delayed(const Duration(seconds: 1)); 
    } catch (e) {
      debugPrint('Signup provider error: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fungsi Verifikasi OTP (Melakukan pendaftaran asli ke Firebase Auth)
  Future<void> verifyOtp(String email, String otp) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (_tempSignupData == null || _tempSignupData!['email'] != email) {
        throw Exception('Data registrasi tidak ditemukan. Silakan daftar ulang.');
      }

      // Melakukan registrasi asli ke Firebase
      await _authService.signUp(
        firstName: _tempSignupData!['firstName']!,
        lastName: _tempSignupData!['lastName']!,
        email: _tempSignupData!['email']!,
        contactNo: _tempSignupData!['contactNo']!,
        password: _tempSignupData!['password']!,
      );

      // Otomatis login setelah pendaftaran berhasil
      _currentUser = await _authService.signIn(
        _tempSignupData!['email']!,
        _tempSignupData!['password']!,
      );

      _tempSignupData = null; // Bersihkan data sementara
    } catch (e) {
      debugPrint('Verify OTP provider error: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Mengubah status On Duty Relawan
  Future<void> toggleDutyStatus(bool onDuty) async {
    if (_currentUser == null) return;
    try {
      await _firestoreService.updateVolunteerDuty(_currentUser!.id, onDuty);
      _currentUser = User(
        id: _currentUser!.id,
        username: _currentUser!.username,
        email: _currentUser!.email,
        lifelineId: _currentUser!.lifelineId,
        firstName: _currentUser!.firstName,
        lastName: _currentUser!.lastName,
        role: _currentUser!.role,
        adminTier: _currentUser!.adminTier,
        barangay: _currentUser!.barangay,
        municipality: _currentUser!.municipality,
        contactNo: _currentUser!.contactNo,
        gender: _currentUser!.gender,
        avatarUrl: _currentUser!.avatarUrl,
        volunteerStatus: _currentUser!.volunteerStatus,
        onDuty: onDuty,
      );
      notifyListeners();
    } catch (e) {
      debugPrint('Error toggling duty: $e');
    }
  }

  // Fungsi Logout
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    try {
      await _authService.signOut();
      _currentUser = null;
    } catch (e) {
      debugPrint('Logout provider error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
