import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:audionyx/domain/song_model/song_model.dart';
import 'package:flutter/material.dart';

class ShareSongService {
  Future<void> shareSong(SongData song, {BuildContext? context}) async {
    final path = song.mp3Url;

    try {
      if (path.startsWith('http')) {
        await Share.share('Check out this song: ${song.title}\n$path');
      } else if (File(path).existsSync()) {
        await Share.shareXFiles([
          XFile(path),
        ], text: 'Check out this song: ${song.title}');
      } else {
        if (context != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cannot share this song.')),
          );
        }
        throw Exception('Cannot share this song: Invalid path');
      }
    } catch (e) {
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sharing song: ${e.toString()}')),
        );
      }
      rethrow;
    }
  }
}
