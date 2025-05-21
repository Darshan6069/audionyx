import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class AuthPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const AuthPrimaryButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;
    final buttonHeight =
        isDesktop
            ? 56.0
            : isTablet
            ? 52.0
            : 49.0;
    final fontSize =
        isDesktop
            ? 18.0
            : isTablet
            ? 17.0
            : 16.0;
    final borderRadius =
        isDesktop
            ? 30.0
            : isTablet
            ? 28.0
            : 25.0;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(MediaQuery.of(context).size.width, buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        ),
        backgroundColor: theme.colorScheme.primary,
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(fontFamily: "AB", fontSize: fontSize, color: theme.colorScheme.onPrimary),
      ),
    );
  }
}

class AuthOutlinedButton extends StatelessWidget {
  final String label;
  final String iconPath;
  final VoidCallback onPressed;

  const AuthOutlinedButton({
    super.key,
    required this.label,
    required this.iconPath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;
    final buttonHeight =
        isDesktop
            ? 56.0
            : isTablet
            ? 52.0
            : 49.0;
    final fontSize =
        isDesktop
            ? 18.0
            : isTablet
            ? 17.0
            : 16.0;
    final borderRadius =
        isDesktop
            ? 30.0
            : isTablet
            ? 28.0
            : 25.0;
    final iconSize =
        isDesktop
            ? 24.0
            : isTablet
            ? 22.0
            : 20.0;

    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        minimumSize: Size(MediaQuery.of(context).size.width, buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        ),
        side: BorderSide(width: 1, color: theme.colorScheme.outline),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(iconPath, height: iconSize),
          Text(
            label,
            style: TextStyle(
              fontFamily: "AB",
              fontSize: fontSize,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: iconSize, width: iconSize),
        ],
      ),
    );
  }
}
