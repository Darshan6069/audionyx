import 'dart:io';
import 'package:audio_service/audio_service.dart';
import 'package:audionyx/repository/bloc/audio_player_bloc_cubit/audio_player_bloc_cubit.dart';
import 'package:audionyx/repository/bloc/auth_bloc_cubit/google_auth_bloc_cubit/google_auth_bloc_cubit.dart';
import 'package:audionyx/repository/bloc/theme_cubit/theme_cubit.dart';
import 'package:audionyx/repository/service/auth_service/google_auth_service.dart';
import 'package:audionyx/repository/service/check_internet_connection/check_internet_connection.dart';
import 'package:audionyx/repository/bloc/auth_bloc_cubit/login_bloc_cubit/login_bloc_cubit.dart';
import 'package:audionyx/repository/bloc/auth_bloc_cubit/registration_bloc_cubit/registration_bloc_cubit.dart';
import 'package:audionyx/repository/bloc/download_song_bloc_cubit/download_song_bloc_cubit.dart';
import 'package:audionyx/repository/bloc/fetch_song_bloc_cubit/fetch_song_bloc_cubit.dart';
import 'package:audionyx/repository/bloc/playlist_bloc_cubit/playlist_bloc_cubit.dart';
import 'package:audionyx/repository/service/notifiaction_service/notification_handler.dart';
import 'package:audionyx/repository/service/notifiaction_service/notification_service.dart';
import 'package:audionyx/repository/service/song_service/audio_service/my_audio_handler.dart';
import 'package:audionyx/repository/service/song_service/playlist_service/playlist_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'core/theme_data/apptheme.dart';
import 'firebase_options.dart';
import 'repository/bloc/upload_song_bloc_cubit/upload_song_bloc_cubit.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(const Duration(seconds: 2));
  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    await FlutterDownloader.initialize();
  }
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  NotificationService().init();
  NotificationHandler.setupFirebaseMessaging();
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class ErrorApp extends StatelessWidget {
  const ErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(
            'Failed to initialize the app. Please try again later.',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => RegistrationBlocCubit()),
        BlocProvider(create: (context) => LoginBlocCubit()),
        BlocProvider(create: (context) => UploadSongBlocCubit()),
        BlocProvider(create: (context) => FetchSongBlocCubit()),
        BlocProvider(create: (context) => DownloadSongBlocCubit()),
        BlocProvider(create: (context) => PlaylistBlocCubit(PlaylistService())),
        BlocProvider(create: (context) => AudioPlayerBlocCubit()),
        BlocProvider(create: (context) => ThemeCubit()),
        BlocProvider(create: (context) => GoogleLoginBlocCubit()),
      ],
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, isDarkMode) {
          return ResponsiveBreakpoints.builder(
            child: MaterialApp(
              title: 'AudioNyx',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
              navigatorKey: navigatorKey,
              home: const CheckInternetConnection(),
            ),
            breakpoints: [
              const Breakpoint(start: 0, end: 450, name: MOBILE),
              const Breakpoint(start: 451, end: 800, name: TABLET),
              const Breakpoint(start: 801, end: 1000, name: DESKTOP),
              const Breakpoint(start: 1001, end: 1200, name: 'LARGE_DESKTOP'),
              const Breakpoint(start: 1201, end: double.infinity, name: 'EXTRA_LARGE'),
            ],
          );
        },
      ),
    );
  }
}
