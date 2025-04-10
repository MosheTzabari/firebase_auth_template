import 'package:flutter/material.dart';
import 'package:soulrise/presentation/size_config.dart';


class TextStyles {
  static late double _baseFontSize;

  // Initialize the base font size for responsive text scaling
  static void init(BuildContext context) {
    _baseFontSize = SizeConfig.responsiveWidth(16); // One-time calculation of base font size
  }

  // Display Large: Primary heading style
  static TextStyle displayLarge(BuildContext context) {
    return TextStyle(
      fontSize: _baseFontSize * 2.1, // Primary heading size
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.primary, // Uses the primary color from the theme
    );
  }

  // Display Medium: Secondary heading style
  static TextStyle displayMedium(BuildContext context) {
    return TextStyle(
      fontSize: _baseFontSize * 1.75, // Secondary heading size
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.secondary, // Uses the secondary color from the theme
    );
  }

  // Display Small: Tertiary heading style
  static TextStyle displaySmall(BuildContext context) {
    return TextStyle(
      fontSize: _baseFontSize * 1.5, // Tertiary heading size
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.secondary,
    );
  }

  // Title Large: Smaller title style
  static TextStyle titleLarge(BuildContext context) {
    return TextStyle(
      fontSize: _baseFontSize * 1.25, // Smaller title size
      fontWeight: FontWeight.w500,
      color: Theme.of(context).colorScheme.secondary,
    );
  }

  // Body Large: Standard body text style
  static TextStyle bodyLarge(BuildContext context) {
    return TextStyle(
      fontSize: _baseFontSize, // Regular body text size
      fontWeight: FontWeight.normal,
      color: Theme.of(context).colorScheme.secondary,
    );
  }

  // Body Medium: Medium-sized body text style
  static TextStyle bodyMedium(BuildContext context) {
    return TextStyle(
      fontSize: _baseFontSize * 0.875, // Slightly smaller body text size
      fontWeight: FontWeight.normal,
      color: Theme.of(context).colorScheme.secondary,
    );
  }

  // Body Small: Smaller body text style
  static TextStyle bodySmall(BuildContext context) {
    return TextStyle(
      fontSize: _baseFontSize * 0.7, // Very small body text size
      fontWeight: FontWeight.normal,
      color: Theme.of(context).colorScheme.secondary,
    );
  }

  // Title: Central title style for general use
  static TextStyle title(BuildContext context) {
    return TextStyle(
      fontSize: _baseFontSize * 1.4, // Central title size
      fontWeight: FontWeight.w500,
      color: Theme.of(context).colorScheme.secondary,
    );
  }

  // InfoText: Style for informational text
  static TextStyle infoText(BuildContext context) {
    return TextStyle(
      fontSize: _baseFontSize * 1.125, // Informational text size
      fontWeight: FontWeight.normal,
      color: Theme.of(context).colorScheme.secondary,
    );
  }

  // DescriptionText: Style for short descriptions
  static TextStyle descriptionText(BuildContext context) {
    return TextStyle(
      fontSize: _baseFontSize * 0.875, // Description text size
      fontWeight: FontWeight.normal,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  // AnswerText: Style for answer-related text
  static TextStyle answerText(BuildContext context) {
    return TextStyle(
      fontSize: _baseFontSize, // Text size for answers
      fontWeight: FontWeight.normal,
      color: Theme.of(context).colorScheme.secondary,
    );
  }

  // WarningText: Style for warning messages
  static TextStyle warningText(BuildContext context) {
    return TextStyle(
      fontSize: _baseFontSize, // Warning text size
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.error, // Uses the error color from the theme
    );
  }

  // HelpText: Style for help-related text
  static TextStyle helpText(BuildContext context) {
    return TextStyle(
      fontSize: _baseFontSize, // Help text size
      fontWeight: FontWeight.normal,
      color: Theme.of(context).colorScheme.secondary,
    );
  }

  // ButtonText: Style for text used in buttons
  static TextStyle buttonText(BuildContext context) {
    return TextStyle(
      fontSize: _baseFontSize, // Button text size
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.surface, // Uses the surface color from the theme
    );
  }
}
