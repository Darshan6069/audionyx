// import 'package:audionyx/core/constants/app_strings.dart';
// import 'package:audionyx/core/constants/extension.dart';
// import 'package:audionyx/core/constants/theme_color.dart';
// import 'package:audionyx/presentation/widget/auth_primary_button.dart';
// import 'package:audionyx/presentation/widget/comman_textformfield.dart';
// import 'package:audionyx/presentation/widget/common_app_bar.dart';
// import 'package:audionyx/presentation/widget/common_richtext.dart';
// import 'package:flutter/material.dart';
//
// class RegistrationScreen extends StatefulWidget {
//   const RegistrationScreen({super.key});
//
//   @override
//   State<RegistrationScreen> createState() => _RegistrationScreenState();
// }
//
// final nameController = TextEditingController();
// final emailController = TextEditingController();
// final passwordController = TextEditingController();
//
// class _RegistrationScreenState extends State<RegistrationScreen> {
//   @override
//   Widget build(BuildContext context) {
//     var varHeight = context.height(context) * 0.02;
//
//     return Scaffold(
//       backgroundColor: ThemeColor.darGreyColor, // 👈 Set black background
//       appBar: CommonAppBar(
//         title: AppStrings.createAccount,
//        ),
//       body: Padding(
//         padding: EdgeInsets.all(context.width(context) * 0.03),
//         child: Form(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const CommonRichText(
//                 title: AppStrings.createAccount,
//               ),
//               SizedBox(height: context.height(context) * 0.02),
//
//               CommonTextformfield(
//                 controller: nameController,
//                 labelText: AppStrings.labelTextForUserName,
//                 errorText: AppStrings.errorTextForUserName,
//                 validator: (value) {
//                   final nameRegex = RegExp(AppStrings.nameRegex);
//                   if (value == null || value.isEmpty) {
//                     return 'Name is required';
//                   } else if (!nameRegex.hasMatch(value)) {
//                     return 'Enter a valid name';
//                   }
//                   return null;
//                 },
//
//               ),
//               SizedBox(height: varHeight),
//
//               CommonTextformfield(
//                 controller: emailController,
//                 labelText: AppStrings.labelTextForEmail,
//                 errorText: AppStrings.errorTextForEmail,
//                 validator: (value) {
//                   final emailRegex = RegExp(AppStrings.emailRegex);
//                   if (value == null || value.isEmpty) {
//                     return 'Email is required';
//                   } else if (!emailRegex.hasMatch(value)) {
//                     return 'Enter a valid email address';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: varHeight),
//
//               CommonTextformfield(
//                 controller: passwordController,
//                 labelText: AppStrings.labelTextForPassword,
//                 errorText: AppStrings.errorTextForPassword,
//                 validator: (value) {
//                   final passwordRegex = RegExp(AppStrings.passwordRegex);
//                   if (value == null || value.isEmpty) {
//                     return 'Password is required';
//                   } else if (!passwordRegex.hasMatch(value)) {
//                     return 'Password must contain at least 8 characters,\n'
//                         'including uppercase, lowercase, digit, and special character';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: varHeight),
//
//               AuthPrimaryButton(
//                 label: AppStrings.registerHere,
//                 onPressed: () {},
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:audionyx/core/constants/extension.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_image.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/theme_color.dart';
import '../../widget/auth_primary_button.dart';
import '../../widget/comman_textformfield.dart';
import '../../widget/custom_text_field.dart';
import 'login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var varHeight = context.height(context) * 0.02;

    return Scaffold(
      backgroundColor: ThemeColor.darkBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.black,
                  child: Image.asset(
                    AppImage.logo,
                    fit: BoxFit.fitHeight,
                  ),
                ),
                const SizedBox(height: 50),
                const Text(
                  AppStrings.register,
                  style: TextStyle(
                    color: ThemeColor.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  AppStrings.ifNeedSupport,
                  style: TextStyle(color: ThemeColor.grey, fontSize: 14),
                ),
                SizedBox(height: varHeight),
                CommonTextformfield(
                  controller: _fullNameController,
                  labelText: AppStrings.labelTextForUserName,
                  errorText: AppStrings.errorTextForUserName,
                  validator: (value) {
                    final nameRegex = RegExp(AppStrings.nameRegex);
                    if (value == null || value.isEmpty) {
                      return 'Name is required';
                    } else if (!nameRegex.hasMatch(value)) {
                      return 'Enter a valid name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: varHeight),

                CommonTextformfield(
                  controller: _emailController,
                  labelText: AppStrings.labelTextForEmail,
                  errorText: AppStrings.errorTextForEmail,
                  validator: (value) {
                    final emailRegex = RegExp(AppStrings.emailRegex);
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    } else if (!emailRegex.hasMatch(value)) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: varHeight),

                CommonTextformfield(
                  controller: _passwordController,
                  labelText: AppStrings.labelTextForPassword,
                  errorText: AppStrings.errorTextForPassword,
                  validator: (value) {
                    final passwordRegex = RegExp(AppStrings.passwordRegex);
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    } else if (!passwordRegex.hasMatch(value)) {
                      return 'Password must contain at least 8 characters,\n'
                          'including uppercase, lowercase, digit, and special character';
                    }
                    return null;
                  },
                ),
                SizedBox(height: varHeight),

                AuthPrimaryButton(
                  label: AppStrings.registerHere,
                  onPressed: () {},
                ),
                const SizedBox(height: 20),
                const Text(
                  AppStrings.or,
                  style: TextStyle(color: ThemeColor.grey, fontSize: 14),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Image.asset(AppImage.iconGoogle, height: 40),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Image.asset(AppImage.iconApple, height: 40),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    AppStrings.haveAccount,
                    style: TextStyle(
                      color: ThemeColor.white,
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
