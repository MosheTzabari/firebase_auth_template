import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:soulrise/application/auth/firebase_auth_bloc.dart';
import 'package:soulrise/presentation/screens/home_screen.dart';
import 'package:soulrise/presentation/screens/reset_password_screen.dart';
import 'package:soulrise/presentation/screens/sign_up_screen.dart';
import 'package:soulrise/presentation/themes/buttons_styles.dart';
import 'package:soulrise/presentation/themes/text_styles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final googleSignIn = GoogleSignIn();

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Dismisses the keyboard when the user taps outside the text fields
  void _dismissKeyboard() {
    _emailFocusNode.unfocus();
    _passwordFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _dismissKeyboard,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Sign In',
            style: TextStyles.title(context),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        resizeToAvoidBottomInset: false,
        body: BlocConsumer<FirebaseAuthBloc, FirebaseAuthState>(
          listener: (context, state) {
            if (state is FirebaseAuthLoadingState ||
                state is GoogleSignInLoadingState ||
                state is FacebookSignInLoadingState) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) =>
                    const Center(child: CircularProgressIndicator()),
              );
            }

            if (state is FirebaseAuthErrorState) {
              Navigator.of(context).pop(); // Closes the progress dialog
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage)),
              );
            } else if (state is FirebaseAuthSuccessState ||
                state is GoogleSignInSuccessState ||
                state is FacebookSignInSuccessState) {
              Navigator.of(context).pop(); // Close the progress dialog before navigation
              // Navigate to the home screen upon successful login
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (ctx) => const HomeScreen()));
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      'Hello, Welcome back',
                      style: TextStyles.bodyLarge(context),
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(flex: 1),

                    // Email input field
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email Address',
                        border: OutlineInputBorder(),
                      ),
                      focusNode: _emailFocusNode,
                      style: TextStyles.bodyLarge(context).copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email';
                        } else if (!RegExp(
                                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                            .hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),

                    // Password input field with toggle visibility
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      focusNode: _passwordFocusNode,
                      style: TextStyles.bodyLarge(context).copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      validator: (value) {
                        return (value == null || value.isEmpty)
                            ? 'Please enter a password'
                            : !RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&]).{6,}$')
                                    .hasMatch(value)
                                ? 'Password must be 6+ characters with uppercase, lowercase, number & special character.'
                                : null;
                      },
                    ),

                    // Forgot Password link
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) => const ResetPasswordScreen()));
                        },
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        child: Text(
                          'Forgot password?',
                          style: TextStyles.bodySmall(context).copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(flex: 1),

                    // Login button
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<FirebaseAuthBloc>().add(
                                SignInEvent(
                                  _emailController.text,
                                  _passwordController.text,
                                ),
                              );
                        }
                      },
                      style: ButtonsStyles.buttonPrimary(context),
                      child: Text(
                        'Login',
                        style: TextStyles.buttonText(context),
                      ),
                    ),
                    const Spacer(flex: 1),

                    // Alternative login options
                    Text(
                      'Or login with',
                      style: TextStyles.bodyLarge(context),
                      textAlign: TextAlign.center,
                    ),

                    const Spacer(flex: 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ButtonsStyles.buildSocialButton(
                          svgPath: ('assets/icons/icon-facebook.svg'),
                          onPressed: () {
                            context.read<FirebaseAuthBloc>().add(FacebookSignInEvent());
                          },
                        ),
                        ButtonsStyles.buildSocialButton(
                          svgPath: ('assets/icons/icon-google.svg'),
                          onPressed: () async {
                            context.read<FirebaseAuthBloc>().add(GoogleSignInEvent());
                          },
                        ),
                        ButtonsStyles.buildSocialButton(
                          svgPath: ('assets/icons/icons8-apple.svg'),
                          onPressed: () {
                            // Handle Apple login (not implemented here)
                          },
                        ),
                      ],
                    ),

                    const Spacer(flex: 1),

                    // Sign up option at the bottom
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don’t have an account?',
                          style: TextStyles.bodyMedium(context),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (ctx) => const SignUpScreen()));
                          },
                          style: TextButton.styleFrom(padding: EdgeInsets.zero),
                          child: Text(
                            'Sign Up',
                            style: TextStyles.bodyMedium(context).copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
