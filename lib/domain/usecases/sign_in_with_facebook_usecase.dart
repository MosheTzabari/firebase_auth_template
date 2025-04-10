import 'package:firebase_auth/firebase_auth.dart';
import 'package:soulrise/data/services/firebase_auth_service.dart';

/// Handles Facebook sign-in logic using FirebaseAuthService.
class SignInWithFacebookUseCase {
  final FirebaseAuthService _authService;

  SignInWithFacebookUseCase(this._authService);

  /// Signs in a user via Facebook.
  /// Returns the [User] if successful, or null if cancelled.
  Future<User?> call() async {
    final userCredential = await _authService.signInWithFacebook();
    return userCredential?.user;
  }
}
