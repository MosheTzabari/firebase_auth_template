import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soulrise/application/auth/firebase_auth_bloc.dart';
import 'package:soulrise/presentation/themes/text_styles.dart';
import 'package:soulrise/presentation/screens/home_screen.dart';
import 'package:soulrise/presentation/screens/login_screen.dart';
import 'package:soulrise/presentation/screens/register_verify_email_screen.dart';
import 'package:soulrise/presentation/themes/buttons_styles.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    // Dispose the focus nodes to free up resources.
    _usernameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Dismiss the keyboard by unfocusing all fields.
  void _dismissKeyboard() {
    _usernameFocusNode.unfocus();
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
            'Sign Up', 
            style: TextStyles.title(context),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        resizeToAvoidBottomInset: false,
        body: BlocConsumer<FirebaseAuthBloc, FirebaseAuthState>(
          listener: (context, state) {
            // Handle different states from the FirebaseAuthBloc
            if (state is FirebaseAuthLoadingState ||
                state is GoogleSignInLoadingState ||
                state is FacebookSignInLoadingState) {
              showDialog(
                context: context,
                barrierDismissible: false, // Prevent dismissing by tapping outside
                builder: (context) =>
                    const Center(child: CircularProgressIndicator()),
              );
            }
            if (state is FirebaseAuthErrorState) {
              Navigator.of(context).pop(); // Close the loading dialog
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage)),
              );
            } else if (state is FirebaseAuthEmailNotVerifiedState) {
              Navigator.of(context).pop(); // Close the loading dialog
              // Navigate to email verification screen after successful registration
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (ctx) => const VerifyEmailScreen()),
              );
            } else if (state is GoogleSignInSuccessState ||
                state is FacebookSignInSuccessState) {
              Navigator.of(context).pop(); // Close the loading dialog before navigating
              // Navigate to the home screen after successful sign-in
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (ctx) => const HomeScreen()));
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Create your account',
                      style: TextStyles.bodyLarge(context),
                      textAlign: TextAlign.center,
                    ),

                    const Spacer(flex: 1),

                    TextFormField(
                        controller: _usernameController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(),
                        ),
                        focusNode: _usernameFocusNode,
                        style: TextStyles.bodyLarge(context).copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        )),

                    const SizedBox(height: 14),

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
                        }),

                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'By signing up you agree to our ',
                          style: TextStyles.bodySmall(context),
                        ),
                        TextButton(
                          onPressed: () {
                            print("Terms of Use pressed ");
                          },
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.zero, 
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap 
                              ),
                          child: Text(
                            'Terms of Use ',
                            style: TextStyles.bodySmall(context).copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              decoration: TextDecoration.underline,
                              decorationColor:
                                  Theme.of(context).colorScheme.primary,
                              decorationThickness: (1.0),
                            ),
                          ),
                        ),
                        Text(
                          'and ',
                          style: TextStyles.bodySmall(context),
                        ),
                        TextButton(
                          onPressed: () {
                            print("Privacy Policy pressed");
                          },
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.zero, 
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap 
                              ),
                          child: Text(
                            'Privacy Policy.',
                            style: TextStyles.bodySmall(context).copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              decoration: TextDecoration.underline,
                              decorationColor:
                                  Theme.of(context).colorScheme.primary,
                              decorationThickness: (1.0),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const Spacer(flex: 1),
                    // Continue button
                    ElevatedButton(
                      onPressed: () {
                        print("Continue button pressed");
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, proceed with the request
                          print("Valid Input! Sending data...");
                          context.read<FirebaseAuthBloc>().add(
                                RegisterEvent(
                                  _emailController.text,
                                  _passwordController.text,
                                ),
                              );
                        }
                      },
                      style: ButtonsStyles.buttonPrimary(context),
                      child: Text(
                        'Continue',
                        style: TextStyles.buttonText(context),
                      ),
                    ),

                    const Spacer(flex: 1),
                    // "Or sign up with" text
                    Text(
                      'Or sign up with',
                      style: TextStyles.bodyLarge(context),
                      textAlign: TextAlign.center,
                    ),

                    const Spacer(flex: 1),
                    // Social buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ButtonsStyles.buildSocialButton(
                          svgPath: ('assets/icons/icon-facebook.svg'),
                          onPressed: () {
                            print("Login with Facebook");
                            context
                                .read<FirebaseAuthBloc>()
                                .add(FacebookSignInEvent());
                          },
                        ),
                        ButtonsStyles.buildSocialButton(
                          svgPath: ('assets/icons/icon-google.svg'),
                          onPressed: () {
                            print("Login with Google");
                            context
                                .read<FirebaseAuthBloc>()
                                .add(GoogleSignInEvent());
                          },
                        ),
                        ButtonsStyles.buildSocialButton(
                          svgPath: ('assets/icons/icons8-apple.svg'),
                          onPressed: () {
                            print("Login with Apple");
                          },
                        ),
                      ],
                    ),

                    const Spacer(flex: 1),
                    // Bottom text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style: TextStyles.bodyMedium(context),
                        ),
                        TextButton(
                          onPressed: () {
                            print("Login pressed");
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (ctx) => const LoginScreen()));
                          },
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                          child: Text(
                            'Login',
                            style: TextStyles.bodyMedium(context).copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              decoration: TextDecoration.underline,
                              decorationColor:
                                  Theme.of(context).colorScheme.primary,
                              decorationThickness: (1.0),
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
