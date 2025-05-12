import 'package:audionyx/repository/bloc/upload_song_bloc_cubit/upload_song_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repository/bloc/upload_song_bloc_cubit/upload_song_bloc_cubit.dart';


class AddSongsScreen extends StatefulWidget {
  const AddSongsScreen({super.key});

  @override
  State<AddSongsScreen> createState() => _AddSongsScreenState();
}

class _AddSongsScreenState extends State<AddSongsScreen> {
  final titleController = TextEditingController();
  final artistController = TextEditingController();
  final albumController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    artistController.dispose();
    albumController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UploadSongBlocCubit, UploadSongState>(
      listener: (context, state) {
        if (state is UploadSongSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
          titleController.clear();
          artistController.clear();
          albumController.clear();
        } else if (state is UploadSongFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<UploadSongBlocCubit>();
        final isLoading = state is UploadSongLoading;
        final songFileName = state is UploadSongInitial ? state.songFileName : '';
        final thumbnailFileName = state is UploadSongInitial ? state.thumbnailFileName : '';

        return Scaffold(
          appBar: AppBar(title: const Text('Add a Song')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  enabled: !isLoading,
                ),
                TextField(
                  controller: artistController,
                  decoration: const InputDecoration(labelText: 'Artist'),
                  enabled: !isLoading,
                ),
                TextField(
                  controller: albumController,
                  decoration: const InputDecoration(labelText: 'Album'),
                  enabled: !isLoading,
                ),
                const SizedBox(height: 20),
                OutlinedButton.icon(
                  icon: const Icon(Icons.attach_file),
                  label: Text(songFileName.isEmpty ? 'Pick MP3 File' : songFileName),
                  onPressed: isLoading ? null : () => cubit.pickSongFile(),
                ),
                const SizedBox(height: 20),
                OutlinedButton.icon(
                  icon: const Icon(Icons.image),
                  label: Text(thumbnailFileName.isEmpty ? 'Pick Thumbnail Image' : thumbnailFileName),
                  onPressed: isLoading ? null : () => cubit.pickThumbnailFile(),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () => cubit.uploadSong(
                    title: titleController.text,
                    artist: artistController.text,
                    album: albumController.text,
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Upload'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}