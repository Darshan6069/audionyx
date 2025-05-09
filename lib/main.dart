import 'dart:io';

import 'package:audionyx/repository/service/check_internet_connection/check_internet_connection.dart';
import 'package:audionyx/repository/bloc/auth_bloc_cubit/login_bloc_cubit/login_bloc_cubit.dart';
import 'package:audionyx/repository/bloc/auth_bloc_cubit/registration_bloc_cubit/registration_bloc_cubit.dart';
import 'package:audionyx/repository/bloc/download_song_bloc_cubit/download_song_bloc_cubit.dart';
import 'package:audionyx/repository/bloc/fetch_song_bloc_cubit/fetch_song_bloc_cubit.dart';
import 'package:audionyx/repository/bloc/playlist_bloc_cubit/playlist_bloc_cubit.dart';
import 'package:audionyx/repository/service/song_service/playlist_service/playlist_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import 'repository/bloc/upload_song_bloc_cubit/upload_song_bloc_cubit.dart';

 final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


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
  }
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Create a navigator key for handling redirects from anywhere in the app

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
        title: 'AudioNyx',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(useMaterial3: true),
        navigatorKey: navigatorKey, // Add the navigator key
        home: CheckInternetConnection(),
      ),
    );
  }
}