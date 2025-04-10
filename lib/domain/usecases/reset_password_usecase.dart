import 'package:soulrise/data/services/firebase_auth_service.dart';

class ResetPasswordUseCase {
  final FirebaseAuthService _authService;

  ResetPasswordUseCase(this._authService);

  Future<void> call(String email) async {
    if (email.isEmpty) {
      throw Exception('Email cannot be empty');
    }
    
    try {
      await _authService.resetPassword(email);
    } catch (e) {
      throw Exception('Failed to reset password: $e');
    }
  }
}
