import 'dart:async';
import 'package:flutter/material.dart';
import 'package:soulrise/presentation/themes/text_styles.dart';
import 'package:soulrise/presentation/screens/welcom_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Timer to wait for 2 seconds before navigating to the Welcome screen
    Timer(const Duration(seconds: 2), () {
      // Navigate to the Welcome screen and replace the current screen (SplashScreen)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          // Center aligns the content properly
          child: Column(
            mainAxisSize: MainAxisSize
                .min, // Ensures the column does not take up more space than its content
            children: [
              Text(
                'SoulRise',
                style: TextStyles.displayLarge(context),
              ),

              const SizedBox(height: 8), // Adds spacing between elements
              const Image(
                image: AssetImage('assets/images/Logo1.png'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
