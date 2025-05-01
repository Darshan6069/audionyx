import 'dart:io';

import 'package:audionyx/check_internet_connection.dart';
import 'package:audionyx/core/constants/app_strings.dart';
import 'package:audionyx/presentation/bottom_navigation_bar/bottom_navigation_bar_screen.dart';
import 'package:audionyx/presentation/bottom_navigation_bar/home_screen/home_screen.dart';
import 'package:audionyx/presentation/onboarding_screen/onboarding_screen.dart';
import 'package:audionyx/repository/bloc/auth_bloc_cubit/login_bloc_cubit/login_bloc_cubit.dart';
import 'package:audionyx/repository/bloc/auth_bloc_cubit/registration_bloc_cubit/registration_bloc_cubit.dart';
import 'package:audionyx/repository/bloc/download_song_bloc_cubit/download_song_bloc_cubit.dart';
import 'package:audionyx/repository/bloc/fetch_song_bloc_cubit/fetch_song_bloc_cubit.dart';
import 'package:audionyx/repository/bloc/playlist_bloc_cubit/playlist_bloc_cubit.dart';
import 'package:audionyx/repository/service/song_service/playlist_service/playlist_service.dart';
import 'package:audionyx/song_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import 'repository/bloc/upload_song_bloc_cubit/upload_song_bloc_cubit.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(const Duration(seconds: 2));
  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    await FlutterDownloader.initialize();
  }  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
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
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(useMaterial3: true),
        home: const CheckInternetConnection(),
      ),
    );
  }
}
