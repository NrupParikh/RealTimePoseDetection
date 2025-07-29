import 'package:flutter/material.dart';

class TextWidget extends StatefulWidget {
  final String hintTitle;
  final IconData rightIcon;
  final bool hideIcon;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;
  final bool? isEnabled; // New property for enable/disable

  const TextWidget({
    super.key,
    required this.hintTitle,
    required this.rightIcon,
    required this.hideIcon,
    required this.keyboardType,
    required this.controller,
    this.textInputAction,
    this.onSubmitted,
    this.focusNode,
    this.isEnabled = true, // Default to true (enabled)
  });

  @override
  State<TextWidget> createState() => _TextWidgetState();
}

class _TextWidgetState extends State<TextWidget> {
  bool obscureText = true;

  void togglePasswordVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: widget.hideIcon ? obscureText : false,
      textInputAction: widget.textInputAction,
      onSubmitted: widget.onSubmitted,
      focusNode: widget.focusNode,
      enabled: widget.isEnabled,
      decoration: InputDecoration(
        prefixIcon: Icon(
          widget.rightIcon,
        ),
        suffixIcon: widget.hideIcon
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: (widget.isEnabled ?? false) ? togglePasswordVisibility : null, 
              )
            : null,
        hintText: widget.hintTitle,
        filled: true,
        fillColor: const Color.fromARGB(115, 229, 226, 226),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}