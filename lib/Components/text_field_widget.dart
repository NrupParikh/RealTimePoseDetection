import 'package:flutter/material.dart';
class TextWidget extends StatefulWidget {
  final String hintTitle;
  final IconData rightIcon;
  final bool hideIcon;
  final TextInputType keyboardType;
  final TextEditingController controller;
  
  const TextWidget({
    super.key,
    required this.hintTitle,
    required this.rightIcon,
    required this.hideIcon,
    required this.keyboardType,
    required this.controller,
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
       obscureText:widget.hideIcon ? obscureText : false,
      decoration: InputDecoration(
        prefixIcon: Icon(
          widget.rightIcon,
        ), //Icon(Icons.email), // Change icon as needed
        suffixIcon: widget.hideIcon
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: togglePasswordVisibility,
              )
            : null,
        hintText: widget.hintTitle, //'Email',
        filled: true,
        fillColor: const Color.fromARGB(115, 229, 226, 226),
       
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0), // Corner radius
          borderSide: BorderSide.none, // No border line
        ),
      ),
    );
  }
}
