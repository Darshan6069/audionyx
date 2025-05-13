import 'dart:async';
import 'dart:io';
import 'package:audionyx/presentation/bottom_navigation_bar/bottom_navigation_bar_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Add this import
import 'package:audionyx/presentation/bottom_navigation_bar/library_screen/tabs/download_song_screen.dart';
import '../../../presentation/auth_screen/email_auth/login_screen.dart';
import '../../../presentation/onboarding_screen/onboarding_screen.dart';
import '../jwt_service/jwt_service.dart';

class CheckInternetConnection extends StatefulWidget {
  const CheckInternetConnection({super.key});

  @override
  State<CheckInternetConnection> createState() => _CheckInternetConnectionState();
}

class _CheckInternetConnectionState extends State<CheckInternetConnection> {
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  bool _isLoading = true;
  bool _isOffline = false;
  bool _isLoggedIn = false;
  bool _isFirstTime = true; // New variable to track first-time user

  @override
  void initState() {
    super.initState();
    _performChecks();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
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
      final jwtService = JwtService();
      return await jwtService.isTokenValid();
    } catch (e) {
      return false;
    }
  }

  Future<bool> _checkIfFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isFirstTime') ?? true; // Default to true if not set
  }

  Future<void> _setNotFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', false); // Mark onboarding as seen
  }

  Future<void> _performChecks() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    bool currentlyOffline;
    bool currentlyLoggedIn = false;
    bool isFirstTime = await _checkIfFirstTime(); // Check if first time

    final connectivityResults = await Connectivity().checkConnectivity();
    bool hasNetwork = !(connectivityResults.contains(ConnectivityResult.none) && connectivityResults.length == 1);

    if (!hasNetwork) {
      currentlyOffline = true;
    } else {
      try {
        final result = await InternetAddress.lookup('google.com').timeout(const Duration(seconds: 5));
        currentlyOffline = result.isEmpty || result[0].rawAddress.isEmpty;
      } on SocketException {
        currentlyOffline = true;
      } on TimeoutException {
        currentlyOffline = true;
      } catch (e) {
        currentlyOffline = true;
      }
    }

    if (!currentlyOffline) {
      currentlyLoggedIn = await _checkIfUserIsLoggedIn();
    }

    if (mounted) {
      setState(() {
        _isOffline = currentlyOffline;
        _isLoggedIn = currentlyLoggedIn;
        _isFirstTime = isFirstTime;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_isFirstTime) {
      // Mark onboarding as seen when navigating to OnboardingScreen
      _setNotFirstTime();
      return const OnboardingScreen();
    } else if (_isOffline) {
      return const DownloadedSongsScreen();
    } else {
      if (_isLoggedIn) {
        return const BottomNavigationBarScreen();
      } else {
        return const LoginScreen();
      }
    }
  }
}