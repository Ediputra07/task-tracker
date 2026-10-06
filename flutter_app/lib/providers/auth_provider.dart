import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/repositories/auth_repository.dart';

class AuthNotifier extends ChangeNotifier {
  final AuthRepository _repository;
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  AuthNotifier(this._repository) {
    _user = _repository.currentUser;
    _repository.authStateChanges.listen((data) {
      _user = data.session?.user;
      notifyListeners();
    });
  }

  User? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> signIn({required String email, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.signIn(email: email, password: password);
      _isLoading = false;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _isLoading = false;
      _errorMessage = _translateAuthError(e.message);
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Gagal masuk. Periksa koneksi internet Anda.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp({required String email, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.signUp(email: email, password: password);
      _isLoading = false;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _isLoading = false;
      _errorMessage = _translateAuthError(e.message);
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Gagal mendaftar. Periksa koneksi internet Anda.';
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();
    await _repository.signOut();
    _user = null;
    _isLoading = false;
    notifyListeners();
  }

  String _translateAuthError(String message) {
    final lower = message.toLowerCase();
    if (lower.contains('invalid login credentials') || lower.contains('invalid_credentials')) {
      return 'Email atau password salah.';
    } else if (lower.contains('already registered') || lower.contains('already exists')) {
      return 'Email sudah terdaftar. Silakan login.';
    } else if (lower.contains('password should be at least')) {
      return 'Password minimal 6 karakter.';
    }
    return message;
  }
}
