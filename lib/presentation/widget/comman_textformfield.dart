import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class CommonTextformfield extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String errorText;
  final String? Function(String?)? validator;
  final bool isPassword;
  final bool enabled;

  const CommonTextformfield({
    super.key,
    required this.controller,
    required this.labelText,
    required this.errorText,
    required this.validator,
    this.isPassword = false,
    this.enabled = true,
  });

  @override
  State<CommonTextformfield> createState() => _CommonTextformfieldState();
}

class _CommonTextformfieldState extends State<CommonTextformfield> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;
    final borderRadius =
        isDesktop
            ? 12.0
            : isTablet
            ? 10.0
            : 8.0;
    final fontSize =
        isDesktop
            ? 18.0
            : isTablet
            ? 16.0
            : 14.0;
    final iconSize =
        isDesktop
            ? 28.0
            : isTablet
            ? 24.0
            : 20.0;
    final padding =
        isDesktop
            ? 16.0
            : isTablet
            ? 12.0
            : 8.0;

    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword ? _obscureText : false,
      enabled: widget.enabled,
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: TextStyle(
          color: theme.colorScheme.onSurface.withOpacity(0.6),
          fontSize: fontSize,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: theme.colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: theme.colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: theme.colorScheme.error, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: theme.colorScheme.outline.withOpacity(0.3)),
        ),
        filled: true,
        fillColor:
            widget.enabled ? theme.colorScheme.surface : theme.colorScheme.surface.withOpacity(0.5),
        contentPadding: EdgeInsets.symmetric(horizontal: padding, vertical: padding),
        suffixIcon:
            widget.isPassword
                ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: theme.colorScheme.onSurfaceVariant,
                    size: iconSize,
                  ),
                  onPressed:
                      widget.enabled
                          ? () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          }
                          : null,
                )
                : null,
      ),
      validator: widget.validator,
      style: TextStyle(
        color:
            widget.enabled
                ? theme.colorScheme.onSurface
                : theme.colorScheme.onSurface.withOpacity(0.5),
        fontSize: fontSize,
      ),
    );
  }
}
