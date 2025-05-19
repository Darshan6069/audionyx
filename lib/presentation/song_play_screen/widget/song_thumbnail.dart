import 'dart:io';
import 'package:audionyx/domain/song_model/song_model.dart';
import 'package:flutter/material.dart';

class SongThumbnail extends StatelessWidget {
  final SongData currentSong;

  const SongThumbnail({super.key, required this.currentSong});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Hero(
          tag: currentSong.id,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
              image: DecorationImage(
                image:
                    currentSong.thumbnailUrl.startsWith('http')
                        ? NetworkImage(currentSong.thumbnailUrl)
                        : FileImage(File(currentSong.thumbnailUrl))
                            as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
