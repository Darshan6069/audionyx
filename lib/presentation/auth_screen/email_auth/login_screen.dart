import 'package:audionyx/core/constants/extension.dart';
import 'package:audionyx/presentation/auth_screen/email_auth/registration_screen.dart';
import 'package:audionyx/presentation/bottom_navigation_bar/bottom_navigation_bar_screen.dart';
import 'package:audionyx/repository/bloc/auth_bloc_cubit/login_bloc_cubit/login_bloc_cubit.dart';
import 'package:audionyx/repository/bloc/auth_bloc_cubit/login_bloc_cubit/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_image.dart';
import '../../../core/constants/app_strings.dart';
import '../../../repository/bloc/auth_bloc_cubit/google_auth_bloc_cubit/google_auth_bloc_cubit.dart';
import '../../../repository/service/auth_service/google_auth_service.dart';
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
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginBlocCubit()),
        BlocProvider(create: (context) => GoogleLoginBlocCubit(GoogleAuthService())),
      ],
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: MultiBlocListener(
                listeners: [
                  BlocListener<LoginBlocCubit, LoginState>(
                    listener: (context, state) {
                      if (state is LoginSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Login successful', style: textTheme.bodyMedium),
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
                child: BlocBuilder<LoginBlocCubit, LoginState>(
                  builder: (context, loginState) {
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
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 40),

                              // Title
                              Text(
                                AppStrings.signIn,
                                style: textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onBackground,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                AppStrings.ifNeedSupport,
                                style: textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onBackground.withOpacity(0.6),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 30),

                              // Email Field
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
                              const SizedBox(height: 16),

                              // Password Field
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
                              const SizedBox(height: 16),

                              // Forgot Password
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    // TODO: Implement password recovery
                                  },
                                  child: Text(
                                    AppStrings.recoveryPassword,
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 24),

                              // Login Button or Loading Indicator
                              loginState is LoginLoading || googleState is LoginLoading
                                  ? CircularProgressIndicator(color: theme.colorScheme.primary)
                                  : AuthPrimaryButton(
                                label: AppStrings.loginHere,
                                onPressed: (){
                                   if (_formKey.currentState?.validate() ?? false) {
                                      context.read<LoginBlocCubit>().loginUser(
                                         email: emailController.text.trim(),
                                         password: passwordController.text.trim(),
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
                                      color: theme.colorScheme.onBackground.withOpacity(0.3),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: Text(
                                      AppStrings.or,
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: theme.colorScheme.onBackground.withOpacity(0.6),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(
                                      color: theme.colorScheme.onBackground.withOpacity(0.3),
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

                              // Sign Up Link
                              RichText(
                                text: TextSpan(
                                  text: "Don't have an account? ",
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onBackground.withOpacity(0.6),
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "Sign Up",
                                      style: TextStyle(
                                        color: theme.colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.pushAndRemoveUntil(context, target: const RegistrationScreen());
                                },
                                child: Text(
                                  AppStrings.notMember,
                                  style: TextStyle(
                                    color: theme.colorScheme.primary,
                                    decoration: TextDecoration.underline,
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