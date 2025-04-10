import 'package:firebase_auth/firebase_auth.dart';
import 'package:soulrise/data/services/firebase_auth_service.dart';

class SignInWithGoogleUseCase {
  final FirebaseAuthService _authService;

  SignInWithGoogleUseCase(this._authService);

  Future<User?> call() async {
    final userCredential = await _authService.signInWithGoogle();
    return userCredential?.user;
  }
}
