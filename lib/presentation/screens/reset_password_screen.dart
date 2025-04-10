import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soulrise/application/auth/firebase_auth_bloc.dart';
import 'package:soulrise/presentation/themes/text_styles.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController(); // Controller for email input
  final _formKey = GlobalKey<FormState>(); // Global key for the form to handle validation
  final FocusNode _emailFocusNode = FocusNode(); // Focus node for email input

  // Method to handle password reset request
  void _resetPassword() {
    final email = _emailController.text.trim(); // Get the email entered by the user
    if (email.isNotEmpty) {
      // If the email is not empty, trigger the reset password event
      context.read<FirebaseAuthBloc>().add(ResetPasswordEvent(email));
    } else {
      // Show a snack bar if the email is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email')),
      );
    }
  }

  @override
  void dispose() {
    // Dispose of controllers and focus nodes to prevent memory leaks
    _emailController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  // Dismiss the keyboard when tapping outside the text field
  void _dismissKeyboard() {
    _emailFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _dismissKeyboard, // Dismiss the keyboard when tapping outside
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Reset Password', // Screen title
            style: TextStyles.title(context),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white), // Customize icon color
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Form(
                key: _formKey, // Assign form key for validation
                child: TextFormField(
                    controller: _emailController, // Bind the text field to the controller
                    decoration: const InputDecoration(
                      labelText: 'Enter your email', // Label for the email field
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress, // Set input type to email
                    focusNode: _emailFocusNode, // Set the focus node for this text field
                    style: TextStyles.bodyLarge(context).copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    validator: (value) {
                      // Validate email input
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email'; // Check if email is empty
                      } else if (!RegExp(
                              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                          .hasMatch(value)) {
                        return 'Please enter a valid email'; // Check if email is valid
                      }
                      return null; // Return null if the input is valid
                    }),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Trigger password reset if form is valid
                  if (_formKey.currentState!.validate()) {
                    _resetPassword();
                  }
                },
                child: const Text('Send Reset Link'), // Button to send reset link
              ),
            ],
          ),
        ),
      ),
    );
  }
}
