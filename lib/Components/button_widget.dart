import 'package:flutter/material.dart';
import 'package:pose_detection/Components/frosted_glass_effect.dart';

class Buttonwidget extends StatefulWidget {
  final String buttontitle;
  final VoidCallback onPressed;
  final List<Color> gradientColors;
  final double? width; 
  final double? height; 
  const Buttonwidget({
    super.key,
    required this.buttontitle,
    required this.onPressed,
    required this.gradientColors,
    this.width,
    this.height
  });

  @override
  State<Buttonwidget> createState() => ButtonwidgetState();
}

class ButtonwidgetState extends State<Buttonwidget> {
  @override
  Widget build(BuildContext context) {
  return SizedBox(
    width: widget.width,
    height: widget.height,
    child: FrostedGlass(
      gradientColors: widget.gradientColors,
      borderRadius: BorderRadius.circular(20),
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 10,
          shadowColor: Colors.black26,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
        ),
        child: Container(
          alignment: Alignment.center,
          child: Text(
            widget.buttontitle,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    ),
  );
}
}
