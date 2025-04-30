import 'package:audionyx/core/constants/extension.dart';
import 'package:audionyx/presentation/auth_screen/email_auth/registration_screen.dart';
import 'package:audionyx/repository/bloc/auth_bloc_cubit/login_bloc_cubit/login_bloc_cubit.dart';
import 'package:audionyx/repository/bloc/auth_bloc_cubit/login_bloc_cubit/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/constants/app_image.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/theme_color.dart';
import '../../bottom_navigation_bar/home_screen/home_screen.dart';
import '../../widget/auth_primary_button.dart';
import '../../widget/comman_textformfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _storage = const FlutterSecureStorage();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var varHeight = context.height(context) * 0.02;

    return BlocProvider(
      create: (context) => LoginBlocCubit(),
      child: Scaffold(
        backgroundColor: ThemeColor.darkBackground,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: BlocConsumer<LoginBlocCubit, LoginState>(
                listener: (context, state) async {
                  if (state is LoginSuccess) {
                    // Store token in secure storage
                    await _storage.write(key: 'auth_token', value: state.token);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Login successful: ${state.token}')),
                    );
                    context.pushAndRemoveUntil(context, target: const HomeScreen());
                  } else if (state is LoginFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error)),
                    );
                  }
                },
                builder: (context, state) {
                  return Column(
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
                        AppStrings.signIn,
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
                      const SizedBox(height: 30),
                      SizedBox(height: varHeight),

                      CommonTextformfield(
                        controller: emailController,
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
                        controller: passwordController,
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
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            AppStrings.recoveryPassword,
                            style: TextStyle(
                              color: ThemeColor.grey,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: varHeight),

                      if (state is LoginLoading)
                        const CircularProgressIndicator()
                      else
                        AuthPrimaryButton(
                          label: AppStrings.loginHere,
                          onPressed: () {
                            context.read<LoginBlocCubit>().loginUser(
                              email: emailController.text,
                              password: passwordController.text,
                            );
                          },
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
                        ],
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegistrationScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          AppStrings.notMember,
                          style: TextStyle(
                            color: ThemeColor.white,
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}