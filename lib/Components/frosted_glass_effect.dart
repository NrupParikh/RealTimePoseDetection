import 'package:flutter/material.dart';

/// A widget that creates a frosted glass effect with a gradient background.
/// It clips its child to a rounded rectangle and applies a blur effect.
class FrostedGlass extends StatelessWidget {
  final double? width;
  final double? height; // Made nullable to allow child to dictate height
  final Widget child;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool applyFilter;
  final List<Color> gradientColors; // Customizable gradient colors
  final Color borderColor; // Customizable border color
  final double blurSigmaX; // New: Customizable blur intensity for X-axis
  final double blurSigmaY; // New: Customizable blur intensity for Y-axis

  const FrostedGlass({
    super.key,
    this.width,
    this.height, // Height is now optional
    required this.child,
    this.borderRadius = const BorderRadius.vertical(top: Radius.circular(30)),
    this.padding,
    this.applyFilter = false,
    // Default gradient colors for a light frosted effect
    // this.gradientColors = const [
    //   Color.fromRGBO(255, 255, 255, 0.25), // White with 25% opacity
    //   Color.fromRGBO(255, 255, 255, 0.05), // White with 5% opacity
    // ],

    this.gradientColors = const [
      Color.fromRGBO(255, 255, 255, 0.25), // White with 25% opacity
      Color.fromRGBO(255, 255, 255, 0.05), // White with 5% opacity
    ],
    // Default border color with transparency
    this.borderColor = const Color.fromRGBO(255, 255, 255, 0.2),
    this.blurSigmaX = 10.0, // Default blur intensity for X-axis
    this.blurSigmaY = 10.0, // Default blur intensity for Y-axis
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      // child: applyFilter
      //     ? BackdropFilter( // Conditionally applies the blur effect to content behind
      //         filter: ImageFilter.blur(sigmaX: blurSigmaX, sigmaY: blurSigmaY), // Use customizable blur intensity
      //         child: buildGlassContainer(),
      //       )
      //     : buildGlassContainer(), // If no filter, just build the container

          // For Emulator only
         child: buildGlassContainer(), // If no filter, just build the container
    );
  }

  Widget buildGlassContainer() {
    return Container(
      height: height, // Will take child's height if null
      width: width??double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft, // Start of the gradient
          end: Alignment.centerRight, // End of the gradient
          colors: gradientColors, // Use customizable gradient colors
        ),
        borderRadius: borderRadius,
        border: Border.all(
          color: borderColor, // Use customizable border color
        ),
      ),
      child: child,
    );
  }
}
