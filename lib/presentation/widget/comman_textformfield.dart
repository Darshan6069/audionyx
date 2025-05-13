import 'package:flutter/material.dart';
import 'package:audionyx/core/constants/theme_color.dart';

class CommonTextformfield extends StatelessWidget {
  final TextEditingController controller;
  final int? maxLength;
  final String labelText;
  final String errorText;
  final String? Function(String?)? validator;

  const CommonTextformfield({
    super.key,
    this.maxLength,
    required this.labelText,
    required this.controller,
    required this.errorText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      maxLength: maxLength,
      controller: controller,
      validator: validator ?? (value) => null,
      onSaved: (value) {
        controller.text = value ?? '';
      },
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: theme.brightness == Brightness.dark ? Colors.white70 : Colors.black54),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15.0,
          horizontal: 10.0,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
              color: theme.brightness == Brightness.dark ? ThemeColor.whiteColor : ThemeColor.blackColor,
              width: 4
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: theme.brightness == Brightness.dark ? ThemeColor.whiteColor : ThemeColor.blackColor,
              width: 2
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: theme.brightness == Brightness.dark ? Colors.white70 : Colors.black54,
              width: 2
          ),
        ),
      ),
    );
  }
}