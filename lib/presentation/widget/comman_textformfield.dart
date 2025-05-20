import 'package:flutter/material.dart';

class CommonTextformfield extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String errorText;
  final String? Function(String?)? validator;
  final bool isPassword; // New parameter to identify password fields
  final bool enabled; // New parameter to control field enable/disable state

  const CommonTextformfield({
    super.key,
    required this.controller,
    required this.labelText,
    required this.errorText,
    required this.validator,
    this.isPassword = false, // Default to false for regular text fields
    this.enabled = true, // Default to true to allow editing
  });

  @override
  State<CommonTextformfield> createState() => _CommonTextformfieldState();
}

class _CommonTextformfieldState extends State<CommonTextformfield> {
  bool _obscureText = true; // Initial value for password visibility

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword ? _obscureText : false,
      // Apply obscuring only to password fields
      enabled: widget.enabled,
      // Pass enabled property to TextFormField
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: theme.colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: theme.colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: theme.colorScheme.error, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: theme.colorScheme.outline.withOpacity(0.3)),
        ),
        filled: true,
        fillColor:
            widget.enabled ? theme.colorScheme.surface : theme.colorScheme.surface.withOpacity(0.5),
        // Adjust fill color for disabled state
        // Add suffix icon for password fields to toggle visibility
        suffixIcon:
            widget.isPassword
                ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  onPressed:
                      widget.enabled
                          ? () {
                            setState(() {
                              _obscureText = !_obscureText; // Toggle password visibility
                            });
                          }
                          : null, // Disable suffix icon when field is disabled
                )
                : null,
      ),
      validator: widget.validator,
      style: TextStyle(
        color:
            widget.enabled
                ? theme.colorScheme.onSurface
                : theme.colorScheme.onSurface.withOpacity(
                  0.5,
                ), // Adjust text color for disabled state
      ),
    );
  }
}
