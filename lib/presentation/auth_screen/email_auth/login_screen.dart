import 'package:audionyx/core/constants/extension.dart';
import 'package:audionyx/presentation/auth_screen/email_auth/registration_screen.dart';
import 'package:audionyx/presentation/bottom_navigation_bar/bottom_navigation_bar_screen.dart';
import 'package:audionyx/repository/bloc/auth_bloc_cubit/login_bloc_cubit/login_bloc_cubit.dart';
import 'package:audionyx/repository/bloc/auth_bloc_cubit/login_bloc_cubit/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../core/constants/app_strings.dart';
import '../../../repository/bloc/auth_bloc_cubit/google_auth_bloc_cubit/google_auth_bloc_cubit.dart';
import '../../../repository/service/auth_service/google_auth_service.dart';
import '../../widget/auth_common_widget.dart';
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

    // Determine padding based on screen size
    final isMobile = ResponsiveBreakpoints.of(context).smallerThan('TABLET');
    final isTablet = ResponsiveBreakpoints.of(context).smallerThan('DESKTOP');
    final horizontalPadding =
        isMobile
            ? 16.0
            : isTablet
            ? 32.0
            : 48.0;
    final verticalPadding = isMobile ? 20.0 : 40.0;
    final buttonWidth = isMobile ? double.infinity : 400.0;
    final fontScale =
        ResponsiveValue<double>(
          context,
          defaultValue: 1.0,
          conditionalValues: [
            const Condition.smallerThan(name: TABLET, value: 0.9),
            const Condition.largerThan(name: DESKTOP, value: 1.2),
          ],
        ).value;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginBlocCubit()),
        BlocProvider(create: (context) => GoogleLoginBlocCubit()),
      ],
      child: Scaffold(
        body: SafeArea(
          child: Center(
            // Center the content for larger screens
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              // Max width for large screens
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: verticalPadding,
                  ),
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
                            context.pushAndRemoveUntil(
                              context,
                              target: const BottomNavigationBarScreen(),
                            );
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
                                content: Text(
                                  'Google Sign-In successful',
                                  style: textTheme.bodyMedium,
                                ),
                                backgroundColor: theme.colorScheme.primary,
                              ),
                            );
                            context.pushAndRemoveUntil(
                              context,
                              target: const BottomNavigationBarScreen(),
                            );
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
                                  // Logo & Header
                                  AuthLogoHeader(
                                    title: AppStrings.signIn,
                                    subtitle: AppStrings.ifNeedSupport,
                                    titleStyle: textTheme.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.onSurface,
                                      fontSize: 28 * fontScale, // Scale font size
                                    ),
                                    subtitleStyle: textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                                      fontSize: 16 * fontScale,
                                    ),
                                  ),
                                  SizedBox(height: isMobile ? 20 : 30),

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
                                    isPassword: true,
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
                                          fontSize: 14 * fontScale,
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: isMobile ? 16 : 24),

                                  // Login Button or Loading Indicator
                                  loginState is LoginLoading || googleState is LoginLoading
                                      ? CircularProgressIndicator(color: theme.colorScheme.primary)
                                      : SizedBox(
                                        width: buttonWidth,
                                        child: AuthPrimaryButton(
                                          label: AppStrings.loginHere,
                                          onPressed: () {
                                            if (_formKey.currentState?.validate() ?? false) {
                                              context.read<LoginBlocCubit>().loginUser(
                                                email: emailController.text.trim(),
                                                password: passwordController.text.trim(),
                                              );
                                            }
                                          },
                                        ),
                                      ),

                                  SizedBox(height: isMobile ? 16 : 20),

                                  // Divider
                                  const AuthDivider(),
                                  SizedBox(height: isMobile ? 16 : 20),

                                  // Google Sign-In
                                  SizedBox(
                                    width: buttonWidth,
                                    child: AuthGoogleSignIn(
                                      onPressed: () {
                                        context.read<GoogleLoginBlocCubit>().signInWithGoogle();
                                      },
                                    ),
                                  ),
                                  SizedBox(height: isMobile ? 16 : 20),
                                  TextButton(
                                    onPressed: () {
                                      context.pushAndRemoveUntil(
                                        context,
                                        target: const RegistrationScreen(),
                                      );
                                    },
                                    child: Text(
                                      AppStrings.notMember,
                                      style: TextStyle(
                                        color: theme.colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14 * fontScale,
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
        ),
      ),
    );
  }
}
