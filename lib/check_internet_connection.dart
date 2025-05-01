import 'dart:async';
import 'dart:io';

import 'package:audionyx/core/constants/app_strings.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:audionyx/download_song_screen.dart';
import 'package:audionyx/presentation/bottom_navigation_bar/home_screen/home_screen.dart';
import 'package:audionyx/presentation/onboarding_screen/onboarding_screen.dart';

class CheckInternetConnection extends StatefulWidget {
  const CheckInternetConnection({super.key});

  @override
  State<CheckInternetConnection> createState() =>
      _CheckInternetConnectionState();
}

class _CheckInternetConnectionState extends State<CheckInternetConnection> {
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  bool _isLoading = true;
  bool _isOffline = false;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();

    _performChecks();

    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      _performChecks();
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<bool> _checkIfUserIsLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final String authToken =
          AppStrings.secureStorage.read(key: 'jwt_token').toString();
      bool loggedIn = authToken.isNotEmpty;

      return loggedIn;
    } catch (e) {
      return false;
    }
  }

  Future<void> _performChecks() async {
    if (!mounted) return;

    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    bool currentlyOffline;
    bool currentlyLoggedIn = false;

    final connectivityResults = await Connectivity().checkConnectivity();
    bool hasNetwork =
        !(connectivityResults.contains(ConnectivityResult.none) &&
            connectivityResults.length == 1);

    if (!hasNetwork) {
      currentlyOffline = true;
    } else {
      try {
        final result = await InternetAddress.lookup(
          'google.com',
        ).timeout(const Duration(seconds: 5));
        currentlyOffline = result.isEmpty || result[0].rawAddress.isEmpty;
      } on SocketException catch (e) {
        currentlyOffline = true;
      } on TimeoutException catch (e) {
        currentlyOffline = true;
      } catch (e) {
        currentlyOffline = true;
      }
    }

    if (!currentlyOffline) {
      currentlyLoggedIn = await _checkIfUserIsLoggedIn();
    } else {}

    if (mounted) {
      setState(() {
        _isOffline = currentlyOffline;
        _isLoggedIn = currentlyLoggedIn;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_isOffline) {
      return const DownloadedSongsScreen();
    } else {
      if (_isLoggedIn) {
        return const HomeScreen();
      } else {
        return const OnboardingScreen();
      }
    }
  }
}
