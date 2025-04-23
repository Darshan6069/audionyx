import 'package:flutter/material.dart';

import '../../core/constants/theme_color.dart';

class CommonTextformfield extends StatelessWidget {
  final TextEditingController controller;
  final int? maxLength;
  final String labelText;
  final String errorText;
  final String? Function(String?)? validator; // Optional validator

  const CommonTextformfield({
    super.key,
    this.maxLength,
    required this.labelText,
    required this.controller,
    required this.errorText,
    this.validator, // Optional parameter
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength:maxLength,
      controller: controller,
      validator: validator ?? (value) => null, // Default to no validation if not provided
      onSaved: (value) {
        controller.text = value ?? '';
      },
      keyboardType: TextInputType.name,
      decoration: InputDecoration(

        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.white70),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15.0,
          horizontal: 10.0,
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 4),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white70, width: 2),
        ),
      ),
    );
  }
}
