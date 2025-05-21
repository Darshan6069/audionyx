import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class PlayerErrorScreen extends StatelessWidget {
  final VoidCallback onRetry;
  final VoidCallback onGoBack;
  final String errorMessage;

  const PlayerErrorScreen({
    super.key,
    required this.onRetry,
    required this.onGoBack,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    // Responsive values
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;
    final iconSize =
        isDesktop
            ? 80.0
            : isTablet
            ? 60.0
            : 40.0;
    final textSize =
        isDesktop
            ? 20.0
            : isTablet
            ? 18.0
            : 15.0;
    final buttonPaddingH =
        isDesktop
            ? 32.0
            : isTablet
            ? 24.0
            : 12.0;
    final buttonPaddingV =
        isDesktop
            ? 16.0
            : isTablet
            ? 12.0
            : 6.0;
    final spacing =
        isDesktop
            ? 24.0
            : isTablet
            ? 16.0
            : 10.0;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF121212), Color(0xFF1A1A1A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 280),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline, size: iconSize, color: Colors.white60),
                  SizedBox(height: spacing),
                  Text(
                    errorMessage,
                    style: TextStyle(color: Colors.white, fontSize: textSize),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: spacing),
                  TextButton.icon(
                    onPressed: onRetry,
                    icon: Icon(Icons.refresh, color: Colors.white, size: iconSize / 2),
                    label: Text(
                      'Retry',
                      style: TextStyle(color: Colors.white, fontSize: textSize - 2),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.15),
                      padding: EdgeInsets.symmetric(
                        horizontal: buttonPaddingH,
                        vertical: buttonPaddingV,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(buttonPaddingH / 2),
                      ),
                    ),
                  ),
                  SizedBox(height: spacing / 2),
                  TextButton.icon(
                    onPressed: onGoBack,
                    icon: Icon(Icons.arrow_back, color: Colors.white, size: iconSize / 2),
                    label: Text(
                      'Go Back',
                      style: TextStyle(color: Colors.white, fontSize: textSize - 2),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.15),
                      padding: EdgeInsets.symmetric(
                        horizontal: buttonPaddingH,
                        vertical: buttonPaddingV,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(buttonPaddingH / 2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
