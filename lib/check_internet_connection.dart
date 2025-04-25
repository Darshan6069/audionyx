import 'package:audionyx/download_song_screen.dart';
import 'package:audionyx/song_list.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';


class CheckInternetConnection extends StatefulWidget {
  const CheckInternetConnection({super.key});

  @override
  State<CheckInternetConnection> createState() => _CheckInternetConnectionState();
}

class _CheckInternetConnectionState extends State<CheckInternetConnection> {
  bool? isOffline;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    setState(() {
      isOffline = result == ConnectivityResult.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isOffline == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return isOffline!
        ? const DownloadedSongsScreen()
        : const SongListScreen();
  }
}
