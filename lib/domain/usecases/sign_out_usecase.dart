import 'package:soulrise/data/services/firebase_auth_service.dart';

class SignOutUseCase {
  final FirebaseAuthService _authService;

  SignOutUseCase(this._authService);

  Future<void> call() async {
    await _authService.signOut();
  }
}
