import 'package:audionyx/presentation/widget/comman_textformfield.dart';
import 'package:audionyx/repository/bloc/upload_song_bloc_cubit/upload_song_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
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
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;
    final horizontalPadding =
        isDesktop
            ? 80.0
            : isTablet
            ? 40.0
            : 24.0;
    final verticalPadding =
        isDesktop
            ? 24.0
            : isTablet
            ? 20.0
            : 16.0;
    final titleFontSize =
        isDesktop
            ? 24.0
            : isTablet
            ? 20.0
            : 18.0;
    final textFieldFontSize =
        isDesktop
            ? 18.0
            : isTablet
            ? 16.0
            : 14.0;
    final buttonFontSize =
        isDesktop
            ? 18.0
            : isTablet
            ? 16.0
            : 14.0;
    final iconSize =
        isDesktop
            ? 28.0
            : isTablet
            ? 24.0
            : 20.0;
    final verticalSpacing =
        isDesktop
            ? 24.0
            : isTablet
            ? 20.0
            : 16.0;
    final buttonPadding =
        isDesktop
            ? const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0)
            : isTablet
            ? const EdgeInsets.symmetric(vertical: 14.0, horizontal: 18.0)
            : const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0);

    return BlocConsumer<UploadSongBlocCubit, UploadSongState>(
      listener: (context, state) {
        if (state is UploadSongSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: ThemeColor.greenColor),
          );
          titleController.clear();
          artistController.clear();
          albumController.clear();
        } else if (state is UploadSongFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error), backgroundColor: ThemeColor.errorColor),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<UploadSongBlocCubit>();
        final isLoading = state is UploadSongLoading;
        final songFileName = state is UploadSongInitial ? state.songFileName : '';
        final thumbnailFileName = state is UploadSongInitial ? state.thumbnailFileName : '';
        final lyricsFileName = state is UploadSongInitial ? state.lyricsFileName : '';

        return Scaffold(
          backgroundColor: ThemeColor.getBackgroundColor(context),
          appBar: AppBar(
            backgroundColor: ThemeColor.getBackgroundColor(context),
            elevation: 0,
            title: Text(
              'Add a Song',
              style: TextStyle(
                color: ThemeColor.getTextColor(context),
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            iconTheme: IconThemeData(color: ThemeColor.getTextColor(context), size: iconSize),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
            child: ListView(
              children: [
                // Title TextField
                DefaultTextStyle(
                  style: TextStyle(
                    fontSize: textFieldFontSize,
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
                SizedBox(height: verticalSpacing),
                // Artist TextField
                DefaultTextStyle(
                  style: TextStyle(
                    fontSize: textFieldFontSize,
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
                SizedBox(height: verticalSpacing),
                // Album TextField
                DefaultTextStyle(
                  style: TextStyle(
                    fontSize: textFieldFontSize,
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
                SizedBox(height: verticalSpacing * 1.5),
                // Pick MP3 File Button
                _buildActionButton(
                  icon: Icons.attach_file,
                  label: songFileName.isEmpty ? 'Pick MP3 File' : songFileName,
                  onPressed: isLoading ? null : () => cubit.pickSongFile(),
                  fontSize: buttonFontSize,
                  iconSize: iconSize,
                  padding: buttonPadding,
                ),
                SizedBox(height: verticalSpacing),
                // Pick Thumbnail Button
                _buildActionButton(
                  icon: Icons.image,
                  label: thumbnailFileName.isEmpty ? 'Pick Thumbnail Image' : thumbnailFileName,
                  onPressed: isLoading ? null : () => cubit.pickThumbnailFile(),
                  fontSize: buttonFontSize,
                  iconSize: iconSize,
                  padding: buttonPadding,
                ),
                SizedBox(height: verticalSpacing),
                // Pick Lyrics File Button
                _buildActionButton(
                  icon: Icons.description,
                  label: lyricsFileName.isEmpty ? 'Pick Lyrics File' : lyricsFileName,
                  onPressed: isLoading ? null : () => cubit.pickLyricsFile(),
                  fontSize: buttonFontSize,
                  iconSize: iconSize,
                  padding: buttonPadding,
                ),
                SizedBox(height: verticalSpacing * 1.5),
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
                  fontSize: buttonFontSize,
                  iconSize: iconSize,
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
    required double fontSize,
    required double iconSize,
    required EdgeInsets padding,
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
              padding: padding,
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.white10 : ThemeColor.grey.withOpacity(0.2),
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
                  Icon(icon, color: ThemeColor.getTextColor(context), size: iconSize),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        color: ThemeColor.getTextColor(context),
                        fontSize: fontSize,
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
    required double fontSize,
    required double iconSize,
  }) {
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;
    final buttonPadding =
        isDesktop
            ? const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0)
            : isTablet
            ? const EdgeInsets.symmetric(vertical: 15.0, horizontal: 18.0)
            : const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0);

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: ThemeColor.greenColor,
        foregroundColor: ThemeColor.white,
        padding: buttonPadding,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
      ),
      child:
          isLoading
              ? SizedBox(
                width: iconSize,
                height: iconSize,
                child: const CircularProgressIndicator(color: ThemeColor.white, strokeWidth: 2),
              )
              : Text('Upload', style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold)),
    );
  }
}
