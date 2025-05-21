import 'package:audionyx/core/constants/extension.dart';
import 'package:audionyx/presentation/auth_screen/email_auth/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../core/constants/app_image.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/theme_color.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;
    final horizontalPadding =
        isDesktop
            ? 80.0
            : isTablet
            ? 40.0
            : 20.0;
    final verticalPadding =
        isDesktop
            ? 40.0
            : isTablet
            ? 30.0
            : 20.0;
    final titleFontSize =
        isDesktop
            ? 36.0
            : isTablet
            ? 34.0
            : 32.0;
    final subtitleFontSize =
        isDesktop
            ? 18.0
            : isTablet
            ? 17.0
            : 16.0;
    final buttonFontSize =
        isDesktop
            ? 20.0
            : isTablet
            ? 19.0
            : 18.0;
    final imagePadding =
        isDesktop
            ? 40.0
            : isTablet
            ? 30.0
            : 20.0;
    final buttonHeight =
        isDesktop
            ? 64.0
            : isTablet
            ? 60.0
            : 56.0;
    final buttonPadding =
        isDesktop
            ? const EdgeInsets.symmetric(horizontal: 60.0, vertical: 40.0)
            : isTablet
            ? const EdgeInsets.symmetric(horizontal: 50.0, vertical: 35.0)
            : const EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ThemeColor.blackColor,
              Color(0xFF1A1A1A), // Slightly lighter shade for depth
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top Image Section
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.all(imagePadding),
                  child: Image.asset(
                    AppImage.onboardingBackground,
                    fit: BoxFit.contain,
                    width:
                        isDesktop
                            ? 400.0
                            : isTablet
                            ? 350.0
                            : 300.0,
                  ),
                ),
              ),

              // Text Section
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppStrings.onboardingTitleLine1,
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                          color: ThemeColor.whiteColor,
                          fontFamily: AppStrings.uberFont,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height:
                            isDesktop
                                ? 12.0
                                : isTablet
                                ? 10.0
                                : 8.0,
                      ),
                      Text(
                        AppStrings.onboardingTitleLine2,
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                          color: ThemeColor.whiteColor,
                          fontFamily: AppStrings.uberFont,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height:
                            isDesktop
                                ? 20.0
                                : isTablet
                                ? 18.0
                                : 16.0,
                      ),
                      Text(
                        'Discover and enjoy your favorite music anytime, anywhere.',
                        style: TextStyle(
                          fontSize: subtitleFontSize,
                          color: ThemeColor.whiteColor.withOpacity(0.7),
                          fontFamily: AppStrings.uberFont,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              // Get Started Button
              Padding(
                padding: buttonPadding,
                child: ElevatedButton(
                  onPressed: () {
                    context.pushAndRemoveUntil(context, target: const RegistrationScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeColor.greenAccent,
                    foregroundColor: ThemeColor.blackColor,
                    minimumSize: Size(double.infinity, buttonHeight),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    elevation: 5,
                    shadowColor: Colors.black.withOpacity(0.3),
                  ),
                  child: Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: buttonFontSize,
                      fontWeight: FontWeight.w600,
                      fontFamily: AppStrings.uberFont,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
