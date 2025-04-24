import 'package:audionyx/core/constants/app_strings.dart';
import 'package:audionyx/presentation/onboarding_screen/onboarding_screen.dart';
import 'package:audionyx/repository/bloc/auth_bloc_cubit/login_bloc_cubit/login_bloc_cubit.dart';
import 'package:audionyx/repository/bloc/auth_bloc_cubit/registration_bloc_cubit/registration_bloc_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(Duration(seconds: 2)); // Optional splash delay
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RegistrationBlocCubit(),
        ),
        BlocProvider(
          create: (context) => LoginBlocCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(useMaterial3: true),
        home: const OnboardingScreen(),
      ),
    );
  }
}
