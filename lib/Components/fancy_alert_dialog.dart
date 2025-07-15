import 'package:flutter/material.dart';
import 'package:pose_detection/Components/button_widget.dart';
import 'package:pose_detection/Components/frosted_glass_effect.dart';
import 'package:pose_detection/Constants/app_colors.dart';

/// A fancy alert dialog with a frosted glass background, customizable title,
/// description, and optional OK and Cancel buttons.
class FancyAlertDialog extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onOkPressed;
  final VoidCallback? onCancelPressed; // Optional cancel button callback
  final String okButtonText;
  final String cancelButtonText;
  final BorderRadius borderRadius; // Corner radius for the dialog

  const FancyAlertDialog({
    super.key,
    required this.title,
    required this.description,
    required this.onOkPressed,
    this.onCancelPressed,
    this.okButtonText = 'OK', // Default text for OK button
    this.cancelButtonText = 'Cancel', // Default text for Cancel button
    this.borderRadius = const BorderRadius.all(
      Radius.circular(20),
    ), // Default dialog corner radius
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // Make the default dialog background transparent to show FrostedGlass
      backgroundColor: Colors.transparent,
      // Apply the desired border radius to the dialog itself
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      child: FrostedGlass(
        applyFilter: true,
          gradientColors: [ColorConstants.endColor,Colors.black],
        // Removed 'height: 400' to allow the height to be determined by content
        borderRadius: borderRadius, // Apply the same radius to FrostedGlass
        padding: const EdgeInsets.all(
          20,
        ), // Padding inside the frosted glass area
        child: IntrinsicHeight(
          // Ensures the FrostedGlass takes the minimum height required by its children
          child: Column(
            mainAxisSize:
                MainAxisSize.min, // Column takes minimum vertical space
            children: [
              // Dialog Title
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // White text for contrast
                 
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16), // Spacing below title
              // Dialog Description
              Text(
                description,
                style: TextStyle(fontSize: 14, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24), // Spacing below description
              // Buttons Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Cancel Button (optional)
                  if (onCancelPressed != null)
                    Expanded(
                      // Allows button to take available space
                      child: Buttonwidget(
                        buttontitle: cancelButtonText,
                        gradientColors: [
                          ColorConstants.startColor, // Start blue
                          ColorConstants.endColor, // End purple-ish
                        ],
                        onPressed: onCancelPressed ?? () {},
                      ),
                    ),
                  // Space between buttons if both are present
                  if (onCancelPressed != null) const SizedBox(width: 16),
                  // OK Button
                  Expanded(
                    // Allows button to take available space
                    child: Buttonwidget(
                      gradientColors: [
                        ColorConstants.startColor, // Start blue
                        ColorConstants.endColor, // End purple-ish
                      ],
                      buttontitle: okButtonText,
                      onPressed: onOkPressed,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void showFancyAlertDialog({
    required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onOkPressed,
    required VoidCallback? onCancelPressed,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FancyAlertDialog(
          title: title,
          description: message,
          onOkPressed: onOkPressed,
          onCancelPressed: onCancelPressed,
        );
      },
    );
  }
}
