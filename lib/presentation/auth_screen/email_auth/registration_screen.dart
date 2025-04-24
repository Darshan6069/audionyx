import 'package:audionyx/core/constants/extension.dart';
import 'package:audionyx/repository/bloc/auth_bloc_cubit/registration_bloc_cubit/registration_state.dart';
import 'package:audionyx/repository/service/auth_service/registration_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_image.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/theme_color.dart';
import '../../../repository/bloc/auth_bloc_cubit/registration_bloc_cubit/registration_bloc_cubit.dart';
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

    return BlocProvider(
      create: (context) => RegistrationBlocCubit(),
      child: Scaffold(
        backgroundColor: ThemeColor.darkBackground,
        body: SafeArea(
          child: BlocConsumer<RegistrationBlocCubit, RegistrationState>(
            listener: (BuildContext context, RegistrationState state) {
              if (state is RegistrationSuccess) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
                // Navigate to LoginScreen or HomeScreen
                context.pushAndRemoveUntil(context, target: LoginScreen());
              } else if (state is RegistrationFailure) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.error)));
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 30,
                  ),
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
                          final passwordRegex = RegExp(
                            AppStrings.passwordRegex,
                          );
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
                      if (state is RegistrationLoading)
                        const CircularProgressIndicator()
                      else
                        AuthPrimaryButton(
                          label: AppStrings.registerHere,
                          onPressed: () {
                            context.read<RegistrationBlocCubit>().registerUser(
                              name: _fullNameController.text,
                              email: _emailController.text,
                              password: _passwordController.text,
                            );
                          },
                        ),
                      const SizedBox(height: 20),
                      const Text(
                        AppStrings.or,
                        style: TextStyle(color: ThemeColor.grey, fontSize: 14),
                      ),
                      const SizedBox(height: 20),
                      IconButton(
                        onPressed: () {
                          context.read<RegistrationBlocCubit>().onRegisterGoogleUser();
                        },
                        icon: Image.asset(AppImage.iconGoogle, height: 40),
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
              );
            },
          ),
        ),
      ),
    );
  }
}
