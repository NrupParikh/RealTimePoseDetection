import 'package:flutter/material.dart';


class TitleWidget extends StatelessWidget {
  final String titleText;
  const TitleWidget({super.key,
  required this.titleText});
  
  @override
  Widget build(BuildContext context) {
    return Text(
      titleText,
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
