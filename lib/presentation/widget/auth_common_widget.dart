import 'package:flutter/material.dart';

import '../../core/constants/app_image.dart';

class AuthLogoHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final double spacing;

  const AuthLogoHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.titleStyle,
    this.subtitleStyle,
    this.spacing = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Hero(
          tag: 'app_logo',
          child: CircleAvatar(
            radius: 60,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            child: Image.asset(AppImage.logo, height: 80),
          ),
        ),
        SizedBox(height: spacing),
        Text(title, style: titleStyle),
        const SizedBox(height: 10),
        Text(subtitle, style: subtitleStyle, textAlign: TextAlign.center),
      ],
    );
  }
}

class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Row(
      children: [
        Expanded(child: Divider(color: theme.colorScheme.onSurface.withOpacity(0.3))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'or',
            style: textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ),
        Expanded(child: Divider(color: theme.colorScheme.onSurface.withOpacity(0.3))),
      ],
    );
  }
}

class AuthGoogleSignIn extends StatelessWidget {
  final VoidCallback onPressed;
  const AuthGoogleSignIn({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Image.asset(
        AppImage.iconGoogle,
        fit: BoxFit.cover,
        height: MediaQuery.of(context).size.height * 0.03,
      ),
    );
  }
}
