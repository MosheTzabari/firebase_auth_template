import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soulrise/presentation/size_config.dart';

class ButtonsStyles {
  // Creates a primary styled button with responsive size
  static ButtonStyle buttonPrimary(BuildContext context) {
    return ElevatedButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.primary, // Button color based on theme
      minimumSize: Size(
        double.infinity, // Full width
        SizeConfig.responsiveHeight(50), // Responsive height
      ),
    );
  }

  // Builds a social media button with an SVG icon
  static Widget buildSocialButton({
    required String svgPath,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      splashColor: Colors.transparent, // Disables splash effect
      highlightColor: Colors.transparent, // Disables highlight effect
      child: Container(
        height: SizeConfig.responsiveHeight(60),
        width: SizeConfig.responsiveWidth(80),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFF3D3D3D), // Dark background for the button
        ),
        child: Center(
          child: SvgPicture.asset(
            svgPath,
            height: SizeConfig.responsiveWidth(34), // Responsive icon size
            width: SizeConfig.responsiveWidth(34),
          ),
        ),
      ),
    );
  }
}
