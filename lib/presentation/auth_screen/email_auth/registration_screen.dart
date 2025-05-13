import 'package:audionyx/core/constants/extension.dart';
import 'package:audionyx/repository/bloc/auth_bloc_cubit/registration_bloc_cubit/registration_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_image.dart';
import '../../../core/constants/app_strings.dart';
import '../../../repository/bloc/auth_bloc_cubit/google_auth_bloc_cubit/google_auth_bloc_cubit.dart';
import '../../../repository/bloc/auth_bloc_cubit/login_bloc_cubit/login_state.dart';
import '../../../repository/bloc/auth_bloc_cubit/registration_bloc_cubit/registration_bloc_cubit.dart';
import '../../../repository/service/auth_service/google_auth_service.dart';
import '../../bottom_navigation_bar/bottom_navigation_bar_screen.dart';
import '../../widget/auth_primary_button.dart';
import '../../widget/comman_textformfield.dart';
import 'login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => RegistrationBlocCubit()),
        BlocProvider(create: (context) => GoogleLoginBlocCubit(GoogleAuthService())),
      ],
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: MultiBlocListener(
                listeners: [
                  BlocListener<RegistrationBlocCubit, RegistrationState>(
                    listener: (context, state) {
                      if (state is RegistrationSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.message, style: textTheme.bodyMedium),
                            backgroundColor: theme.colorScheme.primary,
                          ),
                        );
                        context.pushAndRemoveUntil(context, target: const LoginScreen());
                      } else if (state is RegistrationFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.error, style: textTheme.bodyMedium),
                            backgroundColor: theme.colorScheme.error,
                          ),
                        );
                      }
                    },
                  ),
                  BlocListener<GoogleLoginBlocCubit, LoginState>(
                    listener: (context, state) {
                      if (state is LoginSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Google Sign-In successful', style: textTheme.bodyMedium),
                            backgroundColor: theme.colorScheme.primary,
                          ),
                        );
                        context.pushAndRemoveUntil(context, target: const BottomNavigationBarScreen());
                      } else if (state is LoginFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.error, style: textTheme.bodyMedium),
                            backgroundColor: theme.colorScheme.error,
                          ),
                        );
                      }
                    },
                  ),
                ],
                child: BlocBuilder<RegistrationBlocCubit, RegistrationState>(
                  builder: (context, regState) {
                    return BlocBuilder<GoogleLoginBlocCubit, LoginState>(
                      builder: (context, googleState) {
                        return Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Logo
                              Hero(
                                tag: 'app_logo',
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundColor: theme.colorScheme.primaryContainer,
                                  child: Image.asset(
                                    AppImage.logo,
                                    height: 80,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 40),

                              // Title
                              Text(
                                AppStrings.register,
                                style: textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                AppStrings.ifNeedSupport,
                                style: textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 30),

                              // Full Name Field
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
                              const SizedBox(height: 16),

                              // Email Field
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
                              const SizedBox(height: 16),

                              // Password Field with isPassword set to true
                              CommonTextformfield(
                                controller: _passwordController,
                                labelText: AppStrings.labelTextForPassword,
                                errorText: AppStrings.errorTextForPassword,
                                isPassword: true,  // Enable password masking
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
                              const SizedBox(height: 24),

                              // Register Button or Loading Indicator
                              regState is RegistrationLoading || googleState is LoginLoading
                                  ? CircularProgressIndicator(color: theme.colorScheme.primary)
                                  : AuthPrimaryButton(
                                label: AppStrings.registerHere,
                                onPressed: (){
                                  if (_formKey.currentState?.validate() ?? false) {
                                    context.read<RegistrationBlocCubit>().registerUser(
                                      name: _fullNameController.text.trim(),
                                      email: _emailController.text.trim(),
                                      password: _passwordController.text.trim(),
                                    );
                                  }
                                },
                              ),

                              const SizedBox(height: 20),

                              // Divider
                              Row(
                                children: [
                                  Expanded(
                                    child: Divider(
                                      color: theme.colorScheme.onSurface.withOpacity(0.3),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: Text(
                                      AppStrings.or,
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(
                                      color: theme.colorScheme.onSurface.withOpacity(0.3),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),

                              // Google Sign-In
                              IconButton(
                                onPressed: () {
                                  context.read<GoogleLoginBlocCubit>().signInWithGoogle();
                                },
                                icon: Image.asset(
                                  AppImage.iconGoogle,
                                  height: 48,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextButton(
                                onPressed: () {
                                  context.pushAndRemoveUntil(context, target: const LoginScreen());
                                },
                                child: Text(
                                  AppStrings.haveAccount,
                                  style: TextStyle(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}