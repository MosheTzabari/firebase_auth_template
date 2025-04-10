import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Handles Firebase authentication operations, including
/// email/password, Google, and Facebook sign-in.
class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Registers a new user using email and password.
  /// Sends a verification email upon success.
  Future<UserCredential?> registerWithEmailPassword(
      String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user?.sendEmailVerification();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "An error occurred during registration.";
    }
  }
  
  /// Sends a verification email to the current user.
  /// This method should be called after user registration.
  sendEmailVerification() {}

  /// Returns whether the current user's email is verified.
  Future<bool> isEmailVerified() async {
    User? user = _firebaseAuth.currentUser;
    await user?.reload();
    return user?.emailVerified ?? false;
  }

  /// Signs in a user using email and password.
  Future<UserCredential?> signInWithEmailPassword(
      String email, String password) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "An error occurred during login.";
    }
  }

  /// Returns the current logged-in user.
  Future<User?> getCurrentUser() async {
    try {
      return _firebaseAuth.currentUser;
    } catch (_) {
      throw "Error fetching user data.";
    }
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  /// Sends a password reset email to the given email address.
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (_) {
      throw "Error sending reset email.";
    }
  }

  /// Signs in with a given Firebase [AuthCredential].
  Future<UserCredential> signInWithCredential(AuthCredential credential) async {
    return await _firebaseAuth.signInWithCredential(credential);
  }

  /// Signs in the user using Google authentication.
  Future<UserCredential?> signInWithGoogle() async {
    try {
      if (_firebaseAuth.currentUser != null) {
        await _firebaseAuth.signOut();
        await _googleSignIn.signOut();
      }

      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "An error occurred during Google Sign-In.";
    }
  }

  /// Signs in the user using Facebook authentication.
  Future<UserCredential?> signInWithFacebook() async {
    try {
      if (_firebaseAuth.currentUser != null) {
        await _firebaseAuth.signOut();
      }

      await FacebookAuth.instance.logOut();

      final result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status != LoginStatus.success) return null;

      final accessToken = result.accessToken;
      if (accessToken == null) return null;

      final credential =
          FacebookAuthProvider.credential(accessToken.tokenString);

      return await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "An error occurred during Facebook Sign-In.";
    }
  }
}
