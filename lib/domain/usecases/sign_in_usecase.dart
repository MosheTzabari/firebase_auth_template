import 'package:soulrise/data/services/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInUseCase {
  final FirebaseAuthService _authService;

  SignInUseCase(this._authService);

  Future<User?> call(String email, String password) async {
    try {
      final userCredential = await _authService.signInWithEmailPassword(email, password);
      return userCredential?.user;
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }
}
