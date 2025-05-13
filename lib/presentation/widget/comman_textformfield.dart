import 'package:flutter/material.dart';

class CommonTextformfield extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String errorText;
  final String? Function(String?)? validator;
  final bool isPassword;  // New parameter to identify password fields

  const CommonTextformfield({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.errorText,
    required this.validator,
    this.isPassword = false,  // Default to false for regular text fields
  }) : super(key: key);

  @override
  State<CommonTextformfield> createState() => _CommonTextformfieldState();
}

class _CommonTextformfieldState extends State<CommonTextformfield> {
  bool _obscureText = true;  // Initial value for password visibility

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword ? _obscureText : false,  // Apply obscuring only to password fields
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: TextStyle(
          color: theme.colorScheme.onSurface.withOpacity(0.6),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: theme.colorScheme.outline,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: theme.colorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: theme.colorScheme.error,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: theme.colorScheme.error,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: theme.colorScheme.surface,
        // Add suffix icon for password fields to toggle visibility
        suffixIcon: widget.isPassword
            ? IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;  // Toggle password visibility
            });
          },
        )
            : null,
      ),
      validator: widget.validator,
      style: TextStyle(
        color: theme.colorScheme.onSurface,
      ),
    );
  }
}