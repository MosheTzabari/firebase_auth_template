import 'package:soulrise/presentation/themes/custom_color_scheme.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soulrise/application/auth/firebase_auth_bloc.dart';
import 'package:soulrise/core/providers/usecase_provider.dart';
import 'package:soulrise/presentation/screens/splash_screen.dart';
import 'package:soulrise/presentation/size_config.dart';
import 'package:soulrise/presentation/themes/text_styles.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Custom dark theme using the predefined color scheme
final ThemeData appTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: CustomColorScheme.surface,
  colorScheme: CustomColorScheme.darkScheme,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize all use cases from UseCaseProvider
  final useCases = UseCaseProvider.init();

  runApp(
    MultiBlocProvider(
      providers: [
        // Firebase authentication bloc to manage user authentication
        BlocProvider(
          create: (context) => FirebaseAuthBloc(
            useCases.registerUseCase,
            useCases.signInUseCase,
            useCases.signOutUseCase,
            useCases.resetPasswordUseCase,
            useCases.signInWithGoogleUseCase,
            useCases.signInWithFacebookUseCase,
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SoulRise',
      theme: appTheme,
      navigatorKey: navigatorKey,
      home: const SplashScreen(),
      builder: (context, child) {
        // Initialize size configuration and text styles
        SizeConfig.init(context);
        TextStyles.init(context);
        return child!; // Ensure that child is not null
      },
    );
  }
}
