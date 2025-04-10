import 'package:soulrise/data/services/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterUseCase {
  final FirebaseAuthService _authService;

  RegisterUseCase(this._authService);

  Future<User?> call(String email, String password) async {
    try {
      final userCredential =
          await _authService.registerWithEmailPassword(email, password);
      final user = userCredential?.user;

      if (user != null) {
        await _authService.sendEmailVerification(); 
      }

      return user;
    } catch (e) {
      throw Exception('Failed to register: $e');
    }
  }
}
