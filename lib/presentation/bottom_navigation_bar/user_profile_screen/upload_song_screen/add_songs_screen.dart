import 'package:audionyx/presentation/widget/comman_textformfield.dart';
import 'package:audionyx/repository/bloc/upload_song_bloc_cubit/upload_song_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/theme_color.dart';
import '../../../../repository/bloc/upload_song_bloc_cubit/upload_song_bloc_cubit.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;
    final fontScale = screenWidth < 360 ? 0.9 : 1.0;

    return BlocConsumer<UploadSongBlocCubit, UploadSongState>(
      listener: (context, state) {
        if (state is UploadSongSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: ThemeColor.greenColor,
            ),
          );
          titleController.clear();
          artistController.clear();
          albumController.clear();
        } else if (state is UploadSongFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: ThemeColor.errorColor,
            ),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<UploadSongBlocCubit>();
        final isLoading = state is UploadSongLoading;
        final songFileName =
            state is UploadSongInitial ? state.songFileName : '';
        final thumbnailFileName =
            state is UploadSongInitial ? state.thumbnailFileName : '';
        final lyricsFileName =
            state is UploadSongInitial ? state.lyricsFileName : '';

        return Scaffold(
          backgroundColor: ThemeColor.getBackgroundColor(context),
          appBar: AppBar(
            backgroundColor: ThemeColor.getBackgroundColor(context),
            elevation: 0,
            title: Text(
              'Add a Song',
              style: TextStyle(
                color: ThemeColor.getTextColor(context),
                fontSize: 20 * fontScale,
                fontWeight: FontWeight.bold,
              ),
            ),
            iconTheme: IconThemeData(color: ThemeColor.getTextColor(context)),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: ListView(
              children: [
                // Title TextField
                DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 16 * fontScale,
                    color: ThemeColor.getTextColor(context),
                  ),
                  child: CommonTextformfield(
                    controller: titleController,
                    labelText: 'Title',
                    errorText: 'Please enter a title',
                    enabled: !isLoading,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                    isPassword: false,
                  ),
                ),
                const SizedBox(height: 16),
                // Artist TextField
                DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 16 * fontScale,
                    color: ThemeColor.getTextColor(context),
                  ),
                  child: CommonTextformfield(
                    controller: artistController,
                    labelText: 'Artist',
                    errorText: 'Please enter an artist',
                    enabled: !isLoading,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an artist';
                      }
                      return null;
                    },
                    isPassword: false,
                  ),
                ),
                const SizedBox(height: 16),
                // Album TextField
                DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 16 * fontScale,
                    color: ThemeColor.getTextColor(context),
                  ),
                  child: CommonTextformfield(
                    controller: albumController,
                    labelText: 'Album',
                    errorText: 'Please enter an album',
                    enabled: !isLoading,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an album';
                      }
                      return null;
                    },
                    isPassword: false,
                  ),
                ),
                const SizedBox(height: 24),
                // Pick MP3 File Button
                _buildActionButton(
                  icon: Icons.attach_file,
                  label: songFileName.isEmpty ? 'Pick MP3 File' : songFileName,
                  onPressed: isLoading ? null : () => cubit.pickSongFile(),
                  fontScale: fontScale,
                ),
                const SizedBox(height: 16),
                // Pick Thumbnail Button
                _buildActionButton(
                  icon: Icons.image,
                  label:
                      thumbnailFileName.isEmpty
                          ? 'Pick Thumbnail Image'
                          : thumbnailFileName,
                  onPressed: isLoading ? null : () => cubit.pickThumbnailFile(),
                  fontScale: fontScale,
                ),
                const SizedBox(height: 16),
                // Pick Lyrics File Button
                _buildActionButton(
                  icon: Icons.description,
                  label:
                      lyricsFileName.isEmpty
                          ? 'Pick Lyrics File'
                          : lyricsFileName,
                  onPressed: isLoading ? null : () => cubit.pickLyricsFile(),
                  fontScale: fontScale,
                ),
                const SizedBox(height: 24),
                // Upload Button
                _buildUploadButton(
                  isLoading: isLoading,
                  onPressed:
                      isLoading
                          ? null
                          : () {
                            // Validate all fields before uploading
                            if (titleController.text.isEmpty ||
                                artistController.text.isEmpty ||
                                albumController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Please fill all fields'),
                                  backgroundColor: ThemeColor.errorColor,
                                ),
                              );
                              return;
                            }
                            cubit.uploadSong(
                              title: titleController.text,
                              artist: artistController.text,
                              album: albumController.text,
                            );
                          },
                  fontScale: fontScale,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Builds an action button for picking files with tap animation.
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
    required double fontScale,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 1.0, end: 1.0),
      duration: const Duration(milliseconds: 200),
      builder: (context, scale, child) {
        return GestureDetector(
          onTap: onPressed,
          child: Transform.scale(
            scale: scale,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color:
                    isDarkMode
                        ? Colors.white10
                        : ThemeColor.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color:
                      isDarkMode
                          ? ThemeColor.grey.withOpacity(0.3)
                          : ThemeColor.grey.withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: ThemeColor.getTextColor(context),
                    size: 24 * fontScale,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        color: ThemeColor.getTextColor(context),
                        fontSize: 16 * fontScale,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Builds the upload button with loading indicator.
  Widget _buildUploadButton({
    required bool isLoading,
    required VoidCallback? onPressed,
    required double fontScale,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: ThemeColor.greenColor,
        foregroundColor: ThemeColor.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
      ),
      child:
          isLoading
              ? SizedBox(
                width: 24 * fontScale,
                height: 24 * fontScale,
                child: const CircularProgressIndicator(
                  color: ThemeColor.white,
                  strokeWidth: 2,
                ),
              )
              : Text(
                'Upload',
                style: TextStyle(
                  fontSize: 16 * fontScale,
                  fontWeight: FontWeight.bold,
                ),
              ),
    );
  }
}
