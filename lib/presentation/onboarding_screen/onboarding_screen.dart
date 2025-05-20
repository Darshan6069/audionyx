import 'package:audionyx/core/constants/extension.dart';
import 'package:audionyx/presentation/auth_screen/email_auth/registration_screen.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_image.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/theme_color.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  padding: const EdgeInsets.all(20.0),
                  child: Image.asset(AppImage.onboardingBackground, fit: BoxFit.contain),
                ),
              ),

              // Text Section
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppStrings.onboardingTitleLine1,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: ThemeColor.whiteColor,
                          fontFamily: AppStrings.uberFont,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppStrings.onboardingTitleLine2,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: ThemeColor.whiteColor,
                          fontFamily: AppStrings.uberFont,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Discover and enjoy your favorite music anytime, anywhere.',
                        style: TextStyle(
                          fontSize: 16,
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
                padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
                child: ElevatedButton(
                  onPressed: () {
                    context.pushAndRemoveUntil(context, target: const RegistrationScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeColor.greenAccent,
                    foregroundColor: ThemeColor.blackColor,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    elevation: 5,
                    shadowColor: Colors.black.withOpacity(0.3),
                  ),
                  child: Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: 18,
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
