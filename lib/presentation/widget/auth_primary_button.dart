import 'package:flutter/material.dart';

class AuthPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const AuthPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(MediaQuery.of(context).size.width, 49),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        // Using primary color from theme instead of hardcoded green
        backgroundColor: theme.colorScheme.primary,
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(
          fontFamily: "AB",
          fontSize: 16,
          // Using onPrimary color which will contrast with the primary background
          color: theme.colorScheme.onPrimary,
        ),
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

    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        minimumSize: Size(MediaQuery.of(context).size.width, 49),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        side: BorderSide(
          width: 1,
          // Using outline color from theme
          color: theme.colorScheme.outline,
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(iconPath),
          Text(
            label,
            style: TextStyle(
              fontFamily: "AB",
              fontSize: 16,
              // Using proper text color from theme
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 18, width: 18),
        ],
      ),
    );
  }
}
