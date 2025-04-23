import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppStrings {
  ///font
  static const String uberFont = 'UberFont';

  ///
  static FlutterSecureStorage secureStorage = const FlutterSecureStorage();


  /// api url
  static const baseUrl = 'http://192.168.0.81:8000/api/';

  ///Onboarding Strings
  static const String onboardingTitleLine1 = "Millions of songs.";
  static const String onboardingTitleLine2 = "Free on Spotify.";
  static const String signUpFree = "Sign up free";
  static const String continueWithGoogle = "Continue with Google";
  static const String continueWithFacebook = "Continue with Facebook";
  static const String continueWithApple = "Continue with Apple";
  static const String login = "Log in";

  static const String createAccount = 'Create Account';
  static const String whatsYourEmail = "What's your email?";
  static const String confirmEmail = "You'll need to confirm this email later.";
  static const String createPassword = "Create a password";
  static const String passwordLength = "Use at least 8 characters.";
  static const String whatsYourGender = "What's your gender?";
  static const String male = "Male";
  static const String female = "Female";
  static const String preferNotToSay = "Prefer not to say";
  static const String whatsYourName = "What's your name?";
  static const String spotifyProfile = "This appears on your Spotify profile";
  static const String termsOfUsePrompt = 'By tapping on "Create account" you agree to the Spotify Terms of Use.';
  static const String termsOfUse = 'Terms of Use';
  static const String privacyPolicyPrompt = 'To learn more about how Spotify collects, uses, shares, and protects your personal data, please see the Spotify Privacy Policy.';
  static const String privacyPolicy = 'Privacy Policy';
  static const String newsAndOffers = "Please send me news and offers from Spotify.";
  static const String shareData = "Share my registration data with Spotify's content providers for marketing purposes.";
  static const String next = "Next";
  static const String createAccountButton = "Create an account";

  //reg-ex
  static const String emailRegex = r'^[^\s@]+@[^\s@]+\.[^\s@]+$';
  static const String passwordRegex = r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';
  static const String nameRegex = r"^[a-zA-Z\s]+$";
  // static const String phoneRegex = r"^[1-9]\d{2}\s\d{3}\s\d{4}";

///login screen
  static const String errorPrefix = "Error:";
  static const String loginButton = "Login";
  static const String noAccountPrompt = "Don't Have Account?";
  static const String registerHere = " Register Here";
  static const String successMessage = "Login Successful!";

  //Registration screen
  static const String registrationSuccess = "Registration Successful!";
  static const String submittedSuccessfully = "Submitted successfully.";
  static const String alreadyHaveAccount = "Already Have Account ?";
  static const String loginHere = " Login Here";

  // labelText
  static const String labelTextForUserName = 'UserName';
  static const String labelTextForEmail = 'Email';
  static const String labelTextForPassword = 'Password';
  static const String labelTextForPhone= 'Phone';

  // ErrorText
  static const String errorTextForPassword = 'Enter a Password';
  static const String errorTextForPhone = 'Enter a PhoneNo.';
  static const String errorTextForEmail = 'Enter a Email';
  static const String errorTextForUserName = 'Enter a UserName';
  static const String welcomeMessage = "Welcome,";
  static const String errorMessage = "Error:";
  static const String enterValidValue = "Enter valid value";

}
