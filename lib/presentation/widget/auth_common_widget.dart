import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
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
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;
    final logoRadius =
        isDesktop
            ? 80.0
            : isTablet
            ? 70.0
            : 60.0;
    final logoHeight =
        isDesktop
            ? 100.0
            : isTablet
            ? 90.0
            : 80.0;
    final spacing =
        isDesktop
            ? 48.0
            : isTablet
            ? 44.0
            : 40.0;
    final titleFontSize =
        isDesktop
            ? 28.0
            : isTablet
            ? 24.0
            : 20.0;
    final subtitleFontSize =
        isDesktop
            ? 16.0
            : isTablet
            ? 15.0
            : 14.0;

    return Column(
      children: [
        Hero(
          tag: 'app_logo',
          child: CircleAvatar(
            radius: logoRadius,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            child: Image.asset(AppImage.logo, height: logoHeight),
          ),
        ),
        SizedBox(height: spacing),
        Text(
          title,
          style:
              titleStyle ??
              TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
        SizedBox(height: spacing * 0.25),
        Text(
          subtitle,
          style:
              subtitleStyle ??
              TextStyle(
                fontSize: subtitleFontSize,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
          textAlign: TextAlign.center,
        ),
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
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;
    final dividerThickness =
        isDesktop
            ? 2.0
            : isTablet
            ? 1.5
            : 1.0;
    final fontSize =
        isDesktop
            ? 16.0
            : isTablet
            ? 15.0
            : 14.0;
    final paddingH =
        isDesktop
            ? 24.0
            : isTablet
            ? 20.0
            : 16.0;

    return Row(
      children: [
        Expanded(
          child: Divider(
            color: theme.colorScheme.onSurface.withOpacity(0.3),
            thickness: dividerThickness,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: paddingH),
          child: Text(
            'or',
            style: textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
              fontSize: fontSize,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: theme.colorScheme.onSurface.withOpacity(0.3),
            thickness: dividerThickness,
          ),
        ),
      ],
    );
  }
}

class AuthGoogleSignIn extends StatelessWidget {
  final VoidCallback onPressed;

  const AuthGoogleSignIn({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;
    final iconHeight =
        isDesktop
            ? 0.05
            : isTablet
            ? 0.04
            : 0.03;

    return IconButton(
      onPressed: onPressed,
      icon: Image.asset(
        AppImage.iconGoogle,
        fit: BoxFit.cover,
        height: MediaQuery.of(context).size.height * iconHeight,
      ),
    );
  }
}
