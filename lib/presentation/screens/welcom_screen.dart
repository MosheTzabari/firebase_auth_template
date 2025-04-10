import 'package:flutter/material.dart';

import 'package:soulrise/presentation/screens/login_screen.dart';
import 'package:soulrise/presentation/screens/sign_up_screen.dart';
import 'package:soulrise/presentation/themes/buttons_styles.dart';
import 'package:soulrise/presentation/themes/text_styles.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              // Logo and title
              Expanded(
                flex: 2, // Allocate more space for the logo and titles
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo image
                    Image.asset(
                      'assets/images/Logo1.png', // Path to the image
                    ),
                    const SizedBox(height: 10),
                    // Secondary title
                    Text(
                      'Your Social Network for Events',
                      style: TextStyles.title(context),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    // Description text
                    Text(
                      'Discover the best parties and events, \n connect with others who share your vibe, and follow your favorite productions. \n Filter by location, genre, and crowd, and never miss an unforgettable experience!',
                      style: TextStyles.bodyLarge(context),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              // Buttons section
              Expanded(
                flex: 1, // Allocate less space for the buttons
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Login button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => const LoginScreen()));
                      },
                      style: ButtonsStyles.buttonPrimary(context),
                      child: Text(
                        'Login',
                        style: TextStyles.buttonText(context),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Sign Up button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => const SignUpScreen()));
                      },
                      style: ButtonsStyles.buttonPrimary(context),
                      child: Text(
                        'Sign Up',
                        style: TextStyles.buttonText(context),
                      ),
                    ),

                    const SizedBox(height: 40), // Spacer below the bottom button
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
