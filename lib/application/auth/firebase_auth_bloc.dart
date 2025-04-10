import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:soulrise/domain/usecases/register_usecase.dart';
import 'package:soulrise/domain/usecases/reset_password_usecase.dart';
import 'package:soulrise/domain/usecases/sign_in_usecase.dart';
import 'package:soulrise/domain/usecases/sign_in_with_facebook_usecase.dart';
import 'package:soulrise/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:soulrise/domain/usecases/sign_out_usecase.dart';

/// Base class for all Firebase authentication events.
abstract class FirebaseAuthEvent {}

/// Event triggered when registering a user.
class RegisterEvent extends FirebaseAuthEvent {
  final String email;
  final String password;
  RegisterEvent(this.email, this.password);
}

/// Event triggered when signing in a user.
class SignInEvent extends FirebaseAuthEvent {
  final String email;
  final String password;
  SignInEvent(this.email, this.password);
}

/// Event triggered to send an email verification to the current user.
class SendEmailVerificationEvent extends FirebaseAuthEvent {}

/// Event triggered to check if the user's email is verified.
class CheckEmailVerificationEvent extends FirebaseAuthEvent {}

/// Event triggered when signing out a user.
class SignOutEvent extends FirebaseAuthEvent {}

/// Event triggered to initiate a password reset process.
class ResetPasswordEvent extends FirebaseAuthEvent {
  final String email;
  ResetPasswordEvent(this.email);
}

/// Event triggered to sign in using Google authentication.
class GoogleSignInEvent extends FirebaseAuthEvent {}

/// Event triggered to sign in using Facebook authentication.
class FacebookSignInEvent extends FirebaseAuthEvent {}

/// Base class for all Firebase authentication states.
abstract class FirebaseAuthState {}

/// Initial state of Firebase authentication.
class FirebaseAuthInitialState extends FirebaseAuthState {}

/// State representing a loading/authenticating process.
class FirebaseAuthLoadingState extends FirebaseAuthState {}

/// State emitted when authentication is successful.
class FirebaseAuthSuccessState extends FirebaseAuthState {
  final User user;
  FirebaseAuthSuccessState(this.user);
}

/// State emitted when an error occurs during authentication.
class FirebaseAuthErrorState extends FirebaseAuthState {
  final String errorMessage;
  FirebaseAuthErrorState(this.errorMessage);
}

/// State emitted when the user is unauthenticated.
class FirebaseAuthUnAuthenticatedState extends FirebaseAuthState {}

/// State emitted when the email verification has been sent.
class EmailVerificationSentState extends FirebaseAuthState {}

/// State emitted when a Google Sign-In is in progress.
class GoogleSignInLoadingState extends FirebaseAuthState {}

/// State emitted when a Google Sign-In is successful.
class GoogleSignInSuccessState extends FirebaseAuthState {
  final User user;
  GoogleSignInSuccessState(this.user);
}

/// State emitted when a Facebook Sign-In is in progress.
class FacebookSignInLoadingState extends FirebaseAuthState {}

/// State emitted when a Facebook Sign-In is successful.
class FacebookSignInSuccessState extends FirebaseAuthState {
  final User user;
  FacebookSignInSuccessState(this.user);
}

/// State emitted when a user's email is not verified.
class FirebaseAuthEmailNotVerifiedState extends FirebaseAuthState {}

/// Bloc class for handling Firebase authentication logic.
class FirebaseAuthBloc extends Bloc<FirebaseAuthEvent, FirebaseAuthState> {
  final RegisterUseCase _registerUseCase;
  final SignInUseCase _signInUseCase;
  final SignOutUseCase _signOutUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;
  final SignInWithGoogleUseCase _signInWithGoogleUseCase;
  final SignInWithFacebookUseCase _signInWithFacebookUseCase;

  FirebaseAuthBloc(
    this._registerUseCase,
    this._signInUseCase,
    this._signOutUseCase,
    this._resetPasswordUseCase,
    this._signInWithGoogleUseCase,
    this._signInWithFacebookUseCase,
  ) : super(FirebaseAuthInitialState()) {
    on<SignInEvent>((event, emit) async {
      emit(FirebaseAuthLoadingState());
      try {
        final user = await _signInUseCase(event.email, event.password);
        emit(FirebaseAuthSuccessState(user!));
      } catch (e) {
        emit(FirebaseAuthErrorState(e.toString()));
      }
    });

    on<RegisterEvent>((event, emit) async {
      emit(FirebaseAuthLoadingState());
      try {
        final user = await _registerUseCase.call(event.email, event.password);
        if (user != null) {
          emit(FirebaseAuthEmailNotVerifiedState());
        }
      } catch (e) {
        emit(FirebaseAuthErrorState(e.toString()));
      }
    });

    on<SendEmailVerificationEvent>((event, emit) async {
      try {
        final user = FirebaseAuth.instance.currentUser;

        if (user == null) {
          emit(FirebaseAuthErrorState("No user is currently logged in."));
          return;
        }

        if (user.emailVerified) {
          emit(FirebaseAuthErrorState("Email is already verified."));
          return;
        }

        await user.sendEmailVerification();
        emit(EmailVerificationSentState());
      } catch (e) {
        emit(FirebaseAuthErrorState("Failed to send verification email: ${e.toString()}"));
      }
    });

    on<CheckEmailVerificationEvent>((event, emit) async {
      try {
        final user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          await user.reload();
          final isVerified = user.emailVerified;

          if (isVerified) {
            emit(FirebaseAuthSuccessState(user));
          } else {
            emit(FirebaseAuthEmailNotVerifiedState());
          }
        } else {
          emit(FirebaseAuthUnAuthenticatedState());
        }
      } catch (e) {
        emit(FirebaseAuthErrorState(e.toString()));
      }
    });

    on<SignOutEvent>((event, emit) async {
      emit(FirebaseAuthLoadingState());
      try {
        await _signOutUseCase();
        emit(FirebaseAuthUnAuthenticatedState());
      } catch (e) {
        emit(FirebaseAuthErrorState(e.toString()));
      }
    });

    on<ResetPasswordEvent>((event, emit) async {
      try {
        await _resetPasswordUseCase(event.email);
        emit(FirebaseAuthInitialState());
      } catch (e) {
        emit(FirebaseAuthErrorState(e.toString()));
      }
    });

    on<GoogleSignInEvent>((event, emit) async {
      emit(GoogleSignInLoadingState());
      try {
        final user = await _signInWithGoogleUseCase.call();
        if (user != null) {
          emit(GoogleSignInSuccessState(user));
        } else {
          emit(FirebaseAuthErrorState("Google Sign-In failed."));
        }
      } catch (e) {
        emit(FirebaseAuthErrorState(e.toString()));
      }
    });

    on<FacebookSignInEvent>((event, emit) async {
      emit(FacebookSignInLoadingState());
      try {
        final user = await _signInWithFacebookUseCase.call();
        if (user != null) {
          emit(FacebookSignInSuccessState(user));
        } else {
          emit(FirebaseAuthErrorState("Facebook Sign-In failed."));
        }
      } catch (e) {
        emit(FirebaseAuthErrorState(e.toString()));
      }
    });
  }
}
