import 'dart:io';
import 'package:audionyx/download_song_screen.dart';
import 'package:audionyx/presentation/bottom_navigation_bar/home_screen/home_screen.dart';
import 'package:audionyx/presentation/onboarding_screen/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

class CheckInternetConnection extends StatefulWidget {
  const CheckInternetConnection({super.key});

  @override
  State<CheckInternetConnection> createState() => _CheckInternetConnectionState();
}

class _CheckInternetConnectionState extends State<CheckInternetConnection> {
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool isOffline = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    // Listen for connectivity changes
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      _checkConnectivity(); // Re-check actual internet on change
    });
  }

  Future<void> _checkConnectivity() async {
    try {
      // Step 1: Check network availability
      final connectivityResults = await Connectivity().checkConnectivity();
      if (connectivityResults.contains(ConnectivityResult.none) &&
          connectivityResults.length == 1) {
        _updateConnectionStatus(true); // No network, offline
        return;
      }

      // Step 2: Verify actual internet by pinging a server
      try {
        final result = await InternetAddress.lookup('www.google.com');
        _updateConnectionStatus(result.isEmpty || result[0].rawAddress.isEmpty);
      } on SocketException catch (_) {
        _updateConnectionStatus(true); // No internet, offline
      }
    } catch (e) {
      debugPrint('Connectivity check error: $e');
      _updateConnectionStatus(true); // Assume offline on error
    }
  }

  void _updateConnectionStatus(bool offline) {
    if (mounted) {
      setState(() {
        isOffline = offline;
        isLoading = false;
      });
      debugPrint('Connection status: ${offline ? 'Offline' : 'Online'}');
    }
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return isOffline
        ? const DownloadedSongsScreen()
        : const OnboardingScreen();
  }
}