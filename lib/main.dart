import 'package:audionyx/core/constants/app_strings.dart';
import 'package:audionyx/presentation/onboarding_screen/onboarding_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Future.delayed(Duration(seconds: 2)); // Optional splash delay
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: AppStrings.uberFont,

      ),
      home: const OnboardingScreen(),
    );
  }
}
