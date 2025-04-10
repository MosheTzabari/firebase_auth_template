import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soulrise/application/auth/firebase_auth_bloc.dart';
import 'package:soulrise/presentation/themes/text_styles.dart';
import 'package:soulrise/presentation/screens/home_screen.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startEmailVerificationCheck(); // Starts checking for email verification every 5 seconds
  }

  // Function that checks for email verification every 5 seconds
  void _startEmailVerificationCheck() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      context.read<FirebaseAuthBloc>().add(CheckEmailVerificationEvent());
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancels the timer when leaving the screen
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Email Verification",
          style: TextStyles.title(context),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocListener<FirebaseAuthBloc, FirebaseAuthState>(
        listener: (context, state) {
          // Listens to changes in the state, and navigates to home if email is verified
          if (state is FirebaseAuthSuccessState && state.user.emailVerified) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (ctx) => const HomeScreen()));
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    // Displays a success message that the email has been sent
                    Row(children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 24),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "A verification link has been sent to your email account.",
                          style: TextStyles.bodyLarge(context),
                        ),
                      ),
                    ]),
                    Divider(
                      color: Theme.of(context).colorScheme.primary, // Divider color
                      thickness: 0.5, // Divider thickness
                      height: 20, // Space between rows
                    ),
                    Text(
                      'Please click on the link that has just been sent to your email account to verify your email and continue the registration process.',
                      style: TextStyles.bodyMedium(context),
                    ),
                  ],
                ),
              ),
              // Option to resend the verification email if not received
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Didn\'t receive the email? ',
                        style: TextStyles.bodyMedium(context),
                      ),
                      TextButton(
                        onPressed: () {
                          // Resends the verification email if it hasn't been received
                          context
                              .read<FirebaseAuthBloc>()
                              .add(SendEmailVerificationEvent());
                          print("Resend pressed");
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero, // Removes internal padding
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Adjusts tap area
                        ),
                        child: Text(
                          'Click here to resend',
                          style: TextStyles.bodyMedium(context).copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            decoration: TextDecoration.underline,
                            decorationColor: Theme.of(context).colorScheme.primary,
                            decorationThickness: (0.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
