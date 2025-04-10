import 'package:soulrise/data/services/firebase_auth_service.dart';
import 'package:soulrise/domain/usecases/register_usecase.dart';
import 'package:soulrise/domain/usecases/reset_password_usecase.dart';
import 'package:soulrise/domain/usecases/sign_in_usecase.dart';
import 'package:soulrise/domain/usecases/sign_out_usecase.dart';
import 'package:soulrise/domain/usecases/sign_in_with_facebook_usecase.dart';
import 'package:soulrise/domain/usecases/sign_in_with_google_usecase.dart';

/// Provides instances of all authentication-related use cases.
///
/// This class is responsible for initializing and injecting dependencies
/// required for various authentication operations. It uses a single instance
/// of [FirebaseAuthService] for all use cases.
class UseCaseProvider {
  final RegisterUseCase registerUseCase;
  final SignInUseCase signInUseCase;
  final SignOutUseCase signOutUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  final SignInWithGoogleUseCase signInWithGoogleUseCase;
  final SignInWithFacebookUseCase signInWithFacebookUseCase;

  /// Private named constructor used for initializing the [UseCaseProvider].
  UseCaseProvider._({
    required this.registerUseCase,
    required this.signInUseCase,
    required this.signOutUseCase,
    required this.resetPasswordUseCase,
    required this.signInWithGoogleUseCase,
    required this.signInWithFacebookUseCase,
  });

  /// Factory method to initialize and return a configured [UseCaseProvider].
  static UseCaseProvider init() {
    final firebaseAuthService = FirebaseAuthService();

    return UseCaseProvider._(
      registerUseCase: RegisterUseCase(firebaseAuthService),
      signInUseCase: SignInUseCase(firebaseAuthService),
      signOutUseCase: SignOutUseCase(firebaseAuthService),
      resetPasswordUseCase: ResetPasswordUseCase(firebaseAuthService),
      signInWithGoogleUseCase:
          SignInWithGoogleUseCase(firebaseAuthService, ),
      signInWithFacebookUseCase:
          SignInWithFacebookUseCase(firebaseAuthService),
    );
  }
}
