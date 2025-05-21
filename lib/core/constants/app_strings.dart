import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppStrings {
  static const String uberFont = 'UberFont';

  static FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  static const baseUrl = 'http://192.168.1.49:4000/api/';

  static const String onboardingTitleLine1 = "Millions of songs.";
  static const String onboardingTitleLine2 = "Free on Spotify.";

  static const String emailRegex = r'^[^\s@]+@[^\s@]+\.[^\s@]+$';
  static const String passwordRegex =
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';
  static const String nameRegex = r"^[a-zA-Z\s]+$";

  static const String registerHere = " Register Here";
  static const String loginHere = " Login Here";

  static const String labelTextForUserName = 'UserName';
  static const String labelTextForEmail = 'Email';
  static const String labelTextForPassword = 'Password';

  static const String errorTextForPassword = 'Enter a Password';

  static const String errorTextForEmail = 'Enter a Email';
  static const String errorTextForUserName = 'Enter a UserName';

  static const String signIn = "Sign In";
  static const String ifNeedSupport = "If you need any support click here";

  static const String recoveryPassword = "Recovery Password";
  static const String or = "Or";
  static const String register = "Register";

  static const String notMember = "Not a member? Register now";
  static const String haveAccount = "Do you have an account? Sign In";

  static const String goodMorning = "Good morning, gingrx";
}
