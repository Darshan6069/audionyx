import 'package:audionyx/core/constants/extension.dart';
import 'package:audionyx/presentation/auth_screen/email_auth/login_screen.dart';
import 'package:audionyx/presentation/auth_screen/email_auth/registration_screen.dart';
import 'package:audionyx/repository/service/auth_service/google_auth_service.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_image.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/theme_color.dart';
import '../widget/auth_primary_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ThemeColor.blackColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(AppImage.onboardingBackground),
            const SizedBox(height: 10),

            // Title
            const Text(
              AppStrings.onboardingTitleLine1,
              style: TextStyle(fontSize: 28, color: ThemeColor.whiteColor),
            ),
            const Text(
              AppStrings.onboardingTitleLine2,
              style: TextStyle(fontSize: 28, color: ThemeColor.whiteColor),
            ),
            const SizedBox(height: 25),

            // Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  AuthPrimaryButton(
                    label: AppStrings.signUpFree,
                    onPressed: () {
                      context.push(context, target: const RegistrationScreen());
                    },
                  ),

                  const SizedBox(height: 20),

                  // Login text
                  TextButton(
                    onPressed: () {
                      context.pushAndRemoveUntil(
                        context,
                        target: LoginScreen(),
                      );
                    },
                    child: Text(
                      AppStrings.login,
                      style: TextStyle(
                        fontFamily: AppStrings.uberFont,
                        fontSize: 16,
                        color: ThemeColor.whiteColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
