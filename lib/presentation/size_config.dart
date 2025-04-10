import 'package:flutter/material.dart';

class SizeConfig {
  static late double screenWidth;
  static late double screenHeight;
  static double _baseWidth = 375.0; // Base width used for scaling (iPhone 12)
  static double _baseHeight = 812.0; // Base height used for scaling (iPhone 12)

  // Initialize the screen size based on the context
  static void init(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
  }

  // Scale a given width based on the screen size
  static double responsiveWidth(double width) {
    double scale = screenWidth / _baseWidth; // Calculate scale factor based on screen width
    return width * scale; // Return scaled width
  }

  // Scale a given height based on the screen size
  static double responsiveHeight(double height) {
    double scale = screenHeight / _baseHeight; // Calculate scale factor based on screen height
    return height * scale; // Return scaled height
  }

  // Scale a radius based on the screen width (used for rounded corners)
  static double responsiveRadius(double radius) {
    return responsiveWidth(radius); // Use width scaling to maintain proportions
  }
}
